import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_text.dart';
import '../../providers/app_state_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> _menuItems = const [
    {
      'icon': Icons.person_outline_rounded,
      'label': 'Edit Profil',
    },
    {
      'icon': Icons.location_on_outlined,
      'label': 'Alamat Pengiriman',
    },
    {
      'icon': Icons.receipt_long_outlined,
      'label': 'Riwayat Transaksi',
    },
    {
      'icon': Icons.credit_card_outlined,
      'label': 'Metode Pembayaran',
    },
    {
      'icon': Icons.notifications_none_rounded,
      'label': 'Notifikasi & Privasi',
    },
  ];

  void _handleLogout() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.accentOf(context).withValues(alpha: 0.2),
          ),
        ),
        title: Text(
          'Konfirmasi Logout',
          style: AppTextStyles.display(18, w: FontWeight.w700),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          style: AppTextStyles.body(14).copyWith(
            color: AppColors.textSecondaryOf(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppTextStyles.body(14, w: FontWeight.w600).copyWith(
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.auth.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.auth;
    final userName = auth.userName.isNotEmpty ? auth.userName : 'Qiwam';
    final userEmail = auth.userEmail.isNotEmpty ? auth.userEmail : 'qiwam@gmail.com';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── HERO HEADER (height 200) ───────────────────────────────────
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  // Gradient Mesh
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1E1B4B),
                            Color(0xFF312E81),
                            Color(0xFF4F46E5),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Top-Right Aurora Blob
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primaryLight.withOpacity(0.35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom-Left Aurora Blob
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.pink.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Header Title
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          'My Account',
                          style: AppTextStyles.display(20, w: FontWeight.w800).copyWith(
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── PROFILE CARD (Overlap -56px) ────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GlassCard(
                      borderRadius: 28,
                      bgColor: AppColors.surfaceOf(context).withValues(alpha: 0.94),
                      showBorder: true,
                      blurSigma: 24,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // User Avatar + Info
                          Row(
                            children: [
                              // Avatar Ring with Check Badge
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.gradientPrimary,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.surfaceOf(context),
                                      ),
                                      child: const Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: AppColors.gradientTeal,
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 16),

                              // Name + Email
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: AppTextStyles.display(20, w: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      userEmail,
                                      style: AppTextStyles.body(13).copyWith(
                                        color: AppColors.textSecondaryOf(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Divider
                          Container(
                            height: 1,
                            color: AppColors.accentOf(context).withValues(alpha: 0.1),
                          ),

                          const SizedBox(height: 18),

                          // Stats Row (Orders, Wishlist, Points)
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem('12', 'Orders'),
                                VerticalDivider(
                                  color: AppColors.accentOf(context).withValues(alpha: 0.1),
                                  thickness: 1,
                                ),
                                _buildStatItem('8', 'Wishlist'),
                                VerticalDivider(
                                  color: AppColors.accentOf(context).withValues(alpha: 0.1),
                                  thickness: 1,
                                ),
                                _buildStatItem('2.4K', 'Points'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── MENU ITEMS (5 Staggered Items + 1 Logout) ───────────
                    ...List.generate(_menuItems.length, (index) {
                      final item = _menuItems[index];
                      return ProfileMenuItem(
                        icon: item['icon'] as IconData,
                        label: item['label'] as String,
                        index: index,
                        onTap: () => HapticFeedback.lightImpact(),
                      );
                    }),

                    // Logout Item
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      label: 'Keluar',
                      index: _menuItems.length,
                      isDestructive: true,
                      onTap: _handleLogout,
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        GradientText(
          count,
          style: AppTextStyles.display(18, w: FontWeight.w800),
          gradient: AppColors.gradientPrimary,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.body(11).copyWith(
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}

// ── Staggered Profile Menu Item ─────────────────────────────────────────────
class ProfileMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isDestructive;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  State<ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<ProfileMenuItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    Future.delayed(Duration(milliseconds: widget.index * 55), () {
      if (mounted) {
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isTapped = true),
            onTapUp: (_) => setState(() => _isTapped = false),
            onTapCancel: () => setState(() => _isTapped = false),
            onTap: widget.onTap,
            child: AnimatedScale(
              scale: _isTapped ? 0.98 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: GlassCard(
                borderRadius: 20,
                bgColor: widget.isDestructive
                    ? AppColors.error.withOpacity(0.07)
                    : AppColors.surfaceOf(context).withValues(alpha: 0.88),
                showBorder: true,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isDestructive
                            ? AppColors.error.withOpacity(0.15)
                            : AppColors.primary.withOpacity(0.16),
                        border: Border.all(
                          color: widget.isDestructive
                              ? AppColors.error.withOpacity(0.2)
                              : AppColors.accent.withOpacity(0.16),
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 20,
                        color: widget.isDestructive
                            ? AppColors.error
                            : AppColors.textPrimaryOf(context),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      widget.label,
                      style: AppTextStyles.display(14, w: FontWeight.w600).copyWith(
                        color: widget.isDestructive
                            ? AppColors.error
                            : AppColors.textPrimaryOf(context),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: widget.isDestructive
                          ? AppColors.error.withOpacity(0.6)
                          : AppColors.textDim,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
