import 'package:flutter/material.dart';

import '../data/repository/locale_repository.dart';
import 'app_localizations.dart';

class AppLocaleController extends ChangeNotifier {
  final LocaleRepository _localeRepository;

  AppLocaleController(this._localeRepository);

  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> loadSavedLocale() async {
    final savedCode = await _localeRepository.getLocaleCode();
    _locale = _fromCode(savedCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    final nextLocale = _fromCode(locale?.languageCode);

    final isSameLocale = _locale?.languageCode == nextLocale?.languageCode;
    if (isSameLocale) return;

    _locale = nextLocale;

    if (nextLocale == null) {
      await _localeRepository.clearLocaleCode();
    } else {
      await _localeRepository.saveLocaleCode(nextLocale.languageCode);
    }

    notifyListeners();
  }

  Locale? _fromCode(String? languageCode) {
    if (languageCode == null || languageCode.isEmpty) {
      return null;
    }

    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }

    return null;
  }
}

class AppLocaleScope extends InheritedNotifier<AppLocaleController> {
  const AppLocaleScope({
    super.key,
    required AppLocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppLocaleController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope not found in widget tree.');
    return scope!.notifier!;
  }
}
