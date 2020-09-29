import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/screens/AuthenticationScreen.dart';
import 'package:flutter_complete_guide/screens/CartScreen.dart';
import 'package:flutter_complete_guide/screens/EditListingScreen.dart';
import 'package:flutter_complete_guide/screens/OrdersScreen.dart';
import 'package:flutter_complete_guide/screens/ListingDetailScreen.dart';
import 'package:flutter_complete_guide/screens/ListingsOverviewScreen.dart';
import 'package:flutter_complete_guide/screens/SplashScreen.dart';
import 'package:flutter_complete_guide/screens/UserListingsScreen.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/listings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Listings>(
              update: (ctx, auth, previousListings) => Listings(
                  auth.token,
                  auth.userId,
                  previousListings == null ? [] : previousListings.items),
              create: null),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              update: (ctx, auth, previousOrders) => Orders(
                  auth.token,
                  auth.userId,
                  previousOrders == null ? [] : previousOrders.orders),
              create: null),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'FlowerZ',
              theme: ThemeData(
                  primarySwatch: Colors.green,
                  accentColor: Colors.greenAccent,
                  fontFamily: 'Lato'),
              home: auth.isAuth
                  ? ListingsOverviewScreen()
                  : FutureBuilder(
                      future: auth.autoLogin(),
                      builder: (ctx, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ListingDetailScreen.routeName: (ctx) => ListingDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserListingsScreen.routeName: (ctx) => UserListingsScreen(),
                EditListingScreen.routeName: (ctx) => EditListingScreen(),
                SplashScreen.routeName: (ctx) => SplashScreen()
              }),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flowerz'),
      ),
      body: Center(
        child: Text('Building a flower shop!'),
      ),
    );
  }
}
