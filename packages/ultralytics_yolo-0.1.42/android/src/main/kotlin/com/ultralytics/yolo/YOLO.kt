// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

package com.ultralytics.yolo

import android.content.Context
import android.graphics.*
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import androidx.camera.core.ImageProxy
import com.google.android.gms.tasks.Tasks
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.tensorflow.lite.InterpreterApi
import java.io.IOException
import java.net.URL
import java.nio.MappedByteBuffer
import kotlin.math.max
import kotlin.math.min

/**
 * Unified YOLO class optimized for NPU/GPU using TFLiteAccelerationDelegate.
 */
class YOLO private constructor(
    private val context: Context,
    private val modelPath: String,
    val task: YOLOTask,
    private val labels: List<String>,
    private val preferredDelegate: TFLiteAccelerationDelegate, // UPDATED: Using Delegate directly
    private val interpreterOptions: InterpreterApi.Options,     // Generated via factory
    private val modelBuffer: MappedByteBuffer,
    private val classifierOptions: Map<String, Any>? = null
) {
    private val TAG = "YOLO"

    companion object {
        /**
         * Asynchronous factory to create a YOLO instance.
         * Now takes the preferredDelegate and handles validation internally.
         */
        suspend fun create(
            context: Context,
            modelPath: String,
            task: YOLOTask,
            preferredDelegate: TFLiteAccelerationDelegate = TFLiteAccelerationDelegate.GPU,
            classifierOptions: Map<String, Any>? = null
        ): YOLO = withContext(Dispatchers.IO) {
            val helper = TFLiteAccelerationHelper(context)

            Log.d("YOLO", "Creating YOLO instance for $task using $preferredDelegate")

            // 1. Initialize TFLite Shared Runtime via GMS
            try {
                Tasks.await(helper.initializeTfLite(preferredDelegate))
            } catch (e: Exception) {
                Log.e("YOLO", "Runtime initialization failed", e)
            }

            // 2. Map model into memory
            val buffer = YOLOUtils.loadModelFile(context, modelPath)

            // 3. Benchmark hardware (Priority path for Pixel 9a NPU)
            val validatedResult = helper.selectAndValidateDelegate(buffer, preferredDelegate)

            // 4. Transform validation result into Interpreter options
            val options = helper.createInterpreterOptions(validatedResult, preferredDelegate)

            // 5. Extract metadata labels
            val labels = YOLOFileUtils.loadLabelsFromAppendedZip(context, modelPath) ?: emptyList()

            return@withContext YOLO(
                context, modelPath, task, labels, preferredDelegate, options, buffer, classifierOptions
            )
        }
    }

    private var annotatedBitmap: Bitmap? = null
    
    /**
     * Lazy-initialized predictor using the optimized options.
     */
    private val predictor: Predictor by lazy {
        when (task) {
            YOLOTask.DETECT -> ObjectDetector(context, modelBuffer, modelPath, labels, interpreterOptions)
            YOLOTask.SEGMENT -> Segmenter(context, modelBuffer, modelPath, labels, interpreterOptions)
            YOLOTask.CLASSIFY -> Classifier(context, modelBuffer, modelPath, labels, interpreterOptions, classifierOptions)
            YOLOTask.POSE -> PoseEstimator(context, modelBuffer, modelPath, labels, interpreterOptions=interpreterOptions)
            YOLOTask.OBB -> ObbDetector(context, modelBuffer, modelPath, labels, interpreterOptions)
        }
    }

    /**
     * Predict using raw Bitmap.
     */
    fun predict(bitmap: Bitmap, rotateForCamera: Boolean = false): YOLOResult {
        val result = predictor.predict(bitmap, bitmap.width, bitmap.height, rotateForCamera, isLandscape = false)
        val annotatedImage = if (task == YOLOTask.CLASSIFY) null else drawAnnotations(bitmap, result, rotateForCamera)

        return result.copy(
            originalImage = bitmap,
            annotatedImage = annotatedImage
        )
    }

    /**
     * Predict using ImageProxy. Logic includes automatic resource cleanup.
     */
    fun predict(imageProxy: ImageProxy): YOLOResult? {
        return try {
            val bitmap = ImageUtils.toBitmap(imageProxy) ?: return null
            val result = predictor.predict(bitmap, imageProxy.width, imageProxy.height, rotateForCamera = true, isLandscape = false)
            result.copy(
                originalImage = bitmap,
                annotatedImage = drawAnnotations(bitmap, result, rotateForCamera = true)
            )
        } finally {
            imageProxy.close() // Prevents camera pipeline stall
        }
    }

    /**
     * Logic for drawing high-performance annotations directly on Bitmaps.
     */
    private fun drawAnnotations(bitmap: Bitmap, result: YOLOResult, rotateForCamera: Boolean): Bitmap {
        val sourceBitmap = if (rotateForCamera) {
            val matrix = Matrix().apply { postRotate(90f) }
            Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
        } else {
            bitmap
        }

        if (annotatedBitmap == null ||
            annotatedBitmap!!.width != sourceBitmap.width ||
            annotatedBitmap!!.height != sourceBitmap.height
        ) {
            annotatedBitmap = sourceBitmap.copy(Bitmap.Config.ARGB_8888, true)
        }
        val output = annotatedBitmap!!
        val canvas = Canvas(output)
        canvas.drawBitmap(sourceBitmap, 0f, 0f, null)

        val vw = output.width.toFloat()
        val vh = output.height.toFloat()

        val maxDim = max(vw, vh)
        val paint = Paint().apply {
            isAntiAlias = true
            style = Paint.Style.STROKE
            strokeWidth = maxDim / 150f
            textSize = maxDim / 35f
            typeface = Typeface.DEFAULT_BOLD
        }

        when (task) {
            YOLOTask.DETECT, YOLOTask.SEGMENT, YOLOTask.POSE -> {
                for (box in result.boxes) {
                    paint.color = ultralyticsColors[box.index % ultralyticsColors.size]
                    paint.style = Paint.Style.STROKE
                    canvas.drawRoundRect(box.xywh, 12f, 12f, paint)

                    val label = "${box.cls} ${(box.conf * 100).toInt()}%"
                    val textWidth = paint.measureText(label)
                    val fontMetrics = paint.fontMetrics
                    val textHeight = fontMetrics.descent - fontMetrics.ascent

                    val labelRect = calculateSmartLabelRect(box.xywh, textWidth + 16f, textHeight + 16f, vw, vh)

                    paint.style = Paint.Style.FILL
                    canvas.drawRoundRect(labelRect, 8f, 8f, paint)

                    paint.color = Color.WHITE
                    canvas.drawText(label, labelRect.left + 8f, labelRect.bottom - fontMetrics.descent - 4f, paint)
                }
            }
            YOLOTask.OBB -> {
                for (obb in result.obb) {
                    paint.color = ultralyticsColors[obb.index % ultralyticsColors.size]
                    paint.style = Paint.Style.STROKE
                    val path = Path()
                    val poly = obb.box.toPolygon()
                    path.moveTo(poly[0].x * vw, poly[0].y * vh)
                    for (i in 1 until poly.size) path.lineTo(poly[i].x * vw, poly[i].y * vh)
                    path.close()
                    canvas.drawPath(path, paint)
                }
            }
            else -> {}
        }
        return output
    }

    private fun calculateSmartLabelRect(box: RectF, w: Float, h: Float, vw: Float, vh: Float): RectF {
        var left = box.left
        var top = box.top - h
        if (top < 0) top = box.top
        if (left + w > vw) left = vw - w
        return RectF(max(0f, left), max(0f, top), min(vw, left + w), min(vh, top + h))
    }

    // --- Control API ---
    fun setConfidenceThreshold(threshold: Double) { predictor.setConfidenceThreshold(threshold) }
    fun setIouThreshold(threshold: Double) { predictor.setIouThreshold(threshold) }
    fun getPreferredDelegate(): TFLiteAccelerationDelegate = preferredDelegate
    /**
     * Gets the current confidence threshold from the underlying predictor.
     * @return current threshold as a Float
     */
    fun getConfidenceThreshold(): Float {
        return predictor.getConfidenceThreshold().toFloat()
    }

    /**
     * Gets the current IoU threshold from the underlying predictor.
     * @return current threshold as a Float
     */
    fun getIouThreshold(): Float {
        return predictor.getIouThreshold().toFloat()
    }
}