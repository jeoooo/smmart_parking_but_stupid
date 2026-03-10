import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme.dart';
import '../models.dart';

// ---------------------------------------------------------------------------
// Method Badge — branded header bar for the selected payment method
// ---------------------------------------------------------------------------

class MethodBadge extends StatelessWidget {
  final PaymentMethod method;
  const MethodBadge({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    final color = switch (method) {
      PaymentMethod.gcash => AppColors.gcash,
      PaymentMethod.maya => AppColors.maya,
      PaymentMethod.card => AppColors.card,
    };
    final label = switch (method) {
      PaymentMethod.gcash => 'Pay with GCash',
      PaymentMethod.maya => 'Pay with Maya',
      PaymentMethod.card => 'Credit / Debit Card',
    };
    final icon = switch (method) {
      PaymentMethod.gcash => LucideIcons.wallet,
      PaymentMethod.maya => LucideIcons.wallet,
      PaymentMethod.card => LucideIcons.creditCard,
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'HenrySans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Wallet Form — GCash / Maya mobile number input
// ---------------------------------------------------------------------------

class WalletForm extends StatelessWidget {
  final PaymentMethod method;
  final TextEditingController controller;
  const WalletForm({super.key, required this.method, required this.controller});

  @override
  Widget build(BuildContext context) {
    final label = method == PaymentMethod.gcash ? 'GCash' : 'Maya';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mobile Number', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          decoration: InputDecoration(
            hintText: '09XX XXX XXXX',
            prefixIcon: const Icon(LucideIcons.smartphone, size: 18),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: context.colSurface,
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Enter your $label number';
            if (v.length != 11 || !v.startsWith('09')) {
              return 'Enter a valid PH mobile number (09XXXXXXXXX)';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(LucideIcons.info,
                size: 13, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Enter the mobile number linked to your $label account.',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card Form — credit/debit card input fields
// ---------------------------------------------------------------------------

class CardForm extends StatelessWidget {
  final TextEditingController cardNumCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;
  final TextEditingController nameCtrl;
  final bool obscureCvv;
  final VoidCallback onToggleCvv;

  const CardForm({
    super.key,
    required this.cardNumCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
    required this.nameCtrl,
    required this.obscureCvv,
    required this.onToggleCvv,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card number
        Text('Card Number', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: cardNumCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CardNumberFormatter(),
          ],
          decoration: InputDecoration(
            hintText: '0000 0000 0000 0000',
            prefixIcon: const Icon(LucideIcons.creditCard, size: 18),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: context.colSurface,
          ),
          validator: (v) {
            final clean = v?.replaceAll(' ', '') ?? '';
            if (clean.length != 16) return 'Enter a valid 16-digit card number';
            return null;
          },
        ),
        const SizedBox(height: 14),

        // Expiry + CVV row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expiry', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: expiryCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _ExpiryFormatter(),
                    ],
                    decoration: InputDecoration(
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: context.colSurface,
                    ),
                    validator: (v) {
                      if (v == null || v.length < 5) return 'MM/YY';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CVV', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: cvvCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: obscureCvv,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                      hintText: '•••',
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureCvv ? LucideIcons.eyeOff : LucideIcons.eye,
                          size: 16,
                        ),
                        onPressed: onToggleCvv,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: context.colSurface,
                    ),
                    validator: (v) {
                      if (v == null || v.length < 3) return 'Required';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Cardholder name
        Text('Cardholder Name', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: nameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Name as it appears on card',
            prefixIcon: const Icon(LucideIcons.user, size: 18),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: context.colSurface,
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter cardholder name';
            return null;
          },
        ),
        const SizedBox(height: 14),

        // Accepted cards
        Row(
          children: [
            const Icon(LucideIcons.shieldCheck,
                size: 13, color: AppColors.success),
            const SizedBox(width: 6),
            Text(
              'Visa · Mastercard · JCB',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.success),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Input formatters (private helpers)
// ---------------------------------------------------------------------------

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(' ', '');
    if (digits.length > 16) return old;
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final str = buf.toString();
    return next.copyWith(
        text: str, selection: TextSelection.collapsed(offset: str.length));
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll('/', '');
    if (digits.length > 4) return old;
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2) buf.write('/');
      buf.write(digits[i]);
    }
    final str = buf.toString();
    return next.copyWith(
        text: str, selection: TextSelection.collapsed(offset: str.length));
  }
}
