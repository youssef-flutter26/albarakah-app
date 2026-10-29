import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../data/shipping_cubit.dart';
import '../data/shipping_state.dart';

class ShippingAddressesPage extends StatelessWidget {
  const ShippingAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        title: const Text(
          'Shipping Addresses',
          style: TextStyle(
            color: AppTheme.gold,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.gold),
        centerTitle: true,
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<ShippingCubit, ShippingState>(
            listener: (context, state) {
              if (state is ShippingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.redAccent),
                );
              } else if (state is ShippingAddSuccess ||
                  state is ShippingUpdateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Address saved successfully'),
                      backgroundColor: Colors.green),
                );
              }
            },
            builder: (context, state) {
              var cubit = context.read<ShippingCubit>();

              if (state is ShippingLoading) {
                return const Center(
                    child: CircularProgressIndicator(color: AppTheme.gold));
              }

              if (cubit.addressesList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 72,
                        color: AppTheme.gold.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No addresses registered yet',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.gold,
                          foregroundColor: AppTheme.ink,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            _showAddressBottomSheet(context, cubit),
                        child: const Text(
                          'Add New Address',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: cubit.addressesList.length,
                itemBuilder: (context, index) {
                  final address = cubit.addressesList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.gold.withOpacity(0.25),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.ink,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppTheme.gold.withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.location_on_rounded,
                              color: AppTheme.gold, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                address.label?.isNotEmpty == true
                                    ? address.label!
                                    : 'Shipping Address',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${address.city ?? ''}, ${address.state ?? ''} - ${address.addressLine1 ?? ''}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Phone: ${address.phone ?? ''}',
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        if (address.isDefault == true)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.check_circle_rounded,
                                color: Colors.greenAccent, size: 20),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: Colors.redAccent, size: 22),
                          onPressed: () {
                            if (address.id != null) {
                              cubit.deleteAddress(address.id!);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.gold,
        foregroundColor: AppTheme.ink,
        elevation: 6,
        child: const Icon(Icons.add_rounded, size: 28),
        onPressed: () {
          final cubit = context.read<ShippingCubit>();
          _showAddressBottomSheet(context, cubit);
        },
      ),
    );
  }

  void _showAddressBottomSheet(BuildContext context, ShippingCubit cubit) {
    final labelController = TextEditingController();
    final fullNameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressLine1Controller = TextEditingController();
    final addressLine2Controller = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final postalCodeController = TextEditingController();
    final countryCodeController = TextEditingController(text: 'AE');
    bool isDefaultValue = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1B18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Shipping Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildTextField(labelController, 'Label (e.g. Home)'),
              const SizedBox(height: 12),
              _buildTextField(fullNameController, 'Full Name * (fullName)'),
              const SizedBox(height: 12),
              _buildTextField(phoneController, 'Phone * (phone)',
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              _buildTextField(
                  addressLine1Controller, 'Address Line 1 * (addressLine1)'),
              const SizedBox(height: 12),
              _buildTextField(
                  addressLine2Controller, 'Address Line 2 (addressLine2)'),
              const SizedBox(height: 12),
              _buildTextField(cityController, 'City * (city)'),
              const SizedBox(height: 12),
              _buildTextField(stateController, 'State * (state)'),
              const SizedBox(height: 12),
              _buildTextField(
                  postalCodeController, 'Postal Code * (postalCode)',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField(
                  countryCodeController, 'Country Code * (countryCode)'),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    foregroundColor: AppTheme.ink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (fullNameController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        addressLine1Controller.text.isEmpty ||
                        cityController.text.isEmpty ||
                        postalCodeController.text.isEmpty ||
                        countryCodeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all required fields'),
                            backgroundColor: Colors.redAccent),
                      );
                      return;
                    }

                    final body = {
                      "label": labelController.text,
                      "fullName": fullNameController.text,
                      "phone": phoneController.text,
                      "addressLine1": addressLine1Controller.text,
                      "addressLine2": addressLine2Controller.text,
                      "city": cityController.text,
                      "state": stateController.text,
                      "postalCode": postalCodeController.text,
                      "countryCode": countryCodeController.text,
                      "isDefault": isDefaultValue,
                    };

                    cubit.addAddress(body);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      cursorColor: AppTheme.gold,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
        filled: true,
        fillColor: AppTheme.ink,
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
