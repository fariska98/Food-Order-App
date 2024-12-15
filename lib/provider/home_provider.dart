
import 'package:flutter/material.dart';
import 'package:zartek_test/constants/api_urls.dart';
import 'package:zartek_test/models/food_menu_model.dart';
import 'package:zartek_test/utils/get_service_util.dart';

class HomeProvider extends ChangeNotifier {
  bool isDataLoading = false;
  FoodMenuModel? foodMenuModel;


  fetchFoodMenuData(BuildContext context, String streamId) async {
    foodMenuModel = null;
  
    setDataLoading(true);
    try {
      final jsonData = await GetServiceUtils.fetchData(
        ApiUrls.getFoodMenu(),
          context);
      foodMenuModel = foodMenuModelFromJson(jsonData);
      
    } catch (e) {
      debugPrint('Error: $e');
      setDataLoading(false);
    }
    setDataLoading(false);
    notifyListeners();
  }

  setDataLoading(bool loading) {
    isDataLoading = loading;
    notifyListeners();
  }


}
