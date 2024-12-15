import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/constants/color_class.dart';
import 'package:zartek_test/constants/text_style_class.dart';
import 'package:zartek_test/models/food_menu_model.dart';
import 'package:zartek_test/provider/cart_provider.dart';
import 'package:zartek_test/utils/app_utils.dart';


class CategorySection extends StatelessWidget {
  final Category category;

  const CategorySection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: category.dishes?.length ?? 0,
          itemBuilder: (context, index) {
            final dish = category.dishes![index];
            return DishItem(dish: dish);
          },
        ),
      ],
    );
  }
}

class DishItem extends StatelessWidget {
  final Dish dish;

  const DishItem({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Veg/Non-veg indicator (you might want to add this to your model)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
              ),
              child: const Icon(
                Icons.circle,
                size: 12,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            // Dish details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name ?? '',
                    style: TextStyleClass.manrope500TextStyle(16, ColorClass.black),),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dish.currency ?? ''} ${dish.price ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '${dish.calories ?? ''} calories',
                          style:  TextStyleClass.manrope400TextStyle(14, ColorClass.black)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dish.description ?? '',
                    style: TextStyleClass.manrope400TextStyle(13, ColorClass.grey)
                  ),
                  const SizedBox(height: 12),
                  // Counter
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      final itemCount = cart.getItemCount(dish.id.toString());
                      return Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white),
                              onPressed: itemCount > 0
                                  ? () => cart.decrementItem(
                                      dish.id.toString(),
                                      dish.name ?? '',
                                      double.tryParse(dish.price ?? '0') ?? 0)
                                  : null,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                itemCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () => cart.addItem(
                                dish.id.toString(),
                                dish.name ?? '',
                                double.tryParse(dish.price ?? '0') ?? 0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Customizations available text
                  if (dish.customizationsAvailable == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Customizations Available',
                        style: TextStyleClass.manrope400TextStyle(12, ColorClass.red)
                      ),
                    ),
                ],
              ),
            ),
            // Dish image
            if (dish.imageUrl != null)
              Container(
                width: 80,
                height: 80,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12)
               ),
                  child:AppUtils.cachedNetworkImageWidget(dish.imageUrl!, 79)
                
                
              ),
          ],
        ),
      ),
    );
  }
}