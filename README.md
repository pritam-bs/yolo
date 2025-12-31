# Adaptive Real-time Object Detection with Flutter & YOLO

This Flutter project demonstrates a sophisticated real-time object detection application that dynamically adapts its performance based on the device's system health. It leverages the Ultralytics YOLO model for inference and is built upon a robust, maintainable Clean Architecture.

## Key Features

- **Dynamic Inference Throttling:** The application intelligently monitors system metrics (RAM usage, temperature, battery level) and adjusts YOLO inference parameters in real-time. This ensures optimal performance without overloading the device, preventing thermal throttling and excessive battery drain.
- **Clean Architecture:** Built following Clean Architecture principles, separating the project into `Domain`, `Data`, and `Application` layers. This enhances modularity, testability, and long-term maintainability.
- **Advanced Model Management:**
  - **Resumable Downloads:** Downloads YOLO models with detailed progress updates.
  - **Robust Error Handling:** Implements mechanisms to handle network errors during download.
  - **Lifecycle-Aware:** Automatically pauses and resumes downloads based on the app's lifecycle state.
  - **Retry Functionality:** Allows users to retry failed downloads.
- **Custom System Health Monitoring:** Includes a custom-developed Flutter plugin (`system_monitor`) that uses `EventChannel` to stream real-time system metrics from the native side (Android/iOS) to Flutter.
- **System Health UI Updates:** The UI displays the device's current system health status as `NORMAL`, `THROTTLED`, or `CRITICAL`, providing instant feedback.
- **Optimized Native Integration:**
  - Utilizes a modified local version of the official Flutter Ultralytics YOLO plugin.
  - Employs `YOLOView` for rendering the camera feed and bounding boxes directly on the native side. This significantly reduces the communication overhead between Flutter and the native platform (avoids serialization costs, async overhead, and GC pressure).
  - Only essential detection data (bounding box coordinates, performance stats) is sent back to the Flutter UI for status updates.
- **Enhanced YOLO Plugin Modifications:**
  - **Coordinate-Perfect Rendering:** The `YOLOResult` object was modified to expose the original image dimensions used for inference. This allows for precise mapping of bounding box coordinates to the Flutter widget coordinate space.
  - **Intelligent GPU Delegation (Android):**
    - Performs a GPU delegate compatibility check before initializing the TensorFlow Lite interpreter with GPU support.
    - Automatically falls back to CPU execution if the GPU delegate is not compatible, even if GPU usage is enabled.
    - Includes a secondary fallback to CPU if model loading with the GPU delegate fails, ensuring the app remains functional.
- **Fine-Tuned Inference Pipeline:** CPU and GPU inference settings are optimized for a balance of speed, efficiency, and stability on mobile devices.

## Architecture

The project adheres to the principles of Clean Architecture to create a decoupled and scalable codebase.

- **Domain Layer:** Contains the core business logic, entities (e.g., `DetectionResult`, `SystemMetrics`), and repository interfaces. It is the innermost layer and has no dependencies on other layers.
- **Data Layer:** Implements the repository interfaces defined in the Domain layer. It is responsible for fetching data from data sources (remote servers, local file system, native plugins).
- **Application Layer:** Contains the UI (Widgets/Screens) and state management logic (BLoCs). It depends on the Domain layer to execute business logic and orchestrate the presentation of data to the user.

```mermaid
graph TD
    A[Application Layer <br/> (UI, BLoCs, Widgets)] --> B[Domain Layer <br/> (Entities, Use Cases, Repositories)];
    C[Data Layer <br/> (Repositories Impl, Data Sources)] --> B;
    D[Native Plugins <br/> (YOLO, System Monitor)] --> C;
    E[Remote Data Source] --> C;
```

## Technical Deep Dive

### Reducing Flutter-to-Native Communication Cost

In real-time computer vision apps, constantly streaming camera frames and detection results between Flutter and the native platform can be a major performance bottleneck. This project solves this by using `YOLOView`.

