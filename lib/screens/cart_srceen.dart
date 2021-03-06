import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/paypal_payment.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Cart"),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, int index) => CartItem(
                    cart.items.values.toList()[index].id,
                    cart.items.keys.toList()[index],
                    cart.items.values.toList()[index].price,
                    cart.items.values.toList()[index].quantity,
                    cart.items.values.toList()[index].title),
              ),
            ),
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  OrderButton({
    @required this.cart,
  });

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => PaypalPayment(
                        cart: widget.cart,
                        onFinish: (number) async {
                          // payment done
                          print('order id: ' + number);
                          await Provider.of<Orders>(context, listen: false)
                              .addOrder(widget.cart.items.values.toList(),
                                  widget.cart.totalAmount);
                        },
                      ),
                    ),
                  )
                  .then(
                    (_) => setState(() {
                      _isLoading = false;
                      widget.cart.clear();
                    }),
                  );
            },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      style: TextButton.styleFrom(
          textStyle: TextStyle(
        color: Theme.of(context).primaryColor,
      )),
    );
  }
}
