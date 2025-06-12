import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_login/blocs/signup_form_bloc.dart';

/// UI components for the signup view
class SignupComponents {
  /// Build the header section with logo and title
  static Widget buildHeaderSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Image.asset(
            'assets/flipper_logo.png',
            height: 80,
          ),
        ),
        Text(
          'Create Your Account',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1F36),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Join Flipper to manage your business better',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF4F566B),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  /// Build an input field with consistent styling
  static Widget buildInputField({
    required TextFieldBloc fieldBloc,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? hint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFieldBlocBuilder(
        textFieldBloc: fieldBloc,
        suffixButton: SuffixButton.asyncValidating,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF006AFE)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF006AFE), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  /// Build a dropdown field with consistent styling
  static Widget buildDropdownField<T>({
    required SelectFieldBloc<T, dynamic> fieldBloc,
    required String label,
    required IconData icon,
    required FieldItemBuilder<T> itemBuilder,
    Function(T?)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownFieldBlocBuilder<T>(
        showEmptyItem: false,
        selectFieldBloc: fieldBloc,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF006AFE)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF006AFE), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        itemBuilder: itemBuilder,
        onChanged: onChanged,
      ),
    );
  }

  /// Build the submit button with loading state
  static Widget buildSubmitButton(
      AsyncFieldValidationFormBloc formBloc, bool isLoading) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : formBloc.submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006AFE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Create Account',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
