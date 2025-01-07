import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegisterMode = false;

  Future<void> _submit() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    print('Email: $email, Password: $password');
    if (email.isEmpty || password.isEmpty) return;

    try {
      Map<String, dynamic> result;
      if (_isRegisterMode) {
        result = await ApiService.Register(email, password);
      } else {
        result = await ApiService.Login(email, password);
      }

      if (result.containsKey('token')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result['token']);

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegisterMode ? 'Register' : 'Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isRegisterMode ? 'Register' : 'Login'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegisterMode = !_isRegisterMode;
                });
              },
              child: Text(_isRegisterMode
                  ? 'Already have an account? Login'
                  : 'New user? Register'),
            )
          ],
        ),
      ),
    );
  }
}
