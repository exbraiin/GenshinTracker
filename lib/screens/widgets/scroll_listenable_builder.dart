import 'package:flutter/widgets.dart';

/// A scrollable listenable builder
class ScrollListenableBuilder extends StatefulWidget {
  /// The child widget
  final Widget? child;

  /// The scroll predicate
  final bool Function(ScrollMetrics metrics)? scrollPredicate;

  /// The notification predicate
  final ScrollNotificationPredicate notificationPredicate;

  /// The widget builder.
  final Widget Function(BuildContext context, bool scrolled, Widget? child)?
      builder;

  /// Creates a new [ScrollListenableBuilder] instance.
  const ScrollListenableBuilder({
    super.key,
    this.child,
    this.builder,
    this.scrollPredicate,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  });

  @override
  State<ScrollListenableBuilder> createState() =>
      _ScrollListenableBuilderState();
}

class _ScrollListenableBuilderState extends State<ScrollListenableBuilder> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  var _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = null;
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification &&
        widget.notificationPredicate(notification)) {
      final oldScrolledUnder = _scrolledUnder;
      final metrics = notification.metrics;
      _scrolledUnder = widget.scrollPredicate?.call(metrics) ??
          switch (metrics.axisDirection) {
            AxisDirection.up => metrics.extentAfter > 0,
            AxisDirection.down => metrics.extentBefore > 0,
            _ => _scrolledUnder,
          };

      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder?.call(context, _scrolledUnder, widget.child) ??
        widget.child ??
        const SizedBox.shrink();
  }
}

/// A prefered size scroll listenable builder
class PreferredSizeScrollListenableBuilder extends ScrollListenableBuilder
    implements PreferredSizeWidget {
  /// Creates a new [PreferredSizeScrollListenableBuilder] instance.
  const PreferredSizeScrollListenableBuilder({
    super.key,
    super.builder,
    super.notificationPredicate,
    required PreferredSizeWidget child,
  }) : super(child: child);

  @override
  Size get preferredSize => (child as PreferredSizeWidget).preferredSize;
}
