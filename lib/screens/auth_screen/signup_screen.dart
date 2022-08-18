import 'package:final_year_project/screens/auth_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();

  bool isloading = false;

  final _formKey = GlobalKey<FormState>();

  signup() async {
    final isvalid = _formKey.currentState!.validate();

    if (isvalid) {
      registerUser();
    } else {
      print("field empty");
    }
  }

  registerUser() async {
    setState(() {
      isloading = true;
    });
    try {
      // FirebaseAuth auth = FirebaseAuth.instance;
      User? user = FirebaseAuth.instance.currentUser;

      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((signedInUser) => FirebaseFirestore.instance
                  .collection("Userlist")
                  .doc(signedInUser.user?.uid)
                  .set({
                'user_Id': user?.uid,
                'user_name': username.text,
                'joinDate': DateTime.now().millisecondsSinceEpoch,
                'email': email.text,
                'phoneno': phone.text,
              }).then((signedInUser) => {
                        setState(() {
                          isloading = false;
                        }),
                        print("Successfull"),
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Successfully Signup"),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        )),
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()))
                      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          isloading = false;
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    // try {
    //   print(email.text);
    //   print(password.text);
    // FirebaseAuth auth = FirebaseAuth.instance;
    // User? user = FirebaseAuth.instance.currentUser;
    // auth
    //     .createUserWithEmailAndPassword(
    //         email: email.text, password: password.text)
    //     .then((signedInUser) => FirebaseFirestore.instance
    //             .collection("Userlist")
    //             .doc(signedInUser.user?.uid)
    //             .set({
    //           'user_Id': user?.uid,
    //           'user_name': username.text,
    //           'joinDate': DateTime.now().millisecondsSinceEpoch,
    //           'email': email.text,
    //           'phoneno': phone.text,
    //         }).then((signedInUser) => {
    //                   setState(() {
    //                     isloading = false;
    //                   }),
    //                   print("Successfull"),
    //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                     content: Text("Successfully Signup"),
    //                     backgroundColor: Colors.green,
    //                     behavior: SnackBarBehavior.floating,
    //                   )),
    //                   Navigator.pushReplacement(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (context) => LoginScreen()))
    //                 }));
    // }
    //  on FirebaseAuthException catch (e) {
    //   print("====>>>> email exception");
    //   print(e);

    //   if (e.code == 'email-already-in-use') {
    //     setState(() {
    //       print("====>>>> email");
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         content: Text("The account already exists for that email"),
    //         backgroundColor: Colors.red.shade400,
    //         behavior: SnackBarBehavior.floating,
    //       ));
    //     });
    //   }

    // }
    // catch (e) {
    //   print("=====>>>>>>");
    //   print(e);
    // }
  }

  //Password validation
  String? passvalidation(value) {
    if (value == null || value.isEmpty) {
      return " Password is required";
    } else if (value.length < 6) {
      return " Password must be  6 Characters";
    } else if (value.length > 15) {
      return " Password is too Long";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3c83f1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(22),
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: username,
                          validator: RequiredValidator(
                              errorText: "Username is required"),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              prefix: SizedBox(
                                width: 5,
                              ),
                              labelText: "Username",
                              hintText: "Enter name",
                              suffixIcon: Icon(Icons.person)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: email,
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "Email is required"),
                              EmailValidator(errorText: "Not a valid Email"),
                            ],
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefix: SizedBox(
                              width: 5,
                            ),
                            labelText: "Email",
                            hintText: "Enter  email",
                            suffixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: password,
                          validator: passvalidation,
                          obscureText: true,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefix: SizedBox(
                              width: 5,
                            ),
                            labelText: "Password",
                            hintText: "Enter  password",
                            suffixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: phone,
                          validator: RequiredValidator(
                              errorText: "Number is required"),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefix: SizedBox(
                              width: 5,
                            ),
                            labelText: "Phone no ",
                            hintText: "Enter phone no ",
                            suffixIcon: Icon(Icons.call),
                          ),
                        ),
                        SizedBox(height: 50),
                        isloading
                            ? CircularProgressIndicator(
                                color: Color(0xFF4167b2),
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    primary: Colors.white,
                                    backgroundColor: Color(0xFF4167b2),
                                  ),
                                  onPressed: () {
                                    signup();
                                  },
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
