import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String listingId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.listingId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure you want to remove cart item?'),
                  content: Text('This would delete the item.'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes'))
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(listingId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
                title: Text(title),
                subtitle: Text('total: \$${price * quantity}'),
                trailing: Text('$quantity X'),
                leading: CircleAvatar(
                    child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(child: Text('\$$price')),
                )))),
      ),
    );
  }
}
