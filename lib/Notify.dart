// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'MyApp.dart';
// import 'package:timezone/data/latest.dart' as tz;
//
// class NotificationService {
//   static final NotificationService _notificationService = NotificationService._internal();
//
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   NotificationService._internal();
//
//   Future<void> initNotification () async {
//     final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app/src/main/res/mipmap-hdpi/ic_launcher.png');
//
//     final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   }
//
//   Future <void> showNotification(int id, String title, String body, int seconds) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//               'main_channel',
//               'mainchannel',
//               // 'Main channel notification',
//               importance: Importance.max,
//               priority: Priority.max,
//               icon: 'app/src/main/res/mipmap-hdpi/ic_launcher.png',
//         ),
//     ),
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
//     );
//
//   }
//
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationAPI {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails () async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            'channelId',
            'channelName',
            importance: Importance.max),
    );
  }

  static Future showNotification ({
    int id = 0,
    String ? title,
    String ? body,
    String ? payload,
}) async => _notification.show(
      id,
      title,
      body,
      await _notificationDetails (),
      payload: 'Default sound',
      );
}