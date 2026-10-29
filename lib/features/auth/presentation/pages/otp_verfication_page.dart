import 'package:alberaperfume/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth_cubit.dart';
import '../../data/auth_state.dart';
import '../widgets/custom_button.dart';
import 'login_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phone;
  final String purpose;
  const OtpVerificationPage(
      {Key? key, required this.phone, required this.purpose})
      : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
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
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('OTP Verified Successfully!'),
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
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Verify Code",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter the verification code sent to ${widget.phone}",
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gold,
                    ),
                    cursorColor: AppTheme.gold,
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: const Color(0xFF1E1B18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppTheme.gold.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppTheme.gold.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.gold,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  state is AuthLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.gold,
                          ),
                        )
                      : CustomButton(
                          text: "Verify",
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_otpController.text.trim().isNotEmpty) {
                              context.read<AuthCubit>().verifyOtp(
                                    phone: widget.phone,
                                    otp: _otpController.text.trim(),
                                    purpose: widget.purpose,
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please enter a valid verification code'),
                                  backgroundColor: Colors.grey,
                                ),
                              );
                            }
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
