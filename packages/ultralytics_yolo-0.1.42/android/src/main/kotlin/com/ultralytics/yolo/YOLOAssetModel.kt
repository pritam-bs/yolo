package com.ultralytics.yolo

import android.content.Context
import com.google.android.gms.tflite.acceleration.Model
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.MappedByteBuffer
import java.util.Random

class YOLOAssetModel(
    private val modelBuffer: MappedByteBuffer,
    private val inputWidth: Int = 320,
    private val inputHeight: Int = 320,
    private val inputChannels: Int = 3,
    private val byteSize: Int = 4 // 4 for Float32, 1 for UInt8
) {

    // Construct the GMS Model object wrapper
    val model: Model by lazy {
        Model.Builder()
            .setModelLocation(Model.ModelLocation.fromByteBuffer(modelBuffer))
            .setModelId("yolo_v8_detection")
            .setModelNamespace("ultralytics")
            .build()
    }

    /**
     * Matches getBatchSize() from sample.
     * YOLO usually infers 1 image at a time on mobile.
     */
    fun getBatchSize(): Int = 1

    /**
     * Generates a DirectByteBuffer with random data.
     * The Acceleration Service needs 'Golden Inputs' to run the model on CPU
     * to establish a baseline truth to compare the GPU result against.
     */
    fun getInputs(): Array<Any> {
        val capacity = getBatchSize() * inputWidth * inputHeight * inputChannels * byteSize

        // CRITICAL: Must be allocateDirect and nativeOrder for JNI compatibility
        val buffer = ByteBuffer.allocateDirect(capacity).apply {
            order(ByteOrder.nativeOrder())
        }

        // Fill with random float data (normalized 0..1) to simulate an image
        // An empty (0.0) buffer might trigger optimizations that skip computation, leading to bad validation.
        val random = Random()
        while (buffer.hasRemaining()) {
            if (byteSize == 4) {
                buffer.putFloat(random.nextFloat())
            } else {
                buffer.put(random.nextInt(255).toByte())
            }
        }
        buffer.rewind()

        // Return as Array<Any> to match Java's Object[] signature
        return arrayOf(buffer)
    }

    fun getSingleInput(): ByteBuffer {
        val capacity = getBatchSize() * inputWidth * inputHeight * inputChannels * byteSize

        val buffer = ByteBuffer.allocateDirect(capacity).apply {
            order(ByteOrder.nativeOrder())
        }

        val random = Random()
        while (buffer.hasRemaining()) {
            if (byteSize == 4) {
                buffer.putFloat(random.nextFloat())
            } else {
                buffer.put(random.nextInt(255).toByte())
            }
        }
        buffer.rewind()
        return buffer
    }

    fun getGoldenInputs(): FloatArray {
        val totalElements = 1 * inputWidth * inputHeight * inputChannels
        val flatInput = FloatArray(totalElements)
        val random = Random()
        for (i in flatInput.indices) {
            flatInput[i] = random.nextFloat()
        }
        return flatInput
    }}