import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

import 'features/auth/data/datasources/firebase_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

import 'features/dashboard/data/datasources/sensor_remote_datasource.dart';
import 'features/dashboard/data/repositories/sensor_repository_impl.dart';
import 'features/dashboard/domain/repositories/sensor_repository.dart';
import 'features/dashboard/presentation/providers/sensor_provider.dart';

import 'features/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const SanctuaryApp());
}

/// Composition root: this is the ONLY place that wires concrete
/// Firebase-backed implementations into the abstract repositories the
/// rest of the app depends on. Swapping a backend later means editing
/// only this file.
class SanctuaryApp extends StatelessWidget {
  const SanctuaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Auth wiring -----------------------------------------------------
    final authDatasource = FirebaseAuthDatasource(FirebaseAuth.instance);
    final AuthRepository authRepository = AuthRepositoryImpl(authDatasource);

    // --- Sensor wiring -----------------------------------------------------
    final sensorDatasource = SensorRemoteDatasource(FirebaseDatabase.instance);
    final SensorRepository sensorRepository = SensorRepositoryImpl(sensorDatasource);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            repository: authRepository,
            signInUseCase: SignInUseCase(authRepository),
            signUpUseCase: SignUpUseCase(authRepository),
            signOutUseCase: SignOutUseCase(authRepository),
          ),
        ),
        ChangeNotifierProvider<SensorProvider>(
          create: (_) => SensorProvider(repository: sensorRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Sanctuary',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home:  SplashPage(),
      ),
    );
  }
}