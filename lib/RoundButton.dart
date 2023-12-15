import 'package:flutter/material.dart';



class RoundButton extends StatelessWidget {
  RoundButton({required this.clr,required this.title,required this.onPressed});

  final Color clr;
  final String title;
  final void Function() onPressed;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: clr,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          // onPressed: () {
          //  Navigator.pushNamed(context, LoginScreen.id);
          // },
          minWidth: 200.0,
          height: 45.0,
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Agbalumo',fontSize: 25.0,
            ),
          ),
        ),
      ),
    );
  }
}