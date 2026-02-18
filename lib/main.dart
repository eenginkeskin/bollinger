import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:bollinger/data/services/notification_service.dart';
import 'package:bollinger/ui/app.dart';
import 'package:bollinger/ui/background/background_task_handler.dart';

const _backgroundTaskName = 'com.bollinger.backgroundTask';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return await backgroundTaskHandler();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.initialize();
    await NotificationService.requestPermission();
  } catch (_) {}

  try {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      _backgroundTaskName,
      _backgroundTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  } catch (_) {}

  runApp(const ProviderScope(child: BollingerApp()));
}
