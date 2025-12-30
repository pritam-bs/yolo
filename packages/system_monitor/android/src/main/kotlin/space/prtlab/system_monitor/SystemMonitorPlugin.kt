package space.prtlab.system_monitor

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.app.ActivityManager
import android.os.PowerManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import java.io.RandomAccessFile
import java.util.LinkedList

/** SystemMonitorPlugin */
class SystemMonitorPlugin : FlutterPlugin, EventChannel.StreamHandler {
    private lateinit var channel: EventChannel
    private lateinit var context: Context
    private var handler: Handler? = null
    private var runnable: Runnable? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = EventChannel(flutterPluginBinding.binaryMessenger, "system_monitor/metrics")
        channel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setStreamHandler(null)
        stopMonitoring()
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.eventSink = events
        val args = arguments as? Map<*, *>
        val interval = (args?.get("interval") as? Int)?.toLong() ?: 5000L
        startMonitoring(interval)
    }

    override fun onCancel(arguments: Any?) {
        stopMonitoring()
    }

    private fun startMonitoring(interval: Long) {
        handler = Handler(Looper.getMainLooper())
        runnable = object : Runnable {
            override fun run() {
                collectAndSendMetrics()
                handler?.postDelayed(this, interval)
            }
        }
        handler?.post(runnable!!)
    }

    private fun stopMonitoring() {
        handler?.removeCallbacks(runnable!!)
        runnable = null
        handler = null
        eventSink = null
    }

    private fun collectAndSendMetrics() {
        try {
            val metrics = mutableMapOf<String, Any>(
                "batteryLevel" to getBatteryLevel(),
                "ramUsage" to getRamUsage(),
                "thermalState" to getThermalState()
            )
            eventSink?.success(metrics)
        } catch (e: Exception) {
            eventSink?.error("NATIVE_ERROR", "Error collecting system metrics: ${e.message}", null)
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        if (batteryLevel < 0) {
            throw Exception("Battery level not available")
        }
        return batteryLevel
    }

    private fun getRamUsage(): Double {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        val totalMem = memoryInfo.totalMem
        if (totalMem <= 0) {
            throw Exception("Total memory not available")
        }
        val usedMem = totalMem - memoryInfo.availMem
        return usedMem.toDouble() / totalMem.toDouble()
    }

    private fun getThermalState(): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            return when (powerManager.currentThermalStatus) {
                PowerManager.THERMAL_STATUS_NONE -> "nominal"
                PowerManager.THERMAL_STATUS_LIGHT -> "fair"
                PowerManager.THERMAL_STATUS_MODERATE -> "serious"
                PowerManager.THERMAL_STATUS_SEVERE -> "critical"
                PowerManager.THERMAL_STATUS_CRITICAL -> "critical"
                PowerManager.THERMAL_STATUS_EMERGENCY -> "critical"
                else -> "unknown"
            }
        }
        return "unsupported"
    }
}
