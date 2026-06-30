import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_api_26/features/auth/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String id;


  final String title;
  final double price;
  final String description;
  final String? image;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    this.image,
   required this.isFavorite,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
 late bool isFavorite=widget.isFavorite;

  void toggelFavorite(BuildContext context)async{
    if(FirebaseAuth.instance.currentUser==null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
    String userId =FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection('users').doc(userId).get();
    List<dynamic>favorites=(snapshot.data()as Map)['favorites'];
   // List<dynamic>favorites=(snapshot.data()as Map)['favorites'].add(id); return map +void  ===>error
    // List<dynamic>favorites=(snapshot.data()as Map)['favorites']..add(id);return map after that add
    if(favorites.contains(widget.id)){
      favorites.remove(widget.id);
    }else{
      favorites.add(widget.id);
    }

    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favorites':favorites,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                   Center(child:widget.image==null?Icon(Icons.shopping_bag_outlined, size: 40, color: Colors.blue):Image.network(widget.image!),),
                  PositionBag(
                    top: 10,
                    right: 10,
                    child: Container(
                     // padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero
                          ),
                          onPressed: ()
                            {
                            toggelFavorite(context);
                            setState(() {
                              isFavorite = !isFavorite; ////
                            });

                          },

                          icon:Icon(isFavorite?Icons.favorite:
                          Icons.favorite_border, size: 18, color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.price}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PositionBag extends StatelessWidget {
  final double? top;
  final double? right;
  final Widget child;
  const PositionBag({super.key, this.top, this.right, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(top: top, right: right, child: child);
  }
}
