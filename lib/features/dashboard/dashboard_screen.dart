import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/aurora_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_text.dart';
import '../../core/widgets/custom_bottom_nav.dart';
import '../../core/widgets/theme_toggle_button.dart';
import '../../models/product_model.dart';
import '../../providers/app_state_provider.dart';
import '../../pages/cart_page.dart';
import '../../pages/account_pages.dart';
import '../../pages/camera_screen.dart';

// ── Promo Banner Model ──────────────────────────────────────────────────────
class PromoBannerModel {
  final String badge;
  final String title;
  final String subtitle;
  final String icon;
  final Gradient gradient;

  const PromoBannerModel({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

// ── Main Dashboard Screen with BottomNav + Pages ────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isNavVisible = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onScrollDirectionChanged(bool isScrollingDown) {
    if (isScrollingDown && _isNavVisible) {
      setState(() => _isNavVisible = false);
    } else if (!isScrollingDown && !_isNavVisible) {
      setState(() => _isNavVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Page View
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              DashboardHomeContent(
                onNavigateToCart: () => _onTabSelected(1),
                onScrollDirectionChanged: _onScrollDirectionChanged,
              ),
              CartPage(onStartShopping: () => _onTabSelected(0)),
              const AccountPage(),
            ],
          ),

          // Custom Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNav(
              currentIndex: _currentIndex,
              onTabSelected: _onTabSelected,
              isVisible: _isNavVisible,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dashboard Home Content with Parallax & 3D Cards ─────────────────────────
class DashboardHomeContent extends StatefulWidget {
  final VoidCallback onNavigateToCart;
  final ValueChanged<bool>? onScrollDirectionChanged;

  const DashboardHomeContent({
    super.key,
    required this.onNavigateToCart,
    this.onScrollDirectionChanged,
  });

  @override
  State<DashboardHomeContent> createState() => _DashboardHomeContentState();
}

class _DashboardHomeContentState extends State<DashboardHomeContent> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late final PageController _bannerPageController;

  double _scrollOffset = 0.0;
  double _lastScrollOffset = 0.0;
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Outfit',
    'Makanan',
    'Skincare',
    'Electronic',
  ];

  final List<PromoBannerModel> _banners = const [
    PromoBannerModel(
      badge: 'SUPER PROMO',
      title: 'Gratis Ongkir Super',
      subtitle: 'Min. belanja 0 rupiah se-Indonesia',
      icon: '🚚',
      gradient: AppColors.gradientTeal,
    ),
    PromoBannerModel(
      badge: 'FLASH SALE',
      title: 'Diskon Hingga 50%',
      subtitle: 'Spesial hari ini untuk produk pilihan',
      icon: '⚡',
      gradient: AppColors.gradientPrimary,
    ),
    PromoBannerModel(
      badge: 'NEW ARRIVAL',
      title: 'Koleksi Skincare Korea',
      subtitle: 'Wajah glowing bersinar setiap saat',
      icon: '✨',
      gradient: AppColors.gradientCoral,
    ),
  ];

  final List<ProductModel> _allProducts = const [
    ProductModel(
      id: '1',
      title: 'Leather Bag',
      description: 'Tas kulit handmade premium untuk gaya kasual dan formal.',
      price: 55.0,
      discountPercentage: 10,
      rating: 4.8,
      category: 'Outfit',
      imagePath: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=500&q=80',
    ),
    ProductModel(
      id: '2',
      title: 'Running Shoes',
      description: 'Sepatu lari ergonomis, empuk, dan sangat ringan.',
      price: 120.0,
      discountPercentage: 15,
      rating: 4.9,
      category: 'Outfit',
      imagePath: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&q=80',
    ),
    ProductModel(
      id: '3',
      title: 'Smart Watch AMOLED',
      description: 'Smartwatch tahan air dengan pelacak kebugaran akurat.',
      price: 85.0,
      discountPercentage: 5,
      rating: 4.6,
      category: 'Electronic',
      imagePath: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80',
    ),
    ProductModel(
      id: '4',
      title: 'Wireless Headphones',
      description: 'Headphone noise-cancelling dengan audio bass jernih.',
      price: 45.0,
      discountPercentage: 20,
      rating: 4.7,
      category: 'Electronic',
      imagePath: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80',
    ),
    ProductModel(
      id: '5',
      title: 'Organic Green Salad',
      description: 'Salad sayur organik segar dengan saus spesial lezat.',
      price: 18.0,
      discountPercentage: 0,
      rating: 4.5,
      category: 'Makanan',
      imagePath: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&q=80',
    ),
    ProductModel(
      id: '6',
      title: 'Glow Skincare Serum',
      description: 'Serum pencerah dan pelembap wajah kaya vitamin alami.',
      price: 32.0,
      discountPercentage: 12,
      rating: 4.9,
      category: 'Skincare',
      imagePath: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500&q=80',
    ),
    ProductModel(
      id: '7',
      title: 'Cozy Cotton Hoodie',
      description: 'Hoodie katun lembut, hangat, dan trendi.',
      price: 65.0,
      discountPercentage: 8,
      rating: 4.4,
      category: 'Outfit',
      imagePath: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=500&q=80',
    ),
    ProductModel(
      id: '8',
      title: 'Bass Earbuds Pro',
      description: 'Earbuds wireless bluetooth dengan dynamic stereo sound.',
      price: 99.0,
      discountPercentage: 10,
      rating: 4.8,
      category: 'Electronic',
      imagePath: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500&q=80',
    ),
  ];

  List<ProductModel> get _filteredProducts {
    return _allProducts.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController();
    _bannerPageController = PageController();

    // Auto-advance banner carousel every 3 seconds
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerPageController.hasClients) {
        final nextIndex = (_currentBannerIndex + 1) % _banners.length;
        _bannerPageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _scrollOffset = offset;
    });

