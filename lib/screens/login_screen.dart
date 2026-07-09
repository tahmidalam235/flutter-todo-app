import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.task_alt,
                      size: 70,
                      color: Color(0xff2E8B72),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: passwordController,
                      obscureText: obscure,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          icon: Icon(
                            obscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          final emailController =
                          TextEditingController();

                          final email = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Forgot Password"),
                                content: TextField(
                                  controller: emailController,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Enter your email",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        emailController.text.trim(),
                                      );
                                    },
                                    child: const Text("Send"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (email == null || email.isEmpty) return;

                          try {
                            await AuthService().resetPassword(
                              email: email,
                            );

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Password reset link has been sent to your email.",
                                ),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.message ?? "Failed to send reset email.",
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Forgot Password?",
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading
                            ? null
                            : () async {
                          setState(() => loading = true);

                          try {
                            await AuthService().signIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                            setState(() => loading = false);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login successful."),
                                duration: Duration(milliseconds: 400),
                              ),
                            );

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const MainNavigationScreen(),
                              ),
                            );

                          } on FirebaseAuthException catch (e) {
                            setState(() => loading = false);

                            String message;

                            switch (e.code) {
                              case "user-not-found":
                                message = "No account found with this email.";
                                break;

                              case "wrong-password":
                              case "invalid-credential":
                                message = "Incorrect email or password.";
                                break;

                              case "invalid-email":
                                message = "Invalid email address.";
                                break;

                              default:
                                message = e.message ?? "Login failed.";
                            }

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        },
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text(
                          "Login",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}