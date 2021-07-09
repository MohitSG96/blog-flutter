import 'package:blogs_app/createBlog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user;
  // var _emailController = TextEditingController();
  // var _passwordController = TextEditingController();
  // String email = "";
  // String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TextFormField(
                //   controller: _emailController,
                //   autofillHints: ["email"],
                //   keyboardType: TextInputType.emailAddress,
                //   onChanged: (value) {
                //     email = value.trim();
                //   },
                // ),
                // TextFormField(
                //   controller: _passwordController,
                //   autofillHints: ["password"],
                //   keyboardType: TextInputType.text,
                //   onChanged: (value) {
                //     _password = value;
                //   },
                // ),
                FutureBuilder(
                  future: Firebase.initializeApp(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return TextButton(
                        onPressed: () async {
                          try {
                            var googleUser = await signInWithGoogle();
                            if (googleUser != null) {
                              var firestore = FirebaseFirestore.instance;
                              var user = {
                                "name": googleUser.displayName,
                                "email": googleUser.email,
                                "id": googleUser.uid,
                              };
                              firestore
                                  .collection('users')
                                  .doc(googleUser.uid)
                                  .set(user);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (ctx) => NewBlogScreen(user: user),
                                ),
                              );
                            }
                          } catch (e) {}
                        },
                        child: Text("Login / Signup with google"),
                      );
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }

  Future<User> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // Trigger the authentication flow
    final GoogleSignInAccount googleSignInAccount =
        await GoogleSignIn().signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content: 'The account already exists with a different credential',
            ),
          );
          // handle the error here
          // throw e;
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
          // throw e;
        }
      } catch (e) {
        // handle the error here
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: 'Error occurred using Google Sign In. Try again.',
          ),
        );
        // throw e;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'No Account Selected',
        ),
      );
    }
    return user;
  }

  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