    if (offset > _lastScrollOffset + 12) {
      widget.onScrollDirectionChanged?.call(true); // scrolling down -> hide nav
    } else if (offset < _lastScrollOffset - 12) {
      widget.onScrollDirectionChanged?.call(false); // scrolling up -> show nav
    }
    _lastScrollOffset = offset;
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return Stack(
      children: [
        // ── 1. PARALLAX AURORA BACKGROUND ──────────────────────────────────
        Positioned.fill(
          child: Transform.translate(
            offset: Offset(0, -_scrollOffset * 0.26),
            child: const AuroraBackground(),
          ),
        ),

        // ── 2. SCROLLABLE CONTENT ──────────────────────────────────────────
        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Spacer for Custom Animated AppBar
            const SliverToBoxAdapter(
              child: SizedBox(height: 76),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                child: _buildSearchBar(),
              ),
            ),

            // Promo Banner Carousel with Inner Parallax
            SliverToBoxAdapter(
              child: _buildPromoBannerCarousel(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            // Category Section Title + Chips
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GradientText(
                      'Kategori Pilihan',
                      style: AppTextStyles.display(18, w: FontWeight.w800),
                      gradient: AppColors.gradientPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryChips(),
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            // Product Grid Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory == 'All'
                          ? 'Katalog Produk'
                          : 'Kategori: $_selectedCategory',
                      style: AppTextStyles.display(18, w: FontWeight.w700),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        '${filtered.length} Produk',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Grid with 3D Tilt Cards
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filtered[index];
                    return ProductCard3D(
                      key: ValueKey(product.id),
                      product: product,
                      index: index,
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
          ],
        ),

        // ── 3. CUSTOM ANIMATED GLASS APPBAR ─────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildCustomAppBar(),
        ),
      ],
    );
  }

  // ── Custom Animated AppBar ────────────────────────────────────────────────
  Widget _buildCustomAppBar() {
    final cartCount = context.cart.totalItemCount;
    final isScrolled = _scrollOffset > 25;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).padding.top + 8,
            16,
            12,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0F0E1A).withValues(alpha: 0.88)
                : const Color(0xFFF8FAFC).withValues(alpha: 0.88),
            border: isScrolled
                ? Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.accent.withValues(alpha: 0.12)
                          : const Color(0xFF6366F1).withValues(alpha: 0.12),
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Menu + App Title
              Row(
                children: [
                  GlassCard(
                    width: 40,
                    height: 40,
                    borderRadius: 20,
                    child: Center(
                      child: Icon(
                        Icons.menu_rounded,
                        color: textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GradientText(
                    'QiluthMart',
                    style: AppTextStyles.display(20, w: FontWeight.w800),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF818CF8),
                        Color(0xFFC084FC),
                        Color(0xFFF472B6),
                      ],
                    ),
                  ),
                ],
              ),

              // Right: Theme Switcher + Cart & Notification
              Row(
                children: [
                  // Theme Switcher Button (Sun/Moon with Rotation Animation)
                  const ThemeToggleButton(),

                  const SizedBox(width: 8),

                  // Cart Icon with Badge
                  GestureDetector(
                    onTap: widget.onNavigateToCart,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GlassCard(
                          width: 40,
                          height: 40,
                          borderRadius: 20,
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                        if (cartCount > 0)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: AppColors.gradientPink,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.pink.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                '$cartCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Notification with '3' Badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GlassCard(
                        width: 40,
                        height: 40,
                        borderRadius: 20,
                        child: Center(
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: textPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientPink,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.pink.withValues(alpha: 0.4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search Bar ────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.textMuted : AppColors.lightTextSecondary;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surface2.withValues(alpha: 0.82)
            : Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: isDark
              ? AppColors.accent.withValues(alpha: 0.2)
              : const Color(0xFF6366F1).withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.accent : const Color(0xFF6366F1),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.body(14, color: textPrimary),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari produk impian...',
                hintStyle: AppTextStyles.body(14, color: textMuted),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.close_rounded,
                  color: textMuted,
                  size: 18,
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CameraScreen(),
                ),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.gradientPrimary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Promo Banner Carousel ─────────────────────────────────────────────────
  Widget _buildPromoBannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 178,
          child: PageView.builder(
            controller: _bannerPageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 178,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: banner.gradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Decorative Circle 1 (top-right)
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),

                        // Decorative Circle 2 (bottom-left)
                        Positioned(
                          bottom: -40,
                          left: -20,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                        ),

                        // Large Emoji Icon (right, opacity 0.18)
                        Positioned(
                          right: 18,
                          bottom: 12,
                          child: Opacity(
                            opacity: 0.18,
                            child: Text(
                              banner.icon,
                              style: const TextStyle(fontSize: 72),
                            ),
                          ),
                        ),

                        // Parallax Inner Text Content
                        Transform.translate(
                          offset: Offset(0, _scrollOffset * 0.07),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    banner.badge,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Title
                                Text(
                                  banner.title,
                                  style: AppTextStyles.display(20, w: FontWeight.w800).copyWith(
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // Subtitle
                                Text(
                                  banner.subtitle,
                                  style: AppTextStyles.body(12).copyWith(
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // CTA Glass Button
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: const Text(
                                    'Klaim Sekarang →',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Carousel Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (dotIdx) {
            final isActive = dotIdx == _currentBannerIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: isActive ? AppColors.gradientPrimary : null,
                color: isActive ? null : Colors.white.withValues(alpha: 0.25),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Category Chips ────────────────────────────────────────────────────────
  Widget _buildCategoryChips() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _categories.map((cat) {
          final isSelected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedCategory = cat;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? (isDark
                          ? AppColors.gradientPrimary
                          : const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                            ))
                      : null,
                  color: isSelected
                      ? null
                      : (isDark ? AppColors.surface2 : Colors.white),
                  borderRadius: BorderRadius.circular(50),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: isDark
                              ? AppColors.accent.withValues(alpha: 0.16)
                              : AppColors.lightBorder,
                          width: 1,
                        ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : (!isDark
                          ? [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null),
                ),
                child: Text(
                  cat,
                  style: isSelected
                      ? AppTextStyles.display(13, w: FontWeight.w700).copyWith(
                          color: Colors.white,
                        )
                      : AppTextStyles.body(13, w: FontWeight.w500).copyWith(
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── 3D Tilt Product Card with Entrance Animation ────────────────────────────
class ProductCard3D extends StatefulWidget {
  final ProductModel product;
  final int index;

  const ProductCard3D({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  State<ProductCard3D> createState() => _ProductCard3DState();
}

class _ProductCard3DState extends State<ProductCard3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  double _rotateX = 0.0;
  double _rotateY = 0.0;
  bool _isWishlisted = false;
  bool _isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Stagger based on index
    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotateX = (-details.localPosition.dy / 250).clamp(-0.15, 0.15);
      _rotateY = (details.localPosition.dx / 250).clamp(-0.15, 0.15);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
    });
  }

  void _onPanCancel() {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
    });
  }

  void _handleAddToCart() {
    HapticFeedback.mediumImpact();
    context.cart.addToCart(widget.product);
    setState(() {
      _isAddedToCart = true;
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _isAddedToCart = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(_rotateX)
      ..rotateY(_rotateY);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.textMuted : AppColors.lightTextSecondary;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          onPanCancel: _onPanCancel,
          child: Transform(
            alignment: Alignment.center,
            transform: matrix,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-0.8, -0.8),
                  end: const Alignment(0.8, 0.8),
                  colors: isDark
                      ? const [AppColors.surface, AppColors.surface2]
                      : const [Colors.white, Color(0xFFF8FAFC)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? AppColors.accent.withValues(alpha: 0.12)
                      : const Color(0xFF6366F1).withValues(alpha: 0.12),
                  width: 1,
                ),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.32),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── IMAGE AREA (height 155) ─────────────────────────
                    SizedBox(
                      height: 155,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Product Image
                          CachedNetworkImage(
                            imageUrl: widget.product.imagePath,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: isDark ? AppColors.surface2 : const Color(0xFFF1F5F9),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: isDark ? AppColors.surface2 : const Color(0xFFF1F5F9),
                              child: Icon(
                                Icons.image_not_supported_rounded,
                                color: textMuted,
                                size: 32,
                              ),
                            ),
                          ),

                          // Bottom Gradient Overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Top-Left Discount Badge
                          if (widget.product.discountPercentage > 0)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.gradientPink,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  '-${widget.product.discountPercentage.toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),

                          // Top-Right Wishlist Heart Button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _isWishlisted = !_isWishlisted;
                                });
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withValues(alpha: 0.7),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(scale: anim, child: child),
                                  child: Icon(
                                    _isWishlisted
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    key: ValueKey(_isWishlisted),
                                    color: _isWishlisted
                                        ? AppColors.pink
                                        : Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── CONTENT AREA (padding 12) ───────────────────────
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Title
                                Text(
                                  widget.product.title,
                                  style: AppTextStyles.display(13, w: FontWeight.w600, color: textPrimary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 3),

                                // Product Description
                                Text(
                                  widget.product.description,
                                  style: AppTextStyles.body(11, color: textMuted),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 6),

                                // Star Rating
                                Row(
                                  children: [
                                    ...List.generate(5, (starIdx) {
                                      final isFilled = starIdx < widget.product.rating.floor();
                                      return Icon(
                                        Icons.star_rounded,
                                        size: 11,
                                        color: isFilled
                                            ? AppColors.warning
                                            : AppColors.warning.withValues(alpha: 0.22),
                                      );
                                    }),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.product.rating}',
                                      style: AppTextStyles.body(11, w: FontWeight.w600, color: textPrimary),
                                    ),
                                    Text(
                                      ' (120+)',
                                      style: AppTextStyles.body(10, color: textMuted),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Price + Add to Cart Button
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (widget.product.discountPercentage > 0)
                                        Text(
                                          '\$${widget.product.price.toStringAsFixed(0)}',
                                          style: AppTextStyles.body(10, color: isDark ? AppColors.textDim : AppColors.lightTextMuted).copyWith(
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      GradientText(
                                        '\$${widget.product.discountedPrice.toStringAsFixed(0)}',
                                        style: AppTextStyles.display(15, w: FontWeight.w700),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF6366F1),
                                            Color(0xFFA855F7),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Add to Cart Button
                                GestureDetector(
                                  onTap: _handleAddToCart,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: _isAddedToCart
                                          ? AppColors.gradientTeal
                                          : AppColors.gradientPrimary,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: Icon(
                                        _isAddedToCart
                                            ? Icons.check_rounded
                                            : Icons.add_rounded,
                                        key: ValueKey(_isAddedToCart),
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
