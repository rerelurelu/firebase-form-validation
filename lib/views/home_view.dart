import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Auth User (Logged ' + (user == null ? 'out' : 'in') + ')'),
      ),
      body: Form(
        key: _key,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  validator: validationEmail,
                ),
                TextFormField(
                  controller: passwordController,
                  validator: validationPassword,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text('Sign Up'),
                      onPressed: user != null
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                                errorMessage = '';
                              });
                              if (_key.currentState!.validate()) {
                                try {
                                  await auth.createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  errorMessage = '';
                                } on FirebaseAuthException catch (error) {
                                  errorMessage = error.message!;
                                }
                                setState(() => _isLoading = false);
                              }
                            },
                    ),
                    ElevatedButton(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text('Sign In'),
                      onPressed: user != null
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                                errorMessage = '';
                              });
                              if (_key.currentState!.validate()) {
                                try {
                                  await auth.signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  errorMessage = '';
                                } on FirebaseAuthException catch (error) {
                                  errorMessage = error.message!;
                                }
                                setState(() => _isLoading = false);
                              }
                            },
                    ),
                    ElevatedButton(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text('Log Out'),
                      onPressed: user == null
                          ? null
                          : () async {
                              try {
                                setState(() {
                                  _isLoading = true;
                                  errorMessage = '';
                                });
                                await auth.signOut();
                              } on FirebaseAuthException catch (error) {
                                errorMessage = error.message!;
                              }
                              setState(() => _isLoading = false);
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? validationEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) return 'Email is required.';

  final String pattern = r'\w+@\w+\.\w+';
  final RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid Email';

  return null;
}

String? validationPassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) return 'Password is required.';

  final String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  final RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword))
    return '''
      Password must be at least 8 characters,
      include an uppercase letter, number and symbol.
      ''';

  return null;
}
