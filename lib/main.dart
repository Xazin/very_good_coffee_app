import 'package:flutter/material.dart';
import 'package:very_good_coffee_app/application/startup.dart';
import 'package:very_good_coffee_app/presentation/core/router.dart';

void main() {
  registerGetIt();
  runApp(const AppWidget());
}

/// The entry point of the application.
///
/// The [AppWidget] is responsible for bootstrapping the application.
///
class AppWidget extends StatelessWidget {
  /// Creates a widget which bootstraps the application with a [MaterialApp].
  ///
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      routerConfig: appRouter,
    );
  }
}
