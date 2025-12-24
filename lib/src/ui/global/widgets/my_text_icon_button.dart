import 'package:flutter/material.dart';
import 'package:puzzle_hack/src/ui/utils/colors.dart';
import 'package:puzzle_hack/src/ui/utils/responsive.dart';
import '../../utils/dark_mode_extension.dart';

class MyTextIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  final double height;
  const MyTextIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.height,
  }) : super(key: key);

  @override
  State<MyTextIconButton> createState() => _MyTextIconButtonState();
}

class _MyTextIconButtonState extends State<MyTextIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    final padding = Responsive.of(context).dp(1.3);
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode ? darkGradient : lightGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: TextButton.icon(
          onPressed: widget.onPressed,
          onLongPress: widget.onPressed,
          onHover: (isHovered) {
            if (isHovered != _isPressed) {
              setState(() => _isPressed = false);
            }
          },
          onFocusChange: (hasFocus) {
            if (!hasFocus && _isPressed) {
              setState(() => _isPressed = false);
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.transparent,
            ),
            foregroundColor: WidgetStateProperty.all(
              isDarkMode ? Colors.white : darkColor,
            ),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                Future.delayed(Duration.zero, () {
                  if (mounted) setState(() => _isPressed = true);
                });
                return (isDarkMode ? Colors.white : darkColor)
                    .withOpacity(0.15);
              }
              if (states.contains(WidgetState.hovered)) {
                return (isDarkMode ? Colors.white : darkColor)
                    .withOpacity(0.08);
              }
              Future.delayed(Duration.zero, () {
                if (mounted && _isPressed) setState(() => _isPressed = false);
              });
              return Colors.transparent;
            }),
            fixedSize: WidgetStateProperty.all(
              Size.fromHeight(widget.height),
            ),
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: padding,
              ).copyWith(right: padding * 2),
            ),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            animationDuration: const Duration(milliseconds: 100),
            splashFactory: InkRipple.splashFactory,
          ),
          icon: widget.icon,
          label: Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
