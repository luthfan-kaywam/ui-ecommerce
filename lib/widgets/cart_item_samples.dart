import 'package:flutter/material.dart';

class CartItemSamples extends StatefulWidget {
  const CartItemSamples({super.key});

  @override
  State<CartItemSamples> createState() => _CartItemSamplesState();
}

class _CartItemSamplesState extends State<CartItemSamples> {
  // Simpan kuantitas masing-masing item (item 1..4)
  final Map<int, int> _quantities = {1: 1, 2: 1, 3: 1, 4: 1};
  
  // Daftar item yang tampil secara visual (Tugas 3.3.6)
  final List<int> _visibleItems = [1, 2, 3, 4];
  
  // Status radio selection per item
  final Map<int, bool> _selectedItems = {1: true, 2: true, 3: true, 4: true};

  @override
  Widget build(BuildContext context) {
    List<String> productTitles = [
      'Leather Bag',
      'Running Shoes',
      'Smart Watch',
      'Headphones',
    ];

    List<int> productPrices = [55, 120, 85, 45];

    return Column(
      children: [
        for (int i = 1; i <= 4; i++)
          if (_visibleItems.contains(i))
            Container(
              height: 110,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _selectedItems[i],
                    activeColor: const Color(0xFF4C53A5),
                    onChanged: (val) {
                      setState(() {
                        _selectedItems[i] = !(_selectedItems[i] ?? false);
                      });
                    },
                  ),
                  Container(
                    height: 70,
                    width: 70,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDECF2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/carts/$i.jpg",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.shopping_bag_outlined,
                            size: 35,
                            color: Color(0xFF4C53A5),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          productTitles[i - 1],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                        Text(
                          "\$${productPrices[i - 1]}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // Sembunyikan item secara visual (Tugas 3.3.6)
                            setState(() {
                              _visibleItems.remove(i);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${productTitles[i - 1]} disembunyikan dari cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 22,
                          ),
                        ),
                        Row(
                          children: [
                            // Tombol Tambah Kuantitas (+)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _quantities[i] = (_quantities[i] ?? 1) + 1;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.3),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Color(0xFF4C53A5),
                                ),
                              ),
                            ),
                            // Angka Kuantitas
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                _quantities[i].toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4C53A5),
                                ),
                              ),
                            ),
                            // Tombol Kurang Kuantitas (-)
                            InkWell(
                              onTap: () {
                                if ((_quantities[i] ?? 1) > 1) {
                                  setState(() {
                                    _quantities[i] = (_quantities[i] ?? 1) - 1;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.3),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  size: 18,
                                  color: Color(0xFF4C53A5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
