import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.current!;

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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colSuccessLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.circleCheck,
                        color: AppColors.success, size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text('Session Started!',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Your parking session is now active.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          InfoRow(
                              label: 'Session ID', value: session.sessionId),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Entry Gate', value: session.entryGate),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Entry Time',
                              value: Fmt.dateTime(session.entryTime)),
                          const Divider(height: 20),
                          InfoRow(
                              label: 'Plate Number',
                              value: session.plateNumber ?? '\u2014'),
                          const Divider(height: 20),
                          const InfoRow(
                            label: 'Status',
                            value: 'ACTIVE',
                            valueColor: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colWarningLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.bookmark,
                            color: AppColors.warning, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Bookmark this page to check your session status anytime.',
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
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/session'),
                    child: const Text('View Active Session'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
