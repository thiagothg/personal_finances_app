import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';
part 'auth_tokens.g.dart';

@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime accessExpiresAt,
    required DateTime refreshExpiresAt,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);

  const AuthTokens._();

  bool get isAccessExpired =>
      DateTime.now().isAfter(accessExpiresAt.subtract(const Duration(seconds: 30)));

  bool get isRefreshExpired => DateTime.now().isAfter(refreshExpiresAt);
}
