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
    // final bool isNestedPage = location != '/home' && location != '/settings';
  
      ref.listen<GlobalMessageState?>(globalMessageProvider, (previous, next) {
      if (next != null && next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: next.isError ? Colors.red : Colors.green,
          ),
        );
        // Clear the message after showing
        ref.read(globalMessageProvider.notifier).clearMessage();
      }
    });


    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ThemeColors.primaryColor(),
        iconTheme: IconThemeData(color: Colors.white),
        // centerTitle: true,
        titleSpacing: 0.0,
        title: LanguageSwitcher(),
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
        actions: 1 == 1
            ? <Widget>[
                IconButton(onPressed: () {}, icon: Icon(Icons.local_shipping)),
              ]
            : null,
        // leading:  IconButton(onPressed: (){},
        //    icon: Icon(Icons.menu)),//since we are already using the drawer
      ),
      body: child,
      drawer: isNestedPage ? null : SideBarPanel(),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
