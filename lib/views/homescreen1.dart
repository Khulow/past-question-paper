import 'package:flutter/material.dart';
import 'package:past_question_paper/common_widgets/dashboard_content.dart';
import 'package:past_question_paper/services/helper_user.dart';
import 'package:past_question_paper/utils/theme/widget_themes/text_themes.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:past_question_paper/views/dashboard/profile_screen.dart';
import 'package:past_question_paper/services/bottom_nav_bar.dart';

// homescreen1.dart
class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserViewModel>(context);
    final username = userService.currentUser?.displayName ?? 'Guest';
    final email = userService.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Time to Study!',
        style: TTextTheme.lightTextTheme.titleSmall,
      )),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  username[0].toUpperCase(),
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected:
                  context.watch<BottomNavigationProvider>().currentIndex == 0,
              onTap: () {
                context.read<BottomNavigationProvider>().setCurrentIndex(0);
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              selected:
                  context.watch<BottomNavigationProvider>().currentIndex == 1,
              onTap: () {
                context.read<BottomNavigationProvider>().setCurrentIndex(1);
                Navigator.pop(context); // Close drawer
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                logoutUserInUI(context, userService,
                    context.read<BottomNavigationProvider>());
              },
            ),
          ],
        ),
      ),
      body: Consumer<BottomNavigationProvider>(
        builder: (context, provider, _) => IndexedStack(
          index: provider.currentIndex,
          children: const [
            DashboardContent(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
