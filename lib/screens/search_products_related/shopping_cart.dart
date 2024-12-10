import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopease/common_widgets/background_image_wrapper.dart';
import 'package:shopease/common_widgets/custom_app_bar.dart';
import 'package:shopease/ui/cards/address_card.dart';
import 'package:shopease/ui/cards/shopping_cart_card.dart';
import 'package:provider/provider.dart';
import 'package:user_repository/user_repository.dart';

class ShoppingCart extends StatefulWidget {
  final bool isMainPage;

  const ShoppingCart({super.key, required this.isMainPage});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<FirebaseCartRepo>(context);
    final user = Provider.of<FirebaseUserRepo>(context);
    Stream<List<CartItem>> cart = cartItems.getCartItems(user.currentUser!.uid);

    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          name: 'Shopping cart',
          isMainPage: widget.isMainPage,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 0.0,
                  bottom: 0.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const AddressCard(),
                      const SizedBox(height: 10),
                      StreamBuilder<List<CartItem>>(
                        stream: cart,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                                    child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                DotLottieLoader.fromAsset(
                                    "assets/images/loadingWord.lottie",
                                    frameBuilder: (BuildContext ctx,
                                        DotLottie? dotlottie) {
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
                            )));
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('An Error occurred'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Ensures vertical centering
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Ensures horizontal centering
                                children: [
                                  Lottie.asset(
                                    'assets/images/emptyboxwithsign.json',
                                    height: 250,
                                  ),
                                  Text(
                                    'Your Cart is Empty',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final cartItems = snapshot.data!;
                          return Column(
                            children: cartItems.map((cartItem) {
                              return ShoppingCartCard(cartItem: cartItem);
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(
                          height: 10), // To add some space at the bottom
                    ],
                  ),
                ),
              ),
            ),
            // Positioned Total Amount at the bottom
            StreamBuilder<double>(
              stream: cartItems.getTotalPrice(user.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
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
                  )));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('0.0'));
                }
                if (!snapshot.hasData) {
                  return const Center(
                      child:
                          Text('0.0')); // Handle case where no data is returned
                }
                final totalAmount = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Total: ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${totalAmount.toInt()} USD',
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Text(
                                    'Delivery Fee: ',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '0 USD',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/checkout',
                                  arguments: totalAmount);
                              // Proceed to checkout
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 10.0),
                              elevation: 3.0,
                            ),
                            child: const Text(
                              'Check Out',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
