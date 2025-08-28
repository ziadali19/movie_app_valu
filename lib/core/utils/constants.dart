import 'package:flutter/material.dart';

class AppConstants {
  static String? userToken;
  static String? userId;
  static bool? onBoarding;
  static String? name;
  static String? userType;
  static final navKey = GlobalKey<NavigatorState>();
  static bool isGuest = false;
  static const baseURL = '';

  static String getInitials(String fullName) {
    List<String> nameParts = fullName.split(' ');
    String initials = nameParts[0][0]; // First character of the first name
    if (nameParts.length > 1) {
      initials += nameParts[1][0]; // First character of the last name
    }
    return initials.toUpperCase();
  }
}
