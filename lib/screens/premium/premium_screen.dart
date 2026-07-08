import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Premium header
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5FA2), Color(0xFFD8B4FE), Color(0xFF7C4DFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('👑', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    Text('Fanm+ AI Premium', style: AppTextStyles.displayMedium.copyWith(color: AppColors.white)),
                    const SizedBox(height: 8),
                    Text('Deklewe tout pouvwa Fanm+ AI',
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white.withOpacity(0.9))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Features
              Text('Karakteristik Premium', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 16),

              _PremiumFeature('🤖', 'AI Chat Illimité', 'Poze tout kesyon ou san limit'),
              _PremiumFeature('📊', 'Rapò Sante PDF', 'Ekspòte done sante w an PDF'),
              _PremiumFeature('☁️', 'Backup & Sync', 'Sekirize done w nan nwaj la'),
              _PremiumFeature('🎨', 'Tèm Premium', 'Aksè a tout tèm esklizif'),
              _PremiumFeature('📱', 'Widgets', 'Widgets ekran akèy'),
              _PremiumFeature('🔮', 'Prediksyon Avanse', 'AI prediksyon sik pi presi'),

              const SizedBox(height: 24),

              // Plans
              Text('Plan yo', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text('💎', style: TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text('Mwa', style: AppTextStyles.titleLarge),
                          const SizedBox(height: 4),
                          Text('\$4.99', style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary)),
                          Text('/mwa', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                              child: const Text('Kòmanse'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('PI BON OFR', style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          const Text('👑', style: TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text('Ane', style: AppTextStyles.titleLarge.copyWith(color: AppColors.white)),
                          const SizedBox(height: 4),
                          Text('\$29.99', style: AppTextStyles.displayMedium.copyWith(color: AppColors.white)),
                          Text('/ane', style: TextStyle(color: AppColors.white.withOpacity(0.8))),
                          const SizedBox(height: 4),
                          Text('\$2.50/mwa', style: TextStyle(color: AppColors.white.withOpacity(0.7), fontSize: 12)),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.primary,
                              ),
                              child: const Text('Kòmanse'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumFeature extends StatelessWidget {
  final String emoji, title, desc;
  const _PremiumFeature(this.emoji, this.title, this.desc);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                Text(desc, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.primary),
        ],
      ),
    );
  }
}
