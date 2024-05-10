import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Firebase/firebase_auth_services.dart';
import '../Widgets/text_field.dart';
import '../Widgets/toast.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  final FirebaseAuthService _auth=FirebaseAuthService();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void _signin() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      showToast(message: "Signed in successfully as ${_emailController.text}");
      Navigator.pushNamed(context, "/image");
    } else {
      showToast(message: "Some error happend");
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
    super.dispose();
  }


  Future<User?> _signInWithGoogle() async {
    try {
      await googleSignIn.signOut(); // Sign out the current user (if any)

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          showToast(message: "Logged in  with Google successfully");
          Navigator.pushNamed(context, "/image");
          // Additional logic can be added here, such as saving user data to Firestore
        } else {
          showToast(message: "Failed to sign in with Google");
        }
        return user;
      }
    } catch (error) {
      print("Error signing in with Google: $error");
      showToast(message: "Error signing in with Google");
    }
    return null;
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
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      ),
                      SizedBox(height: 10,),
                      TextFiled(controller: _emailController, hintText: "Email",icon: Icon(Icons.email,)),
                      SizedBox(height: 10,),
                      TextFiled(controller: _passwordController, hintText: "Password",isPassword: true,icon:Icon(Icons.key),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context,"/forgetPassword");
                            },
                            child: Text("Forgot Password?  ",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline ,
                              decorationColor: Colors.white,
                            ),),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: (){
                        if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
                          _signin();
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
                          child:Text("Login "),
                      ),
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height: 2,width:90,color: Colors.indigo,),
                          Text("Or continue with",
                            style: TextStyle(
                                fontSize: 15
                            ),),
                          Container(height: 2,width:90,color: Colors.indigo,),
                        ],
                      ),
                      SizedBox(height:10),
                      InkWell(
                        onTap: _signInWithGoogle,
                        child: Container(
                          height: 40,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width:15),
                              Image.asset("assets/images/img_1.png",
                                width: 25,
                                height: 25,),
                              Text("   Sign In with Google",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),)
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have account ?"),
                          TextButton(onPressed:(){
                            Navigator.pushNamed(context, "/Signup");
                          },
                              child:Text("  Create Account"))
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

