enum ModelType {
  detect('yolo11n'),
  segment('yolo11n-seg'),
  classify('yolo11n-cls'),
  pose('yolo11n-pose'),
  obb('yolo11n-obb');

  final String modelName;
  const ModelType(this.modelName);
}

enum InferenceParameter { none, numItems, confidence, iou }
