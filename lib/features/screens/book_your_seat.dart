import 'dart:convert';
import 'dart:io';
import 'package:co_work_connect/core/widgets/custom_general_button.dart';
import 'package:co_work_connect/core/widgets/custom_text_field.dart';
import 'package:co_work_connect/features/screens/checkout_page.dart';
import 'package:co_work_connect/features/data/models/place_model.dart';
import 'package:co_work_connect/features/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:co_work_connect/features/data/service/local_storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookYourSeatPage extends StatefulWidget {
  const BookYourSeatPage({super.key, required this.placeModel});
  final PlaceModel placeModel;

  @override
  State<BookYourSeatPage> createState() => _BookYourSeatPageState();
}

class _BookYourSeatPageState extends State<BookYourSeatPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  File? image;
  UserModel? currentUser;
  @override
  void initState() {
    super.initState();
    loadCurrentUserData();
  }

  void loadCurrentUserData() async {
    UserModel? user = await LocalUserStorageService.getLoggedInUser();
    if (user != null) {
      setState(() {
        emailController.text = user.email;
        passwordController.text = user.password;
        nameController.text = user.username;
        phoneController.text = "";
        currentUser = user;
        if (user.photoPath != null) image = File(user.photoPath!);
      });
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null && currentUser != null) {
      setState(() {
        image = File(pickedFile.path);
      });

      final updatedUser = UserModel(
        username: currentUser!.username,
        email: currentUser!.email,
        password: currentUser!.password,
        photoPath: pickedFile.path,
      );

      final prefs = await SharedPreferences.getInstance();
      List<String> usersRaw =
          prefs.getStringList(LocalUserStorageService.usersKey) ?? [];
      List<UserModel> users =
          usersRaw.map((e) => UserModel.fromJson(jsonDecode(e))).toList();

      bool userFound = false;
      for (int i = 0; i < users.length; i++) {
        if (users[i].email == updatedUser.email) {
          users[i] = updatedUser;
          userFound = true;
          break;
        }
      }
      if (!userFound) users.add(updatedUser);

      List<String> newUsersRaw =
          users.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(LocalUserStorageService.usersKey, newUsersRaw);

      await LocalUserStorageService.setLoggedInUser(updatedUser);

      setState(() {
        currentUser = updatedUser;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Book your seat",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 17),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.redAccent,
                      backgroundImage:
                          image != null
                              ? FileImage(image!)
                              : AssetImage('assets/avatar.png'),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 4,
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  enabled: false,
                  label: "Email Address",
                  controller: emailController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  enabled: false,
                  label: "Password",
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal info",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "Phone Number",
                  controller: phoneController,
                  inputType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\d{11}$').hasMatch(value.trim())) {
                      return 'Phone number must be exactly 11 digits';
                    }
                    if (!value.startsWith("01")) {
                      return 'Please enter correct phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: "Account Holder’s Name",
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 3) {
                      return 'Please enter correct name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomGeneralButton(
                  text: "Save",
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CheckoutPage(placeModel: widget.placeModel),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
