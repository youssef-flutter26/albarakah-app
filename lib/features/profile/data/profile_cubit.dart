import 'package:alberaperfume/features/profile/data/profile_model.dart';
import 'package:alberaperfume/features/profile/data/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdatedSuccess extends ProfileState {}

// Cubit
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepository.getCurrentProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(ProfileModel updatedProfile) async {
    emit(ProfileUpdating());
    try {
      await profileRepository.updateProfile(updatedProfile);
      emit(ProfileUpdatedSuccess());
      fetchProfile(); // إعادة جلب البيانات المحدثة
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
