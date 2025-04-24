// ignore_for_file: unused_field

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

// import 'translates.dart';

@singleton
class NotificationManager {
  NotificationManager(
    this._notificationPlugin,
    this._firebaseMessaging,
  );

  final FlutterLocalNotificationsPlugin _notificationPlugin;
  final FirebaseMessaging _firebaseMessaging;

  /// Инициализирует FirebaseMessaging
  @preResolve
  Future<void> setupNotifications() async {}

  /// Показывает уведомления в Foreground состоянии.
  Future<void> showHeadsUpNotification(RemoteMessage message) async {}
}
