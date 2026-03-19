# Authentication Feature - Login Implementation

## Overview
Complete login feature implementation for Personal Finances App, including email/password authentication, biometric support, and persistent token storage.

## Architecture

### Domain Layer
**Location**: `lib/domain/`

#### Entities
- `User`: Represents authenticated user with id, name, email, and token
- `LoginRequest`: Email and password input wrapper
- `AuthToken`: Access token with expiration metadata

#### Use Cases
1. **LoginUseCase** (`login_usecase.dart`)
   - Validates email format (must contain @)
   - Validates password (min 6 characters)
   - Delegates login to repository
   - Throws ArgumentError on validation failure

2. **BiometricAuthUseCase** (`biometric_auth_usecase.dart`)
   - Checks device biometric support and enablement
   - Triggers biometric authentication
   - Manages biometric enable/disable

#### Repositories (Abstract)
- `AuthRepository`: Interface defining login, token management, PIN, and biometric contracts

### Data Layer
**Location**: `lib/data/`

#### Datasources
1. **AuthRemoteDatasource**: Handles API communication
   - POST `/api/login` with email/password
   - Returns UserModel with access_token
   - Error handling via DioException

2. **LocalTokenDatasource**: Manages token persistence
   - Stores/retrieves tokens via FlutterSecureStorage
   - Atomic read/write operations

3. **BiometricDatasource**: Wraps local_auth functionality
   - Device capability checks
   - Authentication trigger
   - Error handling for unsupported devices

#### Models
- **UserModel**: Freezed immutable model with JSON serialization
  - Maps API field `access_token` to domain entity
  - Includes `toDomain()` mapper to User entity

#### Repositories (Concrete)
- **AuthRepositoryImpl**: Implements AuthRepository interface
  - Coordinates datasources
  - Stores token automatically on successful login
  - Clears token on logout

### Presentation Layer
**Location**: `lib/features/auth/`

#### Providers
1. **DataSource Providers** (`providers/datasource_providers.dart`)
   - Dio instance
   - AuthRemoteDatasource
   - LocalTokenDatasource
   - BiometricDatasource
   - FlutterSecureStorage
   - LocalAuthentication

2. **Use Case Providers** (`providers.dart`)
   - LoginUseCaseProvider
   - BiometricAuthUseCaseProvider

3. **State Controllers**
   - **LoginController** (@riverpod async)
     - Manages login flow state
     - Handles loading and error states via AsyncValue
     - Calls LoginUseCase and stores token

   - **BiometricAuthController** (@riverpod async)
     - Manages biometric authentication state
     - Checks device capability
     - Returns authentication result

   - **AuthController** (Notifier<AuthState>)
     - Centralsyncs auth state across app
     - Restores user from stored token on app startup
     - Manages PIN setup and biometric settings
     - Handles logout and token clearing

#### Pages
- **LoginPage** (ConsumerStatefulWidget)
  - Email input with validation feedback
  - Password input with show/hide toggle
  - Login button with loading state
  - Biometric button (conditionally displayed)
  - Error handling via SelectableText.rich (red, scrollable)
  - Forgot Password link (placeholder)

### Routing
**Location**: `lib/core/router/`

#### GoRouter Configuration
- `/login`: LoginPage
- Redirect logic:
  - Unknown status → splash screen
  - Unauthenticated + not on login/splash → `/login`
  - Authenticated + on login/splash → `/`
  - Authenticated → `/` (dashboard)

## Data Flow

### Login Flow
```
LoginPage (user enters credentials)
  ↓
ref.read(loginControllerProvider.notifier).login(email, pwd)
  ↓
LoginController.login()
  → AsyncValue.loading
  ↓
LoginUseCase(email, password)
  → Validates email & password
  ↓
AuthRepository.login(email, password)
  ↓
AuthRemoteDatasource.login()
  → POST /api/login
  → Response: { access_token, user: { id, email, name } }
  ↓
UserModel → User (domain entity)
  ↓
AuthRepositoryImpl.storeToken(token)
  → FlutterSecureStorage.write('auth_access_token', token)
  ↓
LoginPage watches loginControllerProvider
  → Navigates to '/' (dashboard) on success
  → Displays error on failure
```

### Persistent Login Restoration
```
App startup
  ↓
AuthController._init()
  ↓
AuthRepository.retrieveStoredToken()
  → FlutterSecureStorage.read('auth_access_token')
  ↓
If token exists:
  → Set AuthStatus.authenticated
  ↓
GoRouter watches AuthState
  → Redirect to dashboard
```

