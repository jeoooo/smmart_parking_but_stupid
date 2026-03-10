import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Status Chip — compact pill badge with label, color, and background color
// ---------------------------------------------------------------------------

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const StatusChip(
      {super.key,
      required this.label,
      required this.color,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

// ---------------------------------------------------------------------------
// Previews
// ---------------------------------------------------------------------------

Widget _pad(Widget child) => Padding(padding: const EdgeInsets.all(8), child: child);

@Preview(name: 'StatusChip \u00B7 Active')
Widget previewActive() => _pad(const StatusChip(
      label: '\u25CF  SESSION ACTIVE',
      color: AppColors.success,
      bgColor: AppColors.successLight,
    ));

@Preview(name: 'StatusChip \u00B7 Pending Payment')
Widget previewPending() => _pad(const StatusChip(
      label: '\u25CF  PENDING PAYMENT',
      color: AppColors.warning,
      bgColor: AppColors.warningLight,
    ));

@Preview(name: 'StatusChip \u00B7 Payment Failed')
Widget previewFailed() => _pad(const StatusChip(
      label: '\u2715  PAYMENT FAILED',
      color: AppColors.error,
      bgColor: AppColors.errorLight,
    ));

@Preview(name: 'StatusChip \u00B7 Paid')
Widget previewPaid() => _pad(const StatusChip(
      label: '\u2713  PAID',
      color: AppColors.success,
      bgColor: AppColors.successLight,
    ));

@Preview(name: 'StatusChip \u00B7 Dark Active')
Widget previewDarkActive() => Theme(
      data: AppTheme.darkTheme,
      child: _pad(StatusChip(
        label: '\u25CF  SESSION ACTIVE',
        color: AppColors.success,
        bgColor: AppColors.darkSuccessLight,
      )),
    );
