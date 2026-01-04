// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

package com.ultralytics.yolo

import android.content.Context
import android.util.Log
import com.google.android.gms.tasks.Task
import com.google.android.gms.tflite.acceleration.*
import com.google.android.gms.tflite.client.TfLiteInitializationOptions
import com.google.android.gms.tflite.gpu.support.TfLiteGpu
import com.google.android.gms.tflite.java.TfLite
import kotlinx.coroutines.tasks.await
import org.tensorflow.lite.InterpreterApi
import org.tensorflow.lite.gpu.GpuDelegateFactory
import org.tensorflow.lite.nnapi.NnApiDelegate
import java.nio.MappedByteBuffer

class TFLiteAccelerationHelper(private val context: Context) {

    private val TAG = "TFLiteAccelerationHelper"

    fun initializeTfLite(preferredDelegate: TFLiteAccelerationDelegate): Task<Void> {
        Log.i(TAG, "Preferred Delegate: $preferredDelegate")
        return TfLiteGpu.isGpuDelegateAvailable(context).onSuccessTask { gpuAvailable ->
            val initOptions = TfLiteInitializationOptions.builder()
                .setEnableGpuDelegateSupport(preferredDelegate == TFLiteAccelerationDelegate.GPU && gpuAvailable)
                .setEnableAutomaticDownload(true)
                .build()
            TfLite.initialize(context, initOptions)
        }
    }

    suspend fun selectAndValidateDelegate(
        modelBuffer: MappedByteBuffer,
        preferredDelegate: TFLiteAccelerationDelegate
    ): ValidatedAccelerationConfigResult? {

        // 1. Create the Asset Model Wrapper
        // Adjust input dims (e.g., 640 or 320) based on your specific YOLO export
        val yoloModel = YOLOAssetModel(modelBuffer, inputWidth = 320, inputHeight = 320)

        val accelerationService = AccelerationService.create(context)

        // 2. Define Configuration to Test
        val accelerationConfig: AccelerationConfig = when (preferredDelegate) {
            TFLiteAccelerationDelegate.GPU -> {
                val gpuAccelerationConfig = GpuAccelerationConfig.Builder()
                gpuAccelerationConfig.setEnableQuantizedInference(true)
                gpuAccelerationConfig.setInferencePreference(GpuAccelerationConfig.GpuInferenceUsage.GPU_INFERENCE_PREFERENCE_SUSTAINED_SPEED)
                gpuAccelerationConfig.setInferencePriority1(GpuAccelerationConfig.GpuInferencePriority.GPU_PRIORITY_MIN_LATENCY)
                gpuAccelerationConfig.setInferencePriority1(GpuAccelerationConfig.GpuInferencePriority.GPU_PRIORITY_MAX_PRECISION)
                gpuAccelerationConfig.setInferencePriority1(GpuAccelerationConfig.GpuInferencePriority.GPU_PRIORITY_MIN_MEMORY_USAGE)

                gpuAccelerationConfig.build()
            }
            else -> CpuAccelerationConfig.Builder().setNumThreads(4).build()
        }

        // Get the inputs: Object[] { float[] }
        val inputs = yoloModel.getGoldenInputs()

        // Build config
        val validationConfigBuilder = CustomValidationConfig.Builder()
            .setAccuracyValidator(MeanSquaredErrorValidator(threshold = 0.2))
            .setGoldenConfig(GpuAccelerationConfig.Builder().build())
            .setBatchSize(yoloModel.getBatchSize())

        validationConfigBuilder.setGoldenInputs(inputs)

        val validationConfig = validationConfigBuilder.build()

        return try {
            Log.i(TAG, "Starting Acceleration Service Validation...")
            val result = accelerationService.validateConfig(
                yoloModel.model,
                accelerationConfig,
                validationConfig
            ).await()

            Log.i(TAG, "Validation Result: Valid=${result.isValid}")
            result
        } catch (e: Exception) {
            Log.e(TAG, "Validation failed with exception: ${e.message}")
            e.printStackTrace()
            null
        }
    }

    fun createInterpreterOptions(
        result: ValidatedAccelerationConfigResult?,
        preferredDelegate: TFLiteAccelerationDelegate
    ): InterpreterApi.Options {
        val options = InterpreterApi.Options().setRuntime(InterpreterApi.Options.TfLiteRuntime.FROM_SYSTEM_ONLY)

        // 1. Acceleration Service Path
        if (result != null && result.isValid) {
            // Note: We check if benchmark result exists and passed, though isValid usually covers this
            for (benchmarkMetric in result.benchmarkResult().metrics()) {
                Log.i(TAG, "Metric name: " + benchmarkMetric.name)
                Log.i(TAG, "Metric values: ")
                for (value in benchmarkMetric.values) {
                    Log.i(TAG, "$value")
                }
            }

            val benchmark = result.benchmarkResult()
            if (benchmark.hasPassedAccuracyCheck()) {
                Log.i(TAG, "SUCCESS: Benchmark passed accuracy check.")
                try {
                    options.accelerationConfig = result
                    Log.i(TAG, "SUCCESS: Applied validated Acceleration Config.")
                    return options
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to apply config: ${e.message}")
                }
            } else {
                Log.w(TAG, "Benchmark failed accuracy check.")
            }
        } else {
            Log.w(TAG, "No Validated Acceleration Config. Falling back.")
        }

        // 2. Manual Fallback Logic (Same as your original)
        Log.w(TAG, "Proceeding with manual fallback for: $preferredDelegate")
        when (preferredDelegate) {
            TFLiteAccelerationDelegate.GPU -> {
                try {
                    options.addDelegateFactory(GpuDelegateFactory())
                    Log.i(TAG, "FALLBACK: Manual GPU Delegate added.")
                } catch (e: Exception) {
                    Log.e(TAG, "GPU Fallback failed: ${e.message}")
                }
            }
            TFLiteAccelerationDelegate.NNAPI -> {
                try {
                    options.addDelegate(NnApiDelegate())
                    Log.i(TAG, "FALLBACK: Manual NNAPI Delegate added.")
                } catch (e: Exception) {
                    try {
                        options.addDelegateFactory(GpuDelegateFactory())
                        Log.i(TAG, "FALLBACK: Manual GPU Delegate added.")
                    } catch (e2: Exception) {
                        Log.e(TAG, "NNAPI and GPU Fallback failed: ${e.message}")
                    }
                }
            }
            TFLiteAccelerationDelegate.CPU -> {
                options.useXNNPACK = true
            }
        }

        options.setNumThreads(Runtime.getRuntime().availableProcessors())
        return options
    }
}