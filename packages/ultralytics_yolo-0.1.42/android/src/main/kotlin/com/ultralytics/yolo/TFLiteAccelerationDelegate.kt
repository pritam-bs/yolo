// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

package com.ultralytics.yolo

/**
 * Enum to specify the preferred TensorFlow Lite acceleration delegate.
 */
enum class TFLiteAccelerationDelegate {
    NNAPI, // Neural Networks API (best for Pixel NPUs)
    GPU,   // GPU Delegate (uses OpenGL ES)
    CPU    // CPU (fallback)
}
