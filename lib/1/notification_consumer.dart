import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'notification_manager.dart';

@injectable
class NotificationConsumer {
  NotificationConsumer(this._notificationManager);

  final NotificationManager _notificationManager;

  void onLoggedIn() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _notificationManager.showHeadsUpNotification(message);
    });

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) sendToServer(token, _platform);
  }
}

/// Значения [platform]: ios, android, huawei
void sendToServer(String token, String platform) {}

String get _platform => switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ =>
        throw UnsupportedError('Unsupported platform $defaultTargetPlatform'),
    };
