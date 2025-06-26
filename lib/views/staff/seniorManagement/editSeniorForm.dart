// import 'package:flutter/material.dart';
// import 'package:random_string/random_string.dart';
// import 'package:ss_home/controller/seniorController.dart';
// import 'package:ss_home/models/senior.dart';

// class EditSeniorPage extends StatefulWidget {
//   final SeniorModel senior;
//   const EditSeniorPage({super.key, required this.senior});

//   @override
//   State<EditSeniorPage> createState() => _EditSeniorPageState();
// }

// class _EditSeniorPageState extends State<EditSeniorPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController _seniorName = TextEditingController();
//   final TextEditingController _seniorAge = TextEditingController();
//   final TextEditingController _seniorTemp = TextEditingController();
//   final TextEditingController _seniorBP_SYS = TextEditingController();
//   final TextEditingController _seniorBP_DIA = TextEditingController();
//   final TextEditingController _seniorHeartRate = TextEditingController();
//   final TextEditingController _seniorSpO2 = TextEditingController();

//   String? _selectedGender;
//   @override
//   void initState() {
//     super.initState();

//     _seniorName.text = widget.senior.seniorName;
//     _seniorAge.text = widget.senior.seniorAge.toString();
//     _seniorTemp.text = widget.senior.seniorTemp.toString();
//     _seniorBP_SYS.text = widget.senior.seniorBloodPressure_SYS.toString();
//     _seniorBP_DIA.text = widget.senior.seniorBloodPressure_DIA.toString();
//     _seniorHeartRate.text = widget.senior.seniorHeartRate.toString();
//     _seniorSpO2.text = widget.senior.seniorSpO2.toString();
//     _selectedGender = widget.senior.seniorGender;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Senior Health Status List"),
//         backgroundColor: const Color(0xFFEAA4A9),
//       ),

//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const Text(
//                     'Senior Info',
//                     style: TextStyle(fontSize: 28, color: Colors.black),
//                   ),
//                   const SizedBox(height: 30),

//                   textField(_seniorName, 'Name', Icons.person),
//                   genderDropdown(),
//                   textField(_seniorAge, 'Age', Icons.cake, isNumber: true),
//                   textField(
//                     _seniorTemp,
//                     'Temperature (°C)',
//                     Icons.thermostat,
//                     isNumber: true,
//                   ),
//                   textField(
//                     _seniorBP_SYS,
//                     'Blood Pressure SYS',
//                     Icons.favorite,
//                     isNumber: true,
//                   ),
//                   textField(
//                     _seniorBP_DIA,
//                     'Blood Pressure DIA',
//                     Icons.favorite_border,
//                     isNumber: true,
//                   ),
//                   textField(
//                     _seniorHeartRate,
//                     'Heart Rate',
//                     Icons.monitor_heart,
//                     isNumber: true,
//                   ),
//                   textField(_seniorSpO2, 'SpO2 (%)', Icons.air, isNumber: true),

//                   const SizedBox(height: 30),

