import 'package:flipper_web/models/business_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class SignupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupUsernameChanged extends SignupEvent {
  final String username;
  SignupUsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class SignupFullNameChanged extends SignupEvent {
  final String fullName;
  SignupFullNameChanged(this.fullName);

  @override
  List<Object> get props => [fullName];
}

class SignupBusinessTypeChanged extends SignupEvent {
  final BusinessType businessType;
  SignupBusinessTypeChanged(this.businessType);

  @override
  List<Object> get props => [businessType];
}

class SignupTinNumberChanged extends SignupEvent {
  final String tinNumber;
  SignupTinNumberChanged(this.tinNumber);

  @override
  List<Object> get props => [tinNumber];
}

class SignupCountryChanged extends SignupEvent {
  final String country;
  SignupCountryChanged(this.country);

  @override
  List<Object> get props => [country];
}

class SignupSubmitted extends SignupEvent {}

// State
class SignupState extends Equatable {
  final String username;
  final bool isUsernameValid;
  final String fullName;
  final bool isFullNameValid;
  final BusinessType? businessType;
  final bool isBusinessTypeValid;
  final String tinNumber;
  final bool isTinNumberValid;
  final String country;
  final bool isCountryValid;
  final bool isFormValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const SignupState({
    this.username = '',
    this.isUsernameValid = false,
    this.fullName = '',
    this.isFullNameValid = false,
    this.businessType,
    this.isBusinessTypeValid = false,
    this.tinNumber = '',
    this.isTinNumberValid = true, // TIN is optional for some business types
    this.country = 'Rwanda',
    this.isCountryValid = true,
    this.isFormValid = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  SignupState copyWith({
    String? username,
    bool? isUsernameValid,
    String? fullName,
    bool? isFullNameValid,
    BusinessType? businessType,
    bool? isBusinessTypeValid,
    String? tinNumber,
    bool? isTinNumberValid,
    String? country,
    bool? isCountryValid,
    bool? isFormValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SignupState(
      username: username ?? this.username,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      fullName: fullName ?? this.fullName,
      isFullNameValid: isFullNameValid ?? this.isFullNameValid,
      businessType: businessType ?? this.businessType,
      isBusinessTypeValid: isBusinessTypeValid ?? this.isBusinessTypeValid,
      tinNumber: tinNumber ?? this.tinNumber,
      isTinNumberValid: isTinNumberValid ?? this.isTinNumberValid,
      country: country ?? this.country,
      isCountryValid: isCountryValid ?? this.isCountryValid,
      isFormValid: isFormValid ?? this.isFormValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    username,
    isUsernameValid,
    fullName,
    isFullNameValid,
    businessType,
    isBusinessTypeValid,
    tinNumber,
    isTinNumberValid,
    country,
    isCountryValid,
    isFormValid,
    isSubmitting,
    isSuccess,
    errorMessage,
  ];
}

// Bloc
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<SignupUsernameChanged>(_onUsernameChanged);
    on<SignupFullNameChanged>(_onFullNameChanged);
    on<SignupBusinessTypeChanged>(_onBusinessTypeChanged);
    on<SignupTinNumberChanged>(_onTinNumberChanged);
    on<SignupCountryChanged>(_onCountryChanged);
    on<SignupSubmitted>(_onSubmitted);
  }

  void _onUsernameChanged(
    SignupUsernameChanged event,
    Emitter<SignupState> emit,
  ) {
    final username = event.username;
    final isUsernameValid = username.length >= 4;

    emit(
      state.copyWith(
        username: username,
        isUsernameValid: isUsernameValid,
        isFormValid: _isFormValid(
          username: username,
          isUsernameValid: isUsernameValid,
          isFullNameValid: state.isFullNameValid,
          isBusinessTypeValid: state.isBusinessTypeValid,
          isTinNumberValid: state.isTinNumberValid,
          isCountryValid: state.isCountryValid,
        ),
      ),
    );
  }

  void _onFullNameChanged(
    SignupFullNameChanged event,
    Emitter<SignupState> emit,
  ) {
    final fullName = event.fullName;
    final isFullNameValid = fullName.trim().split(' ').length >= 2;

    emit(
      state.copyWith(
        fullName: fullName,
        isFullNameValid: isFullNameValid,
        isFormValid: _isFormValid(
          isUsernameValid: state.isUsernameValid,
          isFullNameValid: isFullNameValid,
          isBusinessTypeValid: state.isBusinessTypeValid,
          isTinNumberValid: state.isTinNumberValid,
          isCountryValid: state.isCountryValid,
        ),
      ),
    );
  }

  void _onBusinessTypeChanged(
    SignupBusinessTypeChanged event,
    Emitter<SignupState> emit,
  ) {
    final businessType = event.businessType;
    // ignore: unnecessary_null_comparison
    final isBusinessTypeValid = businessType != null;

    // TIN is not required for business type with id "2" (as in the original implementation)
    final needsTin = businessType.id != "2";
    final isTinNumberValid = !needsTin || (state.tinNumber.length >= 9);

    emit(
      state.copyWith(
        businessType: businessType,
        isBusinessTypeValid: isBusinessTypeValid,
        isTinNumberValid: isTinNumberValid,
        isFormValid: _isFormValid(
          isUsernameValid: state.isUsernameValid,
          isFullNameValid: state.isFullNameValid,
          isBusinessTypeValid: isBusinessTypeValid,
          isTinNumberValid: isTinNumberValid,
          isCountryValid: state.isCountryValid,
        ),
      ),
    );
  }

  void _onTinNumberChanged(
    SignupTinNumberChanged event,
    Emitter<SignupState> emit,
  ) {
    final tinNumber = event.tinNumber;
    // TIN is not required for business type with id "2"
    final needsTin = state.businessType?.id != "2";
    final isTinNumberValid = !needsTin || (tinNumber.length >= 9);

    emit(
      state.copyWith(
        tinNumber: tinNumber,
        isTinNumberValid: isTinNumberValid,
        isFormValid: _isFormValid(
          isUsernameValid: state.isUsernameValid,
          isFullNameValid: state.isFullNameValid,
          isBusinessTypeValid: state.isBusinessTypeValid,
          isTinNumberValid: isTinNumberValid,
          isCountryValid: state.isCountryValid,
        ),
      ),
    );
  }

  void _onCountryChanged(
    SignupCountryChanged event,
    Emitter<SignupState> emit,
  ) {
    final country = event.country;
    final isCountryValid = country.isNotEmpty;

    emit(
      state.copyWith(
        country: country,
        isCountryValid: isCountryValid,
        isFormValid: _isFormValid(
          isUsernameValid: state.isUsernameValid,
          isFullNameValid: state.isFullNameValid,
          isBusinessTypeValid: state.isBusinessTypeValid,
          isTinNumberValid: state.isTinNumberValid,
          isCountryValid: isCountryValid,
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (!state.isFormValid) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      // Here you would typically call your API to register the user
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  bool _isFormValid({
    String? username,
    bool? isUsernameValid,
    bool? isFullNameValid,
    bool? isBusinessTypeValid,
    bool? isTinNumberValid,
    bool? isCountryValid,
  }) {
    return (isUsernameValid ?? state.isUsernameValid) &&
        (isFullNameValid ?? state.isFullNameValid) &&
        (isBusinessTypeValid ?? state.isBusinessTypeValid) &&
        (isTinNumberValid ?? state.isTinNumberValid) &&
        (isCountryValid ?? state.isCountryValid);
  }
}
