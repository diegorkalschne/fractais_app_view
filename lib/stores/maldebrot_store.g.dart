// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maldebrot_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MandelbrotStore on _MandelbrotStore, Store {
  late final _$futureAtom =
      Atom(name: '_MandelbrotStore.future', context: context);

  @override
  Future<File?>? get future {
    _$futureAtom.reportRead();
    return super.future;
  }

  @override
  set future(Future<File?>? value) {
    _$futureAtom.reportWrite(value, super.future, () {
      super.future = value;
    });
  }

  late final _$_MandelbrotStoreActionController =
      ActionController(name: '_MandelbrotStore', context: context);

  @override
  void setFuture(Future<File?> future) {
    final _$actionInfo = _$_MandelbrotStoreActionController.startAction(
        name: '_MandelbrotStore.setFuture');
    try {
      return super.setFuture(future);
    } finally {
      _$_MandelbrotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
future: ${future}
    ''';
  }
}
