import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/screens/OrdersScreen.dart';
import 'package:flutter_complete_guide/screens/UserListingsScreen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children:<Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,),
            Divider(),
            ListTile(leading:Icon(Icons.shop_two),title: Text('Shop'),
            onTap:(){ Navigator.of(context).pushReplacementNamed('/');},),
            Divider(),
            ListTile(leading:Icon(Icons.credit_card),title: Text('Orders'),
            onTap:(){ Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);},),
            Divider(),
            ListTile(leading:Icon(Icons.edit),title: Text('Manage Listings'),
            onTap:(){
            Navigator.of(context).pushReplacementNamed(UserListingsScreen.routeName);
            },),
            Divider(),
            ListTile(leading:Icon(Icons.exit_to_app),title: Text('Logout'),
            onTap:(){ 
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context,listen:false).logout();},)


          

        ]
      ),
      
    );
  }
}