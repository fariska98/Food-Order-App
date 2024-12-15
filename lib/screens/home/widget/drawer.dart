import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/constants/color_class.dart';
import 'package:zartek_test/constants/text_style_class.dart';
import 'package:zartek_test/provider/auth_provider.dart';

import 'package:zartek_test/screens/login/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final userData = loginProvider.getCurrentUserData();
    String formatUserId(dynamic uid) {
      if (uid == null) return '';
      String uidString = uid.toString();
      if (uidString.isEmpty) return '';
      return uidString.length >= 5 ? uidString.substring(0, 5) : uidString;
    }

    return Drawer(
      child: Column(
        children: [
          // User Info Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: const BoxDecoration(
              color: ColorClass.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Profile Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: userData['photoURL'] != null &&
                            userData['photoURL']!.isNotEmpty
                        ? Image.network(
                            userData['photoURL']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white,
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: ColorClass.primaryColor,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.white,
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: ColorClass.primaryColor,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // User Name
                Text(
                  userData['displayName'] ?? userData['phoneNumber'] ?? 'User',
                  style:
                      TextStyleClass.manrope500TextStyle(18, ColorClass.white),
                ),
                const SizedBox(height: 8),
                // User ID
                Text(
                  'ID : ${formatUserId(userData['uid'])}',
                  style:
                      TextStyleClass.manrope400TextStyle(14, ColorClass.white),
                ),
              ],
            ),
          ),

          // Logout Button
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(16),
            child: Consumer<LoginProvider>(
              builder: (context, loginProvider, child) {
                return ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: ColorClass.grey,
                  ),
                  title: Row(
                    children: [
                      Text(
                        'Log out',
                        style: TextStyleClass.manrope500TextStyle(
                            16, ColorClass.grey),
                      ),
                      if (loginProvider.isLoading)
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:   CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorClass.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: loginProvider.isLoading
                      ? null
                      : () async {
                          await loginProvider.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()),
                              (route) => false,
                            );
                          }
                        },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
