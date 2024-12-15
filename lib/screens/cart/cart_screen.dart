import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/constants/color_class.dart';
import 'package:zartek_test/constants/text_style_class.dart';
import 'package:zartek_test/models/cart_model.dart';
import 'package:zartek_test/provider/cart_provider.dart';
import 'package:zartek_test/screens/home/home_screen.dart';
import 'package:zartek_test/utils/app_utils.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppUtils.navigateTo(context,const HomeScreen()),
        ),
        title: const Text('Order Summary'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Order Summary Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: ColorClass.darkgreen,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${cart.uniqueItemCount} Dishes - ${cart.itemCount} Items',
                            style: TextStyleClass.manrope500TextStyle(16, ColorClass.white)
                          ),
                        ),
                      ),
            
                      // Cart Items List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: cart.items.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = cart.items.values.toList()[index];
                          return CartItemWidget(item: item);
                        },
                      ),
                      const Divider(),
            
                      // Order Total
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Text(
                              'Total Amount',
                              style:  TextStyleClass.manrope600TextStyle(16, ColorClass.black)
                            ),
                            Text(
                              cart.getFormattedTotal(),
                              style:  TextStyleClass.manrope500TextStyle(16, ColorClass.primaryColor)
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                AppUtils.submit(
                    nextOnTap: () {
                      _showOrderConfirmationDialog(context, cart);
                    },
                    title: "Place Order",
                   
                    color: ColorClass.darkgreen),

                    const SizedBox(height: 10,)
              ],
            ),
          );
        },
      ),
    );
  }

  void _showOrderConfirmationDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:   Text('Order Confirmation',
        style: TextStyleClass.manrope600TextStyle(18, ColorClass.black),),
        content: const Text('Order successfully placed'),
        actions: [
          TextButton(
            onPressed: () {
              cart.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Veg/Non-veg indicator
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
            ),
          ),
          child: const Icon(
            Icons.circle,
            size: 12,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),

        // Item details
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 108,
              child: Text(
                item.name,
                style:  TextStyleClass.manrope500TextStyle(16, ColorClass.black)
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'INR ${item.price}',
              style:  TextStyleClass.manrope500TextStyle(14, ColorClass.black)
            ),
            Text(
              '${item.quantity * 112} calories', // You might want to store calories in CartItem
              style: TextStyleClass.manrope500TextStyle(14, ColorClass.grey)
            ),
          ],
        ),

        // Quantity controls
        Container(
         
          height: 40,
          decoration: BoxDecoration(
            color: ColorClass.darkgreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Consumer<CartProvider>(
            builder: (context, cart, child) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white, size: 15),
                  onPressed: () {
                    cart.decrementItem(item.id, item.name, item.price);
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Text(
                    item.quantity.toString(),
                    style:  TextStyleClass.manrope500TextStyle(14, ColorClass.white)
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 15),
                  onPressed: () {
                    cart.addItem(item.id, item.name, item.price);
                  },
                ),
              ],
            ),
          ),
        ),

        // Item total
        Container(
          margin: const EdgeInsets.only(left: 2),
          child: Text(
            'INR ${(item.price * item.quantity).toStringAsFixed(2)}',
            style: TextStyleClass.manrope500TextStyle(14, ColorClass.black)
          ),
        ),
      ],
    );
  }
}
