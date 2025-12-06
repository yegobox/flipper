import 'package:dio/dio.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/secrets.dart';

/// Service for interacting with WhatsApp Business API via Facebook Graph API
class WhatsAppService {
  static const String _baseUrl = AppSecrets.socialIntegrationUrl;
  final Dio _dio;

  WhatsAppService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 3),
            ));

  /// Safely extracts error message from dynamic response data
  /// Returns fallback message if structure is not a Map or missing 'error'/'message' keys
  String _extractErrorMessage(dynamic response,
      {String fallback = 'Unknown error'}) {
    if (response is! Map) {
      return fallback;
    }

    final errorMap = response['error'];
    if (errorMap is! Map) {
      return fallback;
    }

    final message = errorMap['message'];
    if (message is String) {
      return message;
    }

    return fallback;
  }

  /// Send a WhatsApp text message
  ///
  /// [phoneNumberId] - WhatsApp Business phone number ID
  /// [recipientPhone] - Recipient's phone number in international format
  /// [messageBody] - Text message content
  /// [replyToMessageId] - Optional message ID to reply to
  ///
  /// Returns the API response data
  /// Throws [Exception] on error
  Future<Map<String, dynamic>> sendWhatsAppMessage({
    required String phoneNumberId,
    required String recipientPhone,
    required String messageBody,
    String? replyToMessageId,
  }) async {
    try {
      final token = AppSecrets.whatsAppToken;

      final url = '$_baseUrl/$phoneNumberId/messages';

      final Map<String, dynamic> requestBody = {
        'messaging_product': 'whatsapp',
        'recipient_type': 'individual',
        'to': recipientPhone,
        'type': 'text',
        'text': {
          'preview_url': false,
          'body': messageBody,
        },
      };

      // Add context for reply
      if (replyToMessageId != null) {
        requestBody['context'] = {
          'message_id': replyToMessageId,
        };
      }
      talker.debug('Sending WhatsApp message: $requestBody');
      final response = await _dio.post(
        url,
        data: requestBody,
        options: Options(
          headers: {
            'Authorization':
                token.startsWith('Bearer ') ? token : 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to send message: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = _extractErrorMessage(e.response?.data);
        throw Exception('WhatsApp API error: $errorMessage');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  /// Send a reply to a WhatsApp message
  ///
  /// This is a convenience method that wraps sendWhatsAppMessage with reply context
  Future<Map<String, dynamic>> sendWhatsAppReply({
    required String phoneNumberId,
    required String recipientPhone,
    required String messageBody,
    required String replyToMessageId,
  }) async {
    return sendWhatsAppMessage(
      phoneNumberId: phoneNumberId,
      recipientPhone: recipientPhone,
      messageBody: messageBody,
      replyToMessageId: replyToMessageId,
    );
  }

  /// Validate WhatsApp phone number ID connection
  ///
  /// Returns true if the phone number ID is valid and accessible with current token
  /// Throws [Exception] on error
  Future<bool> validatePhoneNumberId(String phoneNumberId) async {
    try {
      final token = AppSecrets.whatsAppToken;

      final url = '$_baseUrl/$phoneNumberId';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization':
                token.startsWith('Bearer ') ? token : 'Bearer $token',
          },
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final errorMessage = _extractErrorMessage(
          e.response?.data,
          fallback: 'Invalid WhatsApp token',
        );
        throw Exception('Invalid WhatsApp token: $errorMessage');
      } else if (e.response?.statusCode == 404) {
        final errorMessage = _extractErrorMessage(
          e.response?.data,
          fallback: 'Phone number ID not found',
        );
        throw Exception('Phone number ID not found: $errorMessage');
      }
      throw Exception('Validation error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
