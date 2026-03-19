import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances_app/domain/entities/user.dart';
import 'package:personal_finances_app/domain/repositories/auth_repository.dart';
import 'package:personal_finances_app/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testUser = User(id: '1', name: 'Test User', email: testEmail, token: 'test_token');

  group('LoginUseCase', () {
    test('should call repository.login with correct email and password', () async {
      when(
        () => mockRepository.login(email: testEmail, password: testPassword),
      ).thenAnswer((_) async => testUser);

      await loginUseCase(email: testEmail, password: testPassword);

      verify(() => mockRepository.login(email: testEmail, password: testPassword)).called(1);
    });

    test('should return User when login is successful', () async {
      when(
        () => mockRepository.login(email: testEmail, password: testPassword),
      ).thenAnswer((_) async => testUser);

      final result = await loginUseCase(email: testEmail, password: testPassword);

      expect(result, testUser);
    });

    test('should throw ArgumentError when email is empty', () async {
      expect(() => loginUseCase(email: '', password: testPassword), throwsA(isA<ArgumentError>()));
    });

    test('should throw ArgumentError when email format is invalid', () async {
      expect(
        () => loginUseCase(email: 'invalidemail', password: testPassword),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError when password is empty', () async {
      expect(() => loginUseCase(email: testEmail, password: ''), throwsA(isA<ArgumentError>()));
    });

    test('should throw ArgumentError when password is less than 6 characters', () async {
      expect(
        () => loginUseCase(email: testEmail, password: '12345'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw exception when repository throws', () async {
      when(
        () => mockRepository.login(email: testEmail, password: testPassword),
      ).thenThrow(Exception('Network error'));

      expect(
        () => loginUseCase(email: testEmail, password: testPassword),
        throwsA(isA<Exception>()),
      );
    });

    test('should accept password with exactly 6 characters', () async {
      const passwordWith6Chars = '123456';
      when(
        () => mockRepository.login(email: testEmail, password: passwordWith6Chars),
      ).thenAnswer((_) async => testUser);

      final result = await loginUseCase(email: testEmail, password: passwordWith6Chars);

      expect(result, testUser);
    });

    test('should accept valid email with subdomain', () async {
      const emailWithSubdomain = 'user@mail.example.com';
      when(
        () => mockRepository.login(email: emailWithSubdomain, password: testPassword),
      ).thenAnswer((_) async => testUser);

      final result = await loginUseCase(email: emailWithSubdomain, password: testPassword);

      expect(result, testUser);
    });
  });
}
