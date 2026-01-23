import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/ippis_service.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import '../blocs/signup_form_bloc.dart';

class TinInputField extends StatefulWidget {
  final TextFieldBloc tinNumberBloc;
  final AsyncFieldValidationFormBloc? formBloc;
  final Function(bool isValid, bool isRelaxed)? onValidationResult;

  const TinInputField({
    Key? key,
    required this.tinNumberBloc,
    this.formBloc,
    this.onValidationResult,
  }) : super(key: key);

  @override
  _TinInputFieldState createState() => _TinInputFieldState();
}

class _TinInputFieldState extends State<TinInputField> {
  bool _isLoading = false;
  bool _isValidating = false;
  String? _errorText;

  Future<void> _pickAndProcessPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _errorText = null;
      });

      // Show file picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;

        // Extract TIN from PDF
        final pdfResult = await ProxyService.httpApi.extractCompanyInfoFromPdf(
          flipperHttpClient: ProxyService.http,
          filePath: filePath,
          fileName: 'tin_document.pdf',
        );

        // Extract TIN from the response
        final tin = pdfResult['Content']?['CompanyCode']?.toString();

        if (tin != null && tin.isNotEmpty) {
          // Update the form field with the extracted TIN
          widget.tinNumberBloc.updateValue(tin);
        } else {
          setState(() {
            _errorText = 'Could not extract TIN from the provided document';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorText = 'Error processing PDF: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _validateTin(String tin) async {
    setState(() {
      _isValidating = true;
      _errorText = null;
    });

    try {
      final ippisService = IppisService();
      final business = await ippisService.getBusinessDetails(tin);

      if (business != null) {
        if (mounted) {
          showSuccessNotification(
              context, 'TIN validated: ${business.taxPayerName}');

          // Update the username field with the taxpayer name if formBloc is available
          if (widget.formBloc != null) {
            widget.formBloc!.username.updateValue(business.taxPayerName);
          }

          widget.onValidationResult?.call(true, false);
        }
      } else {
        setState(() {
          _errorText = 'No data found for this TIN';
        });
        widget.onValidationResult?.call(false, false);
      }
    } catch (e) {
      if (e.toString().contains("Server Error")) {
        // Relax validation
        if (mounted) {
          showErrorNotification(
              context, 'Service Unavailable: Validation skipped');
          widget.onValidationResult?.call(false, true);
        }
      } else {
        setState(() {
          _errorText = 'Error validating TIN: ${e.toString()}';
        });
        widget.onValidationResult?.call(false, false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isValidating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldBlocBuilder(
          textFieldBloc: widget.tinNumberBloc,
          decoration: InputDecoration(
            labelText: 'TIN Number',
            labelStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: const Icon(
              Icons.numbers_outlined,
              size: 20,
              color: Colors.black87,
            ),
            suffixIcon: BlocBuilder<TextFieldBloc, TextFieldBlocState>(
              bloc: widget.tinNumberBloc,
              builder: (context, state) {
                final isVerified = (state.extraData is Map &&
                    (state.extraData as Map)['verified'] == true);

                if (isVerified && state.value.toString().isNotEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  );
                }

                if (state.value.toString().isNotEmpty) {
                  return TextButton(
                    onPressed: _isValidating
                        ? null
                        : () => _validateTin(state.value.toString()),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0078D4),
                      disabledForegroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: _isValidating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF0078D4)),
                            ),
                          )
                        : const Text('Validate',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                  );
                } else {
                  return IconButton(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.upload_file_outlined,
                            size: 20,
                            color: Colors.black87,
                          ),
                    onPressed: _isLoading ? null : _pickAndProcessPdf,
                    tooltip: 'Upload PDF with TIN',
                  );
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color(0xFF0078D4)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
            errorText: _errorText,
            hintText: 'Enter TIN number or tap the upload icon',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0, right: 12.0),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
