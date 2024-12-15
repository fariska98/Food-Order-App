import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/constants/color_class.dart';
import 'package:zartek_test/constants/icon_class.dart';
import 'package:zartek_test/constants/image_class.dart';
import 'package:zartek_test/provider/auth_provider.dart';
import 'package:zartek_test/screens/home/home_screen.dart';
import 'package:zartek_test/screens/login/widgets/custom_auth_dialogs.dart';
import 'package:zartek_test/utils/app_utils.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  void _handleGoogleSignIn(BuildContext context) async {
    final authProvider = context.read<LoginProvider>();
    final success = await authProvider.signInWithGoogle(context);
    if (success && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _handlePhoneSignIn(BuildContext context) {
    PhoneAuthDialogs.showPhoneNumberDialog(
      context,
      (phoneNumber) {
        final authProvider = context.read<LoginProvider>();
        authProvider.startPhoneAuth(
          phoneNumber,
          (verificationId) {
            PhoneAuthDialogs.showOTPDialog(
              context,
              (otp) async {
                final success = await authProvider.verifyPhoneCode(otp);
                if (success && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              },
            );
          },
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Unable to login, please try again or check connection")),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100,),
            Image.asset(
              ImageClass.firebase,
              height: 250,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppUtils.buttonsSubmit(
                        nextOnTap: () => _handleGoogleSignIn(context),
                        color: ColorClass.blue,
                        icon: IconClass.google,
                        title: "Google",
                      ),
                      const SizedBox(height: 20),
                      AppUtils.buttonsSubmit(
                        nextOnTap: () => _handlePhoneSignIn(context),
                        color: ColorClass.primaryColor,
                        icon: IconClass.phone,
                        title: "Phone",
                      ),
                      const SizedBox(height: 30),
                      Consumer<LoginProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return const CupertinoActivityIndicator();
                          }
                          if (provider.error != null) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                               "Unable to login, please try again or check connection",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}