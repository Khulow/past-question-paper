import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:past_question_paper/Routes/routes.dart';
import 'package:past_question_paper/services/navigation_service.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String _welcomeShownKey = 'welcomeShown';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(
          const Duration(seconds: 2)); // Minimum splash duration
      if (!mounted) return;

      final userService = Provider.of<UserViewModel>(context, listen: false);

      // Run these operations in parallel
      final results = await Future.wait([
        userService.loginUser('username', 'password'),
        _getWelcomeShownFlag(),
      ]);

      if (!mounted) return;

      final loginStatus = results[0] as String;
      final welcomeShown = results[1] as bool;

      await _handleNavigation(loginStatus, welcomeShown);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleNavigation(String loginStatus, bool welcomeShown) async {
    try {
      if (!welcomeShown) {
        await _setWelcomeShownFlag(true);
        navigatorKey.currentState
            ?.pushReplacementNamed(RouteManager.onboardingPage);
      } else if (loginStatus == 'OK') {
        navigatorKey.currentState?.pushReplacementNamed(RouteManager.mainPage);
      } else {
        navigatorKey.currentState?.pushReplacementNamed(RouteManager.loginPage);
      }
    } catch (e) {
      setState(() {
        _error = 'Navigation failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<bool> _getWelcomeShownFlag() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_welcomeShownKey) ?? false;
    } catch (e) {
      throw Exception('Failed to check welcome status: ${e.toString()}');
    }
  }

  Future<void> _setWelcomeShownFlag(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_welcomeShownKey, value);
    } catch (e) {
      throw Exception('Failed to save welcome status: ${e.toString()}');
    }
  }

  Future<void> _retryInitialization() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _error != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $_error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retryInitialization,
                    child: const Text('Retry'),
                  ),
                ],
              )
            : Lottie.asset(
                'assets/animations/loading1.json',
                width: 100, // Increased size for better visibility
                height: 100,
                fit: BoxFit.contain, // Changed to contain for better scaling
                frameRate: FrameRate.max, // Smoother animation
              ),
      ),
    );
  }
}
