import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum FLNClickAction {
  chat;

  static FLNClickAction? fromString(String? clickAction) =>
      FLNClickAction.values
          .singleWhereOrNull((element) => element.name == clickAction);
}

enum FLNActionId {
  answerAction;

  static FLNActionId? fromString(String? actionId) => FLNActionId.values
      .singleWhereOrNull((element) => element.name == actionId);
}

///! Warn: this is a implementation of local notifications. Can't be used by self
/// to send push notifications to other device.
///
/// Instance of notification service from app
class LocalNotifications {
  // Flutter local notification
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    // initialise the plugin.
    // app_icon needs to be a added as a drawable resource to the Android head project
    const initializationSettingsAndroid =
            AndroidInitializationSettings('@app_icon'),
        initializationSettingsDarwin = DarwinInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            notificationCategories: [
              DarwinNotificationCategory(
                'push_notifications',
                options: {
                  DarwinNotificationCategoryOption.hiddenPreviewShowTitle
                },
              )
            ]);

    final initialized = await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      ),
      onDidReceiveNotificationResponse: onMessageResponse,
    );
    if (!(initialized ?? false)) return;
  }

  // Notification response listener
  static void onMessageResponse(
    NotificationResponse notificationResponse,
  ) async {
    if (notificationResponse.payload == null) return;

    final messageData = jsonDecode(notificationResponse.payload!),
        // actionId = FLNActionId.fromString(notificationResponse.actionId),
        clickAction = FLNClickAction.fromString(messageData['click_action']),
        tokenAuth = await SecureStorage.read(SecureCollection.tokenAuth);
    if (tokenAuth == null) return;

    notificationActionHandler(messageData, clickAction);

    await flutterLocalNotificationsPlugin.cancel(notificationResponse.id ?? 1);
  }

  static void notificationActionHandler(
    Map<String, dynamic> message,
    FLNClickAction? clickAction, [
    FLNActionId? actionId,
  ]) {
    log("click_action ⭕");
  }

  static Future<void> showNotification({
    String? title,
    String? body,
    String? imageUrl,
    String? avatarUrl,
    String? summaryText,
    String? payload,
  }) async {
    final uniqueId = UniqueKey();

    await flutterLocalNotificationsPlugin.show(
      uniqueId.hashCode,
      title,
      body,
      NotificationDetails(
        android: await _androidPlatformChannelSpecifics(
          title: title!,
          body: body!,
          imageUrl: imageUrl,
          avatarUrl: avatarUrl,
          summaryText: summaryText,
        ),
        iOS: await _iosPlatformChannelSpecifics(
          imageUrl: imageUrl,
          fileName: uniqueId.hashCode.toString(),
        ),
      ),
      payload: payload,
    );
  }

  static Future<AndroidNotificationDetails?> _androidPlatformChannelSpecifics({
    required String title,
    required String body,
    String? imageUrl,
    String? avatarUrl,
    String? summaryText,
  }) async {
    if (!Platform.isAndroid) return null;

    final avatarIcon = await buildAndroidBitmap(avatarUrl),
        imageIcon = await buildAndroidBitmap(imageUrl);

    // Create information style
    final styleInformation = imageIcon != null
            ? BigPictureStyleInformation(
                imageIcon,
                contentTitle: title,
                summaryText: summaryText,
              )
            : BigTextStyleInformation(
                body,
                contentTitle: title,
                summaryText: summaryText,
              ),

        // Create notification actions
        notificationActions = <AndroidNotificationAction>[
          // if (message.data['click_action'] == FLNClickAction.chat.name)
          //   AndroidNotificationAction(
          //     FLNActionId.answerAction.name,
          //     "Responder",
          //     showsUserInterface: true,
          //     inputs: [
          //       const AndroidNotificationActionInput(
          //           label: "Escribe una respuesta..")
          //     ],
          //   )
        ];

    return AndroidNotificationDetails(
      'push_notifications',
      'Push notifications',
      channelDescription:
          'This channel is used for firebase push notifications',
      color: const Color(0xFF02A6D0),
      icon: '@app_icon',
      largeIcon: avatarIcon,
      priority: Priority.high,
      importance: Importance.high,
      styleInformation: styleInformation,
      actions: notificationActions,
    );
  }

  // TODO here testing this
  static Future<DarwinNotificationDetails?> _iosPlatformChannelSpecifics({
    String? imageUrl,
    String fileName = 'image',
  }) async {
    if (!Platform.isIOS) return null;

    final savedImage = await downloadAndSavePicture(imageUrl, fileName),
        attachments = savedImage != null
            ? [DarwinNotificationAttachment(savedImage)]
            : null;

    return DarwinNotificationDetails(
      categoryIdentifier: 'push_notifications',
      threadIdentifier: 'Push notifications',
      presentAlert: true,
      presentSound: true,
      presentBanner: true,
      interruptionLevel: InterruptionLevel.active,
      attachments: attachments,
    );
  }
}
