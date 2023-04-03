/// A Collection of diverse languages.
enum LanguageList {
  en('english'),
  es('español'),
  pr('português'),
  fr('français'),
  al('deutsch'),
  it('italiano'),
  rs('pусский'),
  jp('日本語'),
  kr('한국어'),
  ch('中文'),
  ar('العربية'),
  ind('हिंदी'),
  vt('tiếng Việt'),
  tl('ภาษาไทย'),
  tk('türkçe'),
  nd('nederlands');

  const LanguageList(this.value);
  final String value;
}
