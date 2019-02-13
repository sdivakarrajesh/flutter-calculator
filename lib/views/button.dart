import 'package:flutter/material.dart';

class RectangularButton extends StatelessWidget {

  final String buttonText;
  final Function onPressed;
  var span = 1;
  Color color = const Color(0xFF21252B);
  Color highlightColor= const Color(0xFF333A46);
  RectangularButton({this.buttonText,this.onPressed}){
    this.color = const Color(0xFF21252B);
    this.highlightColor = const Color(0xFF333A46);
  }
  RectangularButton.color({this.buttonText,this.onPressed,this.color,this.highlightColor});
  RectangularButton.multispan({this.buttonText, @required this.span, this.onPressed});

  @override
  Widget build(BuildContext context) {
    //print("$buttonText color: ${color}");
    return Flexible(
        flex: span,
        child: Container(
          height: 70.0,
          child: Material(
            color: color,
            child: InkWell(
                splashColor: highlightColor,
                highlightColor: highlightColor,
                onTap: () {
                  onPressed(buttonText);
                },
                
                child: Center(
                  child: Text(
                    "$buttonText",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 28.0,
                    ),
                  ),
                )),
          ),
        ));
  }
}
