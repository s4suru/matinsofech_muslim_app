import '../models/language_model.dart';

class AppConstants {
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: 'en.png', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: 'ar.png', languageName: 'Arabic', countryCode: 'ar_SA', languageCode: 'ar'),
  ];
}