// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goevent2/langauge_translate.dart';
import 'package:goevent2/spleshscreen.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  // await Firebase.initializeApp(
  //   name: 'your_app_name',
  //   options: FirebaseOptions(
  //     apiKey: 'your_api_key',
  //     appId: 'your_app_id',
  //     messagingSenderId: 'your_sender_id',
  //     projectId: 'your_project_id',
  //   ),
  // );
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //requestPermission();
  //listenFCM();
  //loadFCM();
  //initializeNotifications();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ColorNotifire())],
    child: GetMaterialApp(
      translations: LocaleString(),
      locale: const Locale('en_US', 'en_US'),
      title: 'GoEvent'.tr,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      theme: ThemeData(
          useMaterial3: false,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          dividerColor: Colors.transparent,
          // primarySwatch: Colors.blue,
          fontFamily: "Gilroy"),
      home: const Directionality(
          textDirection: TextDirection.ltr, // set this property
          child: Spleshscreen()),
      // home: SliverPersistentAppBar(),
    ),
  ));
}

// 9284798223
// 123

// NOTIFICATION CODE  :-----------------

// void requestPermission() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//   } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//     print('User granted provisional permission');
//   } else {
//     print('User declined or has not accepted permission');
//   }
// }
//
// late AndroidNotificationChannel channel;
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
// void listenFCM() async {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null && !kIsWeb) {
//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               //      one that already exists in example app.
//               icon: '@mipmap/ic_launcher',
//             ),
//             iOS: const IOSNotificationDetails(
//               presentAlert: true,
//               presentSound: true,
//               presentBadge: true,
//             ),
//           ),
//           payload: jsonEncode({
//             "name": message.data["name"],
//             "id": message.data["id"],
//             "propic": message.data["propic"]
//           }));
//     }
//   });
// }
//
// Future<void> initializeNotifications() async {
//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onSelectNotification: (String? payload) async {
//       if (payload != null) {
//         Map data = jsonDecode(payload);
//         // Navigate to the DetailPage when notification is clicked
//
//         Get.to(ChatPage(
//           proPic: data["propic"],
//           resiverUserId: data["id"],
//           resiverUseremail: data["name"],
//         ));
//       }
//     },
//   );
// }
//
// void loadFCM() async {
//   if (!kIsWeb) {
//     channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       importance: Importance.high,
//       enableVibration: true,
//     );
//
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//     /// Create an Android Notification Channel.
//     ///
//     /// We use this channel in the `AndroidManifest.xml` file to override the
//     /// default FCM channel to enable heads up notifications.
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     /// Update the iOS foreground notification presentation options to allow
//     /// heads up notifications.
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
