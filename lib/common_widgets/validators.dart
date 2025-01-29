class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    final RegExp phoneRegExp = RegExp(
      r'^\+?[0-9]{10,15}$',
    );
    if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? validatePrivacy(bool? value) {
    if (value == null || !value) {
      return 'You must accept the privacy policy';
    }
    return null;
  }
}
