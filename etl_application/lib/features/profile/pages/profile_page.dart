import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: ProfilePage()));

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _facebookFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _dayFocus = FocusNode();
  final FocusNode _monthFocus = FocusNode();
  final FocusNode _yearFocus = FocusNode();
  final FocusNode _homeFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _districtFocus = FocusNode();

  // ignore: unused_field
  String? _firstName, _lastName, _facebook, _email, _phone;
  String? _selectedDay, _selectedMonth, _selectedYear;
  String? _selectedHome, _selectedCity, _selectedDistrict;

  final List<String> _days = List.generate(31, (i) => '${i + 1}');
  final List<String> _months = ['ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ພ', 'ມ.ຖ', 'ກ.ກ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ຈ', 'ທ.ວ'];
  final List<String> _years = List.generate(50, (i) => '${1975 + i}');
  // ignore: unused_field
  final List<String> _villages = ['ບ້ານ1', 'ບ້ານ2', 'ບ້ານ3'];
  final List<String> _cities = ['ວຽງຈັນ', 'ຫຼວງນ້ຳທາ'];
  final List<String> _districts = ['ອຸດົມໄຊ', 'ໄຊສົມບູນ'];

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDay == null ||
          _selectedMonth == null ||
          _selectedYear == null ||
          _selectedHome == null ||
          _selectedCity == null ||
          _selectedDistrict == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ກະລຸນາເລືອກຂໍ້ມູນໃຫ້ຄົບ!')),
        );
        return;
      }

      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ບັນທຶກສຳເລັດ')),
      );
    }
  }

  Widget _buildDropdown({
    required String hint,
    required String? selectedValue,
    required List<String> items,
    required FocusNode focusNode,
    required ValueChanged<String?> onChanged,
    FocusNode? nextFocus,
    int flex = 1,
  }) {
    return Flexible(
      flex: flex,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        style: TextStyle(fontSize: 13),
        icon: SizedBox.shrink(), // ❌ ซ่อนไอคอน dropdown arrow
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: (val) {
          onChanged(val);
          if (val != null && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        validator: (val) => val == null ? 'ກະລຸນາເລືອກ' : null,
        focusNode: focusNode,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    required ValueChanged<String?> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      ),
      textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
      focusNode: focusNode,
      onSaved: onSaved,
      validator: (val) => val == null || val.isEmpty ? 'ກະລຸນາປ້ອນ $hint' : null,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF7FF),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            width: 380,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/profile.png"),
                    radius: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Profile Page',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  _buildTextField(
                    hint: 'ຊື່',
                    focusNode: _firstNameFocus,
                    nextFocus: _lastNameFocus,
                    onSaved: (val) => _firstName = val,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    hint: 'ນາມສະກຸນ',
                    focusNode: _lastNameFocus,
                    nextFocus: _facebookFocus,
                    onSaved: (val) => _lastName = val,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    hint: 'ເຟສບຸກ',
                    focusNode: _facebookFocus,
                    nextFocus: _emailFocus,
                    onSaved: (val) => _facebook = val,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    hint: 'ອີເມວ',
                    focusNode: _emailFocus,
                    nextFocus: _phoneFocus,
                    onSaved: (val) => _email = val,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    hint: 'ເບີໂທ',
                    focusNode: _phoneFocus,
                    nextFocus: _dayFocus,
                    onSaved: (val) => _phone = val,
                  ),
                  SizedBox(height: 10),

                  Row(
                    children: [
                      _buildDropdown(
                        hint: 'ວັນ',
                        selectedValue: _selectedDay,
                        items: _days,
                        focusNode: _dayFocus,
                        onChanged: (val) => _selectedDay = val,
                        nextFocus: _monthFocus,
                        flex: 2,
                      ),
                      SizedBox(width: 2),
                      _buildDropdown(
                        hint: 'ເດືອນ',
                        selectedValue: _selectedMonth,
                        items: _months,
                        focusNode: _monthFocus,
                        onChanged: (val) => _selectedMonth = val,
                        nextFocus: _yearFocus,
                        flex: 3,
                      ),
                      SizedBox(width: 2),
                      _buildDropdown(
                        hint: 'ປີ',
                        selectedValue: _selectedYear,
                        items: _years,
                        focusNode: _yearFocus,
                        onChanged: (val) => _selectedYear = val,
                        nextFocus: _homeFocus,
                        flex: 2,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  Row(
                    children: [
                      _buildDropdown(
                        hint: 'ບ້ານ',
                        selectedValue: _selectedHome,
                        items: _villages,
                        focusNode: _homeFocus,
                        onChanged: (val) => _selectedHome = val,
                        nextFocus: _cityFocus,
                        flex: 2,
                      ),
                      SizedBox(width: 2),
                      _buildDropdown(
                        hint: 'ເມືອງ',
                        selectedValue: _selectedCity,
                        items: _cities,
                        focusNode: _cityFocus,
                        onChanged: (val) => _selectedCity = val,
                        nextFocus: _districtFocus,
                        flex: 2,
                      ),
                      SizedBox(width: 2),
                      _buildDropdown(
                        hint: 'ແຂວງ',
                        selectedValue: _selectedDistrict,
                        items: _districts,
                        focusNode: _districtFocus,
                        onChanged: (val) => _selectedDistrict = val,
                        flex: 3,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _onSave,
                    // ignore: sort_child_properties_last
                    child: Text('ບັນທຶກ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
