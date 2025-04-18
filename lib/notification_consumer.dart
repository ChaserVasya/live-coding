import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import 'notification_manager.dart';

@injectable
class NotificationConsumer {
  NotificationConsumer(this._notificationManager);

  final NotificationManager _notificationManager;

  void onLoggedIn() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _notificationManager.showHeadsUpNotification(message);
    });
  }
}
