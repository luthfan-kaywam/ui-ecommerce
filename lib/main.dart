import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/list_chat.dart';
import 'pages/detail_chat.dart';
import 'pages/login_pages.dart';
import 'pages/account_pages.dart';
import 'pages/cart_page.dart';
import 'pages/onboarding_screen.dart';
import 'providers/app_state_provider.dart';
import 'providers/theme_provider.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    const AppStateScope(
      child: _ThemeWrapper(),
    ),
  );
}

// ── _ThemeWrapper: listens to ThemeProvider directly so MaterialApp
//    always re-evaluates themeMode on every toggleTheme() call. ─────────────
class _ThemeWrapper extends StatelessWidget {
  const _ThemeWrapper();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;

    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return MyApp(themeProvider: themeProvider);
      },
    );
  }
}

// ── MyApp ─────────────────────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  final ThemeProvider? themeProvider;

  const MyApp({super.key, this.themeProvider});

  // Global Page Transition: Fade + Slide (Offset(0.04, 0) -> Offset.zero)
  static Route<dynamic> _buildAnimatedRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.auth;
    final tp = themeProvider ?? context.themeProvider;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QiluthMart',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: tp.themeMode,
      // Auth Guard & Entry Flow at Startup: Onboarding -> Login -> Dashboard
      initialRoute: auth.isAuthenticated ? "/dashboard" : "/onboarding",
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case "/":
            page = auth.isAuthenticated
                ? const HomePage()
                : const OnboardingScreen();
            break;
          case "/onboarding":
            page = const OnboardingScreen();
            break;
          case "/login":
            page = const LoginPages();
            break;
          case "/dashboard":
          case "/homePage":
            page = const HomePage();
            break;
          case "/cart":
          case "cartPage":
            page = const CartPage();
            break;
          case "/account":
          case "accountPage":
            page = const AccountPage();
            break;
          case "/list_chat":
          case "ListChat":
            page = const ChatListPage();
            break;
          case "/chat_detail":
          case "ChatDetail":
            final contactName = settings.arguments as String? ?? 'Nike Official';
            page = ChatScreen(contactName: contactName);
            break;
          case "/item_detail":
          case "itemsPage":
          default:
            page = Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: Text(
                  "Detail Produk",
                  style: AppTextStyles.display(16, w: FontWeight.w700),
                ),
                backgroundColor: AppColors.surface,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Center(
                child: Text(
                  "Halaman Detail Produk",
                  style: AppTextStyles.display(18, w: FontWeight.w700).copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
            );
            break;
        }

        return _buildAnimatedRoute(page, settings);
      },
    );
  }
}
