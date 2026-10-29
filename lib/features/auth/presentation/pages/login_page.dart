import 'package:alberaperfume/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/auth_cubit.dart';
import '../../data/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';
import 'forget_password_page.dart';
import 'register_page.dart';
import 'package:alberaperfume/features/home/presentation/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is AuthSuccess) {
              final authState = state;
              String? token = authState.authModel.accessToken;

              if (token != null && token.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('auth_token', token);
                await prefs.setString('token', token);
                await prefs.setString('access_token', token);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authState.message.isNotEmpty
                      ? authState.message
                      : "Logged in successfully!"),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.grey,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          size: 60,
                          color: AppTheme.gold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.gold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Sign in to continue",
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    CustomFormTextField(
                      controller: _emailController,
                      labelText: "Email",
                      hintText: "example@gmail.com",
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomFormTextField(
                      controller: _passwordController,
                      labelText: "Password",
                      hintText: "********",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onSuffixIconPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    state is AuthLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.gold,
                            ),
                          )
                        : CustomButton(
                            text: "Login",
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().login(
                                      identifier: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    );
                              }
                            },
                          ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
