import 'package:flutter/material.dart';
import 'home/camera_screen.dart';
import 'home/feed_screen.dart';
import 'home/home_screen.dart';
import 'home/search_screen.dart';
import 'logout.dart';



class AppRoutes {
  static const String home = '/';
  static const String createPost = '/createPost';
  static const String editPost = '/editPost';
  static const String postSuccess = '/postSuccess';
  static const String deleteConfirmation = '/deleteConfirmation';
  static const myProfile = '/myProfile';
  static const ghostHistory = '/ghostHistory';
  static const changeTheme = '/changeTheme';
  static const profileSettings = '/profileSettings';
  static const profileMenu = '/profileMenu';
  static const settings = '/settings';
  static const terms = '/terms';
  static const privacy = '/privacy';
  static const bugReport = '/bugReport';
  static const about = '/about';
  static const flaggedPosts = '/flagged-posts';
  static const userReports = '/user-report';
  static const analytics = '/analytics-report';
  static const String camera = '/camera';
  static const String search = '/search';
  static const String feed = '/feed';
  static const login = '/login';
  static const logout = '/logout';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case camera:
        return MaterialPageRoute(builder: (_) => ImageUploadScreen());
      case search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case feed:
        return MaterialPageRoute(builder: (_) => const FeedScreen());
      case logout:
        return MaterialPageRoute(builder: (_) => const LogoutScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }

}