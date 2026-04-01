import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
import 'screens/level_selection_screen.dart';
import 'screens/game_screen.dart';
import 'screens/result_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Death Star Defense',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: const ResponsiveWrapper(child: StartScreen()),
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/levels':
            page = const LevelSelectionScreen();
            break;
          case '/game':
            final args = settings.arguments as Map<String, dynamic>;
            page = GameScreen(level: args['level'] as int);
            break;
          case '/result':
            final args = settings.arguments as Map<String, dynamic>;
            page = ResultScreen(
              won: args['won'] as bool,
              level: args['level'] as int,
            );
            break;
          default:
            page = const StartScreen();
        }

        return MaterialPageRoute(
          builder: (_) => ResponsiveWrapper(child: page),
          settings: settings,
        );
      },
    );
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: child,
      ),
    );
  }
}
