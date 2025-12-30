import Flutter
import UIKit

public class SystemMonitorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var timer: Timer?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SystemMonitorPlugin()
        let channel = FlutterEventChannel(name: "system_monitor/metrics", binaryMessenger: registrar.messenger())
        channel.setStreamHandler(instance)
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        let args = arguments as? [String: Any]
        let interval = (args?["interval"] as? Int ?? 5000) / 1000
        startMonitoring(interval: TimeInterval(interval))
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopMonitoring()
        return nil
    }

    private func startMonitoring(interval: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.collectAndSendMetrics()
        }
    }

    private func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        eventSink = nil
    }

    private func collectAndSendMetrics() {
        guard let sink = eventSink else { return }

        do {
            let metrics: [String: Any] = [
                "batteryLevel": try getBatteryLevel(),
                "ramUsage": try getRamUsage(),
                "thermalState": try getThermalState()
            ]
            sink(metrics)
        } catch {
            sink(FlutterError(code: "NATIVE_ERROR", message: "Error collecting system metrics: \(error)", details: nil))
        }
    }

    private func getBatteryLevel() throws -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = Int(UIDevice.current.batteryLevel * 100)
        if level < 0 {
            throw NSError(domain: "BATTERY_ERROR", code: 0, userInfo: [NSLocalizedDescriptionKey: "Battery level is not available"])
        }
        UIDevice.current.isBatteryMonitoringEnabled = false
        return level
    }

    private func getRamUsage() throws -> Double {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        if kerr != KERN_SUCCESS {
            throw NSError(domain: "KERN_ERROR", code: Int(kerr), userInfo: [NSLocalizedDescriptionKey: "Failed to get task info"])
        }

        let used_bytes = taskInfo.resident_size
        let total_bytes = ProcessInfo.processInfo.physicalMemory
        return Double(used_bytes) / Double(total_bytes)
    }

    private func getThermalState() throws -> String {
        if #available(iOS 11.0, *) {
            switch ProcessInfo.processInfo.thermalState {
            case .nominal:
                return "nominal"
            case .fair:
                return "fair"
            case .serious:
                return "serious"
            case .critical:
                return "critical"
            @unknown default:
                return "unknown"
            }
        } else {
            return "unsupported"
        }
    }
}
