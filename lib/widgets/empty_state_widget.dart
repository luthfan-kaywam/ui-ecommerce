import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Glowing Icon Card Container
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF4C53A5).withValues(alpha: 0.08),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4C53A5).withValues(alpha: 0.06),
                  blurRadius: 20,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 70,
              color: const Color(0xFF4C53A5),
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C53A5),
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 10),

          // Message/Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),

          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C53A5),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
                shadowColor: const Color(0xFF4C53A5).withValues(alpha: 0.4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
