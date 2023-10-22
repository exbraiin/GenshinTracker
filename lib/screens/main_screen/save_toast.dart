import 'package:flutter/material.dart';
import 'package:tracker/theme/theme.dart';

class Toast extends StatefulWidget {
  final bool show;

  const Toast({super.key, required this.show});

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
  late final ValueNotifier<int> _notifier;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(0);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _triggerAnimation();
  }

  @override
  void dispose() {
    _notifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Toast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.show == widget.show) return;
    _triggerAnimation();
  }

  void _triggerAnimation() {
    _notifier.value = widget.show ? 0 : 1;
    _controller.animateTo(widget.show ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          return Transform.scale(
            scale: Curves.elasticOut.transform(_controller.value),
            child: ValueListenableBuilder<int>(
              valueListenable: _notifier,
              builder: (context, value, child) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.themeColors.mainColor0,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Stack(
                        children: [
                          if (value == 0)
                            const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.6,
                            ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.save,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
