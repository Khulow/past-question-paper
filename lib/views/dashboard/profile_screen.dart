import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:past_question_paper/services/bottom_nav_bar.dart';
import 'package:past_question_paper/services/helper_user.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:past_question_paper/views/help_support_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    final userService = Provider.of<UserViewModel>(context);
    final username = userService.currentUser?.displayName ?? 'Guest';
    final userEmail = userService.currentUser?.email ?? '';

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // User Profile Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.amber.shade200,
                              width: 4,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                userService.currentUser?.photoURL != null
                                    ? NetworkImage(
                                        userService.currentUser!.photoURL!)
                                    : null,
                            child: userService.currentUser?.photoURL == null
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey.shade600,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Ionicons.camera_outline,
                                  color: Colors.white, size: 20),
                              onPressed: () {
                                //TODO: Add profile picture change functionality
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Profile Options
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /*  _buildProfileOption(
                        Ionicons.settings_outline, 'Settings', false,
                        onTap: () {
                      // TODO: Implement settings navigation
                    }), */
                    _buildDivider(),
                    _buildProfileOption(
                        Ionicons.help_circle_outline, 'Help & Support', false,
                        onTap: () {
                      // TODO: Implement help navigation
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HelpSupportScreen()),
                      );
                    }),
                    _buildDivider(),
                    _buildProfileOption(
                        Ionicons.trash_outline, 'Delete Account', false,
                        onTap: () => deleteUserAccountInUI(
                            context, userService, navigationProvider),
                        isDestructive: true),
                    _buildDivider(),
                    _buildProfileOption(
                        Ionicons.log_out_outline, 'Logout', false,
                        onTap: () => logoutUserInUI(
                            context, userService, navigationProvider),
                        isDestructive: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, bool isSwitch,
      {Function()? onTap, bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red.shade400 : Colors.grey.shade700,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red.shade400 : Colors.black87,
          fontWeight: isDestructive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSwitch
          ? Switch(value: false, onChanged: (bool value) {})
          : Icon(Ionicons.chevron_forward_outline, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 16,
      endIndent: 16,
    );
  }
}
