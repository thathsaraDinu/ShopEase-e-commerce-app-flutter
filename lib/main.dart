import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:products_repository/products_repository.dart';
import 'package:provider/provider.dart';
import 'package:shopease/api/firebase_messaging_api.dart';
import 'package:shopease/common_network_check/firestore_provider.dart';
import 'package:shopease/routes/routes.dart';
import 'package:user_repository/user_repository.dart';
import 'package:wishlist_repository/wishlist_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessagingApi().initNotifications();
  debugPaintSizeEnabled = false; // Optionally enable for debugging
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirestoreProvider(),
        ),
        ChangeNotifierProvider<FirebaseUserRepo>(
          create: (context) => FirebaseUserRepo(),
        ),
        StreamProvider<MyUser>(
          create: (context) =>
              Provider.of<FirebaseUserRepo>(context, listen: false).user,
          initialData: MyUser.empty, // Default value if no user is logged in
        ),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(
          create: (_) => FirebaseCartRepo(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseWishlistRepo(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.getRoutes(),
      initialRoute: '/',
      title: 'Shop Ease',
    );
  }
}
