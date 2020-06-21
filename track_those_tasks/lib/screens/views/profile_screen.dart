import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackthosetasks/assets/colors.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/models/user.dart';
import 'package:trackthosetasks/services/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  User _user;

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: _user == null ? null : Text(_user.uuid),
      ),
      backgroundColor: CustomColors.primaryLightColor,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(PROFILE_LOGOUT),
              onPressed: () async {
                await _authService.signOut();
                await Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
