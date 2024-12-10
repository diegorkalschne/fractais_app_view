import '../stores/maldebrot_store.dart';

final locator = Locator();

void setupLocator() {
  locator.registerSingleton<MandelbrotStore>(MandelbrotStore());
}

class Locator {
  final Map<String, dynamic> _instances = {};

  final Map<String, Function> _factories = {};

  String _getKey<T>({String? name}) {
    return '$T${name ?? ''}';
  }

  T call<T>({String? name}) {
    return get<T>(name: name);
  }

  T get<T>({String? name}) {
    final key = _getKey<T>(name: name);

    if (_instances.containsKey(key)) {
      return _instances[key];
    }

    if (_factories.containsKey(key)) {
      final instance = _factories[key]!();
      _instances[key] = instance;
      return instance;
    }

    throw Exception('Tipo $T não está registrado');
  }

  void registerSingleton<T>(T instance, {String? name}) {
    final key = _getKey<T>(name: name);

    _instances[key] = instance;
  }

  void registerLazySingleton<T>(T Function() factory, {String? name}) {
    final key = _getKey<T>(name: name);

    _factories[key] = factory;
  }

  void unregister<T>({String? name}) {
    final key = _getKey<T>(name: name);

    _instances.remove(key);
  }

  bool isRegistered<T>({String? name}) {
    final key = _getKey<T>(name: name);

    return _instances.containsKey(key);
  }
}
