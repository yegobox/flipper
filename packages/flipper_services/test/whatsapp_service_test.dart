import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_services/whatsapp_service.dart';

// flutter test test/whatsapp_service_test.dart
// Mock classes
class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response<Map<String, dynamic>> {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late WhatsAppService whatsAppService;
  late MockDio mockDio;

  setUpAll(() {
    // Register fallback values
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = MockDio();
    whatsAppService = WhatsAppService(dio: mockDio);
  });

  group('WhatsAppService', () {
    const phoneNumberId = '123456789';
    const recipientPhone = '+1234567890';
    const messageBody = 'Test message';
    const replyToMessageId = 'msg_123';

    group('sendWhatsAppMessage', () {
      test('should send message successfully', () async {
        // Arrange
        final expectedResponse = {
          'messaging_product': 'whatsapp',
          'contacts': [
            {'input': recipientPhone, 'wa_id': recipientPhone}
          ],
          'messages': [
            {'id': 'wamid.123'}
          ]
        };

        final mockResponse = MockResponse();
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.data).thenReturn(expectedResponse);

        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await whatsAppService.sendWhatsAppMessage(
          phoneNumberId: phoneNumberId,
          recipientPhone: recipientPhone,
          messageBody: messageBody,
        );

        // Assert
        expect(result, equals(expectedResponse));
        expect(result['messages'], isNotNull);
        expect(result['messages'][0]['id'], equals('wamid.123'));

        verify(() => mockDio.post(
              'https://graph.facebook.com/v24.0/$phoneNumberId/messages',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).called(1);
      });

      test('should send message with reply context', () async {
        // Arrange
        final expectedResponse = {
          'messaging_product': 'whatsapp',
          'contacts': [
            {'input': recipientPhone, 'wa_id': recipientPhone}
          ],
          'messages': [
            {'id': 'wamid.456'}
          ]
        };

        final mockResponse = MockResponse();
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.data).thenReturn(expectedResponse);

        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await whatsAppService.sendWhatsAppMessage(
          phoneNumberId: phoneNumberId,
          recipientPhone: recipientPhone,
          messageBody: messageBody,
          replyToMessageId: replyToMessageId,
        );

        // Assert
        expect(result, equals(expectedResponse));

        final captured = verify(() => mockDio.post(
              any(),
              data: captureAny(named: 'data'),
              options: any(named: 'options'),
            )).captured;

        final requestData = captured.first as Map<String, dynamic>;
        expect(requestData['context'], isNotNull);
        expect(requestData['context']['message_id'], equals(replyToMessageId));
      });

      test('should handle 201 status code', () async {
        // Arrange
        final expectedResponse = {
          'messages': [
            {'id': 'wamid.789'}
          ]
        };

        final mockResponse = MockResponse();
        when(() => mockResponse.statusCode).thenReturn(201);
        when(() => mockResponse.data).thenReturn(expectedResponse);

        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await whatsAppService.sendWhatsAppMessage(
          phoneNumberId: phoneNumberId,
          recipientPhone: recipientPhone,
          messageBody: messageBody,
        );

        // Assert
        expect(result, equals(expectedResponse));
      });

      test('should throw exception on API error', () async {
        // Arrange
        final errorResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {
            'error': {
              'message': 'Invalid phone number',
              'type': 'OAuthException',
              'code': 100,
            }
          },
        );

        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: errorResponse,
        ));

        // Act & Assert
        expect(
          () => whatsAppService.sendWhatsAppMessage(
            phoneNumberId: phoneNumberId,
            recipientPhone: recipientPhone,
            messageBody: messageBody,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception on network error', () async {
        // Arrange
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Network error',
        ));

        // Act & Assert
        expect(
          () => whatsAppService.sendWhatsAppMessage(
            phoneNumberId: phoneNumberId,
            recipientPhone: recipientPhone,
            messageBody: messageBody,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('sendWhatsAppReply', () {
      test('should send reply successfully', () async {
        // Arrange
        final expectedResponse = {
          'messages': [
            {'id': 'wamid.reply123'}
          ]
        };

        final mockResponse = MockResponse();
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.data).thenReturn(expectedResponse);

        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await whatsAppService.sendWhatsAppReply(
          phoneNumberId: phoneNumberId,
          recipientPhone: recipientPhone,
          messageBody: messageBody,
          replyToMessageId: replyToMessageId,
        );

        // Assert
        expect(result, equals(expectedResponse));
      });
    });

    group('validatePhoneNumberId', () {
      test('should return true for valid phone number ID', () async {
        // Arrange
        final mockResponse = MockResponse();
        when(() => mockResponse.statusCode).thenReturn(200);

        when(() => mockDio.get(
              any(),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final result =
            await whatsAppService.validatePhoneNumberId(phoneNumberId);

        // Assert
        expect(result, isTrue);
      });

      test('should throw exception for invalid token', () async {
        // Arrange
        final errorResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
          data: {
            'error': {
              'message': 'Invalid OAuth access token',
              'type': 'OAuthException',
            }
          },
        );

        when(() => mockDio.get(
              any(),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: errorResponse,
        ));

        // Act & Assert
        expect(
          () => whatsAppService.validatePhoneNumberId(phoneNumberId),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Invalid WhatsApp token'),
            ),
          ),
        );
      });

      test('should throw exception for phone number not found', () async {
        // Arrange
        final errorResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
          data: {
            'error': {
              'message': 'Phone number not found',
            }
          },
        );

        when(() => mockDio.get(
              any(),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: errorResponse,
        ));

        // Act & Assert
        expect(
          () => whatsAppService.validatePhoneNumberId(phoneNumberId),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Phone number ID not found'),
            ),
          ),
        );
      });

      test('should throw exception on network error', () async {
        // Arrange
        when(() => mockDio.get(
              any(),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Connection timeout',
        ));

        // Act & Assert
        expect(
          () => whatsAppService.validatePhoneNumberId(phoneNumberId),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
