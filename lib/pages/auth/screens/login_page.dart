import 'package:admin_app/common/widgets/other_widgets/language_switcher.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_app/providers/auth.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends ConsumerState<LoginPage> {
  bool rememberMe = false;
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider.notifier);

    // final languageId = ref.watch(languageIdProvider);
    final languageContent = ref.watch(languageContentProvider);

    return Scaffold(
      // appBar: AppBar(title: Text("hgj")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _signInFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(alignment: Alignment.centerLeft,
                child: LanguageSwitcher()),
                SizedBox(height: 50),
                Image.asset(
                  'assets/images/foozu_logo_dark.png', // replace with your logo asset
                  // height: 150,
                  width: 150,
                ),

                SizedBox(height: 50),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    // labelText: languageContent['forgot client username']??'',
                    // labelText: AppLocalizations.of(context)!.helloYou,
                    labelText: AppLocalizations.of(context).translate('forgot client username'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Enter your username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

// CustomTextField(controller: _passwordController,obscureText: _obscureText, labelText: 'Enter Password', toggleVisibility: _togglePasswordVisibility,isObscured: true,)

                // ,
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate('forgot client password'),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    Text(AppLocalizations.of(context).translate('remember me title')),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_signInFormKey.currentState!.validate()) {
                      try {
                        await authNotifier.login(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        context.go('/home');
                      } catch (e) {
                        print(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login failed')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 15, 51, 254), // background color
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  ),
                  child: Text(
                    AppLocalizations.of(context).translate('sign in label'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Handle forgot password logic here
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('forgot title'),
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
