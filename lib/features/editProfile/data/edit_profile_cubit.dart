import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_profile_model.dart';
import 'edit_profile_repo.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final UserProfileModel profile;
  EditProfileSuccess(this.profile);
}

class EditProfileError extends EditProfileState {
  final String message;
  EditProfileError(this.message);
}

class EditProfileCubit extends Cubit<EditProfileState> {
  final EditProfileRepository repository;

  EditProfileCubit(this.repository) : super(EditProfileInitial());

  Future<void> updateFullProfile({
    required String name,
    required String email,
    required String phone,
    required EditAddressModel address,
  }) async {
    emit(EditProfileLoading());
    try {
      final updatedProfile = await repository.updateProfile(
        name: name,
        email: email,
        phone: phone,
        address: address,
      );
      emit(EditProfileSuccess(updatedProfile));
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }
}
