import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers + FocusNodes เพื่อกด Enter แล้วไปช่องถัดไป
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _facebookController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _provinceController = TextEditingController();
  final _districtController = TextEditingController();
  final _villageController = TextEditingController();

  final _focusNodes = List.generate(8, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 350,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person,
                            size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        "Profile Page",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(height: 16),

                      _buildTextField("First Name", 0, _firstNameController),
                      const SizedBox(height: 10),

                      _buildTextField("Last Name", 1, _lastNameController),
                      const SizedBox(height: 10),

                      _buildTextField("Facebook", 2, _facebookController),
                      const SizedBox(height: 10),

                      _buildTextField("Email", 3, _emailController,
                          keyboard: TextInputType.emailAddress),
                      const SizedBox(height: 10),

                      _buildTextField("Phone (+856 …)", 4, _phoneController,
                          keyboard: TextInputType.phone),
                      const SizedBox(height: 10),

                      _buildTextField("ແຂວງ", 5, _provinceController),
                      const SizedBox(height: 10),

                      _buildTextField("ເມື່ອງ", 6, _districtController),
                      const SizedBox(height: 10),

                      _buildTextField("ບ້ານ", 7, _villageController),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Form Submitted Successfully")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Save",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, int index, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      focusNode: _focusNodes[index],
      keyboardType: keyboard,
      textInputAction:
          index < _focusNodes.length - 1 ? TextInputAction.next : TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill out this field.";
        }
        return null;
      },
      onFieldSubmitted: (_) {
        if (index < _focusNodes.length - 1) {
          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
        } else {
          FocusScope.of(context).unfocus(); // ปิดคีย์บอร์ด
        }
      },
    );
  }
}
