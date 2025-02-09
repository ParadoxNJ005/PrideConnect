import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prideconnect/components/logoanimaionwidget.dart';
import 'package:prideconnect/screen/profilePage.dart';
import 'package:prideconnect/utils/contstants.dart';

class CartModel {
  String? image;
  String? des;
  String? coins;
  String? name;
  String? type;

  CartModel({this.image, this.des, this.coins, this.name, this.type});

  CartModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    des = json["des"];
    coins = json["coins"];
    name = json["name"];
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["image"] = image;
    _data["des"] = des;
    _data["coins"] = coins;
    _data["name"] = name;
    _data["type"] = type;
    return _data;
  }
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModel> allProducts = [];
  List<CartModel> filteredProducts = [];
  String selectedCategory = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('cart').get();
      setState(() {
        allProducts = snapshot.docs
            .map((doc) => CartModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        filteredProducts = allProducts; // Initially show all items
      });
    } catch (e) {
      print("Error fetching cart items: $e");
    }
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredProducts = category == "All"
          ? allProducts
          : allProducts.where((item) => item.type == category).toList();
    });
  }

  void searchItems(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProducts = allProducts
          .where((item) =>
      (selectedCategory == "All" || item.type == selectedCategory) &&
          (item.name?.toLowerCase().contains(searchQuery) ?? false))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pride Connect" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
        backgroundColor: Constants.PrideAPPCOLOUR, // Set background color to transparent
        elevation: 0, // Remove the shadow
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        // leading:
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset('assets/images/loading.png', fit: BoxFit.contain ,),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfilePage()));},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/loading.png', fit: BoxFit.contain ,),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Constants.PrideAPPCOLOUR,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              onChanged: searchItems,
              decoration: InputDecoration(
                hintText: "Search items...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryChip("All", isSelected: selectedCategory == "All"),
                _buildCategoryChip("Clothing", isSelected: selectedCategory == "Clothing"),
                _buildCategoryChip("Accessories", isSelected: selectedCategory == "Accessories"),
                _buildCategoryChip("Digital", isSelected: selectedCategory == "Digital"),
              ],
            ),
          ),
          // Products Grid
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: LogoAnimationWidget())
                : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return _buildProductCard(filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => filterByCategory(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Constants.SKYBLUE : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(CartModel product) {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: product.image != null
                    ? Image.network(
                  product.image!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                : Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name ?? "Unknown",
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "🪙 ${product.coins ?? "0"}",
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              // Adds spacing between buttons
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.PrideAPPCOLOUR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Buy Now", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.PrideAPPCOLOUR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.shopping_cart_checkout,color: Colors.white,),
              ),
            ],
          )

        ],
      ),
    );
  }
}
