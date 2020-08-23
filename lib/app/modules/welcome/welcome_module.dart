import 'package:flutter_modular/flutter_modular.dart';

import 'welcome_controller.dart';
import 'welcome_page.dart';

class WelcomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => WelcomeController()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => WelcomePage()),
      ];

  static Inject get to => Inject<WelcomeModule>.of();
}
