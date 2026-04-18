// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }
//
// class _RegistrationPageState extends State<RegistrationPage> {
//   // Контроллеры для ввода текста
//   final _nicknameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//
//   File? _image; // Файл выбранного аватара
//   bool _isLoading = false;
//   double _uploadProgress = 0;
//
//   // Выбор изображения из галереи
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Photo selected!")),
//       );
//     }
//   }
//
//   // Основная функция регистрации
//   Future<void> _registerUser() async {
//     final String nickname = _nicknameController.text.trim();
//     final String email = _emailController.text.trim();
//     final String password = _passwordController.text.trim();
//
//     // Валидация
//     if (nickname.isEmpty || email.isEmpty || password.isEmpty ||
//         _image == null) {
//       _showToast("Please fill all fields and select an avatar");
//       return;
//     }
//
//     if (password != _confirmPasswordController.text) {
//       _showToast("Passwords do not match");
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       // 1. Создание пользователя в Auth
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//
//       String uid = userCredential.user!.uid;
//
//       // 2. Загрузка фото в Storage
//       Reference storageRef = FirebaseStorage.instance
//           .ref()
//           .child('user_persons/$uid/avatar.png');
//
//       UploadTask uploadTask = storageRef.putFile(_image!);
//
//       // Отслеживание прогресса загрузки
//       uploadTask.snapshotEvents.listen((event) {
//         setState(() {
//           _uploadProgress = event.bytesTransferred / event.totalBytes;
//         });
//       });
//
//       // Получаем ссылку на загруженное фото
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//
//       // 3. Сохранение расширенного профиля в Firestore (согласно новому скрину)
//       await FirebaseFirestore.instance
//           .collection('user_persons')
//           .doc(uid)
//           .set({
//         'nickname': nickname,
//         'email': email,
//         'avatar': downloadUrl,
//         'coins': 0,
//         'buying': 0,
//         'sales': 0,
//         'message': "Привет ",
//       });
//
//       _showToast("Registration Successful!");
//       Navigator.pop(context);
//
//       // Здесь можно добавить переход на другой экран, например:
//       // Navigator.of(context).pushReplacementNamed('/home');
//
//     } catch (e) {
//       _showToast("Error: ${e.toString()} Password must contains 6 characters");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _showToast(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFDEEFFD),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           children: [
//             SizedBox(height: 40),
//             Text(
//               "Registration Page",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//             TextField(
//               controller: _nicknameController,
//               decoration: InputDecoration(hintText: "Nickname"),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(hintText: "Email"),
//             ),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(hintText: "Password"),
//             ),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(hintText: "Confirm Password"),
//             ),
//             SizedBox(height: 20),
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Choose Avatar ->",
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.white,
//                     backgroundImage: _image != null ? FileImage(_image!) : null,
//                     child: _image == null ?
//                         Icon(Icons.add_a_photo, color: Colors.blue): null),
//
//                 ),
//               ],
//             ),
//             if (_isLoading) ...[
//               SizedBox(height: 20),
//               LinearProgressIndicator(value: _uploadProgress),
//             ],
//             SizedBox(height:30),
//             IconButton(
//               iconSize: 60,
//               icon: Icon(Icons.check_circle, color: Colors.green),
//               onPressed: _isLoading ? null : _registerUser,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../states/main_screen_state.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _image;
  bool _isLoading = false;
  double _uploadProgress = 0;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _showToast("Photo selected!");
    }
  }

  Future<void> _registerUser() async {
    final String nickname = _nicknameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (nickname.isEmpty || email.isEmpty || password.isEmpty || _image == null) {
      _showToast("Please fill all fields and select an avatar");
      return;
    }

    if (password != _confirmPasswordController.text) {
      _showToast("Passwords do not match");
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_persons/$uid/avatar.png');

      UploadTask uploadTask = storageRef.putFile(_image!);

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('user_persons')
          .doc(uid)
          .set({
        'nickname': nickname,
        'email': email,
        'avatar': downloadUrl,
        'coins': 0,
        'buying': 0,
        'sales': 0,
        'message': "Привет ",
      });

      _showToast("Registration Successful!");

      // Переход на главный экран с рабочей панелью навигации
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false,
        );
      }

    } catch (e) {
      _showToast("Error: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Вспомогательный виджет для отрисовки текстовых полей в едином стиле
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF0077B6)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2B2D42)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Create Account",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2B2D42),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Sign up to start earning Rick Coins",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Виджет выбора аватара
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(Icons.person_add_alt_1, size: 40, color: Color(0xFF00B4D8))
                            : null,
                      ),
                    ),
                    if (_image == null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0077B6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            _buildTextField(_nicknameController, "Nickname", Icons.person_outline),
            _buildTextField(_emailController, "Email", Icons.email_outlined),
            _buildTextField(_passwordController, "Password", Icons.lock_outline, isPassword: true),
            _buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock_outline, isPassword: true),

            if (_isLoading) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: _uploadProgress > 0 ? _uploadProgress : null,
                color: const Color(0xFF00B4D8),
                backgroundColor: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 10),
            ] else
              const SizedBox(height: 20),

            // Кнопка регистрации
            Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0077B6).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}