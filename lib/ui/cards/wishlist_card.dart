import 'package:flutter/material.dart';
import 'package:products_repository/products_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:wishlist_repository/wishlist_repository.dart';

class WishlistCard extends StatelessWidget {
  final ProductModel product;

  WishlistCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context, listen: false);
    WishlistRepo wishlist =
        Provider.of<FirebaseWishlistRepo>(context, listen: false);

    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.pushNamed(context, '/productpage', arguments: product);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrls[0],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${product.price} USD',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${product.description}',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Remove from wishlist?'),
                        content: Text(
                            'Are you sure you want to remove ${product.name} from your wishlist?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel', style: TextStyle(color: Colors.blue)),
                          ),
                          TextButton(
                            onPressed: () async {
                              await wishlist.deleteWishlistItem(user.uid, product.pid);
                              Navigator.pop(context);
                            },
                            child: Text('Remove', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
