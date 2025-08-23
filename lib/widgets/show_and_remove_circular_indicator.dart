  import 'package:flutter/material.dart';

Future<void> showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  Future<void> hideLoadingDialog(BuildContext context) async {
    Navigator.of(context).pop();
   // Navigator.of(context).pop();
  }