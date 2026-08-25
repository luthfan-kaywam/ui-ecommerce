import 'package:flutter/material.dart';
import 'auth_provider.dart';
import 'cart_provider.dart';

class AppStateScope extends StatefulWidget {
  final Widget child;
  const AppStateScope({super.key, required this.child});

  @override
  State<AppStateScope> createState() => _AppStateScopeState();
}

class _AppStateScopeState extends State<AppStateScope> {
  late final AuthProvider authProvider;
  late final CartProvider cartProvider;

  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider();
    cartProvider = CartProvider();
  }

  @override
  void dispose() {
    authProvider.dispose();
    cartProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      authProvider: authProvider,
      cartProvider: cartProvider,
      child: ListenableBuilder(
        listenable: Listenable.merge([authProvider, cartProvider]),
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

  const AppStateProvider({
    super.key,
    required this.authProvider,
    required this.cartProvider,
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
        cartProvider != oldWidget.cartProvider;
  }
}

extension AppStateContextExtension on BuildContext {
  AuthProvider get auth => AppStateProvider.of(this).authProvider;
  CartProvider get cart => AppStateProvider.of(this).cartProvider;
}
