
import 'package:admin_app/providers/basic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';


class LanguageSwitcher extends ConsumerWidget {
  final languageId;

  LanguageSwitcher({required this.languageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final triggered_lang_id = languageId == 1 ? 2 : 1;
        print("triggered_lang_id:${languageId}");
// ref.read(languageContentProvider.notifier).loadLanguageContent(1);
        ref.read(languageIdProvider.notifier).state = triggered_lang_id;
        ref
            .read(languageContentProvider.notifier)
            .loadLanguageContent(triggered_lang_id);
      },
      child: Image.asset(
        'assets/images/${languageId == 1 ? "finnish" : "english"}.png', // replace with your logo asset
        // height: 150,
        width: 25,
      ),
      // child: Text('assets/images/${languageId==1?"english":"finnish"}.png'),
    );
  }
}