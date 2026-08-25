import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'custom_image.dart';
import 'favorite_button.dart';
import 'animated_add_to_cart_button.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onCartTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.12),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Discount tag + Favorite button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (product.discountPercentage > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C53A5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "-${product.discountPercentage.toInt()}%",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),

              // Animated Favorite Heart Button
              const FavoriteButton(size: 20),
            ],
          ),
          const SizedBox(height: 8),

          // Product Image with Shimmer & Error Fallback
          Expanded(
            child: Center(
              child: InkWell(
                onTap: onTap ??
                    () {
                      Navigator.pushNamed(context, "itemsPage");
                    },
                child: Hero(
                  tag: "product_image_${product.id}",
                  child: CustomImage(
                    imagePath: product.imagePath,
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Title
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4C53A5),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Category/Description
          Text(
            product.description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Price & Animated Add to Cart button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.discountPercentage > 0)
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    "\$${product.discountedPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ],
              ),

              // Animated Add to Cart Button with Micro-interactions & SnackBar
              AnimatedAddToCartButton(
                product: product,
                onCartTap: onCartTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
