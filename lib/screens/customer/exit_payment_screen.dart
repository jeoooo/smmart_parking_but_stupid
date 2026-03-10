import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class ExitPaymentScreen extends StatelessWidget {
  const ExitPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.current!;
    final dur = session.duration;
    final totalHours = (dur.inMinutes / 60).ceil();
    final additionalHours = totalHours > ParkingRate.baseHours
        ? totalHours - ParkingRate.baseHours
        : 0;
    final additionalFee = additionalHours * ParkingRate.hourlyRate;

    return Scaffold(
      body: Column(
        children: [
          const BrandHeader(compact: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Icon(LucideIcons.receipt,
                      color: AppColors.primary, size: 40),
                  const SizedBox(height: 12),
                  Text('Exit Payment',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Review your parking summary below.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Parking Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Parking Summary',
                              style:
                                  Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 16),
                          InfoRow(
                              label: 'Entry Time',
                              value: Fmt.dateTime(session.entryTime)),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Exit Time',
                              value: Fmt.dateTime(session.exitTime!)),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Total Duration',
                              value: session.formattedDuration),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Session ID',
                              value: session.sessionId),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fee Breakdown
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fee Breakdown',
                              style:
                                  Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 16),
                          InfoRow(
                            label:
                                'Base Rate (first ${ParkingRate.baseHours} hrs)',
                            value: ParkingRate.format(ParkingRate.baseRate),
                          ),
                          if (additionalHours > 0) ...[
                            const Divider(height: 20),
                            InfoRow(
                              label:
                                  'Additional ($additionalHours hr \u00D7 ${ParkingRate.format(ParkingRate.hourlyRate)})',
                              value: ParkingRate.format(additionalFee),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.colPrimaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount Due',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  ParkingRate.format(session.fee),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/payment-method'),
                    child: const Text('Proceed to Payment'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
