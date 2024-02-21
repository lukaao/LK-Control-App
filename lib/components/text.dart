import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String label;
  final String valor;

  const MyText({required this.label, required this.valor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.4,
                  maxWidth: MediaQuery.of(context).size.width * 0.4),
              height: 30,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 3,
                ),
                child: Text(valor, softWrap: false),
              ))
        ],
      ),
    );
  }
}
