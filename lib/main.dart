import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:users_cubit/model/user_model.dart';
import 'package:users_cubit/repositories/user_repository.dart';
import 'package:users_cubit/screens/view/home_view.dart';
import 'package:users_cubit/services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(UserModelAdapter());
  await HiveService.instance.openBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users Cubit',
      theme: ThemeData(
        useMaterial3: true
      ),
      home: MultiRepositoryProvider(
        providers: [RepositoryProvider(create: (context) => UserRepository())],
        child: HomeView(),
      ),
    );
  }
}
