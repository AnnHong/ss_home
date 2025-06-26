import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:ss_home/controller/seniorController.dart';
import 'package:ss_home/models/senior.dart';
import 'package:ss_home/views/staff/seniorManagement/addSeniorForm.dart';
import 'package:ss_home/views/staff/seniorManagement/editSeniorForm.dart';

class SeniorListPage extends StatefulWidget {
  const SeniorListPage({super.key});

  @override
  State<SeniorListPage> createState() => _SeniorListPageState();
}

class _SeniorListPageState extends State<SeniorListPage> {
  // Helper widget for displaying a label with an optional icon (like "Senior Name:")
  Widget _buildInfoLabel(String label, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 2,
      ), // Smaller padding for label part
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Vertically center icon and text
        children: [
          if (icon != null) // Conditionally display icon if provided
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
              fontSize: 14.0, // Slightly smaller font for label
              color: const Color(0xFF555555), // Darker label color
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for displaying the actual value, indented below the label
  // Now includes a parameter to conditionally change text color
  Widget _buildInfoValue(String value, {bool isNormal = true}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
        left: 23.0,
      ), // Indent value to align under icon
      child: Text(
        value,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color:
              isNormal
                  ? Colors.green.shade700
                  : Colors
                      .red
                      .shade700, // Changed normal color to green.shade700
        ),
        maxLines: 2, // Allow value to wrap
        overflow: TextOverflow.ellipsis, // Add ellipsis if it overflows
      ),
    );
  }

  // Function to check if temperature is within normal range
  bool _isTemperatureNormal(double temp) {
    return temp >= 36.1 &&
        temp <= 37.2; // Normal body temperature range in Celsius
  }

  // Function to check if blood pressure is within normal range
  bool _isBloodPressureNormal(int sys, int dia) {
    // Normal: SYS < 120 AND DIA < 80
    // Hypotension: SYS < 90 OR DIA < 60
    // Hypertension: SYS >= 140 OR DIA >= 90
    // Pre-hypertension (borderline): SYS 120-139 OR DIA 80-89
    // For simplicity, defining abnormal as outside optimal or dangerously high/low
    return (sys >= 90 && sys < 140) && (dia >= 60 && dia < 90);
  }

  // Function to check if heart rate is within normal range
  bool _isHeartRateNormal(int hr) {
    return hr >= 60 && hr <= 100; // Normal resting heart rate for adults
  }

  // Widget to display the list of senior health records from Firestore
  Widget _showSeniorList() {
    return StreamBuilder<List<SeniorModel>>(
      stream:
          SeniorController()
              .getSenior(), // Ensure this fetches all seniors, not just one.
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
                  Icons.monitor_heart_outlined,
                  color: Colors.grey.shade400,
                  size: 60,
                ), // Icon for no health data
                const SizedBox(height: 15),
                Text(
                  "No senior health records found. Add one now!", // Engaging message
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          );
        }

        final seniorList = snapshots.data!;
        // print("🔍 Senior List Fetched: ${seniorList.length} items"); // Debug print, consider removing in production

        // Display the list of senior health records
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: seniorList.length,
          itemBuilder: (BuildContext context, int index) {
            final senior = seniorList[index];

            // Determine if health metrics are normal for conditional coloring
            final bool isTempNormal = _isTemperatureNormal(senior.seniorTemp);
            final bool isBPNormal = _isBloodPressureNormal(
              senior.seniorBloodPressure_SYS,
              senior.seniorBloodPressure_DIA,
            );
            final bool isHRNormal = _isHeartRateNormal(senior.seniorHeartRate);
            final bool isSpO2Normal =
                senior.seniorSpO2 >= 95; // SpO2 is generally normal >= 95%

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
                    // Stack details and buttons vertically
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Senior Health Details
                      _buildInfoLabel("Name: ", icon: Icons.person_outline),
                      _buildInfoValue(senior.seniorName),

                      _buildInfoLabel("Age: ", icon: Icons.cake_outlined),
                      _buildInfoValue(senior.seniorAge.toString()),

                      _buildInfoLabel("Gender: ", icon: Icons.wc_outlined),
                      _buildInfoValue(senior.seniorGender),

                      _buildInfoLabel(
                        "Temperature (°C): ",
                        icon: Icons.thermostat_outlined,
                      ),
                      _buildInfoValue(
                        senior.seniorTemp.toStringAsFixed(1),
                        isNormal: isTempNormal,
                      ), // Conditional color

                      _buildInfoLabel(
                        "Blood Pressure (SYS/DIA): ",
                        icon: Icons.monitor_heart_outlined,
                      ),
                      _buildInfoValue(
                        "${senior.seniorBloodPressure_SYS}/${senior.seniorBloodPressure_DIA}",
                        isNormal: isBPNormal,
                      ), // Conditional color

                      _buildInfoLabel(
                        "Heart Rate (bpm): ",
                        icon: Icons.favorite_outline,
                      ),
                      _buildInfoValue(
                        senior.seniorHeartRate.toString(),
                        isNormal: isHRNormal,
                      ), // Conditional color

                      _buildInfoLabel(
                        "SpO2 (%): ",
                        icon: Icons.water_drop_outlined,
                      ),
                      _buildInfoValue(
                        senior.seniorSpO2.toString(),
                        isNormal: isSpO2Normal,
                      ), // Conditional color

                      const SizedBox(
                        height: 10,
                      ), // Space between details and buttons
                      // Edit & Delete Buttons (centered at the bottom)
                      Center(
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
                                        (context) =>
                                            EditSeniorPage(senior: senior),
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
                                          "Are you sure you want to delete ${senior.seniorName}'s health record?",
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
                                      .collection(
                                        'senior',
                                      ) // Assuming your collection is 'senior'
                                      .doc(senior.seniorId)
                                      .delete();

                                  /// 🔒 SAFELY check if the context is still mounted
                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "Deleted ${senior.seniorName}'s health record",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 2),
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
            ), // Your home icon
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
              builder: (context) => const AddSeniorPage(),
            ), // Navigate to AddSeniorPage
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
                  "SENIOR HEALTH ", // First part of the title
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF333333), // Darker text color
                    fontSize: 24.0, // Larger font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "STATUS LIST", // Second part of the title
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFC97B86), // Consistent accent color
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            Expanded(child: _showSeniorList()), // Display the list of seniors
          ],
        ),
      ),
    );
  }
}
