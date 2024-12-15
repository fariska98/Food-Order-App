import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_utils.dart';

class GetServiceUtils {
  static Future<String> fetchData(String getUrl, BuildContext context) async {
    try {
      final hasNetwork = await AppUtils.hasInternet();
      if (!hasNetwork) {
        if (context.mounted) {
          AppUtils.showInSnackBarNormal('No internet connection', context);
        }
        throw Exception('No internet connection');
      }

      debugPrint('Has Internet');
      final url = Uri.parse(getUrl);
      final headers = {
        "Content-Type": "application/json",
      };

      final response = await http.get(url, headers: headers);

      if (kDebugMode) {
        log('$url: ${response.body.toString()}');
      }

      switch (response.statusCode) {
        case 200:
          return response.body;
          
        case 500:
          if (context.mounted) {
            AppUtils.showInSnackBarNormal(
                'status code: ${response.statusCode} - Bad Gateway', context);
          }
          debugPrint('$url status code: ${response.statusCode}');
          throw Exception('Failed to get Data - Server Error');

        default:
          if (context.mounted) {
            AppUtils.showInSnackBarNormal(
                'status code: ${response.statusCode} - Failed to get Data',
                context);
          }
          debugPrint('$url status code: ${response.statusCode}');
          throw Exception('Failed to get Data');
      }
    } catch (e) {
      // Rethrow the exception so the calling code can handle it
      rethrow;
    }
  }
}