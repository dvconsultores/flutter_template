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

  /// Channels registered
  static const channelId = 'push_notifications',
      channelName = 'Push notifications',
      channelDescription =
          'This channel is used for firebase push notifications',
      campaignChannelId = 'campaign_notifications',
      campaignChannelName = 'Campaign notifications',
      campaignChannelDescription =
          'This channel is used for firebase campaign notifications';

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
    FLNClickAction? clickAction,
    bool isCampaign = false,
  }) async {
    final uniqueId = UniqueKey();

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
          isCampaign: isCampaign,
        ),
        iOS: await iosPlatformChannelSpecifics(
          imageUrl: imageUrl,
          fileName: (summaryText ?? title).hashCode.toString(),
          threadIdentifier: summaryText.hashCode.toString(),
          isCampaign: isCampaign,
        ),
      ),
      payload: payload,
    );

    if (Platform.isAndroid) {
      await showGroupNotification(
        summaryText: summaryText,
        isCampaign: isCampaign,
      );
    }
  }

  static Future<void> showGroupNotification({
    String? summaryText,
    bool isCampaign = false,
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
      summaryText: "${groupNotifications.length - 1} $summaryText",
    );

    final groupNotificationDetails = isCampaign
        ? AndroidNotificationDetails(
            campaignChannelId,
            campaignChannelName,
            channelDescription: campaignChannelDescription,
            styleInformation: styleInformation,
            setAsGroupSummary: true,
            groupKey: groupKey,
            // onlyAlertOnce: true,
          )
        : AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            styleInformation: styleInformation,
            setAsGroupSummary: true,
            groupKey: groupKey,
            // onlyAlertOnce: true,
          );

    await flutterLocalNotificationsPlugin.show(
        0, '', '', NotificationDetails(android: groupNotificationDetails));
  }

  static Future<AndroidNotificationDetails?> androidPlatformChannelSpecifics({
    required String title,
    required String body,
    String? imageUrl,
    String? avatarUrl,
    String? summaryText,
    FLNClickAction? clickAction,
    bool isCampaign = false,
  }) async {
    if (!Platform.isAndroid) return null;

    final avatarIcon = await buildAndroidBitmap(avatarUrl),
        imageIcon = await buildAndroidBitmap(imageUrl),
        groupKey = summaryText.hashCode.toString();

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
          if (clickAction == FLNClickAction.chat)
            AndroidNotificationAction(
                FLNActionId.answerAction.name, "Responder",
                showsUserInterface: true,
                inputs: [
                  const AndroidNotificationActionInput(
                      label: "Escribe una respuesta..")
                ])
        ];

    return isCampaign
        ? AndroidNotificationDetails(
            campaignChannelId,
            campaignChannelName,
            channelDescription: campaignChannelDescription,
            color: const Color(0xFF02A6D0),
            icon: '@app_icon',
            largeIcon: avatarIcon,
            priority: Priority.low,
            importance: Importance.low,
            styleInformation: styleInformation,
            actions: notificationActions,
            groupAlertBehavior: GroupAlertBehavior.children,
            groupKey: groupKey,
          )
        : AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            color: const Color(0xFF02A6D0),
            icon: '@app_icon',
            largeIcon: avatarIcon,
            priority: Priority.high,
            importance: Importance.high,
            styleInformation: styleInformation,
            actions: notificationActions,
            groupAlertBehavior: GroupAlertBehavior.children,
            groupKey: groupKey,
          );
  }

  // TODO here testing this
  static Future<DarwinNotificationDetails?> iosPlatformChannelSpecifics({
    String? imageUrl,
    String fileName = 'image',
    String? threadIdentifier,
    bool isCampaign = false,
  }) async {
    if (!Platform.isIOS) return null;

    final savedImage = await downloadAndSavePicture(imageUrl, fileName),
        attachments = savedImage != null
            ? [DarwinNotificationAttachment(savedImage)]
            : null;

    return isCampaign
        ? DarwinNotificationDetails(
            categoryIdentifier: campaignChannelId,
            presentAlert: true,
            presentSound: true,
            presentBanner: true,
            interruptionLevel: InterruptionLevel.passive,
            attachments: attachments,
            threadIdentifier: threadIdentifier,
          )
        : DarwinNotificationDetails(
            categoryIdentifier: channelId,
            presentAlert: true,
            presentSound: true,
            presentBanner: true,
            interruptionLevel: InterruptionLevel.active,
            attachments: attachments,
            threadIdentifier: threadIdentifier,
          );
  }
}
