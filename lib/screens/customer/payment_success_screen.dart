import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late Timer _timer;
  int _remainingSeconds = ParkingRate.exitGraceMinutes * 60;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0 && mounted) {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timerText {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.current;
    if (session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final methodName = switch (session.paymentMethod) {
      PaymentMethod.gcash => 'GCash',
      PaymentMethod.maya => 'Maya',
      PaymentMethod.card => 'Card',
      null => 'Unknown',
    };

    final isUrgent = _remainingSeconds <= 60;

    return Scaffold(
      appBar: const BrandHeader(compact: true),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.colSuccessLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.circleCheck,
                        color: AppColors.success, size: 64),
                  ),
                  const SizedBox(height: 16),
                  Text('Payment Successful!',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${ParkingRate.format(session.fee)} paid via $methodName',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: context.colTextSecondary),
                  ),
                  const SizedBox(height: 28),

                  // Exit validity countdown
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? context.colErrorLight
                          : context.colPrimaryLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (isUrgent ? AppColors.error : AppColors.primary)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'EXIT VALIDITY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: isUrgent
                                ? AppColors.error
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _timerText,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'HenrySans',
                            color: isUrgent
                                ? AppColors.error
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _remainingSeconds > 0
                              ? 'Please exit within this time window'
                              : 'Exit validity expired \u2014 contact staff',
                          style: TextStyle(
                            fontSize: 13,
                            color: isUrgent
                                ? AppColors.error
                                : context.colTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Transaction details
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          InfoRow(
                              label: 'Transaction ID',
                              value: session.transactionId ?? '\u2014'),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Session ID',
                              value: session.sessionId),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Duration',
                              value: session.formattedDuration),
                          const Divider(height: 20),
                          InfoRow(
                            label: 'Amount Paid',
                            value: ParkingRate.format(session.fee),
                            valueColor: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gate reminder
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colWarningLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.triangleAlert,
                            color: AppColors.warning, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Present this screen or your receipt at the exit gate for validation.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: context.colTextPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/receipt'),
                    icon: const Icon(LucideIcons.receipt),
                    label: const Text('View Digital Receipt'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      SessionManager.reset();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    child: const Text('Return to Home'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
