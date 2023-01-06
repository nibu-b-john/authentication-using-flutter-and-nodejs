import 'dart:convert';
import 'dart:developer';
import 'package:authentication/shared_preferences/shared_preference.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName1 = '/LoginScreen';
  static const routeName2 = '/secretsScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<dynamic> onSubmit(email, password) async {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }

    final loggedInTokken = postData(_emailController, _passwordController);

    _emailController.clear();
    _passwordController.clear();
    return loggedInTokken;
  }

  void postData(
      TextEditingController email, TextEditingController password) async {
    final url = Uri.parse("${dotenv.env['YOUR_ENDPOINT_URL']}/postFormData");

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "email": email.text.toString(),
          "password": password.text.toString()
        }));

    final jsonData = jsonDecode(response.body);

    await Preferences.setToken(jsonData['token'].toString());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<bool> checkTokken() async {
    final tokken = await Preferences.getToken();
    if (tokken != null) {
      log('going1');
      Navigator.popAndPushNamed(context, HomeScreen.routeName2);
      return true;
    }
    return false;
  }

  @override
  void initState() {
    checkTokken().then((tokkenReady) async => {
          if (tokkenReady != false)
            {Navigator.popAndPushNamed(context, HomeScreen.routeName2)}
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('in home screen');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Center(child: Text('Authentication Screen')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.7,
            height: 500,
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
                              'Sign up',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account, ",
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    )),
                                onPressed: () async {
                                  Navigator.pushNamed(
                                      context, HomeScreen.routeName1);
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ))
                          ],
                        ),
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
