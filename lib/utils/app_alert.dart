import 'package:flutter/material.dart';

class AppAlert {
  showAlertDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Notification"),
      content: const Text("Email Sent. Please reset your passowrd."),
      actions: [
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
