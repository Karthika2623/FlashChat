import 'package:flashchat_15/constant.dart';
import 'package:flutter/material.dart';
import 'package:flashchat_15/RoundButton.dart';
import 'package:flashchat_15/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat-screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class RegistrationScreen extends StatefulWidget {
  static const String id= 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {


 final _auth=FirebaseAuth.instance;
  bool ShowSpinner=false;
 bool isSecured=true;
  
  late String email;
  late String password;
  
  final _formField=GlobalKey<FormState>();
  final emailcontroller=TextEditingController();
  final passwordcontroller=TextEditingController();

  
@override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: ShowSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 250.0,
                    child: Image.asset('images/logo1.jpg'),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                 email=value;
                },
                decoration:kTextFieldDecoration.copyWith(labelText: 'Enter Your Email..'),),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: passwordcontroller,
                obscureText: true,
                onChanged: (value) {
                  password=value;
                },
                decoration:kTextFieldDecoration.copyWith(labelText: 'Enter Your Password...'),),
              const SizedBox(
                height: 24.0,
              ),
              RoundButton(
                clr: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  // print(email);
                  // print(password);
                  setState(() {
                    ShowSpinner=true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if(newUser!=null){
                      debugPrint('result :$newUser');
                      Navigator.pushNamed(context,ChatScreen.id);
                    }
                    setState(() {
                      ShowSpinner=false;
                    });
                  }
                catch (e) {
                    debugPrint('error=$e');
                }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}