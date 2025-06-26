// import 'package:flutter/material.dart';
// import 'package:ss_home/controller/familyMemberController.dart';
// import 'package:ss_home/models/familyMember.dart';
// import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

// class EditFamilyMemberPage extends StatefulWidget {
//   final FamilyMemberModel member;

//   const EditFamilyMemberPage({super.key, required this.member});

//   @override
//   State<EditFamilyMemberPage> createState() => _EditFamilyPageState();
// }

// class _EditFamilyPageState extends State<EditFamilyMemberPage> {
//   late TextEditingController familyName;
//   late TextEditingController familyPhone;
//   late TextEditingController familyAddr;
//   late TextEditingController seniorName;
//   late TextEditingController familyPostCode;
//   late TextEditingController familyCity;
//   late TextEditingController familyState;

//   @override
//   void initState() {
//     super.initState();
//     familyName = TextEditingController(text: widget.member.familyMemName);
//     familyPhone = TextEditingController(
//       text: widget.member.familyMemPhoneNumber,
//     );
//     familyAddr = TextEditingController(text: widget.member.familyMemAddr);
//     familyPostCode = TextEditingController(
//       text: widget.member.familyMemPostCode,
//     );
//     familyCity = TextEditingController(text: widget.member.familyMemCity);
//     familyState = TextEditingController(text: widget.member.familyMemState);
//     seniorName = TextEditingController(text: widget.member.seniorName);
//   }

//   @override
//   void dispose() {
//     // Dispose of the controllers when the widget is removed from the widget tree
//     familyName.dispose();
//     familyPhone.dispose();
//     familyAddr.dispose();
//     familyPostCode.dispose();
//     familyCity.dispose();
//     familyState.dispose();
//     seniorName.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "SS HOME",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 22.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: const Color(0xFFC97B86),
//         elevation: 4.0,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0), // Increased padding
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "EDIT FAMILY MEMBER INFO",
//               style: GoogleFonts.poppins(
//                 color: const Color(0xFF333333), // Darker text color
//                 fontSize: 24.0, // Larger font size
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 30.0), // Increased spacing
//             // Name Field
//             _buildLabel("Family Member Name"),
//             _buildTextField(controller: familyName, hint: "Enter full name"),
//             const SizedBox(height: 20.0),

//             // Phone Field
//             _buildLabel("Family Member Phone Number"),
//             _buildTextField(
//               controller: familyPhone,
//               hint: "e.g., +60123456789", // More descriptive hint
//               keyboardType: TextInputType.phone, // Changed to phone type
//             ),
//             const SizedBox(height: 20.0),

//             // Address Field
//             _buildLabel("Family Member Address"),
//             _buildTextField(controller: familyAddr, hint: "Street address"),
//             const SizedBox(height: 20.0),

//             // Post Code Field
//             _buildLabel("Family Member Post Code"),
//             _buildTextField(
//               controller: familyPostCode,
//               hint: "e.g., 81300",
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20.0),

//             // City Field
//             _buildLabel("Family Member City"),
//             _buildTextField(controller: familyCity, hint: "City name"),
//             const SizedBox(height: 20.0),

//             // State Field
//             _buildLabel("Family Member State"),
//             _buildTextField(controller: familyState, hint: "State name"),
//             const SizedBox(height: 20.0),

//             // Senior Name Field
//             _buildLabel("Senior Name under family member"),
//             _buildTextField(controller: seniorName, hint: "Name of the senior"),
//             const SizedBox(height: 40.0), // Increased spacing

