import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Firebase/firebase_auth_services.dart';
import '../Widgets/text_field.dart';
import '../Widgets/toast.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _userController=TextEditingController();
  final FirebaseAuthService _auth=FirebaseAuthService();

  void _signUp() async {
    String username = _userController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      showToast(message: "Account created successfully");
      Navigator.pushNamed(context, "/login");
    } else {
      showToast(message: "User already exists!!!!");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Image Viewer",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
          ),
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_image1.jpg'), // Path to your background image asset
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                width: 320,
                height: 400,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("SignUp",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFiled(controller: _userController, hintText: "Username",icon: Icon(Icons.account_circle),),
                    SizedBox(height: 10,),
                    TextFiled(controller: _emailController, hintText: "Email",icon:Icon(Icons.email)),
                    SizedBox(height: 10,),
                    TextFiled(controller: _passwordController, hintText: "Password",isPassword: true,icon: Icon(Icons.key),),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: (){
                      if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
                      _signUp();
                      }else if (_emailController.text.isEmpty && _passwordController.text.isEmpty){
                        Fluttertoast.showToast(
                            msg: "Pleas enter Email and Password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else if (_emailController.text.isEmpty){
                        Fluttertoast.showToast(
                            msg: "Pleas enter Email",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else{
                        Fluttertoast.showToast(
                            msg: "Pleas enter Password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }

                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        elevation: 10,
                        minimumSize: Size(300, 50),
                      ),
                      child:Text("SignUp"),
                    ),
                    SizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have account !!!!"),
                        TextButton(onPressed:(){
                          Navigator.pushNamed(context, "/login");
                        },
                            child:Text(
                                "SignIn here"
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

