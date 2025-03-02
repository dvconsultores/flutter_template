import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
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

enum NotificationChannel {
  push(
    "push_notifications",
    "Push notifications",
    "This channel is used for firebase push notifications",
    Priority.high,
    Importance.high,
    "treassure",
  ),
  campaign(
    "campaign_notifications",
    "Campaign notifications",
    "This channel is used for firebase campaign notifications",
    Priority.low,
    Importance.low,
    "treassure",
  );

  const NotificationChannel(
    this.id,
    this.nameText,
    this.descriptionText,
    this.priority,
    this.importance,
    this.sound,
  );
  final String id;
  final String nameText;
  final String descriptionText;
  final Priority priority;
  final Importance importance;
  final String? sound;

  static NotificationChannel get(String channel) =>
      values.singleWhere((element) => element.name == channel);
}

///! Warn: this is a implementation of local notifications. Can't be used by self
/// to send push notifications to other device.
///
/// Instance of notification service from app
class LocalNotifications {
  // Flutter local notification
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Topics registered
  static const globalTopic = "global", testingTopic = "testing";

  static bool haveTopics(String? from) => [globalTopic, testingTopic]
      .any((value) => from?.contains(value) ?? false);

  static Future<void> initializeNotifications() async {
    // initialise the plugin.
    // app_icon needs to be a added as a drawable resource to the Android head project
    final initializationSettingsAndroid =
            const AndroidInitializationSettings('@app_icon'),
        initializationSettingsDarwin = DarwinInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            notificationCategories: [
              DarwinNotificationCategory(
                NotificationChannel.campaign.id,
                options: {
                  DarwinNotificationCategoryOption.allowInCarPlay,
                },
              ),
              DarwinNotificationCategory(
                NotificationChannel.push.id,
                options: {
                  DarwinNotificationCategoryOption.allowAnnouncement,
                  DarwinNotificationCategoryOption.allowInCarPlay,
                },
              )
            ]);

    final initialized = await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
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
    String? from,
    FLNClickAction? clickAction,
    bool isCampaign = false,
  }) async {
    final uniqueId = UniqueKey();

    final channel =
        NotificationChannel.get(haveTopics(from) ? 'campaign' : 'push');

    await flutterLocalNotificationsPlugin.show(
      uniqueId.hashCode,
      title,
      body,
      NotificationDetails(
        android: await androidPlatformChannelSpecifics(
          title: title!,
          body: body!,
          imageUrl: imageUrl,
          avatarUrl: avatarUrl,
          summaryText: summaryText,
          clickAction: clickAction,
          channel: channel,
        ),
        iOS: await iosPlatformChannelSpecifics(
          imageUrl: imageUrl,
          subtitle: summaryText,
          channel: channel,
        ),
      ),
      payload: payload,
    );

    if (!kIsWeb && Platform.isAndroid) {
      await showGroupNotification(
        summaryText: summaryText,
        channel: channel,
      );
    }
  }

  static Future<void> showGroupNotification({
    String? summaryText,
    required NotificationChannel channel,
  }) async {
    final groupKey = summaryText.hashCode.toString(),
        activeNotifications = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getActiveNotifications(),
        groupNotifications =
            activeNotifications?.where((e) => e.groupKey == groupKey);

    final styleInformation = InboxStyleInformation(
      groupNotifications!.map((e) => e.title!).toList(),
      summaryText:
          "${groupNotifications.length - 1} ${summaryText ?? 'Updates'}",
    );

    final groupNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.nameText,
      channelDescription: channel.descriptionText,
      sound: channel.sound != null
          ? RawResourceAndroidNotificationSound(channel.sound)
          : null,
      enableLights: true,
      channelShowBadge: channel.name != 'campaign',
      color: const Color.fromRGBO(6, 71, 125, 1),
      styleInformation: styleInformation,
      groupKey: groupKey,
      setAsGroupSummary: true,
      // onlyAlertOnce: true,
    );

    await flutterLocalNotificationsPlugin.show(groupKey.toInt(), '', '',
        NotificationDetails(android: groupNotificationDetails));
  }

  static Future<AndroidNotificationDetails?> androidPlatformChannelSpecifics({
    required String title,
    required String body,
    String? imageUrl,
    String? avatarUrl,
    String? summaryText,
    FLNClickAction? clickAction,
    required NotificationChannel channel,
  }) async {
    if (kIsWeb || !Platform.isAndroid) return null;

    final avatarIcon =
            await buildAndroidBitmap(avatarUrl, size: const Size(50, 50)),
        imageIcon = await buildAndroidBitmap(imageUrl),
        groupKey = summaryText.hashCode.toString();

    // Create information style
    final styleInformation = imageIcon != null
            ? BigPictureStyleInformation(
                imageIcon,
                contentTitle: title,
                summaryText: body,
              )
            : BigTextStyleInformation(
                body,
                contentTitle: title,
                summaryText: summaryText,
              ),

        // Create notification actions
        notificationActions = <AndroidNotificationAction>[
          if (clickAction == FLNClickAction.chat)
            AndroidNotificationAction(
                FLNActionId.answerAction.name, "Responder",
                showsUserInterface: true,
                inputs: [
                  const AndroidNotificationActionInput(
                      label: "Escribe una respuesta..")
                ])
        ];

    return AndroidNotificationDetails(
      channel.id,
      channel.nameText,
      channelDescription: channel.descriptionText,
      subText: summaryText,
      color: const Color(0xFF02A6D0),
      largeIcon: avatarIcon,
      priority: channel.priority,
      importance: channel.importance,
      sound: channel.sound != null
          ? RawResourceAndroidNotificationSound(channel.sound)
          : null,
      enableLights: true,
      channelShowBadge: channel.name != 'campaign',
      styleInformation: styleInformation,
      actions: notificationActions,
      groupKey: groupKey,
    );
  }

  static Future<DarwinNotificationDetails?> iosPlatformChannelSpecifics({
    String? imageUrl,
    String? subtitle,
    required NotificationChannel channel,
  }) async {
    if (kIsWeb || !Platform.isIOS) return null;

    final savedImage = await downloadAndSavePicture(imageUrl),
        attachments = savedImage != null
            ? [DarwinNotificationAttachment(savedImage)]
            : null;

    return DarwinNotificationDetails(
      categoryIdentifier: channel.id,
      presentAlert: true,
      presentSound: true,
      presentBanner: true,
      sound: channel.sound != null ? '${channel.sound}.aiff' : null,
      interruptionLevel: channel.name == 'campaign'
          ? InterruptionLevel.passive
          : InterruptionLevel.active,
      attachments: attachments,
      threadIdentifier: subtitle?.hashCode.toString(),
      subtitle: subtitle,
    );
  }
}
