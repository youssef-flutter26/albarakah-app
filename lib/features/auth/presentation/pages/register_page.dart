import 'package:alberaperfume/core/theme/app_theme.dart';
import 'package:alberaperfume/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/auth_cubit.dart';
import '../../data/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';
import 'package:alberaperfume/features/home/presentation/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.gold),
      ),
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
                      : "Account created successfully!"),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
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
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.gold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Enter your details to sign up",
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    CustomFormTextField(
                      controller: _nameController,
                      labelText: "Full Name",
                      hintText: "Your Full Name",
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
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
                      controller: _phoneController,
                      labelText: "Phone Number",
                      hintText: "+2010xxxxxxxx",
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
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
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 35),
                    state is AuthLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.gold,
                            ),
                          )
                        : CustomButton(
                            text: "Sign Up",
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().register(
                                      name: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      password: _passwordController.text,
                                    );
                              }
                            },
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
