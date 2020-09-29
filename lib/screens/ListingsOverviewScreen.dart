import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/listings.dart';
import 'package:flutter_complete_guide/screens/CartScreen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/badge.dart';

import 'package:flutter_complete_guide/widgets/listing_item.dart';
import 'package:flutter_complete_guide/widgets/listings_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ListingsOverviewScreen extends StatefulWidget {
  @override
  _ListingsOverviewScreenState createState() => _ListingsOverviewScreenState();
}

class _ListingsOverviewScreenState extends State<ListingsOverviewScreen> {
  var _showOnlyfavorites = false;
  var _isInit=true;
  var _isLoading=false;
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
       _isLoading=true; 
      });
      Provider.of<Listings>(context).fetchAndSetProducts().then((_){
        
 setState(() {
       _isLoading=false; 
      });
      })  ;

    }
    _isInit=false;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flowerz'),
          actions: <Widget>[
            PopupMenuButton(
                onSelected: (FilterOptions selected) {
                  print(selected);
                  setState(() {
                    if (selected == FilterOptions.Favorites) {
                      _showOnlyfavorites = true;
                    } else {
                      _showOnlyfavorites = false;
                    }
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.Favorites,
                      ),
                      PopupMenuItem(
                        child: Text('Show All'),
                        value: FilterOptions.All,
                      )
                    ]),
            Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                    value: cart.itemCount.toString(),
                    child: ch
                        ),
                  child: IconButton(
                        icon: Icon(Icons.shopping_cart), onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);

                        }),
                        )
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading?Center(child: CircularProgressIndicator(),):ProductsGrid(_showOnlyfavorites));
  }
}
