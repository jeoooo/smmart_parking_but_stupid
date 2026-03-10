import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Info Row — label / value pair used across screens
// ---------------------------------------------------------------------------

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow(
      {super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: 12),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Previews
// ---------------------------------------------------------------------------

Widget _wrap(Widget child, {bool dark = false}) => Theme(
      data: dark ? AppTheme.darkTheme : AppTheme.theme,
      child: Material(
        color: dark ? AppColors.darkCard : AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: child,
        ),
      ),
    );

@Preview(name: 'InfoRow \u00B7 Plain')
Widget previewPlain() =>
    _wrap(const InfoRow(label: 'Session ID', value: 'SP-20260310-0847'));

@Preview(name: 'InfoRow \u00B7 Duration')
Widget previewDuration() =>
    _wrap(const InfoRow(label: 'Total Duration', value: '2h 34m'));

@Preview(name: 'InfoRow \u00B7 Paid (green value)')
Widget previewPaid() => _wrap(const InfoRow(
    label: 'Payment Status',
    value: 'PAID',
    valueColor: AppColors.success));

@Preview(name: 'InfoRow \u00B7 Dark')
Widget previewDark() => _wrap(
    const InfoRow(label: 'Entry Gate', value: 'Gate A \u2014 Main Entrance'),
    dark: true);
