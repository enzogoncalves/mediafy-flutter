import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mediafy/router/app_module.dart';
import 'package:mediafy/router/pages_name.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future main() async {
  await _preload();
  runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    (const AssetImage("assets/welcome-image.svg"), context);
    return MaterialApp.router(
      routerConfig: Modular.routerConfig,
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> _preload() async {
  WidgetsFlutterBinding.ensureInitialized();
  const loader = SvgAssetLoader("assets/welcome-image.svg");
  svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  await dotenv.load(fileName: ".env");
  Modular.setInitialRoute(PagesName.splash);
}
