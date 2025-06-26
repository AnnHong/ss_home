// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ss_home/views/staff/AlertManagement/alertPage.dart';
// import 'package:ss_home/views/staff/familyMemberManagement/familyMemberList.dart';
// import 'package:ss_home/views/staff/seniorManagement/seniorList.dart';
// import 'package:ss_home/util/showDialog.dart';
// import 'package:ss_home/util/callFunction.dart';

// class SSHomeStaffMainPage extends StatefulWidget {
//   final String staffIC;

//   const SSHomeStaffMainPage({super.key, required this.staffIC});

//   @override
//   State<SSHomeStaffMainPage> createState() => _SSHomeStaffMainPageState();
// }

// class _SSHomeStaffMainPageState extends State<SSHomeStaffMainPage> {
//   String staffName = "";
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchStaffData();
//   }

//   // Async method to show the alert dialog and add the alert to Firebase
//   Future<void> showAlertDialog(BuildContext context, String currentUser) async {
//     DateTime now = DateTime.now();

//     // Show the dialog and allow the user to pick an alert type
//     if (mounted) {
//       await showDialog(
//         context: context,
//         builder:
//             (context) => Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       'Select Alert',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     AlertNotificationWidget().alertCard(
//                       context,
//                       'Need Ambulance',
//                       Icons.local_hospital,
//                       Colors.red,
//                       () async {
//                         Navigator.pop(context);
//                         AlertNotificationWidget().showSnackBar(
//                           context,
//                           now,
//                           'Need Ambulance',
//                           currentUser,
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     AlertNotificationWidget().alertCard(
//                       context,
//                       'Need Assistance',
//                       Icons.support_agent,
//                       Colors.blueGrey,
//                       () async {
//                         Navigator.pop(context);
//                         AlertNotificationWidget().showSnackBar(
//                           context,
//                           now,
//                           'Need Assistance',
//                           currentUser,
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     AlertNotificationWidget().alertCard(
//                       context,
//                       'Need Police',
//                       Icons.local_police_sharp,
//                       Colors.blueAccent,
//                       () async {
//                         Navigator.pop(context);
//                         AlertNotificationWidget().showSnackBar(
//                           context,
//                           now,
//                           'Need Police',
//                           currentUser,
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     AlertNotificationWidget().alertCard(
//                       context,
//                       'Fire',
//                       Icons.fireplace,
//                       Colors.orange,
//                       () async {
//                         Navigator.pop(context);
//                         AlertNotificationWidget().showSnackBar(
//                           context,
//                           now,
//                           'Fire',
//                           currentUser,
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 15),
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text("Cancel"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       );
//     }
//   }

//   Future<void> fetchStaffData() async {
//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance
//               .collection('staff')
//               .where('staffIC', isEqualTo: widget.staffIC)
//               .get();

//       if (snapshot.docs.isNotEmpty) {
//         setState(() {
//           staffName = snapshot.docs.first['staffName'];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           staffName = 'Staff';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         staffName = 'Error loading name';
//         isLoading = false;
//       });
//     }
//   }

//   // Modified method to include mounted check
//   Future<void> _showSystemAdminDialog(BuildContext context) async {
//     if (mounted) {
//       await showDialog(
//         context: context,
//         builder:
//             (_) => AlertDialog(
//               title: const Text('System Admin Info'),
//               content: SizedBox(
//                 width: double.maxFinite,
//                 child: SystemAdminList(),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Close'),
//                 ),
//               ],
//             ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose(); // Always call the super.dispose() method
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4C9CD),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color(0xFFEAA4A9),
//         title: const Text("SS Home"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.login),
//             onPressed: () {
//               DialogHelper().showLogoutConfirmationDialogForStaff(context);
//             },
//           ),
//         ],
//       ),
//       body: Expanded(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             Text(
//               isLoading ? "Loading..." : "Welcome, $staffName",
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 100),
//             Expanded(
//               child: Center(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         showAlertDialog(context, staffName);
//                       },
//                       child: const CircleAvatar(
//                         radius: 60,
//                         backgroundColor: Colors.red,
//                         child: Text(
//                           "SOS",
//                           style: TextStyle(
//                             fontSize: 32,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Call Emergency",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 60),
//                     GestureDetector(
//                       onTap: () async {
//                         await _showSystemAdminDialog(context);
//                       },
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundColor: Colors.purple[100],
//                         child: const Icon(
//                           Icons.phone,
//                           size: 40,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Communicate With\nSystem Admin",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: const Color(0xFFF4C9CD),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.monitor_heart_outlined),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SeniorHealthPage()),
//                 );
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.person),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FamilyMemberListPage(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:ss_home/views/staff/AlertManagement/alertPage.dart';
import 'package:ss_home/views/staff/familyMemberManagement/familyMemberList.dart';
import 'package:ss_home/views/staff/seniorManagement/seniorList.dart'; // Assuming this is SeniorListPage
import 'package:ss_home/util/showDialog.dart';
import 'package:ss_home/util/callFunction.dart';
// Assuming SeniorHealthPage is here

class SSHomeStaffMainPage extends StatefulWidget {
  final String staffIC;

  const SSHomeStaffMainPage({super.key, required this.staffIC});

  @override
  State<SSHomeStaffMainPage> createState() => _SSHomeStaffMainPageState();
}

class _SSHomeStaffMainPageState extends State<SSHomeStaffMainPage> {
  String staffName = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStaffData();
  }

  // Async method to show the alert dialog and add the alert to Firebase
  Future<void> showAlertDialog(BuildContext context, String currentUser) async {
    DateTime now = DateTime.now();

    // Show the dialog and allow the user to pick an alert type
    if (mounted) {
      await showDialog(
        context: context,
        builder:
            (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Alert',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AlertNotificationWidget().alertCard(
                      context,
                      'Need Ambulance',
                      Icons.local_hospital,
                      Colors.red,
                      () async {
                        Navigator.pop(context);
                        AlertNotificationWidget().showSnackBar(
                          context,
                          now,
                          'Need Ambulance',
                          currentUser,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    AlertNotificationWidget().alertCard(
                      context,
                      'Need Assistance',
                      Icons.support_agent,
                      Colors.blueGrey,
                      () async {
                        Navigator.pop(context);
                        AlertNotificationWidget().showSnackBar(
                          context,
                          now,
                          'Need Assistance',
                          currentUser,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    AlertNotificationWidget().alertCard(
                      context,
                      'Need Police',
                      Icons.local_police_sharp,
                      Colors.blueAccent,
                      () async {
                        Navigator.pop(context);
                        AlertNotificationWidget().showSnackBar(
                          context,
                          now,
                          'Need Police',
                          currentUser,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    AlertNotificationWidget().alertCard(
                      context,
                      'Fire',
                      Icons.fireplace,
                      Colors.orange,
                      () async {
                        Navigator.pop(context);
                        AlertNotificationWidget().showSnackBar(
                          context,
                          now,
                          'Fire',
                          currentUser,
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    }
  }

  Future<void> fetchStaffData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('staff')
              .where('staffIC', isEqualTo: widget.staffIC)
              .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          staffName = snapshot.docs.first['staffName'];
          isLoading = false;
        });
      } else {
        setState(() {
          staffName = 'Staff';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        staffName = 'Error loading name';
        isLoading = false;
      });
    }
  }

  // Modified method to include mounted check and consistent styling
  Future<void> _showSystemAdminDialog(BuildContext context) async {
    if (mounted) {
      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                'System Admin Info',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child:
                    SystemAdminList(), // Assuming SystemAdminList exists and is styled
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(color: const Color(0xFF555555)),
                  ),
                ),
              ],
            ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose(); // Always call the super.dispose() method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Set scaffold background to white for consistency
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFC97B86), // Consistent AppBar color
        elevation: 4.0,
        centerTitle: true,
        title: Row(
          // Use a Row to combine icon and text
          mainAxisSize: MainAxisSize.min, // Make the row take minimum space
          children: [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 28.0,
            ), // Your home icon
            const SizedBox(width: 20), // Spacing between icon and text
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ), // White icon for logout
            onPressed: () {
              DialogHelper().showLogoutConfirmationDialogForStaff(context);
            },
          ),
        ],
      ),
      body: Container(
        // Wrap body content in a container for margin/padding
        margin: const EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch columns
          children: [
            // Welcome Message
            Text(
              isLoading ? "Loading..." : "Welcome, $staffName",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24, // Larger font
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333), // Darker text color
              ),
            ),
            const SizedBox(height: 50), // Adjusted spacing
            // SOS Button (styled as a prominent card)
            GestureDetector(
              onTap: () async {
                showAlertDialog(context, staffName);
              },
              child: Material(
                elevation: 8.0, // Increased elevation for prominence
                borderRadius: BorderRadius.circular(15), // More rounded corners
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25.0,
                  ), // Increased padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // Gradient for "SOS" button
                      colors: [Colors.red.shade700, Colors.red.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.crisis_alert, // More appropriate emergency icon
                        size: 70, // Larger icon
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "SOS",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50), // Spacing between main action buttons
            // Communicate With System Admin Button (styled as a card)
            GestureDetector(
              onTap: () async {
                await _showSystemAdminDialog(context);
              },
              child: Material(
                elevation: 5.0, // Standard elevation
                borderRadius: BorderRadius.circular(12), // Rounded corners
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ), // Subtle border
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons
                            .contact_support_outlined, // Appropriate support icon
                        size: 60, // Consistent icon size
                        color: const Color(0xFFC97B86), // Accent color
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "CONTACT SYSTEM ADMIN",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: const Color(0xFF555555), // Dark text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(), // Pushes content to top, and bottom nav to bottom
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFC97B86), // Consistent BottomAppBar color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Senior Health Button
            InkWell(
              // Use InkWell for custom tap effect and column layout
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SeniorListPage(),
                  ), // Ensure correct page
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                ), // Reduced vertical padding
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content tightly
                  children: [
                    Icon(
                      Icons.monitor_heart_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 2), // Reduced spacing
                    Text(
                      "Health",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 11,
                      ), // Reduced font size
                    ),
                  ],
                ),
              ),
            ),
            // Family Member List Button
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FamilyMemberListPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                ), // Reduced vertical padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group_outlined,
                      color: Colors.white,
                      size: 28,
                    ), // Changed icon for family members
                    const SizedBox(height: 2), // Reduced spacing
                    Text(
                      "Family",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 11,
                      ), // Reduced font size
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
