import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationsPage(),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  //объект уведомления - экземпляр
  late FlutterLocalNotificationsPlugin localNotifications;

  @override
  void initState() {
    super.initState();
    //объект для Android настроек
    const androidInitialize = AndroidInitializationSettings('ic_launcher');
    //объект для IOS настроек
    const iOSInitialize = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    // общая инициализация
    const initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    //мы создаем локальное уведомление
    localNotifications = FlutterLocalNotificationsPlugin();
    localNotifications.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Нажми на кнопку, чтобы получить уведомление',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _cancelAllNotifications,
            child: const Text('Cancel notification'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _repeatNotification,
        child: const Icon(Icons.notifications),
      ),
    );
  }

  // Future<void> _showNotification() async {
  //   const androidDetails = AndroidNotificationDetails(
  //     "ID",
  //     "Название уведомления",
  //     importance: Importance.high,
  //     channelDescription: "Контент уведомления",
  //   );
  //   const iosDetails = DarwinNotificationDetails();
  //   const generalNotificationDetails = NotificationDetails(
  //     android: androidDetails,
  //     iOS: iosDetails,
  //   );
  //   await localNotifications.show(
  //     0,
  //     "Название",
  //     "Тело уведомления",
  //     generalNotificationDetails,
  //   );
  // }

  Future<void> _repeatNotification() async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'repeating channel id',
      'repeating channel name',
      importance: Importance.high,
      channelDescription: 'repeating description',
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosDetails,
    );
    await localNotifications.periodicallyShow(
      0,
      'Тук-тук',
      'Выдели полчаса на программирование!',
      RepeatInterval.daily,
      notificationDetails,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> _cancelAllNotifications() async {
    await localNotifications.cancelAll();
  }
}
