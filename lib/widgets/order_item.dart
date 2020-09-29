import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as od;

class OrderItem extends StatefulWidget {
  final od.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ListTile(
          title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
          subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm aa').format(widget.order.dateTime)),
          trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              }),
        ),
        if (_expanded)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: min(widget.order.listings.length * 20.0 + 10, 100),
            child: ListView(
                children: widget.order.listings
                    .map((listing) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                listing.title,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                '${listing.quantity}x \$${listing.price}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              )
                            ]))
                    .toList()),
          )
      ]),
    );
  }
}
