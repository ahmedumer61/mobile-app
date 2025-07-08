import 'package:fitness_app/view/login/welcome_view.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfileView extends StatefulWidget {
  @override
  _CompleteProfileViewState createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _waterIntakeController = TextEditingController();

  // Height conversion controllers
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();

  String _selectedGender = '';
  final List<String> _genderOptions = ["Male", "Female", "Other"];
  bool _isLoading = false;
  bool _useMetric = true; // Toggle between metric (cm) and imperial (ft/in)

  @override
  void initState() {
    super.initState();
    _loadExistingData();

    // Add listeners to convert height automatically
    _feetController.addListener(_convertToMetric);
    _inchesController.addListener(_convertToMetric);
    _heightController.addListener(_convertToImperial);
  }

  void _convertToMetric() {
    if (_feetController.text.isNotEmpty || _inchesController.text.isNotEmpty) {
      double feet = double.tryParse(_feetController.text) ?? 0;
      double inches = double.tryParse(_inchesController.text) ?? 0;

      if (feet >= 0 && inches >= 0 && inches < 12) {
        double totalInches = (feet * 12) + inches;
        double cm = totalInches * 2.54;

        if (cm > 0) {
          _heightController.text = cm.toStringAsFixed(1);
        }
      }
    }
  }

  void _convertToImperial() {
    if (_heightController.text.isNotEmpty && _useMetric) {
      double cm = double.tryParse(_heightController.text) ?? 0;

      if (cm > 0) {
        double totalInches = cm / 2.54;
        int feet = (totalInches / 12).floor();
        double remainingInches = totalInches - (feet * 12);

        _feetController.text = feet.toString();
        _inchesController.text = remainingInches.toStringAsFixed(1);
      }
    }
  }

  Future<void> _loadExistingData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedGender = prefs.getString('user_gender') ?? '';
        _dateOfBirthController.text = prefs.getString('date_of_birth') ?? '';
        _weightController.text = prefs.getString('user_weight') ?? '';
        _heightController.text = prefs.getString('user_height') ?? '';
        _waterIntakeController.text =
            prefs.getString('user_water_intake') ?? '';
      });

      // Convert existing height to feet/inches if available
      if (_heightController.text.isNotEmpty) {
        _convertToImperial();
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select your gender'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_gender', _selectedGender);
      await prefs.setString(
          'date_of_birth', _dateOfBirthController.text.trim());
      await prefs.setString('user_weight', _weightController.text.trim());
      await prefs.setString('user_height', _heightController.text.trim());
      await prefs.setString(
          'user_water_intake', _waterIntakeController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Changed navigation to WelcomeView instead of HomeView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildDateInput() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
              SizedBox(width: 12),
              Flexible(
                child: Text("Date of Birth",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(Duration(days: 365 * 25)),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                String formattedDate =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                setState(() {
                  _dateOfBirthController.text = formattedDate;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      _dateOfBirthController.text.isEmpty
                          ? "Select Date"
                          : _dateOfBirthController.text,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: _dateOfBirthController.text.isEmpty
                            ? Colors.grey[500]
                            : Colors.black,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInput() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFFE4B1F0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text("Kg",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 12),
              Flexible(
                child: Text("Your Weight",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "Enter your weight",
              hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF92A3FD), width: 2)),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.02),
            ),
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return 'Please enter your weight';
              double? weight = double.tryParse(value.trim());
              if (weight == null || weight <= 0 || weight > 500)
                return 'Please enter a valid weight (1-500 kg)';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeightInput() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFF9DCEFF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(_useMetric ? "Cm" : "Ft",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 12),
              Flexible(
                child: Text("Your Height",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500)),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _useMetric = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                            vertical: 6),
                        decoration: BoxDecoration(
                          color: _useMetric
                              ? Color(0xFF92A3FD)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "CM",
                          style: TextStyle(
                            color: _useMetric ? Colors.white : Colors.grey[600],
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _useMetric = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                            vertical: 6),
                        decoration: BoxDecoration(
                          color: !_useMetric
                              ? Color(0xFF92A3FD)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "FT/IN",
                          style: TextStyle(
                            color:
                                !_useMetric ? Colors.white : Colors.grey[600],
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Show different inputs based on selected unit
          if (_useMetric) ...[
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "Enter your height in cm",
                hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF92A3FD), width: 2)),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: MediaQuery.of(context).size.height * 0.02),
              ),
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return 'Please enter your height';
                double? height = double.tryParse(value.trim());
                if (height == null || height <= 0 || height > 300)
                  return 'Please enter a valid height (1-300 cm)';
                return null;
              },
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _feetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Feet",
                      hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xFF92A3FD), width: 2)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.02),
                    ),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Enter feet';
                      int? feet = int.tryParse(value.trim());
                      if (feet == null || feet < 0 || feet > 8)
                        return 'Valid range: 0-8 feet';
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _inchesController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "Inches",
                      hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xFF92A3FD), width: 2)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.02),
                    ),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Enter inches';
                      double? inches = double.tryParse(value.trim());
                      if (inches == null || inches < 0 || inches >= 12)
                        return 'Valid range: 0-11.9 inches';
                      return null;
                    },
                  ),
                ),
              ],
            ),

            // Show conversion result
            if (_heightController.text.isNotEmpty) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF92A3FD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF92A3FD).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Color(0xFF92A3FD), size: 18),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "Height: ${_heightController.text} cm",
                        style: TextStyle(
                          color: Color(0xFF92A3FD),
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          // Show conversion for metric input
          if (_useMetric &&
              _feetController.text.isNotEmpty &&
              _inchesController.text.isNotEmpty) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF92A3FD).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF92A3FD).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF92A3FD), size: 18),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Height: ${_feetController.text}' ${_inchesController.text}\"",
                      style: TextStyle(
                        color: Color(0xFF92A3FD),
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWaterIntakeInput() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blueAccent),
              SizedBox(width: 12),
              Flexible(
                child: Text("Daily Water Intake",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _waterIntakeController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "Enter in Liters",
              hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF92A3FD), width: 2)),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.02),
            ),
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return 'Please enter your daily water intake';
              double? intake = double.tryParse(value.trim());
              if (intake == null || intake <= 0 || intake > 10)
                return 'Enter a value between 0.1 and 10 Liters';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose Gender",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender.isEmpty ? null : _selectedGender,
                hint: Text("Select Gender",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: MediaQuery.of(context).size.width * 0.035)),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                items: _genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.black)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue ?? '';
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Container(
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.8,
                    child: Image.asset("assets/img/complete_profile.png",
                        fit: BoxFit.contain),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text("Let's complete your profile",
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(height: 5),
                Text("It will help us to know more about you!",
                    style: TextStyle(
                        fontSize: screenWidth * 0.03, color: Colors.grey[600])),
                SizedBox(height: screenHeight * 0.04),
                _buildGenderDropdown(),
                _buildDateInput(),
                _buildWeightInput(),
                _buildHeightInput(),
                _buildWaterIntakeInput(),
                SizedBox(height: screenHeight * 0.04),
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF92A3FD),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Next",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward,
                                  color: Colors.white, size: 18),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _waterIntakeController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    super.dispose();
  }
}
