import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class CountryActivities extends StatefulWidget {
  const CountryActivities({super.key});

  @override
  State<CountryActivities> createState() => _CountryActivitiesState();
}

class _CountryActivitiesState extends State<CountryActivities> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCountry;
  List<String> countries = ['Oman', 'Georgia', 'Turkey', 'Iran'];

  File? _selectedFile;
  String? _fileName;

  DateTime? selectedDate;

  List<String> selectedActivities = [];
  final List<String> activities = ['Aquarium', 'Mall shopping', 'Teleferik','Cultural festival'];

  String? selectedGender;
  final List<String> genders = ['Male', 'Female'];

  bool _isImageFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.jpg') || ext.endsWith('.jpeg') || ext.endsWith('.png');
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  bool _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || selectedActivities.isEmpty || selectedDate == null || selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields!')),
      );
      return false;
    }
    return true;
  }

  void _confirmSelection() {
    if (!_validateForm()) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
          'Country: $selectedCountry\n'
              'Gender: $selectedGender\n'
              'Activities: ${selectedActivities.join(", ")}\n'
              'Date: ${selectedDate?.toLocal().toString().split(' ')[0]}\n'
              'You have submitted a file or image',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload new activity'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  // Country Dropdown list
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select a country",
                      prefixIcon: Icon(Icons.flag),
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCountry,
                    items: countries.map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedCountry = value),
                    validator: (value) => value == null ? 'Please select a country' : null,
                  ),

                  const SizedBox(height: 20),

                  // Gender Radio Buttons
                  Text('Select Gender:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    children: genders.map((gender) => RadioListTile<String>(
                      title: Text(gender),
                      value: gender,
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    )).toList(),
                  ),
                  if (selectedGender == null)
                    Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 4),
                      child: Text('Please select your gender', style: TextStyle(color: Colors.red)),
                    ),

                  const SizedBox(height: 20),

                  // Activities Checkboxes
                  Text('Select Activities:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...activities.map((activity) => CheckboxListTile(
                    title: Text(activity),
                    value: selectedActivities.contains(activity),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selectedActivities.add(activity);
                        } else {
                          selectedActivities.remove(activity);
                        }
                      });
                    },
                  )),
                  if (selectedActivities.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 4),
                      child: Text('Please select at least one activity', style: TextStyle(color: Colors.red)),
                    ),

                  const SizedBox(height: 20),

                  // Date Picker
                  ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: Icon(Icons.calendar_today),
                    label: Text(
                      selectedDate == null ? 'Pick up a date' : 'Date: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  if (selectedDate == null)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('Please select a date', style: TextStyle(color: Colors.red)),
                    ),

                  const SizedBox(height: 20),

                  // File Picker
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: Icon(Icons.upload_file),
                    label: Text('Upload image or a document'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Center(
                    child: _selectedFile == null
                        ? const Text('No file or an image has been selected.')
                        : _isImageFile(_selectedFile!.path)
                        ? Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(_selectedFile!, height: 200),
                    )
                        : Text('Selected file: $_fileName'),
                  ),

                  const SizedBox(height: 30),

                  // Confirm Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _confirmSelection,
                      icon: Icon(Icons.check_outlined),
                      label: Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