//             Center(
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (familyName.text.isNotEmpty &&
//                           familyPhone.text.isNotEmpty &&
//                           familyAddr.text.isNotEmpty &&
//                           seniorName.text.isNotEmpty &&
//                           familyCity.text.isNotEmpty &&
//                           familyPostCode.text.isNotEmpty &&
//                           familyState.text.isNotEmpty) {
//                         try {
//                           final updatedMember = FamilyMemberModel(
//                             familyMemId: widget.member.familyMemId,
//                             familyMemName: familyName.text,
//                             familyMemPhoneNumber: familyPhone.text,
//                             familyMemAddr: familyAddr.text,
//                             familyMemPostCode: familyPostCode.text,
//                             familyMemCity: familyCity.text,
//                             familyMemState: familyState.text,
//                             seniorName: seniorName.text,
//                           );

//                           await familyMemberController()
//                               .updateFamilyMember(updatedMember)
//                               .then((value) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     backgroundColor: Colors.green,
//                                     content: Text(
//                                       "Family Member updated successfully!",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                     duration: Duration(seconds: 2),
//                                   ),
//                                 );
//                                 Navigator.pop(context);
//                               });
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               backgroundColor: Colors.red,
//                               content: Text(
//                                 "Error: Failed to update family member. $e",
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                               duration: const Duration(seconds: 3),
//                             ),
//                           );
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             backgroundColor: Colors.orange,
//                             content: Text(
//                               "Please fill in all the fields before updating.",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             duration: Duration(seconds: 3),
//                           ),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFC97B86),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 50,
//                         vertical: 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       elevation: 8.0,
//                       minimumSize: const Size(250, 50),
//                     ),
//                     child: Text(
//                       "Update Family Member",
//                       style: GoogleFonts.poppins(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15.0),
//                   OutlinedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: const Color(0xFFC97B86),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 50,
//                         vertical: 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       side: const BorderSide(
//                         color: Color(0xFFC97B86),
//                         width: 2,
//                       ),
//                       minimumSize: const Size(250, 50),
//                     ),
//                     child: Text(
//                       "Cancel",
//                       style: GoogleFonts.poppins(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 50.0),
//           ],
//         ),
//       ),
//     );
//   }

//   // Refactored _buildLabel with GoogleFonts and improved styling
//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         text,
//         style: GoogleFonts.poppins(
//           color: const Color(0xFF555555),
//           fontSize: 14.0,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   // Refactored _buildTextField with GoogleFonts and improved styling
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     TextInputType keyboardType = TextInputType.text, // Default to text
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3), // Adds a soft shadow
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.black87),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 20.0,
//             vertical: 15.0,
//           ),
//           border: InputBorder.none, // Remove default border
//           filled: true,
//           fillColor: Colors.white,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(
//               color: Color(0xFFC97B86),
//               width: 2,
//             ), // Highlight on focus
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:ss_home/controller/familyMemberController.dart';
import 'package:ss_home/models/familyMember.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class EditFamilyMemberPage extends StatefulWidget {
  final FamilyMemberModel member;

  const EditFamilyMemberPage({super.key, required this.member});

  @override
  State<EditFamilyMemberPage> createState() => _EditFamilyPageState();
}

