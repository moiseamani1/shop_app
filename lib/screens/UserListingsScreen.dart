

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/listings.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_listing_item.dart';
import 'package:provider/provider.dart';

import 'EditListingScreen.dart';

class UserListingsScreen extends StatelessWidget {
  static const routeName='/user-listings';



  Future<void> _refreshProducts(BuildContext context) async{

    await Provider.of<Listings>(context,listen:false).fetchAndSetProducts(true);
  }
  @override
  Widget build(BuildContext context) {
    final listingData=Provider.of<Listings>(context);
    return Scaffold(
       drawer:AppDrawer(),
      appBar: AppBar(title:Text('Your Listings'),
     
      actions: <Widget>[

        IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.of(context).pushNamed(EditListingScreen.routeName);


        })
      ],),
      body: FutureBuilder(
        future:_refreshProducts(context),
              builder:(ctx,snapshot) =>snapshot.connectionState==ConnectionState.waiting? Center(child: CircularProgressIndicator(),): RefreshIndicator(
          onRefresh:()=>_refreshProducts(context) ,
                child: Consumer<Listings>(builder: (ctx,listingsData,_)=> Padding(padding: EdgeInsets.all(8),child: ListView.builder(itemCount: listingData.items.length,itemBuilder:(_,i)=> Column(
            children: [
              UserListingItem(listingData.items[i].id,listingData.items[i].title, listingData.items[i].imageUrl),
              Divider()
            ],
          ),),),
                ),
        ),
      ),
      
    );
  }
}