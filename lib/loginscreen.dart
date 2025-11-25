import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'user.dart';
import 'homescreen.dart';
import 'registerscreen.dart';
import 'dart:developer';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  bool rememberMe = false;
  bool emailError = false;
  bool passError = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    loadSavedLogin(); 
  }

  // Load saved email/password from SharedPreferences
  Future<void> loadSavedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    bool? remember = prefs.getBool('rememberMe');

    if (remember != null && remember == true) {
      emailC.text = email ?? "";
      passC.text = password ?? "";
      rememberMe = true;

      if (mounted) setState(() {});
    }
  }

  // Save or remove login details based on Remember Me checkbox
  Future<void> updatePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (rememberMe) {
      // Store email & password
      await prefs.setString('email', emailC.text);
      await prefs.setString('password', passC.text);
      await prefs.setBool('rememberMe', true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preferences Saved"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Remove stored login data
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.remove('rememberMe');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preferences Removed"),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Login function 
  void login() async {
    setState(() {
      emailError = emailC.text.trim().isEmpty;
      passError = passC.text.trim().isEmpty;
    });

    if (emailError || passError) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Color.fromARGB(255, 178, 18, 6),
        ),
      );
      return;
    }

    try {
      var res = await ApiService.loginUser(emailC.text, passC.text);
      log(res.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res['message'])));

      if (res['success'] == true || res['success'] == 1) {
        await updatePreferences();

        if (!rememberMe) {
          emailC.clear();
          passC.clear();
        }

        User user = User.fromJson(res['data']);

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
        );
      }
    } catch (e) {
      // Handle network/API errors
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: $e"),
          backgroundColor: Color.fromARGB(255, 178, 18, 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Color.fromARGB(255, 255, 169, 116),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 30),

              Image.asset(
                'assets/pawpal.png',
                width: 200,
                height: 200,
              ),

              SizedBox(height: 30),

              // Email
              TextField(
                controller: emailC,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: emailError ? "Email cannot be empty" : null,
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              // Password
              TextField(
                controller: passC,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: passError ? "Password cannot be empty" : null,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              // Remember Me checkbox
              Row(
                children: [
                Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() => rememberMe = value!);
                    },
                  ),
                  Text("Remember Me"),
                ],
              ),

             SizedBox(height: 20),

              // Login button
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                ),
                child: Text("Login"),
              ),

              SizedBox(height: 20),

              // Navigate to registration page
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: Text(
                  "Don’t have an account? Register",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
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
