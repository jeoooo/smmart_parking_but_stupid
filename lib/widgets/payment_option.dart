import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Payment Option — tappable card for GCash, Maya, or Card selection
// ---------------------------------------------------------------------------

class PaymentOption extends StatelessWidget {
  final Widget logo;
  final String name;
  final String description;
  final Color bgColor;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.logo,
    required this.name,
    required this.description,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.colCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: logo,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: context.colTextSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