1.  **Native Rendering:** The camera preview, the YOLO inference, and the drawing of bounding boxes are all handled entirely on the native side.
2.  **Minimal Data Transfer:** Only the structured detection data (class IDs, confidence scores, coordinates) and performance metrics are sent asynchronously to the Flutter side.
3.  **Result:** This approach minimizes serialization/deserialization overhead, reduces garbage collection pressure, and avoids saturating the platform channels, leading to a smoother user experience.

### Inference Optimizations

The application's native inference pipeline is finely tuned for both CPU and GPU execution to maximize performance on mobile devices.

#### CPU Optimizations
-   **`setUseXNNPACK(true)`:** This enables the XNNPACK delegate, a library of highly optimized neural network operators for ARM and x86 CPUs. It significantly accelerates model performance by leveraging platform-specific instruction sets.
-   **`setNumThreads(4)`:** The number of threads for CPU inference is intentionally limited to 4 rather than using all available cores (e.g., via `Runtime.getRuntime().availableProcessors()`). This is a critical optimization for mobile devices for several reasons:
    -   **Reduces Performance Variability:** As recommended by Google's best practices, using a high number of threads can lead to unpredictable performance and can even be slower than single-threading if other applications are running concurrently. A fixed, moderate number of threads provides more stable and predictable behavior.
    -   **Prevents UI Jank:** It ensures that the inference workload doesn't consume all CPU resources, leaving cycles for the critical UI thread to run smoothly and prevent a sluggish user experience.
    -   **Manages Thermal Throttling:** Running all CPU cores at maximum capacity generates significant heat, leading the OS to quickly throttle the processor. A moderately threaded workload can often provide higher sustained performance by avoiding this throttling cliff.
    -   **Optimizes for big.LITTLE Architectures:** Many mobile processors have a mix of powerful "big" cores and efficient "LITTLE" cores. Limiting the threads to a number like 4 often encourages the OS to schedule the work on the high-performance "big" cores, leading to better results than spreading the work across all available cores.

#### GPU Optimizations
-   **`isPrecisionLossAllowed = true`:** This allows the GPU delegate to perform calculations using 16-bit floating-point numbers (FP16) instead of the standard 32-bit (FP32). FP16 computations are significantly faster and more memory-efficient on most mobile GPUs, providing a substantial performance boost with a negligible impact on model accuracy.
-   **`setInferencePreference(GpuDelegate.Options.INFERENCE_PREFERENCE_SUSTAINED_SPEED)`:** This setting directs the GPU delegate to optimize for sustained throughput, which is ideal for real-time video processing. It prioritizes maintaining a consistent and high frame rate over a long duration, rather than the lowest possible latency for a single inference.

### System Health & Adaptive AI

The application's core feature is its ability to adapt to changing system conditions. It uses the custom `system_monitor` package to receive a stream of `SystemHealthState` data (`NORMAL`, `WARNING`, or `CRITICAL`). This state is then used to apply a corresponding `YOLOStreamingConfig` and adjust inference thresholds, creating a feedback loop that balances performance with device stability.

The combined adaptive settings are as follows:

| System Health | `YOLOStreamingConfig` | Inference Freq. | Confidence | IoU    | Max Items |
| :------------ | :-------------------- | :-------------- | :--------- | :----- | :-------- |
| **`NORMAL`**  | `highPerformance`     | `null` (Max)    | `0.5`      | `0.45` | `30`      |
| **`WARNING`** | `lowPerformance`      | `10 Hz`         | `0.4`      | `0.5`  | `20`      |
| **`CRITICAL`**| `powerSaving`         | `5 Hz`          | `0.3`      | `0.6`  | `10`      |

-   **NORMAL:** The app runs with maximum inference frequency for the highest accuracy and real-time responsiveness.
-   **WARNING (Throttled):** The inference frequency is capped at 10 Hz, and detection thresholds are adjusted to reduce the computational load.
-   **CRITICAL:** The app enters a `powerSaving` mode, limiting inference to 5 Hz and using the most restrictive thresholds to minimize resource consumption and allow the device to cool down.

![IoU Example](assets/iou.png)

## Getting Started

1.  **Clone the repository:**
    ```bash
    git clone git@github.com:pritam-bs/yolo.git
    cd yolo
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```