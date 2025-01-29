import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart'; // Make sure to import svg_flutter
import 'package:ionicons/ionicons.dart';

class SubjectCard extends StatelessWidget {
  final String name;
  final String svgPath;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.name,
    required this.svgPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SvgPicture.asset(
            svgPath,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => const CircularProgressIndicator(),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(6),
          child: Icon(
            Ionicons.chevron_forward_outline,
            color: Colors.blue.shade700,
            size: 20,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
