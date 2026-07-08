import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'pam_icon.dart';

class FanmBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FanmBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const tabs = [
    _NavItem('Home', 'home'),
    _NavItem('Calendar', 'calendar'),
    _NavItem('Self Care', 'flower'),
    _NavItem('Analysis', 'analysis'),
    _NavItem('Profile', 'profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (index) {
              final tab = tabs[index];
              final isSelected = currentIndex == index;
              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PamIcon(
                        name: tab.iconName,
                        size: isSelected ? 22 : 18,
                        color: isSelected ? AppColors.primary : AppColors.textHint,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tab.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textHint,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String iconName;
  const _NavItem(this.label, this.iconName);
}
