import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المحفظة', style: AppTypography.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF273844), Color(0xFF101C25)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primaryGold.withOpacity(0.4)),
                boxShadow: const [
                  BoxShadow(color: AppColors.goldGlow, blurRadius: 20, offset: Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('رصيد من المتعة', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold)),
                      const Icon(Icons.account_balance_wallet, color: AppColors.primaryGold, size: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('الرصيد المتاح', style: AppTypography.bodySmall),
                  const SizedBox(height: 4),
                  Text('١,٢٤٠ ر.س', style: AppTypography.headingLarge.copyWith(color: AppColors.primaryGold, fontSize: 34)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'إضافة رصيد',
                          height: 44,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'تحويل',
                          isOutlined: true,
                          height: 44,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Transactions Header
            Text('آخر العمليات', style: AppTypography.titleLarge),
            const SizedBox(height: 12),

            _buildTransactionItem(
              title: 'حجز تجربة مناطيد العُلا',
              date: '٢ أكتوبر ٢٠٢٦',
              amount: '-٣٤٠ ر.س',
              isCredit: false,
            ),
            _buildTransactionItem(
              title: 'إعادة شحن المحفظة (Apple Pay)',
              date: '٢٨ سبتمبر ٢٠٢٦',
              amount: '+١,٠٠٠ ر.س',
              isCredit: true,
            ),
            _buildTransactionItem(
              title: 'شراء من بازار مُضيف',
              date: '١٥ سبتمبر ٢٠٢٦',
              amount: '-١٩٠ ر.س',
              isCredit: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String date,
    required String amount,
    required bool isCredit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCredit ? AppColors.success.withOpacity(0.15) : AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isCredit ? AppColors.success : AppColors.primaryGold,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleSmall),
                  const SizedBox(height: 2),
                  Text(date, style: AppTypography.bodySmall),
                ],
              ),
            ],
          ),
          Text(
            amount,
            style: AppTypography.titleSmall.copyWith(
              color: isCredit ? AppColors.success : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
