import 'package:flutter/material.dart';
import 'RoundButton.dart';
import 'constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat-screen.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen' ;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late bool showSpinner;
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 250.0,
                  child: Image.asset('images/logo1.jpg'),
                ),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration:  kTextFieldDecoration.copyWith(labelText: 'Enter Your Email...'),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(labelText: 'Enter Your Password...'),
            ),
            const SizedBox(
              height: 35.0,
            ),
            RoundButton(
                clr: Colors.blue,
                title: 'Log In',
               onPressed: ()async {   setState(() {
              showSpinner= true;
            });
            try{
              final newUser = _auth.signInWithEmailAndPassword(email: email, password: password);

              if(newUser != null){
                Navigator.pushNamed(context, ChatScreen.id);
              }
              setState(() {
                showSpinner= false;
              });
            }catch(e){
              print (e);
            }},),
          ],
        ),
      ),

    );
  }
}