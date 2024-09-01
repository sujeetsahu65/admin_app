import 'package:admin_app/common/widgets/other_widgets/language_switcher.dart';
import 'package:admin_app/common/widgets/other_widgets/sidebarPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarWrapper extends ConsumerWidget implements PreferredSizeWidget {
  final child;
  const AppBarWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isAuthenticated = ref.watch(authProvider);
    // final languageId = ref.watch(languageIdProvider);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ThemeColors.primaryColor(),
        iconTheme: IconThemeData(color: Colors.white),
        // centerTitle: true,
        titleSpacing: 0.0,
        title: LanguageSwitcher(),
        leading: Builder(
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
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    
                    // await authNotifier.logout();
                    // context.go('/login');
                  },
                )
              ]
            : null,
        // leading:  IconButton(onPressed: (){},
        //    icon: Icon(Icons.menu)),//since we are already using the drawer
      ),
      body: child,
      drawer: SideBarPanel(),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
