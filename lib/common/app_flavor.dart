enum AppTier { free, paid }

class AppFlavor {
  static const String _tierValue = String.fromEnvironment(
    'APP_TIER',
    defaultValue: 'free',
  );

  static AppTier get tier {
    switch (_tierValue.toLowerCase()) {
      case 'paid':
        return AppTier.paid;
      case 'free':
      default:
        return AppTier.free;
    }
  }

  static bool get isPaid => tier == AppTier.paid;
  static bool get isFree => tier == AppTier.free;
}
