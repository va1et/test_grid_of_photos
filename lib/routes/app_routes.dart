import 'package:flutter_text/presentation/app.dart';
import 'package:flutter_text/presentation/pages/photos_page.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter() => GoRouter(initialLocation: '/home', routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const PhotosScreen(),
      ),
    ]);
