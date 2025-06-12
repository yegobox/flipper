import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';

class TinInputField extends StatefulWidget {
  final TextFieldBloc<String> tinNumberBloc;

  const TinInputField({
    Key? key,
    required this.tinNumberBloc,
  }) : super(key: key);

  @override
  _TinInputFieldState createState() => _TinInputFieldState();
}

class _TinInputFieldState extends State<TinInputField> {
  bool _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldBlocBuilder(
          textFieldBloc: widget.tinNumberBloc,
          decoration: InputDecoration(
            labelText: 'TIN Number',
            labelStyle: GoogleFonts.poppins(
              color: const Color(0xFF1A1F36),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: const Icon(
              Icons.numbers_outlined,
              size: 20,
              color: Color(0xFF1A1F36),
            ),
            suffixIcon: IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.upload_file_outlined,
                      size: 20,
                      color: Color(0xFF1A1F36),
                    ),
              onPressed: _isLoading ? null : _pickAndProcessPdf,
              tooltip: 'Upload PDF with TIN',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF006AFE)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            errorText: _errorText,
            hintText: 'Enter TIN number or tap the upload icon',
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          keyboardType: TextInputType.number,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1A1F36),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0, right: 12.0),
            child: Text(
              _errorText!,
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
