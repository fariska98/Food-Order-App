
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zartek_test/constants/color_class.dart';
import 'package:zartek_test/constants/image_class.dart';
import 'package:zartek_test/constants/text_style_class.dart';
import 'package:http/http.dart' as http;


class AppUtils {
 

  static Widget buttonsSubmit({
    required nextOnTap,
    required String title,
    required String icon,
    required Color color
  }) {
    return GestureDetector(
      onTap: nextOnTap,
      child: Container(
        width: 350,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(icon, height: 24),
                    const SizedBox(width: 100),
                    Text(title,
                    style: TextStyleClass.manrope600TextStyle(16, ColorClass.white),),
                  ],
                ),
        ),
      ),
    );
  }
  static Widget submit({
    required nextOnTap,
    required String title,
    // required String icon,
    required Color color
  }) {
    return GestureDetector(
      onTap: nextOnTap,
      child: Container(
        width: 350,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Text(title,
            style: TextStyleClass.manrope600TextStyle(16, ColorClass.white),),
          ),
        ),
      ),
    );
  }

  static Widget buttonsSubmitAuth({
    required nextOnTap,
    required String title,
    required IconData icon,
    required Color color,
    required double size
  }) {
    return GestureDetector(
      onTap: nextOnTap,
      child: Container(
        width: 350,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   Icon(icon,
                   color: ColorClass.white,) ,
                      SizedBox(width: size),
                    Text(title,
                    style: TextStyleClass.manrope600TextStyle(16, ColorClass.white),),
                  ],
                ),
        ),
      ),
    );
  }


  static cachedNetworkImageWidget(String imageUrl, double width) {
    return CachedNetworkImage(
      imageUrl:imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => SizedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(ImageClass.placeholder)),)
    );
  }

    static Future<bool> hasInternet() async {
    try {
      final url = Uri.parse('https://www.google.com');
      final response = await http.get(url);
      return kIsWeb ? true : response.statusCode == 200;
    } catch (e) {
      return kIsWeb ? true : false; // Request failed, so no internet connection
    }
  }

  /// Navigate to a new screen/widget
  static navigateTo(BuildContext context, Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
  }

  static showInSnackBarNormal(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        closeIconColor: ColorClass.white,
        backgroundColor: ColorClass.primaryColor,
        showCloseIcon: true,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        content: Text(
          message,
          maxLines: 2,
          style: TextStyleClass.manrope500TextStyle(16, ColorClass.white),
        )));
  }



  

  static noDataWidget(String label, double height) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
          Icons.error,
            size: height,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            label,
            style: TextStyleClass.manrope400TextStyle(16, ColorClass.black),
          ),
        ],
      ),
    );
  }

  static loadingWidget(BuildContext context, double? size) {
    return SizedBox(
        height: size,
        child: const Center(
            child: CupertinoActivityIndicator(
          radius: 10.0,
        )));
  }

  static loadingWidgetWhite(BuildContext context, double? size) {
    return SizedBox(
        height: size,
        child: const Center(
            child: CupertinoActivityIndicator(
          radius: 10.0,
          color: Colors.white,
        )));
  }

  // static cachedNetworkImageWidget(String imageUrl, double width) {
  //   return CachedNetworkImage(
  //     imageUrl: ApiUrls.imageAppend + imageUrl,
  //     fit: BoxFit.cover,
  //     placeholder: (context, url) => const CupertinoActivityIndicator(),
  //     errorWidget: (context, url, error) => SizedBox(
  //         child: Image.asset(
  //       ImageClass.place_holder,
  //       fit: BoxFit.cover,
  //       width: width,
  //     )),
  //   );
  // }

  



  

  
}
