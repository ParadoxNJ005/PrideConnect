import 'package:flutter/material.dart';


class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "logo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Row(
              children: [
                const Icon(Icons.monetization_on_outlined, color: Colors.black),
                const SizedBox(width: 5),
                const Text(
                  "2,450",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search items...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryChip("All", isSelected: true),
                _buildCategoryChip("Clothing"),
                _buildCategoryChip("Accessories"),
                _buildCategoryChip("Digital"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  product.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // if (product.tag != null)
              //   Positioned(
              //     top: 8,
              //     left: 8,
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //       decoration: BoxDecoration(
              //         color: product.tagColor,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Text(
              //         product.tag!,
              //         style: const TextStyle(fontSize: 12, color: Colors.white),
              //       ),
              //     ),
              //   ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "🪙 ${product.price}",
            style: const TextStyle(color: Colors.black),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Buy Now" , style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}

// Product Model
class Product {
  final String name;
  final String imageUrl;
  final int price;
  final String? tag;
  final Color tagColor;

  Product({required this.name, required this.imageUrl, required this.price, this.tag, required this.tagColor});
}

// Sample Products
final List<Product> products = [
  Product(
    name: "Rainbow Pride T-Shirt",
    imageUrl: "assets/images/i.png",
    price: 850,
    tag: "Limited",
    tagColor: Colors.purple,
  ),
  Product(
    name: "Pride Enamel Pin",
    imageUrl: "assets/images/h.png",
    price: 350,
    tag: "New",
    tagColor: Colors.blue,
  ),
  Product(
    name: "Pride Wallpaper Pack",
    imageUrl: "assets/images/j.png",
    price: 150,
    tag: "Digital",
    tagColor: Colors.green,
  ),
  Product(
    name: "Rainbow Bracelet",
    imageUrl: "assets/images/k.png",
    price: 250,
    tag: "Sale",
    tagColor: Colors.red,
  ),
];
