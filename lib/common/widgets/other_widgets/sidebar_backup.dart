import 'package:admin_app/models/basic_models.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/providers/auth.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBarPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      // backgroundColor: Colors.amber,
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

  buildHeader(BuildContext context, ref) {
    final BasicModels basicDataProvider = ref.watch(generalDataProvider);
    return Container(
      color: Colors.blue.shade700,
      width: double.infinity,
      padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
      child: Column(
        children: [
          Image.asset(
            'assets/images/foozu_logo_light.png', // replace with your logo asset
            // height: 150,
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
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Wrap(
          runSpacing: 2,
          children: [
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: Color.fromARGB(255, 45, 45, 45),
              ),
              title: Text(AppLocalizations.of(context).translate('title_home')),
              onTap: () {
                // GoRouter.of(context).pushReplacementNamed('home');
                context.go('/home');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.shopping_cart_outlined,
                color: Color.fromARGB(255, 45, 45, 45),
              ),
              title: Text(AppLocalizations.of(context)
                  .translate('receive order button')),
              onTap: () {

                context.go('/received-orders');
                // GoRouter.of(context).pushNamed('product-list',
                //     pathParameters: {
                //       "product_name": "parle",
                //       "title": "proooo"
                //     });
                // ref.read(pageStateProvider.notifier).update((state) => 1);
                //  GoRouter.of(context).pushReplacementNamed('menu-page', pathParameters:{"cat_id":"1"});
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.more_time,
                color: Color.fromARGB(255, 45, 45, 45),
              ),
              title: Text(AppLocalizations.of(context)
                  .translate('title_Pre_order_booking')),
              onTap: () {
                // context.go('/pre-orders');
                // If we want that when we go back the sidebar is closed then we can use pop.(context)
                // Navigator.pop(context);
                // GoRouter.of(context).pushNamed('profile');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.warning_amber_outlined,
                color: Color.fromARGB(255, 45, 45, 45),
              ),
              title: Text(
                  AppLocalizations.of(context).translate('fail order button')),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.clear_outlined,
                color: Color.fromARGB(255, 45, 45, 45),
              ),
              title: Text(AppLocalizations.of(context)
                  .translate('title_cancelled_order')),
              onTap: () {
                 context.go('/cancelled-orders');
                // GoRouter.of(context).pushNamed('login');
                // GoRouter.of(context).pushNamed('login');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                color: Color.fromARGB(255, 45, 45, 45),
              ),
              title: Text(
                  AppLocalizations.of(context).translate('setting page title')),
              onTap: () {
                // GoRouter.of(context).pushNamed('/settings');
                // GoRouter.of(context).pushNamed('login');
                context.go('/settings');
              },
            ),
            const Divider(
              color: Colors.black54,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Color.fromARGB(255, 45, 45, 45),
              ),
              title:
                  Text(AppLocalizations.of(context).translate('title_logout')),
              onTap: () async {
                // ref.read(authProvider.notifier).clearUserCookie();
                // GoRouter.of(context).pushReplacementNamed('logout');
                await ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
