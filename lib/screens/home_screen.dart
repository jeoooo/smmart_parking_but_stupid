import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'customer/session_screen.dart';
import 'customer/receipt_screen.dart';

// Mock availability data
const _gates = [
  (label: 'Gate A · Main Entrance', available: 124, total: 200),
  (label: 'Gate B · North Wing', available: 87, total: 150),
  (label: 'Gate C · Food Court', available: 0, total: 80),
];

final _steps = [
  (
    icon: LucideIcons.qrCode,
    title: 'Scan Entry QR',
    desc: 'At the parking entrance',
    color: AppColors.primary,
  ),
  (
    icon: LucideIcons.car,
    title: 'Park Vehicle',
    desc: 'Timer runs in the background',
    color: AppColors.primary,
  ),
  (
    icon: LucideIcons.logOut,
    title: 'Scan Exit QR',
    desc: 'When you\'re ready to leave',
    color: AppColors.primary,
  ),
  (
    icon: LucideIcons.creditCard,
    title: 'Pay & Exit',
    desc: 'GCash, Maya, or Card',
    color: AppColors.primary,
  ),
];

final _mockHistory = <ParkingSession>[
  ParkingSession(
    sessionId: 'SP-20260308-4521',
    plateNumber: 'DAV 2026',
    entryGate: 'Gate A \u2014 Main Entrance',
    entryTime: DateTime(2026, 3, 8, 10, 15),
    exitTime: DateTime(2026, 3, 8, 13, 42),
    status: SessionStatus.paid,
    paymentStatus: PaymentStatus.completed,
    paymentMethod: PaymentMethod.gcash,
    transactionId: 'TXN1741394520000',
  ),
  ParkingSession(
    sessionId: 'SP-20260301-2089',
    plateNumber: 'DAV 2026',
    entryGate: 'Gate B \u2014 North Wing',
    entryTime: DateTime(2026, 3, 1, 14, 30),
    exitTime: DateTime(2026, 3, 1, 16, 5),
    status: SessionStatus.paid,
    paymentStatus: PaymentStatus.completed,
    paymentMethod: PaymentMethod.maya,
    transactionId: 'TXN1740815400000',
  ),
  ParkingSession(
    sessionId: 'SP-20260218-7734',
    plateNumber: 'DAV 2026',
    entryGate: 'Gate A \u2014 Main Entrance',
    entryTime: DateTime(2026, 2, 18, 9, 0),
    exitTime: DateTime(2026, 2, 18, 11, 30),
    status: SessionStatus.paid,
    paymentStatus: PaymentStatus.completed,
    paymentMethod: PaymentMethod.card,
    transactionId: 'TXN1739844000000',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  int get _totalAvailable => _gates.fold(0, (s, g) => s + g.available);
  int get _totalSpaces => _gates.fold(0, (s, g) => s + g.total);
  int get _totalOccupied => _totalSpaces - _totalAvailable;
  Timer? _liveTimer;

  @override
  void initState() {
    super.initState();
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHero(context),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildAvailabilityTab(context),
                _buildRecordsTab(context),
                _buildInfoTab(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.mapPin),
            selectedIcon: Icon(LucideIcons.mapPin),
            label: 'Availability',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.clock),
            selectedIcon: Icon(LucideIcons.clock),
            label: 'Records',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.info),
            selectedIcon: Icon(LucideIcons.info),
            label: 'Info',
          ),
        ],
      ),
    );
  }

  // ── Tab 0: Live availability + Start Parking ──────────────────────────────

  Widget _buildAvailabilityTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Occupancy summary ────────────────────────────────────────────
          SectionLabel(label: 'Live Availability'),
          const SizedBox(height: 10),
          OccupancySummary(
            available: _totalAvailable,
            occupied: _totalOccupied,
            total: _totalSpaces,
          ),
          const SizedBox(height: 10),
          ..._gates.map((g) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GateCard(gate: g),
              )),

          const SizedBox(height: 24),

          // ── Entry QR ─────────────────────────────────────────────────────
            SectionLabel(label: 'Start Parking'),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Scan to Start Parking',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Point your phone camera at any entrance QR code.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  MockQRCode(
                    data: 'https://smartparking.smcitydavao.ph/entry/gate-a',
                    size: 200,
                  ),
                  const SizedBox(height: 12),
                  StatusChip(
                    label: 'GATE A · MAIN ENTRANCE',
                    color: AppColors.primary,
                    bgColor: context.colPrimaryLight,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: context.colSuccessLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.circleCheck,
                            color: AppColors.success, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'No app download required',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: AppColors.success),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Demo launcher ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colPrimaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.beaker,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Demo mode — tap below to simulate scanning the entry QR code.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () {
              SessionManager.startSession();
              Navigator.pushNamed(context, '/entry');
            },
            icon: const Icon(LucideIcons.qrCode),
            label: const Text('Simulate Entry Scan'),
          ),
        ],
      ),
    );
  }

  // ── Tab 1: Parking Records ────────────────────────────────────────────────

  Widget _buildRecordsTab(BuildContext context) {
    final session = SessionManager.current;
    final hasActiveSession =
        session != null && session.status != SessionStatus.exited;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasActiveSession) ...[  
            SectionLabel(label: 'Current Session'),
            const SizedBox(height: 10),
            _buildActiveSessionCard(context, session),
            const SizedBox(height: 24),
          ],
          SectionLabel(label: 'Parking History'),
          const SizedBox(height: 10),
          if (_mockHistory.isEmpty)
            _buildEmptyHistory(context)
          else
            ..._mockHistory.map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildHistoryCard(context, s),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard(
      BuildContext context, ParkingSession session) {
    final (badgeLabel, badgeColor, badgeBg) = switch (session.status) {
      SessionStatus.pendingPayment => (
          'PENDING PAYMENT',
          AppColors.warning,
          context.colWarningLight,
        ),
      SessionStatus.paid => (
          'PAID',
          AppColors.success,
          context.colSuccessLight,
        ),
      _ => ('ACTIVE', AppColors.success, context.colSuccessLight),
    };
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionScreen(session: session),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.sessionId,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        session.plateNumber ?? '\u2014',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                StatusChip(
                  label: badgeLabel,
                  color: badgeColor,
                  bgColor: badgeBg,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 6),
            InfoRow(label: 'Gate', value: session.entryGate),
            InfoRow(
                label: 'Entry Time',
                value: Fmt.dateTime(session.entryTime)),
            InfoRow(label: 'Duration', value: session.formattedDuration),
            InfoRow(
                label: 'Running Fee',
                value: ParkingRate.format(session.fee),
                valueColor: AppColors.primary),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, ParkingSession session) {
    final methodColor = switch (session.paymentMethod) {
      PaymentMethod.gcash => AppColors.gcash,
      PaymentMethod.maya => AppColors.maya,
      PaymentMethod.card => AppColors.card,
      null => AppColors.textSecondary,
    };
    final methodLabel = session.paymentMethod?.name.toUpperCase() ?? '\u2014';
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiptScreen(session: session),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    Fmt.date(session.entryTime),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  ParkingRate.format(session.fee),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              session.entryGate,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(LucideIcons.clock,
                    size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(session.formattedDuration,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 14),
                Icon(LucideIcons.creditCard, size: 13, color: methodColor),
                const SizedBox(width: 4),
                Text(
                  methodLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: methodColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildEmptyHistory(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(LucideIcons.car,
                size: 48,
                color: AppColors.textSecondary.withValues(alpha: 0.35)),
            const SizedBox(height: 12),
            Text(
              'No parking records yet',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab 2: Info (How It Works + Rates) ────────────────────────────────────

  Widget _buildInfoTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(label: 'How It Works'),
          const SizedBox(height: 10),
          ...List.generate(
            _steps.length,
            (i) => StepItem(
              number: '${i + 1}',
              icon: _steps[i].icon,
              title: _steps[i].title,
              desc: _steps[i].desc,
              isLast: i == _steps.length - 1,
            ),
          ),
          const SizedBox(height: 28),
          SectionLabel(label: 'Parking Rates'),
          const SizedBox(height: 10),
          const RateCard(),
        ],
      ),
    );
  }

  // ── Persistent hero header ────────────────────────────────────────────────

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/logos/SM_2022.svg',
              width: 44,
              height: 44,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SMART PARKING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'HenrySans',
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'SM City Davao',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'HenrySans',
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4AFF91),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'HenrySans',
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




