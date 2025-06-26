import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:ss_home/controller/systemAdminController.dart';
import 'package:ss_home/models/systemAdmin.dart';

class SystemAdminRegisterScreen extends StatefulWidget {
  const SystemAdminRegisterScreen({super.key});

  @override
  State<SystemAdminRegisterScreen> createState() =>
      _SystemAdminRegisterScreenState();
}

class _SystemAdminRegisterScreenState extends State<SystemAdminRegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _saname = TextEditingController();
  final TextEditingController _saemail = TextEditingController();
  final TextEditingController _saphoneNum = TextEditingController();
  final TextEditingController _sasecpassword = TextEditingController();
  final TextEditingController _sasecconfirmPassword = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient Background
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                    //
                    Text(
                      '\nSIGN UP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Name Textfield
                    TextFormField(
                      controller: _saname,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Colors.black),
                        errorStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          // Rounded corners
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

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
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Phone Number Textfield
                    TextFormField(
                      controller: _saphoneNum,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: const TextStyle(color: Colors.black),
                        errorStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Password Textfield
                    TextFormField(
                      controller: _sasecpassword,
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your security password';
                        }
                        // Ensure the password is exactly 6 digits
                        if (value.length != 6) {
                          return 'Password must be 6 digits';
                        }
                        // Ensure the password contains only numeric digits
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Password must be numeric';
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
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Confirm Password Textfield
                    TextFormField(
                      controller: _sasecconfirmPassword,
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        // if (value!.isEmpty) {
                        //   return 'Please confirm your security password';
                        // }
                        // return null;
                        if (value!.isEmpty) {
                          return 'Please enter your security password';
                        }
                        // Ensure the password is exactly 6 digits
                        if (value.length != 6) {
                          return 'Password must be 6 digits';
                        }
                        // Ensure the password contains only numeric digits
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Password must be numeric';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Confirm Security Password',
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
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Register Button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_sasecpassword.text ==
                              _sasecconfirmPassword.text) {
                            String systemAdminID = randomAlphaNumeric(10);
                            final newSystemAdmin = SystemAdmin(
                              systemAdminID: systemAdminID,
                              systemAdminName: _saname.text,
                              systemAdminEmail: _saemail.text,
                              systemAdminPhoneNum: _saphoneNum.text,
                              systemAdminSecPassword: _sasecpassword.text,
                            );

                            await systemAdminController().addSystemAdmin(
                              newSystemAdmin,
                            );
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return AlertDialog(
                            //       content: Text(
                            //         'Your account has been created successfully',
                            //       ),
                            //       actions: [
                            //         TextButton(
                            //           onPressed:
                            //               () => Navigator.of(
                            //                 context,
                            //               ).pushReplacementNamed(
                            //                 '/SystemAdminlogin',
                            //               ),
                            //           child: const Text('OK'),
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  // Add a background color to the dialog
                                  backgroundColor:
                                      Colors
                                          .white, // Or a light blue, e.g., Colors.lightBlue.shade50
                                  shape: RoundedRectangleBorder(
                                    // Add rounded corners to the dialog
                                    borderRadius: BorderRadius.circular(
                                      20.0,
                                    ), // Adjust radius as needed
                                  ),
                                  title: const Text(
                                    // Added a title
                                    'Success!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blueAccent, // Title color
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  content: const Text(
                                    'Your account has been created successfully',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .black87, // Darker text for readability
                                      fontSize: 16,
                                    ),
                                  ),
                                  actions: [
                                    Center(
                                      // Center the "OK" button
                                      child: TextButton(
                                        onPressed:
                                            () => Navigator.of(
                                              context,
                                              rootNavigator: true,
                                            ).pushReplacementNamed(
                                              '/SystemAdminlogin',
                                            ),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            color:
                                                Colors
                                                    .blueAccent, // Primary color for the button
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  // backgroundColor: Colors.yellow,
                                  title: Center(
                                    child: Text(
                                      'Password does not match',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      },
                      child: const Text('Register'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30.0,
                          ), // Rounded button
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Back to Login Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed('/SystemAdminlogin');
                      },
                      child: const Text('Back to Login'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30.0,
                          ), // Rounded button
                        ),
                        foregroundColor: Colors.black,
                        backgroundColor:
                            Colors
                                .grey, // Optional: style the button differently
                      ),
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

  @override
  void dispose() {
    _saemail.dispose();
    _sasecpassword.dispose();
    _sasecconfirmPassword.dispose();
    _saphoneNum.dispose();
    _saname.dispose();
    super.dispose();
  }
}
