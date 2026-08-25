class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final String category;
  final String imagePath;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.discountPercentage = 0.0,
    this.rating = 4.5,
    required this.category,
    required this.imagePath,
  });

  double get discountedPrice {
    if (discountPercentage <= 0) return price;
    return price * (1 - (discountPercentage / 100));
  }
}
