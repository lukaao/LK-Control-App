// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyButtom extends StatelessWidget {
  String label;
  double height;
  double width;
  Color? color;
  Color? labelColor;
  final onPressed;

  MyButtom(
      {super.key,
      required this.label,
      required this.height,
      required this.width,
      required this.onPressed,
      this.labelColor,
      this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                color == null ? Theme.of(context).primaryColorLight : color!),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ))),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15,
              color: labelColor == null ? Colors.black : labelColor!),
        ),
      ),
    );
  }
}
