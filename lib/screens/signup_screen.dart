import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:IUApp/method/firebase_methods.dart';
import 'package:IUApp/models/user.dart';
import 'package:IUApp/screens/signin_screen.dart';
import 'package:IUApp/utils/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode pwdNode = FocusNode();

  bool obscure = true;

  FirebaseMethods _methods = FirebaseMethods();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.blue,
                  Colors.deepPurple,
                  Colors.deepPurpleAccent
                ])),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Pacifico'),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Hey!' + PHONE_NO.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    focusNode: emailNode,
                    validator: (String email) => emailValidator(email),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(pwdNode);
                    },
                    style: labelStyle,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: labelStyle,
                        enabledBorder: labelBorder,
                        focusedBorder: labelBorder,
                        errorBorder: errorBorder,
                        border: labelBorder,
                        errorStyle: errorStyle,
                        filled: true,
                        fillColor: Colors.white12),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: pwdController,
                    focusNode: pwdNode,
                    validator: (String pwd) => pwdValidator(pwd),
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    style: labelStyle,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: labelStyle,
                      enabledBorder: labelBorder,
                      focusedBorder: labelBorder,
                      errorBorder: errorBorder,
                      border: labelBorder,
                      errorStyle: errorStyle,
                      filled: true,
                      fillColor: Colors.white12,
                      suffixIcon: IconButton(
                        color: Colors.white,
                        icon: obscure
                            ? Icon(Icons.remove_red_eye)
                            : Icon(MdiIcons.eyeOff),
                        onPressed: () {
                          print("pressed");
                          obscure ? obscure = false : obscure = true;
                          setState(() {});
                        },
                      ),
                    ),
                    obscureText: obscure,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white12,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Sign Up',
                        style: signStyle,
                      ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate()) {
                        emailController.text = emailController.text.trim();
                        pwdController.text = pwdController.text.trim();
                        print(emailController.text + pwdController.text);

                        _methods
                            .signUp(
                                email: emailController.text,
                                pwd: pwdController.text)
                            .then((FirebaseUser user) {
                          //CHECK GOT USER OT NOT
                          if (user != null) {
                            acknowledgeDialog(context, emailController.text);
                          } else
                            print('Some Error Occurred');
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Already have account?  ",
                        style: labelStyle,
                      ),
                      GestureDetector(
                        child: Text(
                          "SignIn!",
                          style: signStyle,
                        ),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                              ModalRoute.withName(''));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
