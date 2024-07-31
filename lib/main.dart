import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Ensure navigator key is provided
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final filePath = await getPath();
  log(filePath);

  CatcherOptions debugOptions = CatcherOptions(
    DialogReportMode(),
    [
      FileHandler(
        File(filePath),
        printLogs: true,
      )
    ],
    localizationOptions: [LocalizationOptions.buildDefaultEnglishOptions()],
  );

  CatcherOptions releaseOptions = CatcherOptions(
    DialogReportMode(),
    [
      FileHandler(
        File(filePath),
        printLogs: true,
      )
    ],
    localizationOptions: [LocalizationOptions.buildDefaultEnglishOptions()],
  );

  Catcher(
    rootWidget: const Home(),
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
    navigatorKey: navigatorKey,
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Screen(),
      navigatorKey: Catcher.navigatorKey, // Provide navigator key here
    );
  }
}

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            Catcher.reportCheckedError('error', 'stackTrace');
            int.parse('lkdsjfk'); // This will cause a FormatException
            // throw Exception("This is a test crash!");
          },
          child: const Text('Crash'),
        ),
      ),
    );
  }
}

Future<String> getPath() async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = path.join(directory.path, 'log.txt');
  final file = File(filePath);
  if (!await file.exists()) {
    await file.create();
  }
  print(await file.exists());
  return file.path;
}
