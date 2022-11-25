// Also called login Page //

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'MyApp.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// import 'package:sign_button/sign_button.dart'
//import 'package:firebase_core_web/firebase_core_web_interop.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

Future <void> main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(login());
}

class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  //Initialize FirebaseApp
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return loginscreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class loginscreen extends StatefulWidget {
  const loginscreen({Key? key}) : super(key: key);

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  //login fucnction
  static Future<User?> loginUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No users found");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: const Text(
              "Todo list",
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: const Text(
              "Login to your app",
              style: TextStyle(letterSpacing: 2, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: "Username",
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.black,
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text("Forget password"),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              elevation: 10,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () async {
                User? user = await loginUsingEmailPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context,
                );
                print(user);
                if (user != null) {
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => profile()));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                }
              },
              fillColor: Colors.deepOrange,
              child: const Text(
                "Login",
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(child: Text("------------  or  ------------", style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic), )),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Center(
              child: SignInButton(
                Buttons.GoogleDark,
                onPressed: () async{
                  await GoogleSignIn().signIn();
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  String username = googleUser!.email;
  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
  // try {
  //   final UserCredential userCredential =
  //   await auth.signInWithCredential(credential);
  //
  //   user = userCredential.user;
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'account-exists-with-different-credential') {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       Authentication.customSnackBar(
  //         content:
  //         'The account already exists with a different credential.',
  //       ),
  //     );
  //   } else if (e.code == 'invalid-credential') {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       Authentication.customSnackBar(
  //         content:
  //         'Error occurred while accessing credentials. Try again.',
  //       ),
  //     );
  //   }
  // } catch (e) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     Authentication.customSnackBar(
  //       content: 'Error occurred using Google Sign-In. Try again.',
  //     ),
  //   );
  // }
}


// class Profile extends StatefulWidget {
//   const Profile({Key? key}) : super(key: key);
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: const Text(
//         "wow",
//         style: TextStyle(fontSize: 50),
//       ),
//     );
//   }
// }


