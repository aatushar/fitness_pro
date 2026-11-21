import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/l10n/app_strings.dart';

/// The app language (English by default), remembered between launches.
class LocaleCubit extends Cubit<AppLanguage> {
  static const _languageKey = 'language';

  LocaleCubit() : super(AppLanguage.english);

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _apply(AppLanguage.fromCode(prefs.getString(_languageKey)));
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (language == state) return;
    _apply(language);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.code);
  }

  void _apply(AppLanguage language) {
    AppStrings.current = language;
    emit(language);
  }
}
