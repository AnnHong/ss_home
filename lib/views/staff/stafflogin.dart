import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ss_home/views/staff/staffMainPage.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure this import is present

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  _StaffLoginScreenState createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _sIC = TextEditingController();
  final TextEditingController _spassword = TextEditingController();
  bool _passwordVisible = false;
  bool isSystemAdmin = false; // This state controls the login type

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4C9CD), // Soft peach background
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Increased padding
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'SS HOME',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 32, // Larger font size for main title
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '\nHome Monitoring System',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18, // Slightly larger subtitle
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 100), // More space after the title
              // IC Textfield
              TextFormField(
                controller: _sIC,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your IC';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'IC',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                  ), // Softer hint text
                  errorStyle: GoogleFonts.poppins(
                    color: Colors.redAccent,
                  ), // Clearer error text
                  prefixIcon: const Icon(
                    Icons.card_membership,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ), // Adjusted padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ), // Rounded corners
                    borderSide: BorderSide.none, // No border line
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFDF7284),
                      width: 2,
                    ), // Highlight focused border
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacing between input fields
              // Password textfield
              TextFormField(
                controller: _spassword,
                obscureText: !_passwordVisible,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                  ), // Softer hint text
                  errorStyle: GoogleFonts.poppins(
                    color: Colors.redAccent,
                  ), // Clearer error text
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
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ), // Adjusted padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ), // Rounded corners
                    borderSide: BorderSide.none, // No border line
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFDF7284),
                      width: 2,
                    ), // Highlight focused border
                  ),
                ),
              ),

              const SizedBox(height: 40), // More space before the login button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String ic = (_sIC.text.trim());
                    String password = _spassword.text.trim();

                    try {
                      QuerySnapshot staffSnapshot =
                          await FirebaseFirestore.instance
                              .collection('staff')
                              .where('staffIC', isEqualTo: ic)
                              .where('staffPassword', isEqualTo: password)
                              .get();

                      if (staffSnapshot.docs.isNotEmpty) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('staffIC', ic);
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed("/staffHomePage", arguments: ic);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Wrong IC / password',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error: $e',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDF7284), // Rose color
                  foregroundColor: Colors.white, // White text color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      30.0,
                    ), // More rounded button
                  ),
                  elevation: 5, // Add a subtle shadow
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30), // Spacing before the new button

              TextButton.icon(
                onPressed: () {
                  setState(() {
                    isSystemAdmin = !isSystemAdmin;
                    if (isSystemAdmin) {
                      Navigator.pushNamed(context, '/SystemAdminlogin');
                    } else {
                      Navigator.pushNamed(context, '/Stafflogin');
                    }
                  });
                },
                icon: const Icon(Icons.support_agent, color: Colors.black),
                label: Text(
                  isSystemAdmin ? 'Staff Login' : 'System Admin Login',
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 3,
                    ), // Optional: Add a border for definition
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Removed floatingActionButton and floatingActionButtonLocation
      // floatingActionButton: FloatingActionButton.extended(...)
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
