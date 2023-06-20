import 'package:passwordly/ui/routes/route_argument_key.dart';

extension RouteArgumentMap on Map<RouteArgumentKey, dynamic> {
  T find<T>(RouteArgumentKey key, T defaultValue) {
    return containsKey(key) ? this[key] : defaultValue;
  }
}
