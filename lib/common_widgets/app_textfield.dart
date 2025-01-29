import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.keyboardType,
    this.hideText = false,
    required this.prefix,
    required this.validator,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool hideText;
  final IconData prefix;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0, right: 0),
      child: TextFormField(
        //validator: validator,
        obscureText: hideText,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Color.fromRGBO(235, 39, 142, 1)),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          labelText: labelText,
          prefixIcon: Icon(prefix, color: const Color.fromRGBO(0, 174, 241, 1)),
        ),
      ),
    );
  }
}
