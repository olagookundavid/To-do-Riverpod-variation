import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providerclass.dart';

final providerClassProvider = ChangeNotifierProvider<ProviderClass>((ref) {
  return ProviderClass();
});

var todoProvider = StateProvider((ref) {
  final todo = ref.watch(providerClassProvider).todo;
  return todo;
});
