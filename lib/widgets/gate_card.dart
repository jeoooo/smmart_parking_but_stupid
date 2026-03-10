import 'package:flutter/material.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Gate Card — single parking gate availability row with progress bar
// ---------------------------------------------------------------------------

class GateCard extends StatelessWidget {
  final ({String label, int available, int total}) gate;
  const GateCard({super.key, required this.gate});

  @override
  Widget build(BuildContext context) {
    final isFull = gate.available == 0;
    final pct = gate.total > 0 ? gate.available / gate.total : 0.0;
    final statusColor = isFull ? AppColors.error : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.colCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gate.label, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 4,
                    backgroundColor: statusColor.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isFull ? 'FULL' : '${gate.available}',
                style: TextStyle(
                  fontFamily: 'HenrySans',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: statusColor,
                ),
              ),
              Text('/ ${gate.total}', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
