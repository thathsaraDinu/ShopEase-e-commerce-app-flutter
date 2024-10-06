import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:products_repository/products_repository.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/common_widgets/custom_snackbar.dart';
import 'package:shoppingapp/common_network_check/firestore_provider.dart';
import 'package:user_repository/user_repository.dart';

class ProductDetails extends StatefulWidget {
  final BuildContext parentContext;
  const ProductDetails({super.key, required this.parentContext});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int itemAmount = 1;
  Color selectedColor = Colors.transparent;
  int colorSelect = 0;
  bool isAddtoCartLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<FirebaseCartRepo>(context, listen: false);
    final user = Provider.of<FirebaseUserRepo>(context, listen: false);

    String userid = user.currentUser!.uid;

    final ProductModel item =
        ModalRoute.of(context)!.settings.arguments as ProductModel;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            '${item.price} LKR',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ratingstars(item),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            item.longDescription,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          colorselectarea(item.colors),
          buybuttons(item, userid, cart),
        ],
      ),
    );
  }

  Column colorselectarea(List<Color> colors) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Color',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 40,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: colors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;

                              colorSelect = 2;
                            });
                          },
                          child: Container(
                            height: color == selectedColor ? 35 : 28,
                            width: color == selectedColor ? 35 : 28,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: color == selectedColor
                                    ? darkenColor(color)
                                    : Colors.black38,
                                width: color == selectedColor ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            itemcountarea(),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Color darkenColor(Color color, [double factor = 0.3]) {
    assert(factor >= 0 && factor <= 1, 'Factor should be between 0 and 1');

    // Convert the color to HSL (Hue, Saturation, Lightness)
    final hslColor = HSLColor.fromColor(color);

    // Darken the color by reducing the lightness
    final darkenedHsl =
        hslColor.withLightness((hslColor.lightness - factor).clamp(0.0, 1.0));

    // Return the color with reduced lightness, which makes it appear darker
    return darkenedHsl.toColor();
  }

  Column sizeselectarea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    border: Border.all(
                      color: Colors.green,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    '6',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Container itemcountarea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              if (itemAmount > 1) {
                setState(() {
                  itemAmount--;
                });
              }
            },
            child: amountbuttons(Icons.remove),
          ),
          const SizedBox(
            width: 15.0,
          ),
          SizedBox(
            width: 25,
            child: Text(
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              '$itemAmount',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                itemAmount++;
              });
            },
            child: amountbuttons(Icons.add),
          ),
        ],
      ),
    );
  }

  Container amountbuttons(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon, // Use the determined icon here
        size: 30.0,
        color: Colors.black,
      ),
    );
  }

  Column buybuttons(ProductModel item, String userid, FirebaseCartRepo cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.black,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          ),
          onPressed: isAddtoCartLoading
              ? null // Disable button while SnackBar is active
              : () async {
                  if (selectedColor == Colors.transparent) {
                    if (mounted) {
                      CustomSnackbar().show(
                          context: widget.parentContext,
                          message: 'Please select a color!',
                          type: 'w');
                    }
                  } else {
                    await _addToCart(item, userid, cart, context);
                  }
                },
          child: isAddtoCartLoading
              ? progressIndicator()
              : const Text('Add to Cart', style: TextStyle(fontSize: 18.0)),
        ),
        const SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          ),
          onPressed: () {},
          child: const Text('Buy Now', style: TextStyle(fontSize: 18.0)),
        ),
      ],
    );
  }

  Widget progressIndicator() {
    return const SizedBox(
      height: 26.0,
      width: 26.0,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3.0,
        backgroundColor: Colors.black,
      ),
    );
  }

  Future<void> _addToCart(ProductModel item, String userid,
      FirebaseCartRepo cart, BuildContext context) async {
    setState(() {
      isAddtoCartLoading = true;
    });
    final firestoreProvider =
        Provider.of<FirestoreProvider>(context, listen: false);
    try {
      await firestoreProvider.performFirestoreOperation(() async {
        await cart.addCartItem(userid, selectedColor, itemAmount, item.id,
            item.price, item.name, item.imageUrls[0], item.price);
        if (mounted) {
          CustomSnackbar().show(
            type: 's',
            context: widget.parentContext,
            message: 'Item added to cart!',
          );
        }
      }, context);
    } finally {
      setState(() {
        isAddtoCartLoading = false;
      });
    }
  }

  Row ratingstars(ProductModel item) {
    return Row(
      children: [
        RatingStars(
          value: item.rating,
          starBuilder: (index, color) => Icon(
            size: 22,
            Icons.star,
            color: color,
          ),
          starCount: 5,
          starSize: 22,
          maxValue: 5,
          starSpacing: 1,
          maxValueVisibility: true,
          valueLabelVisibility: true,
          valueLabelColor: const Color.fromARGB(255, 113, 113, 113),
          animationDuration: const Duration(milliseconds: 1000),
          valueLabelPadding:
              const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
          valueLabelMargin: const EdgeInsets.only(right: 8),
          starOffColor: const Color(0xffe7e8ea),
          starColor: const Color.fromARGB(255, 255, 230, 0),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          '${item.ratingCount} reviews',
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
