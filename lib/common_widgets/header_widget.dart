// user_header.dart
import 'package:flutter/material.dart';
import 'package:past_question_paper/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserViewModel>(context);
    final username = authProvider.currentUser?.displayName ?? 'Guest';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              authProvider.currentUser?.displayName ??
                  'https://via.placeholder.com/150', // Placeholder image URL
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome,',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
