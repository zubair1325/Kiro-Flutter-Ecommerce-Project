class OperationState {
  bool? isFailed;
  String? message;
  OperationState(this.message, {this.isFailed = false});
}
