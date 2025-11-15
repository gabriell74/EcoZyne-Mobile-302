import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHelper {
  static int? currentUserId(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return userProvider.user?.id;
  }

  static bool isLoggedIn(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return userProvider.user != null && !userProvider.isGuest;
  }
}