//                   ElevatedButton(
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         final updatedSenior = SeniorModel(
//                           seniorId: widget.senior.seniorId, // keep the same ID
//                           seniorName: _seniorName.text,
//                           seniorAge: int.parse(_seniorAge.text),
//                           seniorGender: _selectedGender!,
//                           seniorTemp: double.parse(_seniorTemp.text),
//                           seniorBloodPressure_SYS: int.parse(
//                             _seniorBP_SYS.text,
//                           ),
//                           seniorBloodPressure_DIA: int.parse(
//                             _seniorBP_DIA.text,
//                           ),
//                           seniorHeartRate: int.parse(_seniorHeartRate.text),
//                           seniorSpO2: int.parse(_seniorSpO2.text),
//                         );

//                         await SeniorController().updateSenior(updatedSenior);

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             backgroundColor: Colors.green,
//                             content: Text("Senior data has been updated."),
//                           ),
//                         );

//                         Navigator.pop(context); // Go back after update
//                       }
//                     },
//                     child: const Text('Update Senior'),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.black,
//                       backgroundColor: Colors.orange,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget textField(
//     TextEditingController controller,
//     String hint,
//     IconData icon, {
//     bool isNumber = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         validator: (value) => value!.isEmpty ? 'Please enter $hint' : null,
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: const TextStyle(color: Colors.black),
//           errorStyle: const TextStyle(color: Colors.white),
//           prefixIcon: Icon(icon, color: Colors.black),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.all(15),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: const BorderSide(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget genderDropdown() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: DropdownButtonFormField<String>(
//         value: _selectedGender,
//         onChanged: (newValue) {
//           setState(() {
//             _selectedGender = newValue;
//           });
//         },
//         validator: (value) => value == null ? 'Please select gender' : null,
//         items:
//             ['Male', 'Female'].map((gender) {
//               return DropdownMenuItem(value: gender, child: Text(gender));
//             }).toList(),
//         decoration: InputDecoration(
//           hintText: 'Gender',
//           hintStyle: const TextStyle(color: Colors.black),
//           errorStyle: const TextStyle(color: Colors.white),
//           prefixIcon: const Icon(Icons.wc, color: Colors.black),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.all(15),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: const BorderSide(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _seniorName.dispose();
//     _seniorAge.dispose();
//     _seniorTemp.dispose();
//     _seniorBP_SYS.dispose();
//     _seniorBP_DIA.dispose();
//     _seniorHeartRate.dispose();
//     _seniorSpO2.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart'; // This import isn't strictly needed for EditSeniorPage but is kept if other parts of the app rely on it.
import 'package:ss_home/controller/seniorController.dart';
import 'package:ss_home/models/senior.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts

class EditSeniorPage extends StatefulWidget {
  final SeniorModel senior;
  const EditSeniorPage({super.key, required this.senior});

  @override
  State<EditSeniorPage> createState() => _EditSeniorPageState();
}

class _EditSeniorPageState extends State<EditSeniorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _seniorName = TextEditingController();
  final TextEditingController _seniorAge = TextEditingController();
  final TextEditingController _seniorTemp = TextEditingController();
  final TextEditingController _seniorBP_SYS = TextEditingController();
  final TextEditingController _seniorBP_DIA = TextEditingController();
  final TextEditingController _seniorHeartRate = TextEditingController();
  final TextEditingController _seniorSpO2 = TextEditingController();

  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers and selected gender with the existing senior's data
    _seniorName.text = widget.senior.seniorName;
    _seniorAge.text = widget.senior.seniorAge.toString();
    _seniorTemp.text = widget.senior.seniorTemp.toString();
    _seniorBP_SYS.text = widget.senior.seniorBloodPressure_SYS.toString();
    _seniorBP_DIA.text = widget.senior.seniorBloodPressure_DIA.toString();
    _seniorHeartRate.text = widget.senior.seniorHeartRate.toString();
    _seniorSpO2.text = widget.senior.seniorSpO2.toString();
    _selectedGender = widget.senior.seniorGender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SS HOME", // Consistent app bar title
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFC97B86), // Consistent background color
        elevation: 4.0, // Consistent elevation
        centerTitle: true, // Consistent centered title
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), // Consistent padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to start
            children: <Widget>[
              Text(
                'EDIT SENIOR INFO', // Changed text and style to match AddSeniorPage
                style: GoogleFonts.poppins(
                  color: const Color(0xFF333333),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              _buildLabel(
                "Senior Name",
              ), // Replaced textField with _buildLabel and _buildTextField
              _buildTextField(controller: _seniorName, hint: "Enter full name"),
              const SizedBox(height: 20.0), // Consistent spacing

              _buildLabel(
                "Gender",
              ), // Replaced genderDropdown with _buildLabel and _genderDropdown
              _genderDropdown(),
              const SizedBox(height: 20.0),

              _buildLabel("Senior Age"),
              _buildTextField(
                controller: _seniorAge,
                hint: "Enter age",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("Temperature (°C)"),
              _buildTextField(
                controller: _seniorTemp,
                hint: "Enter temperature",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("Blood Pressure SYS"),
              _buildTextField(
                controller: _seniorBP_SYS,
                hint: "Enter systolic BP",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("Blood Pressure DIA"),
              _buildTextField(
                controller: _seniorBP_DIA,
                hint: "Enter diastolic BP",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("Heart Rate"),
              _buildTextField(
                controller: _seniorHeartRate,
                hint: "Enter heart rate",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("SpO2 (%)"),
              _buildTextField(
                controller: _seniorSpO2,
                hint: "Enter SpO2",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 40.0), // Increased spacing before buttons

              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Validate form and ensure gender is selected
                        if (_formKey.currentState!.validate() &&
                            _selectedGender != null) {
                          final updatedSenior = SeniorModel(
                            seniorId:
                                widget.senior.seniorId, // Keep the same ID
                            seniorName: _seniorName.text,
                            seniorAge: int.parse(_seniorAge.text),
                            seniorGender: _selectedGender!,
                            seniorTemp: double.parse(_seniorTemp.text),
                            seniorBloodPressure_SYS: int.parse(
                              _seniorBP_SYS.text,
                            ),
                            seniorBloodPressure_DIA: int.parse(
                              _seniorBP_DIA.text,
                            ),
                            seniorHeartRate: int.parse(_seniorHeartRate.text),
                            seniorSpO2: int.parse(_seniorSpO2.text),
                          );

                          await SeniorController().updateSenior(updatedSenior);

                          // Check if the widget is still mounted before showing SnackBar or popping
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Senior data has been updated successfully!",
                                style: TextStyle(
                                  color: Colors.white,
                                ), // Consistent text style
                              ),
                              duration: Duration(
                                seconds: 2,
                              ), // Consistent duration
                            ),
                          );
                          Navigator.pop(context); // Go back after update
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.orange,
                              content: Text(
                                "Please fill in all the fields and select a gender.", // Improved message
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
                        elevation: 8.0, // Consistent elevation
                        minimumSize: const Size(250, 50), // Consistent size
                      ),
                      child: Text(
                        'Update Senior',
                        style: GoogleFonts.poppins(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0), // Spacing between buttons
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        ); // Go back to the previous screen
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
      ),
    );
  }

  // Helper widget to build labels (copied from AddSeniorPage)
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

  // Helper widget to build text fields with consistent styling (copied from AddSeniorPage)
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
      child: TextFormField(
        // Using TextFormField for validation
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.black87),
        validator:
            (value) =>
                value!.isEmpty ? 'Please enter $hint' : null, // Added validator
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
          errorStyle: GoogleFonts.poppins(
            color: Colors.redAccent,
            fontSize: 12.0,
          ), // Style for error text
        ),
      ),
    );
  }

  // Helper widget for gender dropdown with consistent styling (copied from AddSeniorPage)
  Widget _genderDropdown() {
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
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        onChanged: (newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
        validator: (value) => value == null ? 'Please select gender' : null,
        items:
            ['Male', 'Female'].map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(
                  gender,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
        decoration: InputDecoration(
          hintText: 'Select Gender',
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
          errorStyle: GoogleFonts.poppins(
            color: Colors.redAccent,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _seniorName.dispose();
    _seniorAge.dispose();
    _seniorTemp.dispose();
    _seniorBP_SYS.dispose();
    _seniorBP_DIA.dispose();
    _seniorHeartRate.dispose();
    _seniorSpO2.dispose();
    super.dispose();
  }
}
