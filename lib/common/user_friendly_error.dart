import 'dart:async';
import 'dart:io';

import 'app_localizations.dart';

enum ErrorMessageContext {
  generic,
  login,
  register,
  storyList,
  storyDetail,
  addStory,
  imagePicker,
}

class UserFriendlyError {
  static String message(
    Object error,
    AppLocalizations l10n, {
    ErrorMessageContext context = ErrorMessageContext.generic,
  }) {
    final raw = error.toString().replaceFirst('Exception: ', '').trim();
    final lower = raw.toLowerCase();

    if (_isNetworkError(error, lower)) {
      return l10n.errorNoInternet;
    }

    if (error is TimeoutException ||
        lower.contains('timeout') ||
        lower.contains('timed out')) {
      return l10n.errorRequestTimeout;
    }

    if (_isSessionError(lower)) {
      return l10n.errorSessionExpired;
    }

    if (context == ErrorMessageContext.login &&
        _isInvalidCredentialError(lower)) {
      return l10n.errorInvalidCredentials;
    }

    if (context == ErrorMessageContext.register &&
        _isEmailAlreadyRegisteredError(lower)) {
      return l10n.errorEmailAlreadyRegistered;
    }

    if (context == ErrorMessageContext.imagePicker &&
        _isPermissionError(lower)) {
      return l10n.errorImagePermissionDenied;
    }

    if (_isNotFoundError(lower)) {
      return context == ErrorMessageContext.storyDetail
          ? l10n.errorStoryNotFound
          : l10n.errorDataNotFound;
    }

    if (_isPayloadTooLargeError(lower)) {
      return l10n.errorImageTooLarge;
    }

    if (_isServerError(lower)) {
      return l10n.errorServer;
    }

    switch (context) {
      case ErrorMessageContext.login:
        return l10n.errorLoginFailedFriendly;
      case ErrorMessageContext.register:
        return l10n.errorRegisterFailedFriendly;
      case ErrorMessageContext.storyList:
        return l10n.errorLoadStoriesFriendly;
      case ErrorMessageContext.storyDetail:
        return l10n.errorLoadStoryDetailFriendly;
      case ErrorMessageContext.addStory:
        return l10n.errorUploadStoryFriendly;
      case ErrorMessageContext.imagePicker:
        return l10n.errorPickImageFriendly;
      case ErrorMessageContext.generic:
        return l10n.errorGenericFriendly;
    }
  }

  static bool _isNetworkError(Object error, String lower) {
    return error is SocketException ||
        lower.contains('socketexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('no address associated with hostname') ||
        lower.contains('network is unreachable') ||
        lower.contains('connection refused') ||
        lower.contains('connection reset by peer') ||
        lower.contains('connection closed') ||
        lower.contains('clientexception with socket');
  }

  static bool _isSessionError(String lower) {
    return lower.contains('401') ||
        lower.contains('unauthorized') ||
        lower.contains('token is invalid') ||
        lower.contains('token invalid') ||
        lower.contains('token expired') ||
        lower.contains('jwt expired');
  }

  static bool _isInvalidCredentialError(String lower) {
    return lower.contains('invalid password') ||
        lower.contains('wrong password') ||
        lower.contains('user not found') ||
        lower.contains('email or password') ||
        lower.contains('credential') ||
        lower.contains('akun tidak ditemukan') ||
        lower.contains('kata sandi salah');
  }

  static bool _isEmailAlreadyRegisteredError(String lower) {
    return lower.contains('email is already taken') ||
        lower.contains('email already') ||
        lower.contains('already registered') ||
        lower.contains('already exists') ||
        lower.contains('sudah terdaftar');
  }

  static bool _isPermissionError(String lower) {
    return lower.contains('permission') && lower.contains('denied');
  }

  static bool _isNotFoundError(String lower) {
    return lower.contains('404') || lower.contains('not found');
  }

  static bool _isPayloadTooLargeError(String lower) {
    return lower.contains('413') ||
        lower.contains('payload too large') ||
        lower.contains('request entity too large') ||
        lower.contains('file too large') ||
        lower.contains('too large');
  }

  static bool _isServerError(String lower) {
    return lower.contains('500') ||
        lower.contains('502') ||
        lower.contains('503') ||
        lower.contains('504') ||
        lower.contains('internal server error');
  }
}
