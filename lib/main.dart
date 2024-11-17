import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_riverpod/pages/home_page.dart';
import 'services/pokemon_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> di() async {
  GetIt.instance.registerLazySingleton<HttpServices>(
    () => HttpServices(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.quattrocentoSansTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}
