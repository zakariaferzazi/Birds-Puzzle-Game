import 'package:flutter/material.dart';
import 'package:puzzle_hack/src/ui/utils/colors.dart';
import 'package:puzzle_hack/src/ui/utils/responsive.dart';
import 'package:puzzle_hack/src/ui/utils/dark_mode_extension.dart';

class MyIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  const MyIconButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
  }) : super(key: key);

  @override
  State<MyIconButton> createState() => _MyIconButtonState();
}

class _MyIconButtonState extends State<MyIconButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    final size = Responsive.of(context).dp(6).clamp(40, 80).toDouble();
    return AnimatedScale(
      scale: _isPressed ? 0.9 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOutCubic,
      child: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode ? darkGradient : lightGradient,
          shape: BoxShape.circle,
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: MaterialButton(
          onPressed: widget.onPressed,
          onHighlightChanged: (isPressed) {
            setState(() => _isPressed = isPressed);
          },
          minWidth: size,
          height: size,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 2),
          ),
          color: Colors.transparent,
          child: Icon(
            widget.iconData,
            size: size * 0.4,
          ),
        ),
      ),
    );
  }
}
