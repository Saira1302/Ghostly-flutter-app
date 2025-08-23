import 'package:firebase_connection_app/profile/change_theme.dart';
import 'package:firebase_connection_app/profile/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Firebase config
import 'firebase_options.dart';

// Providers
import 'package:firebase_connection_app/lib/profile/theme_provider.dart';

// Screens & Routes
import 'package:firebase_connection_app/home/home_screen.dart';
import 'package:firebase_connection_app/home/feed_screen.dart';
import 'package:firebase_connection_app/onboarding_page1.dart';
import 'package:firebase_connection_app/splash_screen.dart';
import 'package:firebase_connection_app/welcome_screen.dart';
import 'package:firebase_connection_app/auth/login_screen.dart';
import 'package:firebase_connection_app/auth/signup_screen.dart';
import 'package:firebase_connection_app/logout.dart';

import 'package:firebase_connection_app/profile/my_profile.dart';
import 'package:firebase_connection_app/profile/profile_menu.dart';
import 'package:firebase_connection_app/profile/profile_setting.dart';
import 'package:firebase_connection_app/setting/about_app.dart';
import 'package:firebase_connection_app/setting/privacy_policy.dart';
import 'package:firebase_connection_app/setting/report_bug.dart';
import 'package:firebase_connection_app/setting/setting_main.dart';
import 'package:firebase_connection_app/setting/terms_and_conditions.dart';
import 'package:firebase_connection_app/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Ghostly',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
      routes: {
        '/': (context) => OnboardingScreen(),
        '/splash': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/feed': (context) => FeedScreen(),

        // AppRoutes
        AppRoutes.myProfile: (context) => const MyProfile(),
        AppRoutes.changeTheme: (context) => const ChangeTheme(),
        AppRoutes.profileSettings: (context) => const ProfileSettings(),
        AppRoutes.profileMenu: (context) => const ProfileMenu(),
        AppRoutes.settings: (context) => const SettingsMain(),
        AppRoutes.terms: (context) => const TermsAndConditionsScreen(),
        AppRoutes.privacy: (context) => const PrivacyPolicyScreen(),
        AppRoutes.bugReport: (context) => const ReportTheBugScreen(),
        AppRoutes.about: (context) => const AboutAppScreen(),
        AppRoutes.logout: (context) => const LogoutScreen(),
      },
    );
  }
}
