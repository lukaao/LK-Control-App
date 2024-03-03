import 'package:flutter/material.dart';

class LayoutTelas extends StatelessWidget {
  final Widget body;
  LayoutTelas({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0, color: Colors.transparent),
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(40),
            //   topRight: Radius.circular(40),
            // ),
          ),
          child: Container(
            child: body,
          ),
        ),
      ],
    );
  }
}
