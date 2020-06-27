import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IUApp/screens/signin_screen.dart';

String PHONE_NO = "";

OutlineInputBorder labelBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.white));

OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.redAccent));

TextStyle errorStyle = TextStyle(
  color: Colors.redAccent,
  fontWeight: FontWeight.w500,
);

TextStyle labelStyle =
    TextStyle(fontWeight: FontWeight.w500, color: Colors.white);

TextStyle signStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    fontFamily: 'Girassol');

TextStyle uploaderStyle = TextStyle(
    color: Colors.deepPurpleAccent,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    fontFamily: 'Girassol');

TextStyle imgDetailsStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w700,
  fontSize: 15,
);
TextStyle imgDateStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 10,
);

emailValidator(String email) {
  email = email.trim();
  if (email.isEmpty)
    return "Enter Email";
  else {
    if (!email.contains('@', 0)) {
      return 'Invalid Email';
    }
  }
}

pwdValidator(String pwd) {
  pwd = pwd.trim();
  if (pwd.isEmpty)
    return "Enter Password";
  else {
    if (pwd.length < 6) {
      return 'Minimum password length must be 6';
    }
  }
}

codeValidation(String code) {
  code = code.trim();
  if (code.isEmpty)
    return "Enter Country Code";
  else {
    if (code.length > 2 || code.length < 1) return "Check Country Code";
  }
}

phoneValidation(String phone) {
  phone = phone.trim();
  if (phone.isEmpty)
    return "Enter Phone Number";
  else {
    if (phone.length != 10) return "Enter PhoneNumber with 10digits";
  }
}

smsValidator(String code) {
  if (code.isEmpty) return "Enter SMS Code";
}

String getUserName(FirebaseUser user) {
  if (user.displayName != null)
    return user.displayName;
  else {
    return "${user.email.split('@')[0]}";
  }
}

showToast({@required String msg}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 16.0);
}

acknowledgeDialog(BuildContext context, String email) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.deepPurpleAccent,
            title: Text(
              "Mail Verification Sent",
              style: signStyle,
            ),
            content: Text(
              "A verification email has been sent to ${email}. Click on the confirmation link in the email to activate you account." +
                  "After verifying go to Sign in Page to sign in.",
              style: labelStyle,
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white12,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Sign In", style: signStyle),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                    ModalRoute.withName(''),
                  );
                },
              )
            ],
          ));
}

EmailNotVerifiedDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.deepPurpleAccent,
            title: Text(
              "Sign In failed",
              style: signStyle,
            ),
            content: Text(
              "Email is not verified. Find verification link in the mail"
              " received after SignUp.",
              style: labelStyle,
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white12,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("OK", style: signStyle),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));
}

PhoneNotVerifiedDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.deepPurpleAccent,
            title: Text(
              "Hey",
              style: signStyle,
            ),
            content: Text(
              "Phone number is not verified. Open the side menu and follow the steps to verify phone number." +
                  "After phone is verified you can upload images",
              style: labelStyle,
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white12,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("OK", style: signStyle),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));
}
