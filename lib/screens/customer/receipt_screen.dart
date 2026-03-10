import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class ReceiptScreen extends StatelessWidget {
  final ParkingSession? session;
  const ReceiptScreen({super.key, this.session});

  @override
  Widget build(BuildContext context) {
    final session = this.session ?? SessionManager.current!;
    final methodName = switch (session.paymentMethod!) {
      PaymentMethod.gcash => 'GCash',
      PaymentMethod.maya => 'Maya',
      PaymentMethod.card => 'Credit/Debit Card',
    };
    final dur = session.duration;
    final totalHours = (dur.inMinutes / 60).ceil();
    final additionalHours = totalHours > ParkingRate.baseHours
        ? totalHours - ParkingRate.baseHours
        : 0;

    return Scaffold(
      backgroundColor: context.colBackground,
      body: Column(
        children: [
          const BrandHeader(compact: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Receipt card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colCard,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Receipt header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: context.colPrimaryLight,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/logos/SM_2022.svg',
                                    width: 22,
                                    height: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'SM SmartParking',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'SM City Davao',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.primary),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'DIGITAL RECEIPT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Divider
                        Container(
                            width: double.infinity,
                            height: 1,
                            color: context.colBorder),

                        // Receipt body
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              InfoRow(
                                  label: 'Transaction ID',
                                  value: session.transactionId ?? '\u2014'),
                              const Divider(height: 20),
                              InfoRow(
                                  label: 'Session ID',
                                  value: session.sessionId),
                              const SizedBox(height: 20),

                              // Entry/Exit details
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: context.colBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    DetailRow(
                                        icon: LucideIcons.logIn,
                                        label: 'Entry',
                                        value: Fmt.dateTime(
                                            session.entryTime)),
                                    const SizedBox(height: 8),
                                    DetailRow(
                                        icon: LucideIcons.mapPin,
                                        label: 'Gate',
                                        value: session.entryGate),
                                    const SizedBox(height: 8),
                                    DetailRow(
                                        icon: LucideIcons.logOut,
                                        label: 'Exit',
                                        value: Fmt.dateTime(
                                            session.exitTime!)),
                                    const SizedBox(height: 8),
                                    DetailRow(
                                        icon: LucideIcons.timer,
                                        label: 'Duration',
                                        value: session.formattedDuration),
                                    if (session.plateNumber != null) ...[
                                      const SizedBox(height: 8),
                                      DetailRow(
                                          icon: LucideIcons.car,
                                          label: 'Plate',
                                          value: session.plateNumber!),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Fee breakdown
                              InfoRow(
                                  label:
                                      'Base Rate (first ${ParkingRate.baseHours} hrs)',
                                  value: ParkingRate.format(
                                      ParkingRate.baseRate)),
                              if (additionalHours > 0) ...[
                                const Divider(height: 20),
                                InfoRow(
                                  label: 'Additional ($additionalHours hr)',
                                  value: ParkingRate.format(
                                      additionalHours *
                                          ParkingRate.hourlyRate),
                                ),
                              ],
                              const SizedBox(height: 16),

                              // Total
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: context.colSuccessLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'TOTAL PAID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.success,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      ParkingRate.format(session.fee),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              InfoRow(
                                  label: 'Payment Method',
                                  value: methodName),
                              const Divider(height: 20),
                              const InfoRow(
                                  label: 'Payment Status',
                                  value: 'PAID',
                                  valueColor: AppColors.success),
                              const Divider(height: 20),
                              InfoRow(
                                  label: 'Date',
                                  value: Fmt.date(DateTime.now())),
                            ],
                          ),
                        ),

                        Container(
                            width: double.infinity,
                            height: 1,
                            color: context.colBorder),

                        // Footer with QR
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              MockQRCode(
                                  data: session.transactionId ??
                                      session.sessionId,
                                  size: 120),
                              const SizedBox(height: 12),
                              Text(
                                'Present at exit gate for validation',
                                style:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Thank you for parking at\nSM City Davao!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This serves as your official digital parking receipt.',
                                style: Theme.of(context).textTheme.labelSmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      SessionManager.reset();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    icon: const Icon(LucideIcons.house),
                    label: const Text('Return to Home'),
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

