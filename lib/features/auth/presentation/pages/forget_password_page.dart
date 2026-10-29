import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/auth_cubit.dart';
import '../../data/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';
import 'otp_verfication_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
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
          listener: (context, state) {
            if (state is OtpSentState || state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Verification code sent via WhatsApp successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerificationPage(
                    phone: _phoneController.text.trim(),
                    purpose: 'forgot-password',
                  ),
                ),
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
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.gold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Enter your phone number and we'll send you a verification code on WhatsApp",
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    CustomFormTextField(
                      controller: _phoneController,
                      labelText: "Phone Number",
                      hintText: "010xxxxxxxx",
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
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
                            text: "Send Code via WhatsApp",
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().sendOtp(
                                      phone: _phoneController.text.trim(),
                                      purpose: 'forgot-password',
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
