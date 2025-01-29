/* import 'package:flutter/material.dart';
import 'package:past_question_paper/features/core/provider/bottom_nav_bar.dart';
import 'package:past_question_paper/features/core/screens/dashboard/profile_screen.dart';
import 'package:past_question_paper/features/core/screens/dashboard_content.dart';
import 'package:past_question_paper/services/user_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserService>(context);
    final username = authProvider.currentUser?.displayName ?? 'Guest';

    return Consumer<BottomNavigationProvider>(
        builder: (context, navigationProvider, child) {
      return Scaffold(
        appBar: AppBar(
          // Your existing AppBar code
          backgroundColor: const Color.fromRGBO(255, 188, 75, 0.1),
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  backgroundImage: AssetImage(
                    'assets/images/welcome_image.png',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Hi, $username',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Add any additional widgets here for the AppBar
            ],
          ),
        ),
        body: IndexedStack(
          index: navigationProvider.currentIndex,
          children: const [
            DashboardContent(), // Extract your existing home content into a separate widget
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).indicatorColor,
          currentIndex: navigationProvider.currentIndex,
          onTap: (index) => navigationProvider.setCurrentIndex(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
 */