class _EditFamilyPageState extends State<EditFamilyMemberPage> {
  // TextEditingControllers for the form fields
  late TextEditingController familyName;
  late TextEditingController familyPhone;
  late TextEditingController familyAddr;
  late TextEditingController seniorName;
  late TextEditingController familyPostCode;
  late TextEditingController familyCity;
  late TextEditingController familyState;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing member data
    familyName = TextEditingController(text: widget.member.familyMemName);
    familyPhone = TextEditingController(
      text: widget.member.familyMemPhoneNumber,
    );
    familyAddr = TextEditingController(text: widget.member.familyMemAddr);
    familyPostCode = TextEditingController(
      text: widget.member.familyMemPostCode,
    );
    familyCity = TextEditingController(text: widget.member.familyMemCity);
    familyState = TextEditingController(text: widget.member.familyMemState);
    seniorName = TextEditingController(text: widget.member.seniorName);
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    familyName.dispose();
    familyPhone.dispose();
    familyAddr.dispose();
    familyPostCode.dispose();
    familyCity.dispose();
    familyState.dispose();
    seniorName.dispose();
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
        backgroundColor: const Color(0xFFC97B86), // Consistent background color
        elevation: 4.0, // Added elevation
        centerTitle: true, // Centered title
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), // Consistent padding
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to start
          children: [
            Text(
              "EDIT FAMILY MEMBER INFO",
              style: GoogleFonts.poppins(
                color: const Color(0xFF333333), // Darker text color
                fontSize: 24.0, // Larger font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0), // Increased spacing
            // Name Field
            _buildLabel("Family Member Name"),
            _buildTextField(controller: familyName, hint: "Enter full name"),
            const SizedBox(height: 20.0), // Consistent spacing
            // Phone Field
            _buildLabel("Family Member Phone Number"),
            _buildTextField(
              controller: familyPhone,
              hint: "e.g., +60123456789", // More descriptive hint
              keyboardType: TextInputType.phone, // Changed to phone type
            ),
            const SizedBox(height: 20.0),

            // Address Field
            _buildLabel("Family Member Address"),
            _buildTextField(controller: familyAddr, hint: "Street address"),
            const SizedBox(height: 20.0),

            // Post Code Field
            _buildLabel("Family Member Post Code"),
            _buildTextField(
              controller: familyPostCode,
              hint: "e.g., 81300",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),

            // City Field
            _buildLabel("Family Member City"),
            _buildTextField(controller: familyCity, hint: "City name"),
            const SizedBox(height: 20.0),

            // State Field
            _buildLabel("Family Member State"),
            _buildTextField(controller: familyState, hint: "State name"),
            const SizedBox(height: 20.0),

            // Senior Name Field
            _buildLabel("Senior Name under family member"),
            _buildTextField(controller: seniorName, hint: "Name of the senior"),
            const SizedBox(height: 40.0), // Increased spacing before buttons

            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Validate if all fields are not empty
                      if (familyName.text.isNotEmpty &&
                          familyPhone.text.isNotEmpty &&
                          familyAddr.text.isNotEmpty &&
                          seniorName.text.isNotEmpty &&
                          familyCity.text.isNotEmpty &&
                          familyPostCode.text.isNotEmpty &&
                          familyState.text.isNotEmpty) {
                        try {
                          // Create an updated FamilyMemberModel
                          final updatedMember = FamilyMemberModel(
                            familyMemId: widget.member.familyMemId,
                            familyMemName: familyName.text,
                            familyMemPhoneNumber: familyPhone.text,
                            familyMemAddr: familyAddr.text,
                            familyMemPostCode: familyPostCode.text,
                            familyMemCity: familyCity.text,
                            familyMemState:
                                familyState
                                    .text, // Corrected to use familyState.text
                            seniorName: seniorName.text,
                          );

                          // Call the update method
                          await familyMemberController().updateFamilyMember(
                            updatedMember,
                          );

                          // Check if the widget is still mounted before showing SnackBar or popping
                          if (!mounted) return;

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Family Member updated successfully!",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(
                            context,
                          ); // Go back after successful update
                        } catch (e) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                "Error: Failed to update family member. $e",
                                style: const TextStyle(color: Colors.white),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      } else {
                        // Show warning if any field is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.orange,
                            content: Text(
                              "Please fill in all the fields before updating.",
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFC97B86,
                      ), // Consistent button color
                      foregroundColor: Colors.white, // Consistent text color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Rounded corners
                      ),
                      elevation: 8.0, // Added elevation
                      minimumSize: const Size(250, 50), // Consistent size
                    ),
                    child: Text(
                      "Update Family Member",
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0), // Spacing between buttons
                  OutlinedButton(
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
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Rounded corners
                      ),
                      side: const BorderSide(
                        color: Color(0xFFC97B86),
                        width: 2,
                      ), // Border color
                      minimumSize: const Size(
                        250,
                        50,
                      ), // Match width of update button
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
            const SizedBox(height: 50.0), // Spacing at the bottom
          ],
        ),
      ),
    );
  }

  // Helper widget to build labels
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

  // Helper widget to build text fields with consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType =
        TextInputType.text, // Default to text input type
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
            offset: const Offset(0, 3), // Adds a soft shadow
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
          border: InputBorder.none, // Remove default border
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFC97B86),
              width: 2,
            ), // Highlight on focus
          ),
        ),
      ),
    );
  }
}
