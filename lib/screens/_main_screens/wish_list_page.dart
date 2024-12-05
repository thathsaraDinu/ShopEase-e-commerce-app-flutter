import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:products_repository/products_repository.dart';
import 'package:shopease/common_widgets/custom_app_bar.dart';
import 'package:shopease/ui/cards/wishlist_card.dart';
import 'package:user_repository/user_repository.dart';
import 'package:wishlist_repository/wishlist_repository.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatelessWidget {
  const WishListPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseUserRepo user = Provider.of<FirebaseUserRepo>(context);
    WishlistRepo wishlist = Provider.of<FirebaseWishlistRepo>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        name: 'Wish List',
        isMainPage: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              // Add Expanded here to ensure the StreamBuilder gets bounded height
              child: StreamBuilder<List<ProductModel>>(
                stream: wishlist.getWishlistItems(user.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Center(
                            child: Container(
                                child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DotLottieLoader.fromAsset(
                            "assets/images/loadingWord.lottie", frameBuilder:
                                (BuildContext ctx, DotLottie? dotlottie) {
                          if (dotlottie != null) {
                            return Lottie.memory(
                                dotlottie.animations.values.single);
                          } else {
                            return Container();
                          }
                        }),
                        Text(
                          'Please wait',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ))));
                  }
                  if (snapshot.hasError) {
                    print('wishlist error ${snapshot.error}');
                    return const Center(child: Text('An Error occurred'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Container(
                            child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DotLottieLoader.fromAsset(
                            "assets/images/emptywishlist.lottie", frameBuilder:
                                (BuildContext ctx, DotLottie? dotlottie) {
                          if (dotlottie != null) {
                            return SizedBox(
                              height: 300,
                              child: Lottie.memory(
                                  dotlottie.animations.values.single),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        Text(
                          'Your Wishlist is Empty',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    )));
                  }

                  final wishlist = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: wishlist.map((wishlistItem) {
                        return WishlistCard(product: wishlistItem);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
