import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:ss_home/controller/seniorController.dart';
import 'package:ss_home/models/senior.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts

class AddSeniorPage extends StatefulWidget {
  const AddSeniorPage({super.key});

  @override
  State<AddSeniorPage> createState() => _AddSeniorPageState();
}

class _AddSeniorPageState extends State<AddSeniorPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SS HOME", // Changed title to match the example
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFC97B86), // Changed color
        elevation: 4.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Changed to SingleChildScrollView with padding
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to start
            children: <Widget>[
              Text(
                'SENIOR INFO', // Changed text and style
                style: GoogleFonts.poppins(
                  color: const Color(0xFF333333),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              _buildLabel("Senior Name"), // Added label
              _buildTextField(controller: _seniorName, hint: "Enter full name"),
              const SizedBox(height: 20.0), // Consistent spacing

              _buildLabel("Gender"), // Added label for dropdown
              _genderDropdown(), // Renamed to follow _build prefix
              const SizedBox(height: 20.0),

              _buildLabel("Senior Age"), // Added label
              _buildTextField(
                controller: _seniorAge,
                hint: "Enter age",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("Temperature (°C)"), // Added label
              _buildTextField(
                controller: _seniorTemp,
                hint: "Enter temperature",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("Blood Pressure SYS"), // Added label
              _buildTextField(
                controller: _seniorBP_SYS,
                hint: "Enter systolic BP",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("Blood Pressure DIA"), // Added label
              _buildTextField(
                controller: _seniorBP_DIA,
                hint: "Enter diastolic BP",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("Heart Rate"), // Added label
              _buildTextField(
                controller: _seniorHeartRate,
                hint: "Enter heart rate",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),

              _buildLabel("SpO2 (%)"), // Added label
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
                        if (_formKey.currentState!.validate() &&
                            _selectedGender != null) {
                          // Added null check for gender
                          String seniorID = randomAlphaNumeric(10);
                          final newSenior = SeniorModel(
                            seniorId: seniorID,
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

                          await SeniorController().addSenior(newSenior);

                          if (!mounted) return; // Add this line for safety

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Senior data has been added.",
                                style: TextStyle(
                                  color: Colors.white,
                                ), // Added text style
                              ),
                              duration: Duration(seconds: 2), // Added duration
                            ),
                          );
                          Navigator.pop(context);
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
                        minimumSize: const Size(250, 50),
                      ),
                      child: Text(
                        'Add Senior',
                        style: GoogleFonts.poppins(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC97B86),
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
                        ),
                        minimumSize: const Size(250, 50),
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
              const SizedBox(height: 50.0), // Added spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // Renamed from textField to _buildTextField and updated styling
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
        // Changed from TextField to TextFormField for validation
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

  // Renamed from genderDropdown to _genderDropdown and updated styling
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
          hintText: 'Select Gender', // Changed hint text
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
