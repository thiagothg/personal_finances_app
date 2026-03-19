import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances_app/domain/repositories/auth_repository.dart';
import 'package:personal_finances_app/domain/usecases/biometric_auth_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late BiometricAuthUseCase biometricAuthUseCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    biometricAuthUseCase = BiometricAuthUseCase(mockRepository);
  });

  group('BiometricAuthUseCase', () {
    group('canUseBiometrics', () {
      test('should return true when device supports and biometrics is enabled', () async {
        when(() => mockRepository.deviceSupportsBiometrics()).thenAnswer((_) async => true);
        when(() => mockRepository.canCheckBiometrics()).thenAnswer((_) async => true);
        when(() => mockRepository.isBiometricsEnabled()).thenAnswer((_) async => true);

        final result = await biometricAuthUseCase.canUseBiometrics();

        expect(result, true);
      });

      test('should return false when device does not support biometrics', () async {
        when(() => mockRepository.deviceSupportsBiometrics()).thenAnswer((_) async => false);
        when(() => mockRepository.canCheckBiometrics()).thenAnswer((_) async => true);
        when(() => mockRepository.isBiometricsEnabled()).thenAnswer((_) async => true);

        final result = await biometricAuthUseCase.canUseBiometrics();

        expect(result, false);
      });

      test('should return false when cannot check biometrics', () async {
        when(() => mockRepository.deviceSupportsBiometrics()).thenAnswer((_) async => true);
        when(() => mockRepository.canCheckBiometrics()).thenAnswer((_) async => false);
        when(() => mockRepository.isBiometricsEnabled()).thenAnswer((_) async => true);

        final result = await biometricAuthUseCase.canUseBiometrics();

        expect(result, false);
      });

      test('should return false when biometrics is disabled', () async {
        when(() => mockRepository.deviceSupportsBiometrics()).thenAnswer((_) async => true);
        when(() => mockRepository.canCheckBiometrics()).thenAnswer((_) async => true);
        when(() => mockRepository.isBiometricsEnabled()).thenAnswer((_) async => false);

        final result = await biometricAuthUseCase.canUseBiometrics();

        expect(result, false);
      });
    });

    group('authenticate', () {
      test('should return true when authentication succeeds', () async {
        when(
          () => mockRepository.authenticateWithBiometrics(reason: any(named: 'reason')),
        ).thenAnswer((_) async => true);

        final result = await biometricAuthUseCase.authenticate();

        expect(result, true);
      });

      test('should return false when authentication fails', () async {
        when(
          () => mockRepository.authenticateWithBiometrics(reason: any(named: 'reason')),
        ).thenAnswer((_) async => false);

        final result = await biometricAuthUseCase.authenticate();

        expect(result, false);
      });

      test('should return false when authentication throws exception', () async {
        when(
          () => mockRepository.authenticateWithBiometrics(reason: any(named: 'reason')),
        ).thenThrow(Exception('Biometric error'));

        final result = await biometricAuthUseCase.authenticate();

        expect(result, false);
      });

      test('should pass custom reason to repository', () async {
        const customReason = 'Authenticate for transaction';
        when(
          () => mockRepository.authenticateWithBiometrics(reason: customReason),
        ).thenAnswer((_) async => true);

        await biometricAuthUseCase.authenticate(reason: customReason);

        verify(() => mockRepository.authenticateWithBiometrics(reason: customReason)).called(1);
      });
    });

    group('enable and disable', () {
      test('should call enableBiometrics(true) when enable is called', () async {
        when(() => mockRepository.enableBiometrics(true)).thenAnswer((_) async {});

        await biometricAuthUseCase.enable();

        verify(() => mockRepository.enableBiometrics(true)).called(1);
      });

      test('should call enableBiometrics(false) when disable is called', () async {
        when(() => mockRepository.enableBiometrics(false)).thenAnswer((_) async {});

        await biometricAuthUseCase.disable();

        verify(() => mockRepository.enableBiometrics(false)).called(1);
      });
    });
  });
}
