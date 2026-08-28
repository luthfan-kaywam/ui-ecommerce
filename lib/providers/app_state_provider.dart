import 'package:flutter/material.dart';
import 'auth_provider.dart';
import 'cart_provider.dart';
import 'theme_provider.dart';

class AppStateScope extends StatefulWidget {
  final Widget child;
  const AppStateScope({super.key, required this.child});

  @override
  State<AppStateScope> createState() => _AppStateScopeState();
}

class _AppStateScopeState extends State<AppStateScope> {
  late final AuthProvider authProvider;
  late final CartProvider cartProvider;
  late final ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider();
    cartProvider = CartProvider();
    themeProvider = ThemeProvider();
  }

  @override
  void dispose() {
    authProvider.dispose();
    cartProvider.dispose();
    themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      authProvider: authProvider,
      cartProvider: cartProvider,
      themeProvider: themeProvider,
      child: ListenableBuilder(
        listenable: Listenable.merge([authProvider, cartProvider, themeProvider]),
        builder: (context, child) {
          return widget.child;
        },
      ),
    );
  }
}

class AppStateProvider extends InheritedWidget {
  final AuthProvider authProvider;
  final CartProvider cartProvider;
  final ThemeProvider themeProvider;

  const AppStateProvider({
    super.key,
    required this.authProvider,
    required this.cartProvider,
    required this.themeProvider,
    required super.child,
  });

  static AppStateProvider of(BuildContext context) {
    final AppStateProvider? result =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(result != null, 'No AppStateProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) {
    return authProvider != oldWidget.authProvider ||
        cartProvider != oldWidget.cartProvider ||
        themeProvider != oldWidget.themeProvider;
  }
}

extension AppStateContextExtension on BuildContext {
  AuthProvider get auth => AppStateProvider.of(this).authProvider;
  CartProvider get cart => AppStateProvider.of(this).cartProvider;
  ThemeProvider get themeProvider => AppStateProvider.of(this).themeProvider;
  bool get isDarkMode => themeProvider.isDarkMode;
}

