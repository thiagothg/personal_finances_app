import 'dart:async';
import 'dart:io';

import 'package:hive/hive.dart';

import '../interface/local_storage_interface.dart';

class LocalStorafeHive implements ILocalStorage {
  final Completer<Box> _instance = Completer<Box>();

  _init() async {
      var path = Directory.current.path;
      Hive.init(path);
      var box = Hive.openBox('open');
      _instance.complete(box);
  }

  LocalStorafeHive() {
    _init();
  }

  @override
  Future delete(String key) async {
    var box = await _instance.future;
    box.delete(key);
  }

  @override
  Future<List<String>> get(String key) async {
    var box = await _instance.future;
    return box.get(key);
  }
  
  @override
  Future put(String key, List<String> value) async {
    var box = await _instance.future;
    box.put(key, value);
  }

}