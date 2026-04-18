import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rick_coins_market_ruhsari/states/main_screen_state.dart';
import 'package:rick_coins_market_ruhsari/ui/sign_in_sign_up/registration_page.dart';

import '../home_page.dart';



class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error during login: ${e.toString()}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Login Page",
//               style: TextStyle(fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(hintText: "Email")
//             ),
//             TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(hintText: "Password")
//             ),
//             SizedBox(height: 30),
//             if (_isLoading) ...[
//               CircularProgressIndicator(),
//             ],
//             ElevatedButton(onPressed: _login, child: Text("Login"), style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: const Color.fromARGB(255, 51, 84, 216),
//             )
//             ),
//             TextButton(onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
//             }, child: Text("Registration", style: TextStyle(fontSize: 16),))
//           ],
//         ),
//       ),
//     );
//   }
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Растягиваем элементы
            children: [
              const Icon(
                  Icons.currency_bitcoin, size: 80, color: Color(0xFF00B4D8)),
              const SizedBox(height: 16),
              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2B2D42)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to earn Rick Coins",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // поле Email
              TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  )
              ),
              const SizedBox(height: 16),

              // поле Password
              TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  )
              ),
              const SizedBox(height: 30),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00B4D8),
                          Color(0xFF0077B6)
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF0077B6).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5)),
                      ]
                  ),
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Login", style: TextStyle(fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                  ),
                ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => RegistrationPage()));
                },
                child: const Text("Don't have an account? Sign Up",
                    style: TextStyle(fontSize: 16, color: Color(0xFF0077B6))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
