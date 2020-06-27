import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:IUApp/method/firebase_methods.dart';
import 'package:IUApp/utils/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  FocusNode phoneNode = FocusNode();
  FocusNode codeNode = FocusNode();

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
            padding: const EdgeInsets.all(40),
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
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'First verify your Mobile Number',
                    style: signStyle,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: codeController,
                    focusNode: codeNode,
                    validator: (String code) => codeValidation(code),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(phoneNode);
                    },
                    style: labelStyle,
                    decoration: InputDecoration(
                        hintText: "91",
                        labelText: "Country Code",
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
                    controller: phoneController,
                    focusNode: phoneNode,
                    validator: (String phone) => phoneValidation(phone),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    style: labelStyle,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: labelStyle,
                      enabledBorder: labelBorder,
                      focusedBorder: labelBorder,
                      errorBorder: errorBorder,
                      border: labelBorder,
                      errorStyle: errorStyle,
                      filled: true,
                      fillColor: Colors.white12,
                    ),
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
                        'Send Code',
                        style: signStyle,
                      ),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate()) {
                        phoneController.text = phoneController.text.trim();
                        codeController.text = codeController.text.trim();
                        print(phoneController.text + " " + codeController.text);
                        String phoneNumber = "+" +
                            codeController.text.trim() +
                            phoneController.text.trim();
                        _methods.sendCodeToPhoneNumber(
                            phonenumber: phoneNumber, context: context);
                      }
                    },
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
