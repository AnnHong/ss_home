import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ss_home/views/systemAdmin/systemAdminHomePage.dart';

class SystemAdminLoginScreen extends StatefulWidget {
  const SystemAdminLoginScreen({super.key});

  @override
  _SystemAdminLoginScreenState createState() => _SystemAdminLoginScreenState();
}

class _SystemAdminLoginScreenState extends State<SystemAdminLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _saemail = TextEditingController();
  final TextEditingController _sapassword = TextEditingController();
  bool _passwordVisible = false;
  bool isSystemAdmin = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.9],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // App name and description
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'SS HOME',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '\nHome Monitoring System',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 80),

                // Email Textfield
                TextFormField(
                  controller: _saemail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.black),
                    errorStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.mail, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ), // Rounded corners
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Password Textfield
                TextFormField(
                  controller: _sapassword,
                  obscureText: !_passwordVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Security Password',
                    hintStyle: const TextStyle(color: Colors.black),
                    errorStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ), // Rounded corners
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // "Register Here" Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed:
                          () => Navigator.pushNamed(
                            context,
                            '/SystemAdminregister',
                          ),
                      child: const Text(
                        'Register Here',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Login Button with improved style
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String email = _saemail.text.trim();
                      String secpassword = _sapassword.text.trim();

                      try {
                        // Check if there's a system admin with matching email and password
                        QuerySnapshot snapshot =
                            await FirebaseFirestore.instance
                                .collection('systemAdmin')
                                .where('systemAdminEmail', isEqualTo: email)
                                .where(
                                  'systemAdminSecPassword',
                                  isEqualTo: secpassword,
                                )
                                .get();

                        if (snapshot.docs.isNotEmpty) {
                          // Save login state in SharedPreferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('isSystemAdminLoggedIn', true);

                          Navigator.of(
                            context,
                          ).pushNamed('/SystemAdminHomePage');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wrong email or password'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ), // Rounded button
                    ),
                    // primary: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 30),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isSystemAdmin = !isSystemAdmin;
                      if (isSystemAdmin) {
                        Navigator.pushNamed(context, '/Stafflogin');
                      } else {
                        Navigator.pushNamed(context, '/SystemAdminlogin');
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ), // Changed icon color to black for better visibility on a potentially lighter button background, or keep white if you style the button background.
                  label: Text(
                    isSystemAdmin
                        ? 'System Admin Login'
                        : 'Staff Login', // More descriptive label
                    style: TextStyle(
                      color: Colors.black,
                    ), // Changed text color to black
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color(0xFFDF7284),
                        width: 3,
                      ), // Optional: Add a border for definition
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     setState(() {
      //       isSystemAdmin = isSystemAdmin;
      //       if (isSystemAdmin) {
      //         Navigator.pushNamed(context, '/SystemAdminlogin');
      //       } else {
      //         Navigator.pushNamed(context, '/Stafflogin');
      //       }
      //     });
      //   },
      //   icon: const Icon(Icons.person),
      //   label: Text(isSystemAdmin ? 'SystemAdmin' : 'Staff'),
      //   backgroundColor: Colors.blue.shade400,
      // ),
    );
  }
}
