enum PaymentMethod { gcash, maya, card }

enum SessionStatus { active, pendingPayment, paid, exited }

enum PaymentStatus { pending, processing, completed, failed }

// ── Branch / Gate data ────────────────────────────────────────────────────────

typedef GateData = ({String label, int available, int total});

class SmBranch {
  final String id;
  final String name;
  final List<GateData> gates;

  const SmBranch({
    required this.id,
    required this.name,
    required this.gates,
  });
}

class BranchManager {
  static final List<SmBranch> branches = [
    SmBranch(
      id: 'smcd',
      name: 'SM City Davao',
      gates: [
        (label: 'Gate A · Main Entrance', available: 124, total: 200),
        (label: 'Gate B · North Wing', available: 87, total: 150),
        (label: 'Gate C · Food Court', available: 0, total: 80),
      ],
    ),
    SmBranch(
      id: 'smlp',
      name: 'SM Lanang Premier',
      gates: [
        (label: 'Gate 1 · Main Entrance', available: 98, total: 180),
        (label: 'Gate 2 · Upper Ground', available: 45, total: 120),
        (label: 'Gate 3 · Seaside Wing', available: 12, total: 90),
      ],
    ),
  ];

  static SmBranch current = branches.first;

  static void select(SmBranch branch) => current = branch;
}

// ─────────────────────────────────────────────────────────────────────────────

class ParkingRate {
  static const double baseRate = 40.0;
  static const int baseHours = 3;
  static const double hourlyRate = 20.0;
  static const int exitGraceMinutes = 15;

  static double compute(Duration duration) {
    if (duration.inMinutes <= 0) return 0;
    final hours = (duration.inMinutes / 60).ceil();
    if (hours <= baseHours) return baseRate;
    return baseRate + ((hours - baseHours) * hourlyRate);
  }

  static String format(double amount) => '\u20B1${amount.toStringAsFixed(2)}';
}

class ParkingSession {
  String sessionId;
  String? plateNumber;
  String entryGate;
  String branchName;
  DateTime entryTime;
  DateTime? exitTime;
  SessionStatus status;
  PaymentStatus paymentStatus;
  PaymentMethod? paymentMethod;
  String? transactionId;

  ParkingSession({
    required this.sessionId,
    this.plateNumber,
    required this.entryGate,
    String? branchName,
    required this.entryTime,
    this.exitTime,
    this.status = SessionStatus.active,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentMethod,
    this.transactionId,
  }) : branchName = branchName ?? BranchManager.current.name;

  Duration get duration => (exitTime ?? DateTime.now()).difference(entryTime);
  double get fee => ParkingRate.compute(duration);

  String get formattedDuration {
    final d = duration;
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}

class Fmt {
  static String time(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  static String date(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  static String dateTime(DateTime dt) => '${date(dt)} at ${time(dt)}';
}

class SessionManager {
  static ParkingSession? current;

  static void startSession() {
    final branch = BranchManager.current;
    current = ParkingSession(
      sessionId:
          'SP-20260310-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}',
      plateNumber: 'DAV 2026',
      entryGate: branch.gates.first.label,
      branchName: branch.name,
      entryTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 34)),
    );
  }

  static void scanExit() {
    current?.exitTime = DateTime.now();
    current?.status = SessionStatus.pendingPayment;
  }

  static void pay(PaymentMethod method) {
    current?.paymentMethod = method;
    current?.paymentStatus = PaymentStatus.completed;
    current?.status = SessionStatus.paid;
    current?.transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
  }

  static void reset() {
    current = null;
  }
}
