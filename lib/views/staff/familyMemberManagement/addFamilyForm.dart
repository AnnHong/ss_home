import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:ss_home/controller/familyMemberController.dart';
import 'package:ss_home/models/familyMember.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFamilyMemberPage extends StatefulWidget {
  const AddFamilyMemberPage({super.key});

  @override
  State<AddFamilyMemberPage> createState() => _AddFamilyPageState();
}

class _AddFamilyPageState extends State<AddFamilyMemberPage> {
  final familyName = TextEditingController();
  final familyPhone = TextEditingController();
  final familyAddr = TextEditingController();
  final seniorName = TextEditingController();
  final familyPostcode = TextEditingController();
  final familyCity = TextEditingController();
  final familyState = TextEditingController();

  @override
  void dispose() {
    familyName.dispose();
    familyPhone.dispose();
    familyAddr.dispose();
    seniorName.dispose();
    familyPostcode.dispose();
    familyCity.dispose();
    familyState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SS HOME",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFC97B86),
        elevation: 4.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "FAMILY MEMBER INFO",
              style: GoogleFonts.poppins(
                color: const Color(0xFF333333),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),

            _buildLabel("Family Member Name"),
            _buildTextField(controller: familyName, hint: "Enter full name"),
            const SizedBox(height: 20.0),

            _buildLabel("Family Member Phone Number"),
            _buildTextField(
              controller: familyPhone,
              hint: "e.g., +60123456789",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20.0),

            _buildLabel("Family Member Address"),
            _buildTextField(controller: familyAddr, hint: "Street address"),
            const SizedBox(height: 20.0),

            _buildLabel("Family Member Post Code"),
            _buildTextField(
              controller: familyPostcode,
              hint: "e.g., 81300",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),

            _buildLabel("Family Member City"),
            _buildTextField(controller: familyCity, hint: "City name"),
            const SizedBox(height: 20.0),

            _buildLabel("Family Member State"),
            _buildTextField(controller: familyState, hint: "State name"),
            const SizedBox(height: 20.0),

            _buildLabel("Senior Name under family member"),
            _buildTextField(controller: seniorName, hint: "Name of the senior"),
            const SizedBox(height: 40.0),

            Center(
              child: Column(
                // Use a Column to stack the buttons
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (familyName.text.isNotEmpty &&
                          familyPhone.text.isNotEmpty &&
                          familyAddr.text.isNotEmpty &&
                          seniorName.text.isNotEmpty &&
                          familyCity.text.isNotEmpty &&
                          familyPostcode.text.isNotEmpty &&
                          familyState.text.isNotEmpty) {
                        try {
                          String familyID = randomAlphaNumeric(10);
                          final newFamilyMember = FamilyMemberModel(
                            familyMemId: familyID,
                            seniorName: seniorName.text,
                            familyMemName: familyName.text,
                            familyMemPhoneNumber: familyPhone.text,
                            familyMemAddr: familyAddr.text,
                            familyMemPostCode: familyPostcode.text,
                            familyMemCity: familyCity.text,
                            familyMemState: familyState.text,
                          );

                          await familyMemberController().addFamilyMember(
                            newFamilyMember,
                          );

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Family Member has been added successfully!",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                "Error: Failed to add family member. $e",
                                style: const TextStyle(color: Colors.white),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.orange,
                            content: Text(
                              "Please fill in all the fields before adding.",
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC97B86),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8.0,
                      minimumSize: const Size(
                        250,
                        50,
                      ), // Ensure consistent width
                    ),
                    child: Text(
                      "Add Family Member",
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0), // Space between buttons
                  OutlinedButton(
                    // Use OutlinedButton for a secondary action
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(
                        0xFFC97B86,
                      ), // Text color same as primary button
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: const BorderSide(
                        color: Color(0xFFC97B86),
                        width: 2,
                      ), // Border color
                      minimumSize: const Size(
                        250,
                        50,
                      ), // Match width of add button
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: const Color(0xFF555555),
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFC97B86), width: 2),
          ),
        ),
      ),
    );
  }
}
