import 'package:flutter/material.dart';

import 'app_locale_controller.dart';
import 'app_localizations.dart';

Future<void> showLanguageSettingsSheet(BuildContext context) async {
  final localeController = AppLocaleScope.of(context);
  final selectedLanguageCode = localeController.locale?.languageCode;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final sheetL10n = AppLocalizations.of(sheetContext);

      Future<void> selectLanguage(String? languageCode) async {
        Navigator.of(sheetContext).pop();
        await localeController.setLocale(
          languageCode == null ? null : Locale(languageCode),
        );
      }

      Widget languageOption({
        required String title,
        required String? value,
      }) {
        final isSelected = selectedLanguageCode == value;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          leading: Icon(
            isSelected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade500,
          ),
          title: Text(title),
          onTap: () => selectLanguage(value),
        );
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sheetL10n.languageSettings,
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sheetL10n.chooseLanguage,
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              languageOption(
                title: sheetL10n.useSystemLanguage,
                value: null,
              ),
              languageOption(
                title: sheetL10n.languageIndonesian,
                value: 'id',
              ),
              languageOption(
                title: sheetL10n.languageEnglish,
                value: 'en',
              ),
            ],
          ),
        ),
      );
    },
  );
}
