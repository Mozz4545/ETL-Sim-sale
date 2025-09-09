import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../home/controllers/main_menu_bar.dart';
import './_profile_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _profileImage;
  bool _editing = true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Color(0xFF4F8FFF), width: 1.2),
    );
    return Scaffold(
      appBar: const MainMenuBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4F8FFF), Color(0xFFB6D0FF), Color(0xFFF6F8FF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Card(
              color: Colors.white.withOpacity(0.95),
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 54,
                            backgroundColor: const Color(0xFF4F8FFF),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Color(0xFF4F8FFF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      if (_editing) ...[
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'ຊື່',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border.copyWith(
                              borderSide: const BorderSide(
                                color: Color(0xFF4F8FFF),
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                          ),
                          style: const TextStyle(fontSize: 17),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'ກະລຸນາປ້ອນຊື່' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'ນາມສະກຸນ',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border.copyWith(
                              borderSide: const BorderSide(
                                color: Color(0xFF4F8FFF),
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                          ),
                          style: const TextStyle(fontSize: 17),
                          validator: (v) => v == null || v.isEmpty
                              ? 'ກະລຸນາປ້ອນນາມສະກຸນ'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border.copyWith(
                              borderSide: const BorderSide(
                                color: Color(0xFF4F8FFF),
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                          ),
                          style: const TextStyle(fontSize: 17),
                          validator: (v) => v == null || v.isEmpty
                              ? 'ກະລຸນາປ້ອນ Email'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'ເບີໂທ',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border.copyWith(
                              borderSide: const BorderSide(
                                color: Color(0xFF4F8FFF),
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                          ),
                          style: const TextStyle(fontSize: 17),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'ກະລຸນາປ້ອນເບີໂທ' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _villageController,
                          decoration: InputDecoration(
                            labelText: 'ບ້ານ',
                            prefixIcon: const Icon(Icons.home_outlined),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border.copyWith(
                              borderSide: const BorderSide(
                                color: Color(0xFF4F8FFF),
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                          ),
                          style: const TextStyle(fontSize: 17),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _districtController,
                          decoration: InputDecoration(
                            labelText: 'ເມືອງ',
                            prefixIcon: const Icon(
                              Icons.location_city_outlined,
                            ),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border.copyWith(
                              borderSide: const BorderSide(
                                color: Color(0xFF4F8FFF),
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                          ),
                          style: const TextStyle(fontSize: 17),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _provinceController,
                          decoration: InputDecoration(
                            labelText: 'ແຂວງ',
                            prefixIcon: const Icon(Icons.map_outlined),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border.copyWith(
                              borderSide: const BorderSide(
                                color: Color(0xFF4F8FFF),
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                          ),
                          style: const TextStyle(fontSize: 17),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'ທີ່ຢູ່ຈັດສົ່ງ',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border.copyWith(
                              borderSide: const BorderSide(
                                color: Color(0xFF4F8FFF),
                                width: 2,
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                          ),
                          style: const TextStyle(fontSize: 17),
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        ProfileField(
                          label: 'ຊື່',
                          value: _firstNameController.text,
                          icon: Icons.person_outline,
                        ),
                        ProfileField(
                          label: 'ທີ່ຢູ່ຈັດສົ່ງ',
                          value: _addressController.text,
                          icon: Icons.location_on_outlined,
                        ),
                        ProfileField(
                          label: 'ນາມສະກຸນ',
                          value: _lastNameController.text,
                          icon: Icons.person_outline,
                        ),
                        ProfileField(
                          label: 'Email',
                          value: _emailController.text,
                          icon: Icons.email_outlined,
                        ),
                        ProfileField(
                          label: 'ເບີໂທ',
                          value: _phoneController.text,
                          icon: Icons.phone_outlined,
                        ),
                        ProfileField(
                          label: 'ບ້ານ',
                          value: _villageController.text,
                          icon: Icons.home_outlined,
                        ),
                        ProfileField(
                          label: 'ເມືອງ',
                          value: _districtController.text,
                          icon: Icons.location_city_outlined,
                        ),
                        ProfileField(
                          label: 'ແຂວງ',
                          value: _provinceController.text,
                          icon: Icons.map_outlined,
                        ),
                        const SizedBox(height: 32),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(_editing ? Icons.save : Icons.edit),
                          label: Text(_editing ? 'ບັນທຶກ' : 'ແກ້ໄຂ'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F8FFF),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (_editing) {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _editing = false);
                              }
                            } else {
                              setState(() => _editing = true);
                            }
                          },
                        ),
                      ),
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
}
