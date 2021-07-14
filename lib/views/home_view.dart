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

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Auth User (Logged ' + (user == null ? 'out' : 'in') + ')'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: emailController,
              ),
              TextField(
                controller: passwordController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: Text('Sign Up'),
                    onPressed: () async {
                      await auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    child: Text('Sign In'),
                    onPressed: () async {
                      await auth.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    child: Text('Log Out'),
                    onPressed: () async {
                      await auth.signOut();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
