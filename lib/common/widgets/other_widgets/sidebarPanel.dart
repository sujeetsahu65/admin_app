import 'package:admin_app/models/basic_models.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/providers/auth.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SideBarPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildHeader(context, ref),
            buildMenuItems(context, ref),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, ref) {
    final BasicModels basicDataProvider = ref.watch(generalDataProvider);
    return Container(
      color: Colors.blue.shade700,
      width: double.infinity,
      padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
      child: Column(
        children: [
          Image.asset(
            'assets/images/foozu_logo_light.png',
            width: 80,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            basicDataProvider.locationMaster.disName,
            style: TextStyle(fontSize: 18, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget buildMenuItems(BuildContext context, ref) {
    final languageContent = ref.watch(languageContentProvider);
    final String location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    //     final bool isLoginRoute = goRouterState?.location == '/login';
    // final currentRoute2 = GoRouter.of(context).routerDelegate.;
      // GoRouter _router = GoRouter;
      //            final Uri location = _router.routerDelegate.currentConfiguration.uri;
        print("location is: $location");
    final currentRoute = location;

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Wrap(
        runSpacing: 2,
        children: [
          buildMenuItem(
            context,
            ref,
            title: AppLocalizations.of(context).translate('title_home'),
            icon: Icons.home_outlined,
            route: '/home',
            currentRoute: currentRoute,
          ),
          buildMenuItem(
            context,
            ref,
            title: AppLocalizations.of(context)
                .translate('receive order button'),
            icon: Icons.shopping_cart_outlined,
            route: '/received-orders',
            currentRoute: currentRoute,
          ),
          buildMenuItem(
            context,
            ref,
            title: AppLocalizations.of(context)
                .translate('title_Pre_order_booking'),
            icon: Icons.more_time,
            route: '/pre-orders',
            currentRoute: currentRoute,
          ),
          buildMenuItem(
            context,
            ref,
            title: AppLocalizations.of(context)
                .translate('fail order button'),
            icon: Icons.warning_amber_outlined,
            route: '/failed-orders',
            currentRoute: currentRoute,
          ),
          buildMenuItem(
            context,
            ref,
            title: AppLocalizations.of(context)
                .translate('title_cancelled_order'),
            icon: Icons.clear_outlined,
            route: '/cancelled-orders',
            currentRoute: currentRoute,
          ),
          buildMenuItem(
            context,
            ref,
            title: AppLocalizations.of(context)
                .translate('setting page title'),
            icon: Icons.settings_outlined,
            route: '/settings',
            currentRoute: currentRoute,
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Color.fromARGB(255, 45, 45, 45),
            ),
            title: Text(
                AppLocalizations.of(context).translate('title_logout')),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required IconData icon,
    required String route,
    required String currentRoute,
  }) {
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Color.fromARGB(255, 45, 45, 45),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        context.go(route);
      },
    );
  }
}
