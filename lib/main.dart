import 'package:authentiction_flutter/src/core/secrets/app_secretes.dart';
import 'package:authentiction_flutter/src/core/theme/theme_data.dart';
import 'package:authentiction_flutter/src/features/auth/repository/auth_repository.dart';
import 'package:authentiction_flutter/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppSecret.url,
    anonKey: AppSecret.anonKey,
  );

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  MyApp({
    super.key,
    required this.sharedPreferences,
  });

  final supabase = Supabase.instance.client;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(supabase, googleSignIn),
        ),
        RepositoryProvider<FlutterSecureStorage>(
          create: (context) => const FlutterSecureStorage(),
        ),
        RepositoryProvider<SharedPreferences>(
          create: (context) => sharedPreferences,
        )
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
          secureStorage: context.read<FlutterSecureStorage>(),
          sharedPreferences: context.read<SharedPreferences>(),
        )..add(CheckAuthStatus()),
        child: MaterialApp(
          title: 'Authentication Flutter',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          initialRoute: '/',
          routes: routes,
        ),
      ),
    );
  }
}
