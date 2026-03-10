import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class SessionScreen extends StatefulWidget {
  final ParkingSession? session;
  const SessionScreen({super.key, this.session});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session ?? SessionManager.current!;
    final dur = session.duration;
    final hours = dur.inHours.toString().padLeft(2, '0');
    final minutes = (dur.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (dur.inSeconds % 60).toString().padLeft(2, '0');

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
                  StatusChip(
                    label: '\u25CF  SESSION ACTIVE',
                    color: AppColors.success,
                    bgColor: context.colSuccessLight,
                  ),
                  const SizedBox(height: 24),

                  // Timer display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'ELAPSED TIME',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$hours:$minutes:$seconds',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'HenrySans',
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Estimated Fee: ${ParkingRate.format(session.fee)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Session details
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Session Details',
                              style:
                                  Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 12),
                          InfoRow(
                              label: 'Session ID',
                              value: session.sessionId),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Entry Gate',
                              value: session.entryGate),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Entry Time',
                              value: Fmt.dateTime(session.entryTime)),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Plate Number',
                              value: session.plateNumber ?? '\u2014'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rate info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rate Info',
                              style:
                                  Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 12),
                          InfoRow(
                              label: 'Base Rate (first 3 hrs)',
                              value:
                                  ParkingRate.format(ParkingRate.baseRate)),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Additional per hour',
                              value:
                                  ParkingRate.format(ParkingRate.hourlyRate)),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Exit grace period',
                              value:
                                  '${ParkingRate.exitGraceMinutes} minutes'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Demo hint
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colPrimaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.info,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Demo: Tap below to simulate scanning the exit QR code.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      SessionManager.scanExit();
                      Navigator.pushNamed(context, '/exit-payment');
                    },
                    icon: const Icon(LucideIcons.logOut),
                    label: const Text('Scan Exit QR'),
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
