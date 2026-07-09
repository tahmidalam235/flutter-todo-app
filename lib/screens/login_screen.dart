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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff121212)
          : const Color(0xffF6F7FB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              color: isDark
                  ? const Color(0xff1B1B1B)
                  : Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: .06)
                      : Colors.grey.withValues(alpha: .15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.task_alt,
                      size: 70,
                      color: Color(0xff2E8B72),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Sign in to continue managing your tasks",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? Colors.white60
                            : Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: emailController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : Colors.grey.shade700,
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: isDark
                              ? Colors.white70
                              : Colors.grey.shade700,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xff2A2A2A)
                            : const Color(0xffF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: passwordController,
                      obscureText: obscure,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : Colors.grey.shade700,
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: isDark
                              ? Colors.white70
                              : Colors.grey.shade700,
                        ),
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
                            color: isDark
                                ? Colors.white70
                                : Colors.grey.shade700,
                          ),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xff2A2A2A)
                            : const Color(0xffF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xff2E8B72),
                          padding: EdgeInsets.zero,
                        ),
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
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2E8B72),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
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
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
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