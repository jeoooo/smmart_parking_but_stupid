import 'package:flutter/material.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileCtrl = TextEditingController();
  final _cardNumCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _obscureCvv = true;

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _cardNumCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final method =
        ModalRoute.of(context)!.settings.arguments as PaymentMethod;
    final session = SessionManager.current!;

    return Scaffold(
      appBar: const BrandHeader(compact: true),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment method branded header
                    MethodBadge(method: method),
                    const SizedBox(height: 20),

                    // Amount display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.colPrimaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text('Amount to Pay',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 6),
                          Text(
                            ParkingRate.format(session.fee),
                            style: const TextStyle(
                              fontFamily: 'HenrySans',
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            session.sessionId,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form fields based on method
                    if (method == PaymentMethod.gcash ||
                        method == PaymentMethod.maya) ...[
                      WalletForm(
                        method: method,
                        controller: _mobileCtrl,
                      ),
                    ] else ...[
                      CardForm(
                        cardNumCtrl: _cardNumCtrl,
                        expiryCtrl: _expiryCtrl,
                        cvvCtrl: _cvvCtrl,
                        nameCtrl: _nameCtrl,
                        obscureCvv: _obscureCvv,
                        onToggleCvv: () =>
                            setState(() => _obscureCvv = !_obscureCvv),
                      ),
                    ],
                    const SizedBox(height: 28),

                    ElevatedButton(
                      onPressed: () => _submit(context, method),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _methodColor(method),
                      ),
                      child: Text(
                          'Pay ${ParkingRate.format(session.fee)}'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Color _methodColor(PaymentMethod method) => switch (method) {
        PaymentMethod.gcash => AppColors.gcash,
        PaymentMethod.maya => AppColors.maya,
        PaymentMethod.card => AppColors.card,
      };

  void _submit(BuildContext context, PaymentMethod method) {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: _methodColor(method)),
                const SizedBox(height: 16),
                const Text('Processing payment...'),
              ],
            ),
          ),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      SessionManager.pay(method);
      Navigator.of(context).pop();
      Navigator.pushNamedAndRemoveUntil(
          context, '/payment-success', (r) => r.settings.name == '/');
    });
  }
}


