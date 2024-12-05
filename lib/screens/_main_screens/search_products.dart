import 'dart:async';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:products_repository/products_repository.dart';
import 'package:shopease/ui/cards/product_card.dart';
import 'package:shopease/ui/cards/product_type_card.dart';
import 'package:shopease/common_network_check/dependency_injection.dart';
import 'package:shopease/data/dummy_data_product_type.dart';
import 'package:shopease/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class RecycledItemsMain extends StatefulWidget {
  const RecycledItemsMain({super.key});
  @override
  State<RecycledItemsMain> createState() => RecycledItemsMainState();
}

class RecycledItemsMainState extends State<RecycledItemsMain> {
  final FocusNode _focusNode = FocusNode();
  int selectedIndex = 0;
  List<ProductModel> _products = [];
  bool isLoading = false;
  int sortingType = 0;
  Timer? _debounce;
  List<ProductModel> filteredProductsl = [];

  List<ProductModel> filteredProducts = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProductsByType('');
    DependencyInjection.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the TextField is unfocused when the widget is first built
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    });
  }

  void _fetchSearchProducts(String query) {
    final filteredProductsm = filteredProducts
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _products = filteredProductsm;
      isLoading = false;
    });
  }

  void sortProducts() {
    switch (sortingType) {
      case 1:
        _products.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 2:
        _products.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 3:
        _products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 4:
        _products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
  }

  // Future<void> _fetchFromBack() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final productService = Provider.of<ProductService>(context, listen: false);
  //   final products = await productService.getAllProducts(sortingType);
  //   setState(() {
  //     _products = filteredProducts;
  //     isLoading = false;
  //   });
  // }

  Future<void> _fetchProductsByType(String query) async {
    try {
      setState(() {
        isLoading = true;
      });
      final productService =
          Provider.of<ProductService>(context, listen: false);
      final products = await productService.getAllProducts(sortingType);
      filteredProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        _products = filteredProducts;
        isLoading = false;
      });
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void _delayBackendCalls(Function func, String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Perform your backend call here
      func(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CustomAppBar(
        name: 'Shop Ease',
        isMainPage: true,
      ),
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus(); // Unfocus TextField when tapping outside
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 8, bottom: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    onChanged: (query) {
                      _delayBackendCalls(
                          _fetchSearchProducts, query); // Trigger search
                    },
                    controller: _searchController,
                    focusNode: _focusNode,
                    autofocus: false,
                    decoration: InputDecoration(
                      prefixIconColor: const Color.fromARGB(255, 174, 174, 174),
                      contentPadding: const EdgeInsets.all(8.0),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 2.0,
                            color: Color.fromARGB(255, 174, 174, 174)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 2.0,
                            color: Color.fromARGB(255, 124, 124, 124)),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search Products',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 174, 174, 174),
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            selectedIndex = index;
                            _delayBackendCalls(_fetchProductsByType,
                                productTypes[index]['search']!);
                          });
                        },
                        child: ProductTypeCard(
                            item: productTypes[index],
                            selectedIndex: selectedIndex,
                            index: index),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: productTypes.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productTypes[selectedIndex]['topic']!,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Material(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Sort By'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        selected:
                                            sortingType == 1 ? true : false,
                                        selectedColor: Colors.red[800],
                                        title: const Text('Name: A to Z'),
                                        onTap: () {
                                          setState(() {
                                            sortingType = 1;
                                          });
                                          sortProducts();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        selected:
                                            sortingType == 2 ? true : false,
                                        selectedColor: Colors.red[800],
                                        title: const Text('Name: Z to A'),
                                        onTap: () {
                                          setState(() {
                                            sortingType = 2;
                                          });

                                          sortProducts();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        selected:
                                            sortingType == 3 ? true : false,
                                        selectedColor: Colors.red[800],
                                        title: const Text('Price: Low to High'),
                                        onTap: () {
                                          setState(() {
                                            sortingType = 3;
                                          });
                                          sortProducts();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        selected:
                                            sortingType == 4 ? true : false,
                                        selectedColor: Colors.red[800],
                                        title: const Text('Price: High to Low'),
                                        onTap: () {
                                          setState(() {
                                            sortingType = 4;
                                          });
                                          sortProducts();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: const Row(
                              children: [
                                Text('Sort'),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.sort,
                                  size: 20.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10.0),
                              DotLottieLoader.fromAsset(
                                  "assets/images/loadingWord.lottie",
                                  frameBuilder:
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
                          ),
                        )
                      : _products.length == 0
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Ensures vertical centering
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Ensures horizontal centering
                                children: [
                                  DotLottieLoader.fromAsset(
                                    "assets/images/ladywithabox.lottie",
                                    frameBuilder: (BuildContext ctx,
                                        DotLottie? dotlottie) {
                                      if (dotlottie != null) {
                                        return SizedBox(
                                          height:
                                            260, // Set your desired height
                                          child: Lottie.memory(dotlottie
                                              .animations.values.single),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),

                                  const SizedBox(
                                      height:
                                          20), // Adds some space between the image and the text
                                  Text(
                                    'No Products Found',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // Disable internal scrolling
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio: 0.6,
                              ),
                              itemCount: _products.length,
                              itemBuilder: (BuildContext context, int index) {
                                ProductModel product = _products[index];
                                return ProductCard(
                                  item: product,
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
