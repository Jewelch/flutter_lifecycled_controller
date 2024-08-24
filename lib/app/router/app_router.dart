import 'package:go_router/go_router.dart';
import 'package:tiny_architecture/modules/login/login_screen.dart';
import 'package:tiny_architecture/modules/product_details/product_details_screen.dart';
import 'package:tiny_architecture/modules/profile/profile_screen.dart';

import 'route_names.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: RouteNames.root,
        builder: (_, __) => LoginScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: RouteNames.productDetails.asSubroute,
            builder: (_, __) => const ProductDetailsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.profileScreen,
        builder: (_, __) => ProfileScreen(),
      ),
    ],
  );
}
