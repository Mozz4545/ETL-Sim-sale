import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CustomerForm(),
    debugShowCheckedModeBanner: false,
  ));
}

class CustomerForm extends StatefulWidget {
  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final facebookController = TextEditingController();
  final emailController = TextEditingController();

  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final facebookFocus = FocusNode();
  final emailFocus = FocusNode();

  String? selectedProvince;
  String? selectedDistrict;
  String? selectedVillage;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    facebookController.dispose();
    emailController.dispose();
    nameFocus.dispose();
    phoneFocus.dispose();
    facebookFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
    required FocusNode currentFocus,
    FocusNode? nextFocus,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: currentFocus,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Color(0xFFE3F2FD),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please fill out this field' : null,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(label),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          validator: (value) =>
              value == null || value.isEmpty ? 'Please fill out this field' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFE3F2FD),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: items
              .map((e) => DropdownMenuItem<String>(
                    child: Text(e),
                    value: e,
                  ))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D47A1),
      appBar: AppBar(
        backgroundColor: Color(0xFF0D47A1),
        elevation: 0,
        title: Text(
          'Welcome',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Row 1
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel('ຊື່ ແລະ ນາມສະກຸນ'),
                        buildTextField(
                          hint: 'User name',
                          controller: nameController,
                          currentFocus: nameFocus,
                          nextFocus: phoneFocus,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel('ເບີໂທ'),
                        buildTextField(
                          hint: 'Phone number',
                          controller: phoneController,
                          currentFocus: phoneFocus,
                          nextFocus: facebookFocus,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Row 2
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel('ທີ່ຢູ່ເຟສບຸກ'),
                        buildTextField(
                          hint: 'Facebook address',
                          controller: facebookController,
                          currentFocus: facebookFocus,
                          nextFocus: emailFocus,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel('ທີ່ຢູ່ອີເມວ'),
                        buildTextField(
                          hint: 'Email address',
                          controller: emailController,
                          currentFocus: emailFocus,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Row 3
              Row(
                children: [
                  Expanded(
                    child: buildDropdown(
                      label: 'ແຂວງ',
                      value: selectedProvince,
                      items: ['Vientiane Capital', 'Champasak', 'Savannakhet'],
                      onChanged: (val) => setState(() => selectedProvince = val),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: buildDropdown(
                      label: 'ເມືອງ',
                      value: selectedDistrict,
                      items: ['Sisattanak', 'Chanthabuly', 'Xaysettha'],
                      onChanged: (val) => setState(() => selectedDistrict = val),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Row 4
              Row(
                children: [
                  Expanded(
                    child: buildDropdown(
                      label: 'ບ້ານ',
                      value: selectedVillage,
                      items: ['Ban Phonxay', 'Ban Dongpalan', 'Ban Saphangthong'],
                      onChanged: (val) => setState(() => selectedVillage = val),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: SizedBox()), // ช่องเปล่าให้บาลานซ์กับแถวอื่น
                ],
              ),
              SizedBox(height: 24),

              // Save Button
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("✅ Form submitted successfully")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF0D47A1),
                    side: BorderSide(color: Color(0xFF0D47A1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
