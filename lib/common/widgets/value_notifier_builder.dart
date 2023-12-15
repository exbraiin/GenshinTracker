import 'package:flutter/widgets.dart';

class ValueNotifierBuilder<T> extends StatefulWidget {
  final T value;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    ValueNotifier<T> notifier,
    Widget? child,
  ) builder;

  const ValueNotifierBuilder({
    super.key,
    this.child,
    required this.value,
    required this.builder,
  });

  @override
  State<ValueNotifierBuilder<T>> createState() => _ValueNotifierBuilderState();
}

class _ValueNotifierBuilderState<T> extends State<ValueNotifierBuilder<T>> {
  late final ValueNotifier<T> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(widget.value);
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ValueNotifierBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _notifier.value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: _notifier,
      builder: (context, value, child) =>
          widget.builder(context, _notifier, child),
      child: widget.child,
    );
  }
}
