// ignore_for_file: unused_field

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

// import 'translates.dart';

import 'flavor.dart';

@singleton
class NotificationManager {
  NotificationManager(
    this._notificationPlugin,
    this._firebaseMessaging,
    this._flavor,
  );

  final FlutterLocalNotificationsPlugin _notificationPlugin;
  final FirebaseMessaging _firebaseMessaging;
  final Flavor _flavor;

  /// Инициализирует FirebaseMessaging
  @preResolve
  Future<void> setupNotifications() async {}

  /// Показывает уведомления в Foreground состоянии.
  Future<void> showHeadsUpNotification(RemoteMessage message) async {}
}
