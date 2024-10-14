import 'package:admin_app/common/widgets/other_widgets/customFont.dart';
import 'package:admin_app/common/widgets/other_widgets/language_switcher.dart';
import 'package:admin_app/common/widgets/other_widgets/sidebar_panel.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppBarWrapper extends ConsumerWidget implements PreferredSizeWidget {
  final Widget child;
  const AppBarWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isAuthenticated = ref.watch(authProvider);
    // final languageId = ref.watch(languageIdProvider);
    final goRouter = ref.watch(goRouterProvider);
    final String currentLocation =
        goRouter.routerDelegate.currentConfiguration.uri.toString();
    final bool isNestedPage =
        RegExp(r'^/settings/.*').hasMatch(currentLocation);

    String? currentRouteName;
    // print(goRouter.routerDelegate.currentConfiguration.runtimeType);

    final RouteMatchList currentConfig =
        goRouter.routerDelegate.currentConfiguration;

    if (currentConfig.matches.isNotEmpty) {
      // Access the first route match
      final routeMatch = currentConfig.matches.first;

      // Check if the route is a GoRoute
      if (routeMatch.route is GoRoute) {
        final GoRoute currentRoute = routeMatch.route as GoRoute;
        currentRouteName = currentRoute.name;
        // Now you can access the name and path of the GoRoute
        // print(currentRoute.name); // Prints the name of the route
        // print(currentRoute.path); // Prints the path of the route
      } else {
        print('The route is not a GoRoute.');
      }
    } else {
      print('No matches found in RouteMatchList');
    }

    ref.listen<GlobalMessageState?>(globalMessageProvider, (previous, next) {
      if (next != null && next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: next.isError ? Colors.red : Colors.green,
            duration: const Duration(milliseconds: 1500),
          ),
        );
        // Clear the message after showing
        ref.read(globalMessageProvider.notifier).clearMessage();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        // centerTitle: true,
        titleSpacing: 0.0,
        title: currentRouteName != null
            ? CustomFont(text: currentRouteName, color: Colors.white)
                .mediumLarge()
            : null,
        // title: Text("currentRouteName"),
        leading: isNestedPage
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop(); // Navigate back
                },
              )
            : Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),

        // actions: isAuthenticated?<Widget>[
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.local_shipping)),
          LanguageSwitcher()
        ],
        // leading:  IconButton(onPressed: (){},
        //    icon: Icon(Icons.menu)),//since we are already using the drawer
      ),
      body: child,
      drawer: isNestedPage ? null : SideBarPanel(),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
