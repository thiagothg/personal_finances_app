import 'package:flutter_modular/flutter_modular.dart';

import '../../core/consts/routers_const.dart';
import 'login_controller.dart';
import 'login_page.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LoginController()),
      ];

  @override
  List<Router> get routers => [
        Router(RoutersConst.login, child: (_, args) => LoginPage()),
      ];

  static Inject get to => Inject<LoginModule>.of();
}
