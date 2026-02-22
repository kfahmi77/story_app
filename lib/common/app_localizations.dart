import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('en'), Locale('id')];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcomeBack': 'Welcome Back',
      'signInSubtitle': 'Sign in to continue sharing stories',
      'email': 'Email',
      'enterEmail': 'Enter your email',
      'password': 'Password',
      'enterPassword': 'Enter your password',
      'signIn': 'Sign In',
      'dontHaveAccount': "Don't have an account? ",
      'register': 'Register',
      'createAccount': 'Create Account',
      'joinSubtitle': 'Join and share your Dicoding stories',
      'name': 'Name',
      'enterName': 'Enter your name',
      'passwordHint': 'At least 8 characters',
      'alreadyHaveAccount': 'Already have an account? ',
      'login': 'Login',
      'registrationSuccess': 'Registration successful! Please login.',

      'emailRequired': 'Email is required',
      'emailInvalid': 'Enter a valid email',
      'passwordRequired': 'Password is required',
      'passwordMinLength': 'Password must be at least 8 characters',
      'nameRequired': 'Name is required',

      // Story List
      'story': 'Story',
      'logout': 'Logout',
      'noStories': 'No stories yet',
      'retry': 'Retry',

      // Story Detail
      'storyDetail': 'Story Detail',

      // Add Story
      'newStory': 'New Story',
      'noImageSelected': 'No image selected',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'description': 'Description',
      'writeStory': 'Write your story...',
      'upload': 'Upload',
      'selectImage': 'Please select an image first',
      'enterDescription': 'Please enter a description',
      'storyUploaded': 'Story uploaded successfully!',
      'failedPickImage': 'Failed to pick image',

      // General
      'pageNotFound': 'Page not found',
      'errorNoInternet':
          'No internet connection. Check your network and try again.',
      'errorRequestTimeout':
          'The request took too long. Please try again in a moment.',
      'errorServer':
          'Server is having a problem. Please try again later.',
      'errorSessionExpired':
          'Your session has expired. Please login again.',
      'errorDataNotFound': 'Data could not be found.',
      'errorStoryNotFound': 'Story not found or no longer available.',
      'errorImageTooLarge':
          'Image is too large. Please choose a smaller image.',
      'errorInvalidCredentials':
          'Email or password is incorrect. Please check and try again.',
      'errorEmailAlreadyRegistered':
          'This email is already registered. Please use another email.',
      'errorImagePermissionDenied':
          'Permission to access camera/gallery was denied.',
      'errorGenericFriendly':
          'Something went wrong. Please try again in a moment.',
      'errorLoginFailedFriendly':
          'Login failed. Please check your data and try again.',
      'errorRegisterFailedFriendly':
          'Registration failed. Please check your data and try again.',
      'errorLoadStoriesFriendly':
          'Stories could not be loaded. Please try again.',
      'errorLoadStoryDetailFriendly':
          'Story detail could not be loaded. Please try again.',
      'errorUploadStoryFriendly':
          'Story could not be uploaded. Please try again.',
      'errorPickImageFriendly':
          'Failed to select image. Please try again.',
    },
    'id': {
      // Auth
      'welcomeBack': 'Selamat Datang',
      'signInSubtitle': 'Masuk untuk berbagi cerita',
      'email': 'Email',
      'enterEmail': 'Masukkan email Anda',
      'password': 'Kata Sandi',
      'enterPassword': 'Masukkan kata sandi Anda',
      'signIn': 'Masuk',
      'dontHaveAccount': 'Belum punya akun? ',
      'register': 'Daftar',
      'createAccount': 'Buat Akun',
      'joinSubtitle': 'Gabung dan bagikan cerita Dicoding Anda',
      'name': 'Nama',
      'enterName': 'Masukkan nama Anda',
      'passwordHint': 'Minimal 8 karakter',
      'alreadyHaveAccount': 'Sudah punya akun? ',
      'login': 'Masuk',
      'registrationSuccess': 'Pendaftaran berhasil! Silakan masuk.',

      // Validation
      'emailRequired': 'Email wajib diisi',
      'emailInvalid': 'Masukkan email yang valid',
      'passwordRequired': 'Kata sandi wajib diisi',
      'passwordMinLength': 'Kata sandi minimal 8 karakter',
      'nameRequired': 'Nama wajib diisi',

      // Story List
      'story': 'Cerita',
      'logout': 'Keluar',
      'noStories': 'Belum ada cerita',
      'retry': 'Coba Lagi',

      // Story Detail
      'storyDetail': 'Detail Cerita',

      // Add Story
      'newStory': 'Cerita Baru',
      'noImageSelected': 'Belum ada gambar dipilih',
      'camera': 'Kamera',
      'gallery': 'Galeri',
      'description': 'Deskripsi',
      'writeStory': 'Tulis cerita Anda...',
      'upload': 'Unggah',
      'selectImage': 'Silakan pilih gambar terlebih dahulu',
      'enterDescription': 'Silakan masukkan deskripsi',
      'storyUploaded': 'Cerita berhasil diunggah!',
      'failedPickImage': 'Gagal memilih gambar',

      // General
      'pageNotFound': 'Halaman tidak ditemukan',
      'errorNoInternet':
          'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
      'errorRequestTimeout':
          'Permintaan terlalu lama diproses. Silakan coba lagi sebentar lagi.',
      'errorServer':
          'Server sedang bermasalah. Silakan coba lagi nanti.',
      'errorSessionExpired':
          'Sesi Anda sudah berakhir. Silakan masuk kembali.',
      'errorDataNotFound': 'Data tidak ditemukan.',
      'errorStoryNotFound':
          'Cerita tidak ditemukan atau sudah tidak tersedia.',
      'errorImageTooLarge':
          'Ukuran gambar terlalu besar. Pilih gambar yang lebih kecil.',
      'errorInvalidCredentials':
          'Email atau kata sandi salah. Periksa lalu coba lagi.',
      'errorEmailAlreadyRegistered':
          'Email ini sudah terdaftar. Silakan gunakan email lain.',
      'errorImagePermissionDenied':
          'Izin akses kamera/galeri ditolak.',
      'errorGenericFriendly':
          'Terjadi kendala. Silakan coba lagi beberapa saat lagi.',
      'errorLoginFailedFriendly':
          'Gagal masuk. Periksa data Anda lalu coba lagi.',
      'errorRegisterFailedFriendly':
          'Pendaftaran gagal. Periksa data Anda lalu coba lagi.',
      'errorLoadStoriesFriendly':
          'Daftar cerita belum bisa dimuat. Silakan coba lagi.',
      'errorLoadStoryDetailFriendly':
          'Detail cerita belum bisa dimuat. Silakan coba lagi.',
      'errorUploadStoryFriendly':
          'Cerita belum berhasil diunggah. Silakan coba lagi.',
      'errorPickImageFriendly':
          'Gagal memilih gambar. Silakan coba lagi.',
    },
  };

  String _translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  // Auth
  String get welcomeBack => _translate('welcomeBack');
  String get signInSubtitle => _translate('signInSubtitle');
  String get email => _translate('email');
  String get enterEmail => _translate('enterEmail');
  String get password => _translate('password');
  String get enterPassword => _translate('enterPassword');
  String get signIn => _translate('signIn');
  String get dontHaveAccount => _translate('dontHaveAccount');
  String get register => _translate('register');
  String get createAccount => _translate('createAccount');
  String get joinSubtitle => _translate('joinSubtitle');
  String get name => _translate('name');
  String get enterName => _translate('enterName');
  String get passwordHint => _translate('passwordHint');
  String get alreadyHaveAccount => _translate('alreadyHaveAccount');
  String get login => _translate('login');
  String get registrationSuccess => _translate('registrationSuccess');

  // Validation
  String get emailRequired => _translate('emailRequired');
  String get emailInvalid => _translate('emailInvalid');
  String get passwordRequired => _translate('passwordRequired');
  String get passwordMinLength => _translate('passwordMinLength');
  String get nameRequired => _translate('nameRequired');

  // Story List
  String get story => _translate('story');
  String get logout => _translate('logout');
  String get noStories => _translate('noStories');
  String get retry => _translate('retry');

  // Story Detail
  String get storyDetail => _translate('storyDetail');

  // Add Story
  String get newStory => _translate('newStory');
  String get noImageSelected => _translate('noImageSelected');
  String get camera => _translate('camera');
  String get gallery => _translate('gallery');
  String get description => _translate('description');
  String get writeStory => _translate('writeStory');
  String get upload => _translate('upload');
  String get selectImage => _translate('selectImage');
  String get enterDescription => _translate('enterDescription');
  String get storyUploaded => _translate('storyUploaded');
  String get failedPickImage => _translate('failedPickImage');

  // General
  String get pageNotFound => _translate('pageNotFound');
  String get errorNoInternet => _translate('errorNoInternet');
  String get errorRequestTimeout => _translate('errorRequestTimeout');
  String get errorServer => _translate('errorServer');
  String get errorSessionExpired => _translate('errorSessionExpired');
  String get errorDataNotFound => _translate('errorDataNotFound');
  String get errorStoryNotFound => _translate('errorStoryNotFound');
  String get errorImageTooLarge => _translate('errorImageTooLarge');
  String get errorInvalidCredentials => _translate('errorInvalidCredentials');
  String get errorEmailAlreadyRegistered =>
      _translate('errorEmailAlreadyRegistered');
  String get errorImagePermissionDenied =>
      _translate('errorImagePermissionDenied');
  String get errorGenericFriendly => _translate('errorGenericFriendly');
  String get errorLoginFailedFriendly => _translate('errorLoginFailedFriendly');
  String get errorRegisterFailedFriendly =>
      _translate('errorRegisterFailedFriendly');
  String get errorLoadStoriesFriendly =>
      _translate('errorLoadStoriesFriendly');
  String get errorLoadStoryDetailFriendly =>
      _translate('errorLoadStoryDetailFriendly');
  String get errorUploadStoryFriendly =>
      _translate('errorUploadStoryFriendly');
  String get errorPickImageFriendly => _translate('errorPickImageFriendly');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
