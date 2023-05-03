import 'dart:io';
import 'package:collection/collection.dart';

/// A Collection of diverse languages.
enum LanguageList {
  en(locale: 'english', lcidString: 'en_US'),
  es(locale: 'español', lcidString: 'es_ES'),
  pt(locale: 'português', lcidString: 'pt_BR'),
  fr(locale: 'français', lcidString: 'fr_FR'),
  de(locale: 'deutsch', lcidString: 'de_DE'),
  it(locale: 'italiano', lcidString: 'it_IT'),
  ru(locale: 'pусский', lcidString: 'ru'),
  ja(locale: '日本語', lcidString: 'ja'),
  ko(locale: '한국어', lcidString: 'ko'),
  zh(locale: '中文', lcidString: 'zh_CN'),
  ar(locale: 'العربية', lcidString: 'ar_SA'),
  hi(locale: 'हिंदी', lcidString: 'hi'),
  vi(locale: 'tiếng Việt', lcidString: 'vi'),
  th(locale: 'ภาษาไทย', lcidString: 'th'),
  tr(locale: 'türkçe', lcidString: 'tr'),
  nl(locale: 'nederlands', lcidString: 'nl_NL');

  const LanguageList({
    required this.locale,
    required this.lcidString,
  });
  final String locale;
  final String lcidString;

  static LanguageList deviceLanguage() {
    return LanguageList.values.firstWhereOrNull(
            (element) => element.lcidString == Platform.localeName) ??
        LanguageList.en;
  }
}
