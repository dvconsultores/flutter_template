import 'package:flutter/foundation.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/services/device_info_service.dart';
import 'package:launch_review/launch_review.dart';

class AppReviewService {
  static Future<void> openStore({bool writeReview = false}) async {
    if (kIsWeb) {
      switch (await DeviceInfo.web.getOSInsideWeb()) {
        case TargetPlatform.macOS || TargetPlatform.iOS:
          await openUrl("https://apps.apple.com/us/app/apolo-pay/id6473090644");
          return;

        case TargetPlatform.android || _:
          await openUrl(
              "https://play.google.com/store/apps/details?id=app.apoloPay.apolo&hl=es-419");
          return;
      }
    }

    await LaunchReview.launch(
      androidAppId: "app.apoloPay.apolo",
      iOSAppId: "6473090644",
      writeReview: writeReview,
    );
  }
}
