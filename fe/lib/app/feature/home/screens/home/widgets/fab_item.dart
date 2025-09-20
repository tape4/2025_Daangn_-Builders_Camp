import 'package:flutter/material.dart';

class FABItem extends StatelessWidget {
  final String label;
  final String heroTag;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData icon;
  final double offset;
  final Animation<double> animation;

  const FABItem({
    Key? key,
    required this.label,
    required this.heroTag,
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    required this.offset,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -offset * animation.value),
      child: ScaleTransition(
        scale: animation,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              heroTag: heroTag,
              onPressed: onPressed,
              backgroundColor: backgroundColor,
              child: Icon(icon, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}