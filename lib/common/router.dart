import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_localizations.dart';

import '../data/repository/auth_repository.dart';
import '../ui/auth/login_page.dart';
import '../ui/auth/register_page.dart';
import '../ui/story/add_story_page.dart';
import '../ui/story/story_detail_page.dart';
import '../ui/story/story_list_page.dart';

GoRouter createRouter({required AuthRepository authRepo}) {
  return GoRouter(
    initialLocation: '/stories',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final loggedIn = await authRepo.isLoggedIn();
      final isOnAuth =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!loggedIn && !isOnAuth) return '/login';
      if (loggedIn && isOnAuth) return '/stories';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(
          onLoginSuccess: () => context.go('/stories'),
          onNavigateToRegister: () => context.go('/register'),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterPage(
          onRegisterSuccess: () => context.go('/login'),
          onNavigateToLogin: () => context.go('/login'),
        ),
      ),
      GoRoute(
        path: '/stories',
        builder: (context, state) => StoryListPage(
          onStoryTapped: (id) => context.push('/stories/$id'),
          onAddStory: () => context.push('/stories/add'),
          onLogout: () => context.go('/login'),
        ),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) =>
                AddStoryPage(onStoryUploaded: () => context.go('/stories')),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StoryDetailPage(storyId: id);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      final l10n = AppLocalizations.of(context);
      return Scaffold(
        body: Center(
          child: Text('${l10n.pageNotFound}: ${state.matchedLocation}'),
        ),
      );
    },
  );
}
