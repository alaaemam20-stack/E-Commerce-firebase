import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List cart=[];
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCart();
  }
  Future<void> getCart() async{
    print(FirebaseAuth.instance.currentUser);
    String userId=FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot=
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();

    cart=snapshot.get("cart");
    print(cart);

    setState(() {
      isLoading=false;
    });

  }
  Future<void> updateCart() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({
      "cart": cart,
    });

    setState(() {});
  }
  double getTotal() {
    double total = 0;

    for (var item in cart) {
      if (item["price"] == null || item["quantity"] == null) {
        print("Invalid item: $item");
        continue;
      }

      total += (item["price"] as num).toDouble() *
          (item["quantity"] as num).toDouble();
    }

    return total;
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading){   return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );}


    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Container(
                      //   width: 80,
                      //   height: 80,
                      //   decoration: BoxDecoration(
                      //     color: Colors.blue.shade50,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: const Icon(Icons.shopping_bag_outlined, color: Colors.blue, size: 30),
                      // ),
                      item["image"] == null || item["image"] == ""
                          ? const Icon(Icons.shopping_bag, size: 70)
                          : Image.network(
                        item["image"],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${item['price']}',
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _buildQtyBtn(Icons.remove,  () async {
                            if (item["quantity"] > 1) {
                              item["quantity"]--;
                            } else {
                              cart.removeAt(index);
                            }

                            await updateCart();
                          },),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('${item['quantity']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          _buildQtyBtn(Icons.add,  () async {
                            item["quantity"]++;

                            await updateCart();
                          },),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                    Text( "\$${getTotal()}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: const Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }
}
