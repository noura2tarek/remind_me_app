// repeat option container widget
import 'package:flutter/material.dart';

class RepeatContainer extends StatelessWidget {
  const RepeatContainer({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: isSelected
            ? Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.check, color: Colors.white, size: 16),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
      ),
    );
  }
}
