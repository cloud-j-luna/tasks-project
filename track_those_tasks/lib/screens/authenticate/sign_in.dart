import 'package:flutter/material.dart';
import 'package:trackthosetasks/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          title: Text('Sign In'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: RaisedButton(
            child: Text('Sign In as Guest'),
            onPressed: () async {
              dynamic result = await _authService.signInAnon();
              if(result == null) {
                print('Error signing in');
              } else {
                print('Signed in');
                print(result.uid);
              }
            },
          ),
        ));
  }
}
