import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../data/edit_profile_cubit.dart';
import '../data/edit_profile_model.dart';

class EditProfilePage extends StatefulWidget {
  final dynamic
      currentProfile; // جعلناها مرنة لتستقبل أي موديل بدون إجبار نوع معين

  const EditProfilePage({super.key, this.currentProfile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController line1Controller;
  late TextEditingController line2Controller;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;
  late TextEditingController regionController;

  @override
  void initState() {
    super.initState();
    final p = widget.currentProfile;

    nameController = TextEditingController(text: p?.name ?? '');
    emailController = TextEditingController(
        text: (p?.email != null && p.email.isNotEmpty) ? p.email : '');
    phoneController = TextEditingController(text: p?.phone ?? '');

    // التعامل الآمن مع العنوان سواء كان موجود أو لأ
    final addr = p?.address;
    line1Controller = TextEditingController(text: addr?.line1 ?? '');
    line2Controller = TextEditingController(text: addr?.line2 ?? '');
    cityController = TextEditingController(text: addr?.city ?? '');
    stateController = TextEditingController(text: addr?.state ?? '');
    postalCodeController = TextEditingController(text: addr?.postalCode ?? '');
    regionController = TextEditingController(text: addr?.region ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    line1Controller.dispose();
    line2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: AppTheme.ink,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'EDIT PROFILE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: AppTheme.gold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.gold),
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is EditProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                    controller: nameController,
                    label: 'Full Name',
                    icon: Icons.person_outline),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 24),
                const Text(
                  'Delivery Address',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gold),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                    controller: line1Controller,
                    label: 'Street Address (Line 1)',
                    icon: Icons.location_on_outlined),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: line2Controller,
                    label: 'Area / Street (Line 2)',
                    icon: Icons.map_outlined),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: cityController,
                    label: 'City',
                    icon: Icons.location_city_outlined),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: stateController,
                    label: 'State',
                    icon: Icons.public_outlined),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: postalCodeController,
                    label: 'Postal Code',
                    icon: Icons.pin_drop_outlined,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: regionController,
                    label: 'Region (e.g., IN)',
                    icon: Icons.flag_outlined),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: AppTheme.ink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: state is EditProfileLoading
                        ? null
                        : () {
                            final updatedAddress = EditAddressModel(
                              line1: line1Controller.text,
                              line2: line2Controller.text,
                              city: cityController.text,
                              state: stateController.text,
                              postalCode: postalCodeController.text,
                              region: regionController.text,
                            );

                            context.read<EditProfileCubit>().updateFullProfile(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  address: updatedAddress,
                                );
                          },
                    child: state is EditProfileLoading
                        ? const CircularProgressIndicator(color: AppTheme.ink)
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      cursorColor: AppTheme.gold,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: AppTheme.gold),
        filled: true,
        fillColor: const Color(0xFF1E1B18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.gold.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.gold, width: 2),
        ),
      ),
    );
  }
}
