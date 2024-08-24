abstract class RouteNames {
  static const String root = '/';
  static const String productDetails = '/productDetails';
  static const String profileScreen = '/profileScreen';
}

extension StringRouteExt on String {
  String get asSubroute => replaceAll("/", "");
}