### Biometric Authentication
```
LoginPage (biometric button clicked)
  ↓
BiometricAuthController.authenticate()
  ↓
BiometricUseCase.authenticate()
  → BiometricRepository.authenticateWithBiometrics()
  → local_auth.authenticate(reason: "...")
  ↓
If authenticated:
  → AuthController updates status
  → GoRouter redirects to '/'
```

## API Contract

### POST /api/login

**Request**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (Success 200)**:
```json
{
  "data": {
    "id": "123",
    "name": "User Name",
    "email": "user@example.com",
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Response (Error 401)**:
```json
{
  "message": "Invalid email or password"
}
```

## Validation Rules

### Email
- Non-empty
- Contains @ symbol
- Contains domain (. after @)

### Password
- Non-empty
- Minimum 6 characters

## Storage

### FlutterSecureStorage Keys
- `auth_access_token`: User's access token (encrypted)
- `user_pin_hash`: SHA-256 hash of 4-digit PIN
- `biometric_enabled`: '1' or '0' flag

## Error Handling

### Client-Side Validation
- Email format validation: "Invalid email format"
- Password length validation: "Min. 6 characters"

### Server-Side Errors
- Displayed in red SelectableText.rich
- User can retry without clearing form

### Biometric Errors
- Device not supported: biometric button hidden
- Authentication failed: returns false, retry available
- Exceptions caught and logged

## Testing

### Unit Tests (19 passing)

**LoginUseCase Tests**:
- Email/password validation
- Valid login calls repository
- Invalid credentials rejected
- Exception handling

**BiometricAuthUseCase Tests**:
- Capability checks
- Authentication flow
- Enable/disable functionality
- Error resilience

**AuthRepositoryImpl Tests**:
- Login flow
- Token storage/retrieval/clearing
- Biometric settings

### Widget Tests (11 passing)

**LoginPage Tests**:
- Page renders with title
- Email/password fields present
- Password visibility toggle
- Login button present
- Forgot Password button
- Input acceptance
- Scrollable on small screens
- AppBar present

## Security Considerations

1. **Token Storage**: FlutterSecureStorage uses platform-level encryption (Keychain on iOS, Keystore on Android)
2. **Password**: Only transmitted to API over HTTPS (assumed)
3. **No Caching**: Tokens not cached in memory after app close
4. **PIN Hash**: Stored as SHA-256 hash, never plain text
5. **Biometric**: Uses device-level biometric authentication, no token needed for face/fingerprint

## Dependencies

- `flutter_riverpod`: State management
- `go_router`: Navigation
- `dio`: HTTP client
- `flutter_secure_storage`: Secure token storage
- `local_auth`: Biometric authentication
- `freezed_annotation`: Immutable models
- `json_serializable`: JSON parsing

## Future Enhancements

- [ ] Forgot password flow (email verification)
- [ ] Token refresh logic (refresh tokens)
- [ ] Multi-factor authentication (MFA)
- [ ] Social login (Google, Apple)
- [ ] Sign up / registration feature
- [ ] Remember device option
- [ ] Login history audit trail

## Troubleshooting

### Build Failures
```bash
# Regenerate code
flutter pub run build_runner build --delete-conflicting-outputs
```

### Token Persistence Issues
- Verify FlutterSecureStorage permissions in platform configs
- iOS: Check Keychain entitlements
- Android: Check AndroidManifest.xml permissions

### Biometric Authentication Fails
- Verify device supports biometric (check `deviceSupportsBiometrics()`)
- iOS: Enable Face ID/Touch ID in settings
- Android: Set up biometric in device security settings

## File Structure

```
lib/
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── login_request.dart
│   │   └── auth_token.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       └── biometric_auth_usecase.dart
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   ├── local_token_datasource.dart
│   │   └── biometric_datasource.dart
│   ├── models/
│   │   └── user_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
└── features/auth/
    ├── presentation/
    │   └── pages/
    │       └── login_page.dart
    └── providers/
        ├── datasource_providers.dart
        ├── login_provider.dart
        ├── biometric_auth_provider.dart
        └── providers.dart

test/
├── unit/
│   ├── usecases/
│   │   ├── login_usecase_test.dart
│   │   └── biometric_auth_usecase_test.dart
│   └── repositories/
│       └── auth_repository_impl_test.dart
└── widget/
    └── pages/
        └── login_page_test.dart
```

## Implementation Checklist

- [x] Domain layer: Entities, usecases, repository interface
- [x] Data layer: Datasources, models, repository impl
- [x] Providers: Datasource, usecase, state controllers
- [x] LoginPage UI with validation and error handling
- [x] Router integration with auth state guards
- [x] Unit tests (19/19 passing)
- [x] Widget tests (11/11 passing)
- [x] Build without errors
- [x] Token persistence
- [x] Biometric support
- [x] Documentation
