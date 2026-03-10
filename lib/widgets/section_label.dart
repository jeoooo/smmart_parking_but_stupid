import 'package:flutter/material.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Section Label — uppercase category header used across tabs
// ---------------------------------------------------------------------------

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: context.colTextSecondary,
            letterSpacing: 1.2,
          ),
    );
  }
}
