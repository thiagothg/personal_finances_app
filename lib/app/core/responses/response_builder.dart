import '../enums/app_enums.dart';
import '../interface/error_interceptor_interface.dart';
import 'response_default.dart';

class ResponseBuilder {
  static DefaultResponse failed<T>(
      {T object, String message, IErrorInterceptor errorInterceptor}) {
    return DefaultResponse<T>(
      object: object, message: message, status: ResponseStatus.rsFalied
    );
  }

  static DefaultResponse success<T>({T object, String message}) {
    return DefaultResponse<T>(
      object: object, message: message, status: ResponseStatus.rsSuccess
    );
  }
  
}