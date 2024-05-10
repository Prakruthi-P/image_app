import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/Firebase/firebase_auth_services.dart';

import '../Widgets/text_field.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _email=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Text("Image Viewer",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
          ),
          body: Container(
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
                width: 300,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Please enter your email , will send you the reset password link:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFiled(controller: _email, hintText: "Email",icon: Icon(Icons.email,)),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: (){
                          _forgorPassword();
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        elevation: 10,
                        minimumSize: Size(300, 50),
                      ),
                      child:Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future _forgorPassword() async{
    try{
      List<String> signInMethods = [];
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(_email.text.trim())
        .then((value) => signInMethods = value);
      if (signInMethods.isEmpty) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("The user with this email doesn't exist. Please check your email address."),
              );
            }
        );
      } else {
        // User exists, send the password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text.trim());
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Reset password link has been sent to the above email. Please check!!!"),
              );
            }
        );
      }
    }on FirebaseAuthException catch (e){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          }
      );
    }
  }
}
