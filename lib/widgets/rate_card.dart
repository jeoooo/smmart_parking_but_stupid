import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme.dart';
import '../models.dart';

// ---------------------------------------------------------------------------
// Rate Card — displays base rate, hourly rate, and exit grace period
// ---------------------------------------------------------------------------

class RateCard extends StatelessWidget {
  const RateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(LucideIcons.circleDollarSign,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text('Parking Rates',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          _RateRow(
              label: 'First ${ParkingRate.baseHours} hours',
              value: ParkingRate.format(ParkingRate.baseRate),
              context: context),
          const Divider(height: 14),
          _RateRow(
              label: 'Per hour after',
              value: ParkingRate.format(ParkingRate.hourlyRate),
              context: context),
          const Divider(height: 14),
          _RateRow(
              label: 'Exit grace period',
              value: '${ParkingRate.exitGraceMinutes} min',
              context: context),
        ],
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;
  const _RateRow(
      {required this.label, required this.value, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
