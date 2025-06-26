import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ss_home/controller/familyMemberController.dart';
import 'package:ss_home/models/familyMember.dart';
import 'package:ss_home/views/staff/familyMemberManagement/addFamilyForm.dart';
import 'package:ss_home/views/staff/familyMemberManagement/editFamilyForm.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class FamilyMemberListPage extends StatefulWidget {
  const FamilyMemberListPage({super.key});

  @override
  State<FamilyMemberListPage> createState() => _FamilyMemberListPageState();
}

class _FamilyMemberListPageState extends State<FamilyMemberListPage> {
  // Helper widget for displaying key-value pairs in a row
  Widget _buildRowText(String label, {IconData? icon}) {
    // Added optional icon parameter
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start, // Align to top for potentially multiline values
        children: [
          if (icon != null) // Conditionally display icon
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                icon,
                size: 18.0,
                color: const Color(0xFF555555),
              ), // Icon styling
            ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
              color: const Color(0xFF555555), // Darker label color
            ),
          ),
        ],
      ),
    );
  }

  // familyMember.seniorName
  Widget _buildInfoRow(String info) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
        left: 23.0,
      ), // Indent value to align under icon
      child: Text(
        info,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color: const Color(0xFFC97B86),
          // Changed normal color to green.shade700
        ),
        maxLines: 2, // Allow value to wrap
        overflow: TextOverflow.ellipsis, // Add ellipsis if it overflows
      ),
    );
  }

  // Helper widget specifically for address, allowing for smaller font and wrapped text
  Widget _buildAddressRow(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 23.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
                color: const Color(0xFFC97B86),
              ),
              maxLines: 4, // Allow address to wrap up to 3 lines
              overflow: TextOverflow.ellipsis, // Add ellipsis if it overflows
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display the list of family members from Firestore
  Widget _showFamilyMemList() {
    return StreamBuilder<List<FamilyMemberModel>>(
      stream: familyMemberController().getFamilyMembers(),
      builder: (context, snapshots) {
        // Show loading indicator while fetching data
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFC97B86)),
          ); // Styled loading indicator
        }

        // Show a message if no data is available
        if (!snapshots.hasData || snapshots.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  color: Colors.grey.shade400,
                  size: 60,
                ), // Changed icon
                const SizedBox(height: 15),
                Text(
                  "No family members found. Add one now!", // More engaging message
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          );
        }

        final familyList = snapshots.data!;

        // Display the list of family members
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: familyList.length,
          itemBuilder: (BuildContext context, int index) {
            FamilyMemberModel familyMember = familyList[index];

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ), // Spacing between cards
              child: Material(
                elevation: 5.0, // Card shadow
                borderRadius: BorderRadius.circular(
                  12,
                ), // Rounded corners for card
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0, // Increased vertical padding
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ), // Subtle border
                  ),
                  child: Column(
                    // Changed from Row to Column to stack details and buttons
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Family Member Details
                      _buildRowText(
                        "Senior Name: ",
                        // familyMember.seniorName,
                        icon: Icons.elderly_outlined,
                      ),
                      _buildInfoRow(familyMember.seniorName),
                      const SizedBox(height: 5.0),
                      _buildRowText(
                        "Family Member: ",
                        // familyMember.familyMemName,
                        icon: Icons.family_restroom_rounded,
                      ),
                      _buildInfoRow(familyMember.familyMemName),
                      const SizedBox(height: 5.0),
                      _buildRowText(
                        "Phone Number: ",
                        // familyMember.familyMemPhoneNumber.toString(),
                        icon: Icons.phone_android_outlined,
                      ),
                      _buildInfoRow(familyMember.familyMemPhoneNumber),
                      const SizedBox(height: 5.0),
                      _buildRowText(
                        "Address: ",
                        // familyMember.seniorName,
                        icon: Icons.home,
                      ),
                      _buildAddressRow(
                        // "Address: ",
                        "${familyMember.familyMemAddr}, ${familyMember.familyMemPostCode}, ${familyMember.familyMemCity}, ${familyMember.familyMemState}",
                      ), // Combined address

                      const SizedBox(
                        height: 10,
                      ), // Space between details and buttons
                      // Edit & Delete Buttons (now centered at the bottom of the card)
                      Center(
                        // Changed Align to Center to horizontally center the row of buttons
                        child: Row(
                          mainAxisSize:
                              MainAxisSize
                                  .min, // Take minimum space for the row
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit_note,
                                color: const Color(0xFFC97B86),
                                size: 28,
                              ), // Styled icon
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => EditFamilyMemberPage(
                                          member: familyMember,
                                        ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.red.shade700,
                                size: 28,
                              ), // Styled icon
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        backgroundColor:
                                            Colors.white, // Dialog background
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ), // Rounded dialog
                                        title: Text(
                                          "Confirm Delete",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        content: Text(
                                          "Are you sure you want to delete ${familyMember.familyMemName}?",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xFF555555),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                            child: Text(
                                              "Delete",
                                              style: GoogleFonts.poppins(
                                                color: Colors.red.shade700,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                // Proceed only if user confirms
                                if (confirm == true) {
                                  await FirebaseFirestore.instance
                                      .collection('familyMember')
                                      .doc(familyMember.familyMemId)
                                      .delete();

                                  /// 🔒 SAFELY check if the context is still mounted
                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "Deleted ${familyMember.familyMemName}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                      duration: const Duration(
                                        seconds: 2,
                                      ), // Consistent duration
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // Use a Row to combine icon and text
          mainAxisSize: MainAxisSize.min, // Make the row take minimum space
          children: [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 28.0,
            ), // Your icon
            const SizedBox(width: 8), // Spacing between icon and text
            Text(
              "SS HOME",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFC97B86), // Consistent AppBar color
        elevation: 4.0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC97B86), // Consistent FAB color
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFamilyMemberPage(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ), // White icon for better contrast
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align to start for page title
              children: [
                Text(
                  "FAMILY MEMBER ", // Split text for distinct styling
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF333333), // Darker text color
                    fontSize: 24.0, // Larger font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "LIST", // Second part of the title
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFC97B86), // Consistent accent color
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            Expanded(
              child: _showFamilyMemList(),
            ), // Use the _showFamilyMemList widget
          ],
        ),
      ),
    );
  }
}
