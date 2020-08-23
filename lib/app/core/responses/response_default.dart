


import '../enums/app_enums.dart';

class DefaultResponse<T> {
  final T object;
  final String message;
  final ResponseStatus status;

  bool get success => status == ResponseStatus.rsSuccess;
  bool get failed => failed == ResponseStatus.rsFalied;

  DefaultResponse({this.object, this.message, this.status});

}