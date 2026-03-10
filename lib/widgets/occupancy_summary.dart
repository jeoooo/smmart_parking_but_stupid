import 'package:flutter/material.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Occupancy Summary — progress bar + stats for available/occupied/total
// ---------------------------------------------------------------------------

class OccupancySummary extends StatelessWidget {
  final int available;
  final int occupied;
  final int total;

  const OccupancySummary({
    super.key,
    required this.available,
    required this.occupied,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? occupied / total : 0.0;
    return Container(
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
              _Stat(value: '$available', label: 'Available', color: AppColors.success),
              _divider(),
              _Stat(value: '$occupied', label: 'Occupied', color: AppColors.error),
              _divider(),
              _Stat(value: '$total', label: 'Total', color: context.colTextPrimary),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: AppColors.success.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                pct > 0.9 ? AppColors.error : AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: AppColors.border,
      );
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _Stat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                fontFamily: 'HenrySans',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              )),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
