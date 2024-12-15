import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zartek_test/constants/color_class.dart';
import 'package:zartek_test/constants/image_class.dart';
import 'package:zartek_test/screens/home/home_screen.dart';

import 'package:zartek_test/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create fade-in animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start animation and navigate after delay
    _animationController.forward();
    
    // Check auth state after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      checkAuthAndNavigate();
    });
  }

  Future<void> checkAuthAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (mounted) {
      if (user != null) {
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Image.asset(
                ImageClass.firebase,
                height: 150,
                
              ),
              const SizedBox(height: 20),
              
              const SizedBox(
                width: 30,
                height: 30,
                child: CupertinoActivityIndicator(
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}