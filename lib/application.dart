import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/root_navigator.dart';
import 'package:health_app/core/theme/app_theme.dart';
import 'package:health_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:health_app/features/onboarding/view/onboarding_screen.dart';
import 'package:health_app/features/onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:provider/provider.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel()..loadCurrentUser(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health App',
        theme: appTheme,
        // theme: ThemeData(
        //   brightness: Brightness.dark,
        //   primarySwatch: Colors.blueGrey,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        home: const AppEntryPoint(),
      ),
    );
  }
}

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  bool? _showOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      final userId = authVm.user?.uid;
      if (userId != null) {
        authVm.saveFcmToken(userId);
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          authVm.saveFcmToken(userId);
        });
      }
    });
  }

  Future<void> _checkOnboarding() async {
    final completed = await hasCompletedOnboarding();
    setState(() {
      _showOnboarding = !completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _showOnboarding!
        ? OnboardingScreen(
            onFinish: () async {
              await setOnboardingComplete();
              setState(() {
                _showOnboarding = false;
              });
            },
          )
        : const RootNavigator();
  }
}
