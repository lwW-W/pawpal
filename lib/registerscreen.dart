import 'package:flutter/material.dart';
import 'api.dart';
import 'dart:developer'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController cpassC = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  bool nameError = false;
  bool emailError = false;
  bool passError = false;
  bool cpassError = false;
  bool phoneError = false;
  bool _obscurePass = true;
  bool _obscureCpass = true;
  bool isLoading = false;

  // Register Function
  void register() async {
    setState(() {
      nameError = nameC.text.trim().isEmpty;
      emailError = emailC.text.trim().isEmpty;
      passError = passC.text.trim().isEmpty;
      cpassError = cpassC.text.trim().isEmpty;
      phoneError = phoneC.text.trim().isEmpty;
    });

    if (nameError || emailError || passError || cpassError || phoneError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Color.fromARGB(255, 178, 18, 6),
        ),
      );
      return;
    }

    // Validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailC.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid email address"),
          backgroundColor: Color.fromARGB(255, 178, 18, 6),
        ),
      );
      return;
    }

    // Password must be at least 6 characters
    if (passC.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password must be at least 6 characters"),
          backgroundColor: Color.fromARGB(255, 178, 18, 6),
        ),
      );
      return;
    }

    if (passC.text != cpassC.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Color.fromARGB(255, 178, 18, 6),
        ),
      );
      return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Register this account?"),
        content: Text("Are you sure you want to register this account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Register"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isLoading = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Registering..."),
          ],
        ),
      ),
    );

    // API CALL with timeout and error handling
    try {
      var res = await ApiService.registerUser(
        nameC.text,
        emailC.text,
        passC.text,
        phoneC.text,
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return {
            "success": false,
            "message": "Request timed out",
          };
        },
      );

      log(res.toString());

      if (!mounted) return;
      Navigator.pop(context);
      setState(() => isLoading = false);

      // If Registration success
      if (res['success'] == true || res['success'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Back to Login page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message']),
            backgroundColor: Color.fromARGB(255, 178, 18, 6),
          ),
        );
      }

    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: $e"),
          backgroundColor: Color.fromARGB(255, 178, 18, 6),
        ),
      );
    }
  }

  // UI 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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

              // Full Name
              TextField(
                controller: nameC,
                decoration: InputDecoration(
                  labelText: "Name",
                  errorText: nameError ? "Name cannot be empty" : null,
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              // Email 
              TextField(
                controller: emailC,
                keyboardType: TextInputType.emailAddress,
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
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: passError ? "Password cannot be empty" : null,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() {
                      _obscurePass = !_obscurePass;
                    }),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Confirm Password 
              TextField(
                controller: cpassC,
                obscureText: _obscureCpass,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  errorText:
                      cpassError ? "Confirm Password cannot be empty" : null,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCpass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() {
                      _obscureCpass = !_obscureCpass;
                    }),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Phone Number 
              TextField(
                controller: phoneC,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  errorText: phoneError ? "Phone number cannot be empty" : null,
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              // Register Button
              ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                ),
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
