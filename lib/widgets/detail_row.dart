import 'package:flutter/material.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Detail Row — icon + label + value row used in the receipt screen
// ---------------------------------------------------------------------------

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow(
      {super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.colTextSecondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: Text(value,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.right),
        ),
      ],
    );
  }
}
