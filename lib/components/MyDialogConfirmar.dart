import 'package:flutter/material.dart';

showMyDialogConfirmar(
    {required BuildContext context,
    required String title,
    required String msg,
    Icon? icone,
    Widget? child}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          surfaceTintColor: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icone != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [icone],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      msg,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    )
                  ],
                ),
                if (child != null) child,
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ));
    },
  );
}
