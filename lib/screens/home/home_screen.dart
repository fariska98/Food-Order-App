import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/constants/color_class.dart';
import 'package:zartek_test/constants/text_style_class.dart';
import 'package:zartek_test/provider/home_provider.dart';
import 'package:zartek_test/provider/cart_provider.dart';
import 'package:zartek_test/screens/cart/cart_screen.dart';
import 'package:zartek_test/screens/home/widget/category_section.dart';
import 'package:zartek_test/screens/home/widget/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchFoodMenuData(context, '');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize tab controller when data is available
    final categories = context.watch<HomeProvider>().foodMenuModel?.categories;
    if (categories != null && _tabController == null) {
      _tabController = TabController(
        length: categories.length,
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
     
        actions: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart,color: ColorClass.grey,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) => Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 17,
                      minHeight: 17,
                    ),
                    child: Text(
                      cart.itemCount.toString(),
                      style: TextStyleClass.manrope500TextStyle(10, ColorClass.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              if (homeProvider.isDataLoading ||
                  homeProvider.foodMenuModel?.categories == null) {
                return const SizedBox.shrink();
              }

              return TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: ColorClass.red,
                labelColor: ColorClass.red,
                unselectedLabelColor: ColorClass.grey,
                tabs: homeProvider.foodMenuModel!.categories!.map((category) {
                  return Tab(text: category.name ?? '');
                }).toList(),
              );
            },
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isDataLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (homeProvider.foodMenuModel?.categories == null) {
            return const Center(child: Text('No data available'));
          }

          return TabBarView(
            controller: _tabController,
            children: homeProvider.foodMenuModel!.categories!.map((category) {
              return SingleChildScrollView(
                child: CategorySection(category: category),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
