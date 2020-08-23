import 'package:mobx/mobx.dart';

part 'welcome_controller.g.dart';

class WelcomeController = _WelcomeControllerBase with _$WelcomeController;

abstract class _WelcomeControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
