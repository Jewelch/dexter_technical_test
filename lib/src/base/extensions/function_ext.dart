extension CallbackExt on Function {
  void execute(Function fn, {bool? when}) => (when ?? false) ? this(fn.call()) : null;
}
