import 'package:flutter/material.dart';
import 'login-screen.dart';
import 'package:flashchat_15/registration.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'RoundButton.dart';

class HomeScreen extends StatefulWidget {

  static const String id= 'home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with SingleTickerProviderStateMixin {

  late AnimationController  controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller=AnimationController(
      duration: const Duration(seconds: 1),
        vsync:this,
       upperBound: 100.0
    );
    animation=ColorTween(begin: Colors.red,end: Colors.lightBlue).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});

    });
  }
@override
  void dispose() {
   controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 160.0,
                    width: 200.0,
                    child: Image.asset('images/logo1.jpg'),
                  ),
                ),
             DefaultTextStyle(
                  style: const TextStyle(
                     color: Colors.purple,
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Agbalumo',
                   ),
               child: AnimatedTextKit(
               animatedTexts: [
                 WavyAnimatedText('CHAT APP'),],
               isRepeatingAnimation: true,
              ),
              ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundButton(title: 'Log In',clr: Colors.lightBlue,onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
            },
            ),
            RoundButton(title: 'Register',
              clr: Colors.blueAccent,
              onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
            ),
          ],
        ),
      ),
    );
  }
}




