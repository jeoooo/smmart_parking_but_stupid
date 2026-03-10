import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

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
                  Text('Select Payment',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Choose your preferred payment method.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: context.colPrimaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Amount: ${ParkingRate.format(session.fee)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  PaymentOption(
                    icon: LucideIcons.wallet,
                    name: 'GCash',
                    description: 'Pay with your GCash wallet',
                    color: AppColors.gcash,
                    onTap: () => Navigator.pushNamed(context, '/payment-form',
                        arguments: PaymentMethod.gcash),
                  ),
                  const SizedBox(height: 12),
                  PaymentOption(
                    icon: LucideIcons.wallet,
                    name: 'Maya',
                    description: 'Pay with your Maya wallet',
                    color: AppColors.maya,
                    onTap: () => Navigator.pushNamed(context, '/payment-form',
                        arguments: PaymentMethod.maya),
                  ),
                  const SizedBox(height: 12),
                  PaymentOption(
                    icon: LucideIcons.creditCard,
                    name: 'Credit / Debit Card',
                    description: 'Visa, Mastercard, JCB',
                    color: AppColors.card,
                    onTap: () => Navigator.pushNamed(context, '/payment-form',
                        arguments: PaymentMethod.card),
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

