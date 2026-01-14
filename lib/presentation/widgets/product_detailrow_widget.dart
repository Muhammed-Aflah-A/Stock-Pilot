import 'package:flutter/material.dart';

class DetailRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;
  final Color? valueColor;
  final bool showDot;

  const DetailRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.valueColor,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  if (showDot)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: valueColor ?? Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: Colors.grey[300], height: 1),
      ],
    );
  }
}
