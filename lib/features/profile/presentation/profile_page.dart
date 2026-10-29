import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/pages/login_page.dart';
import '../../editProfile/presentation/edit_profile_page.dart';
import '../../my_order.dart/presentation/my_order_page.dart';
import '../../payment/presentation/payment_page.dart';
import '../../shippingAddresses/presentation/shipping_address_page.dart';
import '../data/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image selected successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1B18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppTheme.gold.withOpacity(0.3)),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.gold),
          ),
          content: const Text(
            'Are you sure you want to log out of your account?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.white60, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'MY PROFILE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: AppTheme.gold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.gold),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 50, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.gold),
                      onPressed: () =>
                          context.read<ProfileCubit>().fetchProfile(),
                      child: const Text('Retry',
                          style: TextStyle(color: AppTheme.ink)),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.ink,
                  Color(0xFF141210),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // قسم الصورة وزر التعديل بشكل مبهر
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _pickImageFromGallery(context),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.gold,
                                      AppTheme.gold.withOpacity(0.3)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.gold.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Color(0xFF1E1B18),
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 50,
                                    color: AppTheme.gold,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.gold,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt_rounded,
                                      size: 14, color: AppTheme.ink),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 38,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<ProfileCubit>(),
                                    child: const EditProfilePage(),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_rounded,
                                size: 14, color: AppTheme.ink),
                            label: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                  color: AppTheme.ink,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.gold,
                              elevation: 5,
                              shadowColor: AppTheme.gold.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // قائمة التنقل بتصميم فخم ومضاء بحدود ذهبية
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.gold.withOpacity(0.3), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildProfileItem(
                          icon: Icons.shopping_bag_outlined,
                          title: 'My Orders',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MyOrdersPage()),
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildProfileItem(
                          icon: Icons.location_on_outlined,
                          title: 'Shipping Addresses',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const ShippingAddressesPage()),
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildProfileItem(
                          icon: Icons.payment_outlined,
                          title: 'Payment ',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const PaymentMethodsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // زر تسجيل الخروج بتصميم متميز
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.redAccent.withOpacity(0.3), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: _buildProfileItem(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      textColor: Colors.redAccent,
                      iconColor: Colors.redAccent,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.white,
    Color iconColor = AppTheme.gold,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.ink,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: iconColor == Colors.redAccent ? Colors.redAccent : AppTheme.gold,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.gold.withOpacity(0.15),
      indent: 18,
      endIndent: 18,
    );
  }
}
