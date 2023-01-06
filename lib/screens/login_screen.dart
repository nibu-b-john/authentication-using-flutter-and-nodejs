import 'dart:convert';
import 'dart:developer';
import 'package:authentication/screens/homeScreen.dart';
import 'package:authentication/shared_preferences/shared_preference.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/secretScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<dynamic> onSubmit(email, password) async {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }

    final loggedInTokken =
        await postData(_emailController, _passwordController);

    _emailController.clear();
    _passwordController.clear();
    return loggedInTokken;
  }

  Future<dynamic> postData(
      TextEditingController email, TextEditingController password) async {
    final url = Uri.parse("${dotenv.env['YOUR_ENDPOINT_URL']}/postLoginData");
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "email": email.text.toString(),
          "password": password.text.toString()
        }));
    final jsonData = jsonDecode(response.body);
    await Preferences.setToken(jsonData['tokken']);
    return jsonData;
  }

  @override
  void initState() {
    checkTokken().then((tokkenReady) async => {
          log(tokkenReady.toString()),
          if (tokkenReady)
            {
              await Preferences.remove(),
              Navigator.popAndPushNamed(context, HomeScreen.routeName2)
            }
        });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<bool> checkTokken() async {
    final tokken = await Preferences.getToken();
    log(tokken.toString());
    if (tokken != null) {
      Navigator.popAndPushNamed(context, LoginScreen.routeName);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    log('in login screen');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Padding(
            padding: EdgeInsets.only(left: 60), child: Text('Login Screen')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.7,
            height: 700,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a email';
                            }
                            return null;
                          },
                          controller: _emailController,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              labelText: 'email',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary))),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a valid password';
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          autocorrect: false,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              labelText: 'password',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white)),
                            onPressed: () async {
                              await onSubmit(_emailController.text,
                                  _passwordController.text);
                              checkTokken();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white)),
                            onPressed: () async {
                              final hello = await Preferences.getToken();
                              log(hello);
                            },
                            child: Text(
                              'Log Token',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
