package com.ultralytics.yolo

import android.util.Log
import com.google.android.gms.tflite.acceleration.BenchmarkResult
import com.google.android.gms.tflite.acceleration.CustomValidationConfig
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer
import kotlin.math.pow

class MeanSquaredErrorValidator(
    private val threshold: Double = 0.003 // Adjust based on precision needs (0.003 is standard for float32)
) : CustomValidationConfig.AccuracyValidator {

    private val TAG = "MSEValidator"

    override fun validate(benchmarkResult: BenchmarkResult, goldenOutputs: Array<ByteBuffer>): Boolean {
        val actualOutputs = benchmarkResult.actualOutput()

        if (actualOutputs.size != goldenOutputs.size) {
            Log.e(TAG, "Output count mismatch: Actual ${actualOutputs.size} vs Golden ${goldenOutputs.size}")
            return false
        }

        for (i in actualOutputs.indices) {
            // Get buffers
            val goldenBuffer = goldenOutputs[i].order(ByteOrder.nativeOrder()).asFloatBuffer()
            val actualBuffer = actualOutputs[i].value.order(ByteOrder.nativeOrder()).asFloatBuffer()

            if (!checkMeanSquaredError(goldenBuffer, actualBuffer)) {
                Log.e(TAG, "MSE check failed at output index $i")
                return false
            }
        }

        Log.i(TAG, "Validation Passed.")
        return true
    }

    private fun checkMeanSquaredError(expected: FloatBuffer, actual: FloatBuffer): Boolean {
        if (expected.remaining() != actual.remaining()) {
            Log.e(TAG, "Vector length mismatch. Exp: ${expected.remaining()}, Act: ${actual.remaining()}")
            return false
        }

        var sum = 0.0
        val length = expected.remaining()

        // Reset positions just in case
        expected.rewind()
        actual.rewind()

        for (i in 0 until length) {
            val diff = expected.get(i) - actual.get(i)
            sum += diff.pow(2)
        }

        val mse = if (length == 0) 0.0 else sum / length
        Log.d(TAG, "Mean Squared Error: $mse (Threshold: $threshold)")

        return mse < threshold
    }
}