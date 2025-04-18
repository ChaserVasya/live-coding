import 'dart:developer' as dev;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:live_coding/1/translates.dart';

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

  @preResolve
  Future<void> setupNotifications() async {
    // Enables android heads-up notifications.
    for (AndroidNotificationChannel channel in _androidChannels.values) {
      await _notificationPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // Enables ios heads-up notifications.
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    switch (_flavor) {
      // The mobi server sends a notification info in the [data] field.
      // [data] field does not trigger FCM to show push.
      // https://yt.mobifitness.ru/youtrack/issue/TRN-881/V-MP-trenera-na-Android-ne-prihodyat-pushi#focus=Comments-4-78566.0-0
      case Flavor.mobifitness:
        FirebaseMessaging.onBackgroundMessage(
          _NotificationWorker.showDataBasedNotification,
        );
      case Flavor.fitness1c:
    }
  }

  Future<void> showHeadsUpNotification(RemoteMessage message) async {
    if (message.notification != null) {
      await _showNotificationBasedNotification(message);
      return;
    }
    await _NotificationWorker.showDataBasedNotification(message);
  }

  Future<void> _showNotificationBasedNotification(RemoteMessage message) async {
    final notification = message.notification;
    dev.log('Showing notification. data: $notification');
    if (notification == null) {
      return;
    }
    await _notificationPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      _getChannelNotificationDetails(AndroidChannelId.general),
    );
  }
}

// Separated functions into this class to emphasize that
// they should be autonomous
class _NotificationWorker {
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();

  @pragma('vm:entry-point')
  static Future<void> showDataBasedNotification(
    RemoteMessage notification,
  ) async {
    final data = notification.data;
    dev.log('Showing notification. data: $data');
    final String title = data['title'] ?? '';
    final String message = data['message'] ?? '';
    if (title.isEmpty && message.isEmpty) {
      return;
    }
    await _notificationPlugin.show(
      (title + message).hashCode,
      title.isNotEmpty ? title : tr.appName,
      message,
      _getChannelNotificationDetails(AndroidChannelId.general),
    );
  }
}

enum AndroidChannelId {
  general('general_notification_channel');

  final String id;

  const AndroidChannelId(this.id);
}

final _androidChannels = {
  AndroidChannelId.general: AndroidNotificationChannel(
    AndroidChannelId.general.id,
    tr.notificationChannelTitle,
    description: tr.notificationChannelMessage,
    importance: Importance.max,
  ),
};

NotificationDetails _getChannelNotificationDetails(
  AndroidChannelId androidChannelId,
) {
  final channel = _androidChannels[androidChannelId]!;
  return NotificationDetails(
    android: AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      icon: 'ic_notification',
    ),
  );
}
