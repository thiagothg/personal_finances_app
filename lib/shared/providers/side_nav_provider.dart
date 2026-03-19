import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'side_nav_provider.g.dart';

@riverpod
class SideNavExpanded extends _$SideNavExpanded {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
