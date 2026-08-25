import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../models/product_model.dart';
import '../widgets/HomeAppBar.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_card.dart';
import '../widgets/empty_state_widget.dart';
import 'cart_page.dart';
import 'account_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomePageContent(onNavigateToCart: () => _onTabTapped(1)),
          CartPage(onStartShopping: () => _onTabTapped(0)),
          const AccountPage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        height: 65,
        color: const Color(0xFF4C53A5),
        index: _currentIndex,
        items: const [
          Icon(Icons.home, size: 28, color: Colors.white),
          Icon(Icons.shopping_cart, size: 28, color: Colors.white),
          Icon(Icons.person, size: 28, color: Colors.white),
        ],
        onTap: _onTabTapped,
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final VoidCallback onNavigateToCart;

  const HomePageContent({super.key, required this.onNavigateToCart});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Outfit',
    'Makanan',
    'Skincare',
    'Electronic',
  ];

  final List<ProductModel> _allProducts = const [
    ProductModel(
      id: '1',
      title: 'Leather Bag',
      description: 'Premium quality handmade leather bag for daily style.',
      price: 55.0,
      discountPercentage: 10,
      rating: 4.8,
      category: 'Outfit',
      imagePath: 'assets/images/carts/1.jpg',
    ),
    ProductModel(
      id: '2',
      title: 'Running Shoes',
      description: 'Lightweight ergonomic running shoes with max cushion.',
      price: 120.0,
      discountPercentage: 15,
      rating: 4.9,
      category: 'Outfit',
      imagePath: 'assets/images/carts/2.jpg',
    ),
    ProductModel(
      id: '3',
      title: 'Smart Watch',
      description: 'Waterproof smart fitness tracker with AMOLED screen.',
      price: 85.0,
      discountPercentage: 5,
      rating: 4.6,
      category: 'Electronic',
      imagePath: 'assets/images/carts/3.jpg',
    ),
    ProductModel(
      id: '4',
      title: 'Headphones',
      description: 'Wireless noise-canceling over-ear studio headphones.',
      price: 45.0,
      discountPercentage: 20,
      rating: 4.7,
      category: 'Electronic',
      imagePath: 'assets/images/carts/4.jpg',
    ),
    ProductModel(
      id: '5',
      title: 'Organic Salad',
      description: 'Fresh organic green salad with house dressing.',
      price: 18.0,
      discountPercentage: 0,
      rating: 4.5,
      category: 'Makanan',
      imagePath: 'images/items/2.jpg',
    ),
    ProductModel(
      id: '6',
      title: 'Skincare Glow Serum',
      description: 'Nourishing hydrating serum for radiant glowing skin.',
      price: 32.0,
      discountPercentage: 12,
      rating: 4.9,
      category: 'Skincare',
      imagePath: 'images/items/3.jpg',
    ),
    ProductModel(
      id: '7',
      title: 'Casual Hoodie',
      description: 'Soft cotton warm hoodie available in stylish colors.',
      price: 65.0,
      discountPercentage: 8,
      rating: 4.4,
      category: 'Outfit',
      imagePath: 'images/items/1.jpg',
    ),
    ProductModel(
      id: '8',
      title: 'Wireless Earbuds',
      description: 'Compact bluetooth earphone with extra bass response.',
      price: 99.0,
      discountPercentage: 10,
      rating: 4.8,
      category: 'Electronic',
      imagePath: 'images/items/4.jpg',
    ),
  ];

  List<ProductModel> get _filteredProducts {
    return _allProducts.where((product) {
      final matchesSearch = product.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return SafeArea(
      child: ListView(
        children: [
          HomeAppBar(onCartTap: widget.onNavigateToCart),
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 25),
            decoration: const BoxDecoration(
              color: Color(0xFFEDFCF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Color(0xFF4C53A5),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Cari produk impian Anda...",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        ),
                      const Icon(
                        Icons.camera_alt_outlined,
                        size: 24,
                        color: Color(0xFF4C53A5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Category Chips Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text(
                    "Kategori Produk",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                CategoryChips(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (cat) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // Header Product Catalog
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory == 'All'
                            ? "Katalog Produk"
                            : "Kategori: $_selectedCategory",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                      Text(
                        "${filtered.length} Produk",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Product Grid List
                filtered.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: 'Produk Tidak Ditemukan',
                        message: _searchQuery.isNotEmpty
                            ? 'Tidak ada produk yang cocok dengan "$_searchQuery". Coba kata kunci lain atau reset filter.'
                            : 'Belum ada produk di kategori $_selectedCategory.',
                        actionLabel: 'Reset Pencarian',
                        onAction: () {
                          setState(() {
                            _searchQuery = '';
                            _selectedCategory = 'All';
                          });
                        },
                      )
                    : filtered.length <= 2
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: filtered.map((product) {
                                  return SizedBox(
                                    width: 200,
                                    height: 295,
                                    child: ProductCard(
                                      product: product,
                                      onCartTap: widget.onNavigateToCart,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        : GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                product: filtered[index],
                                onCartTap: widget.onNavigateToCart,
                              );
                            },
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
