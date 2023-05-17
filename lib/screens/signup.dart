import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/username_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController fnameController = TextEditingController();
    TextEditingController lnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final fname = TextField(
      controller: fnameController,
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
    );

    final lname = TextField(
      controller: lnameController,
      decoration: const InputDecoration(
        hintText: "Last Name",
      ),
    );

    final email = TextField(
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );

    final password = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
    );
    final RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$');
    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          final bool isFnameGiven = fnameController.text.isNotEmpty;
          final bool isLnameGiven = lnameController.text.isNotEmpty;
          final bool emailValid = emailRegExp.hasMatch(emailController.text);
          final bool isPassGiven = passwordController.text.isNotEmpty;
          final bool isPassLength = passwordController.text.length >= 6;
          if (!isFnameGiven) {
            showAlertDialogInvalidInput(context, "First name is required");
          } else if (!isLnameGiven) {
            showAlertDialogInvalidInput(context, "Last name is required");
          } else if (!emailValid) {
            showAlertDialogInvalidInput(context, "Input valid email");
          } else if (!isPassGiven) {
            showAlertDialogInvalidInput(context, "Password is required");
          } else if (!isPassLength) {
            showAlertDialogInvalidInput(
                context, "Password is required to have at least 6 characters");
            // FirebaseAuthException also present in api/firebase_auth_api.dart however
            // I cannot make a prompt appear from there, so I coded this portion also.
            // The exception can be found printed in the terminal.
          }
          if (isFnameGiven &&
              isLnameGiven &&
              emailValid &&
              isPassGiven &&
              isPassLength) {
            Username user = Username(
                fname: fnameController.text, lname: lnameController.text);
            await context
                .read<AuthProvider>()
                .signUp(user, emailController.text, passwordController.text);
            if (context.mounted) Navigator.pop(context);
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            fname,
            lname,
            email,
            password,
            SignupButton,
            backButton
          ],
        ),
      ),
    );
  }
}

// Alert dialog for invalid fname/lname/email
showAlertDialogInvalidInput(BuildContext context, String message) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Invalid input"),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
