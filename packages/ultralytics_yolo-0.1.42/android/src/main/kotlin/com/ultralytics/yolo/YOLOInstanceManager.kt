// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

package com.ultralytics.yolo

import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import kotlinx.coroutines.*
import java.nio.MappedByteBuffer

/**
 * Manages multiple YOLO instances with unique IDs.
 * Updated to use the YOLO.create factory for optimized hardware acceleration.
 */
object YOLOInstanceManager {
    private const val TAG = "YOLOInstanceManager"

    // Singleton access
    val shared: YOLOInstanceManager = this

    // Store YOLO instances by their unique ID
    private val instances = mutableMapOf<String, YOLO>()

    // Store loading states to prevent multiple concurrent loads for the same ID
    private val loadingStates = mutableMapOf<String, Boolean>()

    // Store classifier options per instance
    private val instanceOptions = mutableMapOf<String, Map<String, Any>>()

    init {
        // Initialize default instance placeholder
        createInstance("default")
    }

    /**
     * Creates a new instance placeholder
     */
    fun createInstance(instanceId: String) {
        loadingStates[instanceId] = false
        Log.d(TAG, "Created instance placeholder: $instanceId")
    }

    /**
     * Gets a YOLO instance by ID
     */
    fun getInstance(instanceId: String): YOLO? {
        return instances[instanceId]
    }

    /**
     * Loads a model for a specific instance using the YOLO.create factory.
     * This handles NPU/GPU validation automatically via TFLiteAccelerationHelper.
     */
    suspend fun loadModel(
        instanceId: String,
        context: Context,
        modelPath: String,
        task: YOLOTask,
        preferredDelegate: TFLiteAccelerationDelegate = TFLiteAccelerationDelegate.GPU,
        classifierOptions: Map<String, Any>? = null
    ): Result<Unit> = withContext(Dispatchers.IO) {

        // Check if already loaded
        if (instances[instanceId] != null) {
            Log.d(TAG, "Instance $instanceId already loaded.")
            return@withContext Result.success(Unit)
        }

        // Check if loading to prevent race conditions
        if (loadingStates[instanceId] == true) {
            Log.w(TAG, "Model is already loading for instance: $instanceId")
            return@withContext Result.failure(Exception("Model is already loading"))
        }

        // Mark as loading
        loadingStates[instanceId] = true

        try {
            // Store classifier options if provided
            classifierOptions?.let {
                instanceOptions[instanceId] = it
            }

            // USE THE FACTORY PATTERN:
            // YOLO.create handles runtime init, model mapping, and hardware validation internally.
            Log.d(TAG, "Triggering optimized YOLO creation for instance: $instanceId")
            val yolo = YOLO.create(
                context = context,
                modelPath = modelPath,
                task = task,
                preferredDelegate = preferredDelegate,
                classifierOptions = classifierOptions
            )

            instances[instanceId] = yolo
            loadingStates[instanceId] = false

            Log.d(TAG, "Model loaded and optimized successfully for instance: $instanceId")
            return@withContext Result.success(Unit)

        } catch (e: Exception) {
            loadingStates[instanceId] = false
            instanceOptions.remove(instanceId)
            Log.e(TAG, "Failed to load model for instance $instanceId: ${e.message}")
            return@withContext Result.failure(e)
        }
    }

    /**
     * Runs inference on a specific instance with temporary threshold overrides.
     */
    suspend fun predict(
        instanceId: String,
        bitmap: Bitmap,
        confidenceThreshold: Float? = null,
        iouThreshold: Float? = null
    ): YOLOResult? = withContext(Dispatchers.Default) {
        val yolo = instances[instanceId] ?: run {
            Log.e(TAG, "No model loaded for instance: $instanceId")
            return@withContext null
        }

        // Store current thresholds to restore later
        val originalConfThreshold = yolo.getConfidenceThreshold()
        val originalIouThreshold = yolo.getIouThreshold()

        return@withContext try {
            // Apply overrides if provided
            confidenceThreshold?.let { yolo.setConfidenceThreshold(it.toDouble()) }
            iouThreshold?.let { yolo.setIouThreshold(it.toDouble()) }

            val result = yolo.predict(bitmap)

            // Restore original thresholds
            yolo.setConfidenceThreshold(originalConfThreshold.toDouble())
            yolo.setIouThreshold(originalIouThreshold.toDouble())

            result
        } catch (e: Exception) {
            Log.e(TAG, "Prediction failed for instance $instanceId: ${e.message}")
            // Ensure restoration on error
            yolo.setConfidenceThreshold(originalConfThreshold.toDouble())
            yolo.setIouThreshold(originalIouThreshold.toDouble())
            null
        }
    }

    /**
     * Disposes a specific instance and cleans up metadata.
     */
    fun dispose(instanceId: String) {
        if (instances.containsKey(instanceId)) {
            Log.d(TAG, "Disposing YOLO instance: $instanceId")
            instances.remove(instanceId)
            loadingStates.remove(instanceId)
            instanceOptions.remove(instanceId)
        }
    }

    fun removeInstance(instanceId: String) = dispose(instanceId)

    fun disposeAll() {
        instances.keys.toList().forEach { dispose(it) }
        Log.d(TAG, "Disposed all active YOLO instances.")
    }

    fun hasInstance(instanceId: String): Boolean = instances.containsKey(instanceId)

    fun getActiveInstanceIds(): List<String> = instances.keys.toList()

    fun getClassifierOptions(instanceId: String): Map<String, Any>? = instanceOptions[instanceId]

    fun clearAll() = disposeAll()
}