import 'package:firebase_messaging/firebase_messaging.dart';
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
    if (token != null) sendToServer(token, "IOS_OR_ANDROID");
  }
}

void sendToServer(String _, String platform) {}
