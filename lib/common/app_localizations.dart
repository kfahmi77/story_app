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
      'beFirstStory': 'Be the first to share a story!',
      'retry': 'Retry',

      // Story Detail
      'storyDetail': 'Story Detail',

      // Add Story
      'newStory': 'New Story',
      'noImageSelected': 'No image selected',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'description': 'Description',
      'storyDetails': 'Story Details',
      'location': 'Location',
      'storyLocation': 'Story Location',
      'locationPinned': 'Location Pinned',
      'pickLocationOnMap': 'Pick Location on Map',
      'changeLocation': 'Change Location',
      'removeLocation': 'Remove Location',
      'useCurrentLocation': 'Use Current Location',
      'freeTierLabel': 'FREE',
      'paidTierLabel': 'PAID',
      'selectedLocation': 'Selected Location',
      'noLocationSelectedYet': 'No location selected yet',
      'locationOptional': 'Location is optional',
      'locationPaidOnly':
          'Location selection is available in the paid version only.',
      'tapMapToSelectLocation': 'Tap on the map to select a location',
      'confirmLocation': 'Confirm Location',
      'locationCoordinates': 'Coordinates',
      'locationAddress': 'Address',
      'tapMarkerForAddress': 'Tap marker to view address',
      'resolvingAddress': 'Loading address...',
      'addressNotFound': 'Address could not be found.',
      'failedLoadAddress': 'Failed to load address.',
      'mapPickerTitle': 'Choose Location',
      'writeStory': 'Write your story...',
      'tapToBrowse': 'Tap to browse',
      'upload': 'Upload',
      'selectImage': 'Please select an image first',
      'enterDescription': 'Please enter a description',
      'storyUploaded': 'Story uploaded successfully!',
      'failedPickImage': 'Failed to pick image',

      // General
      'pageNotFound': 'Page not found',
      'language': 'Language',
      'languageSettings': 'Language Settings',
      'chooseLanguage': 'Choose your preferred language.',
      'useSystemLanguage': 'Use device language',
      'languageIndonesian': 'Bahasa Indonesia',
      'languageEnglish': 'English',
      'errorNoInternet':
          'No internet connection. Check your network and try again.',
      'errorRequestTimeout':
          'The request took too long. Please try again in a moment.',
      'errorServer': 'Server is having a problem. Please try again later.',
      'errorSessionExpired': 'Your session has expired. Please login again.',
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
      'errorLocationPermissionDenied':
          'Location permission was denied. You can still pick a location manually on the map.',
      'errorLocationPermissionPermanentlyDenied':
          'Location permission is permanently denied. Enable it from device settings to use current location.',
      'errorLocationServiceDisabled':
          'Location service is disabled. Please turn on GPS/location services.',
      'errorAddressUnavailable':
          'Address is unavailable for this location. Coordinates are shown instead.',
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
      'errorPickImageFriendly': 'Failed to select image. Please try again.',
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
      'beFirstStory': 'Jadilah yang pertama membagikan cerita!',
      'retry': 'Coba Lagi',

      // Story Detail
      'storyDetail': 'Detail Cerita',

      // Add Story
      'newStory': 'Cerita Baru',
      'noImageSelected': 'Belum ada gambar dipilih',
      'camera': 'Kamera',
      'gallery': 'Galeri',
      'description': 'Deskripsi',
      'storyDetails': 'Detail Cerita',
      'location': 'Lokasi',
      'storyLocation': 'Lokasi Cerita',
      'locationPinned': 'Lokasi Ditandai',
      'pickLocationOnMap': 'Pilih Lokasi di Peta',
      'changeLocation': 'Ubah Lokasi',
      'removeLocation': 'Hapus Lokasi',
      'useCurrentLocation': 'Gunakan Lokasi Saat Ini',
      'freeTierLabel': 'GRATIS',
      'paidTierLabel': 'BERBAYAR',
      'selectedLocation': 'Lokasi Terpilih',
      'noLocationSelectedYet': 'Belum ada lokasi yang dipilih',
      'locationOptional': 'Lokasi bersifat opsional',
      'locationPaidOnly':
          'Fitur pilih lokasi hanya tersedia di versi berbayar.',
      'tapMapToSelectLocation': 'Ketuk peta untuk memilih lokasi',
      'confirmLocation': 'Konfirmasi Lokasi',
      'locationCoordinates': 'Koordinat',
      'locationAddress': 'Alamat',
      'tapMarkerForAddress': 'Ketuk marker untuk melihat alamat',
      'resolvingAddress': 'Memuat alamat...',
      'addressNotFound': 'Alamat tidak ditemukan.',
      'failedLoadAddress': 'Gagal memuat alamat.',
      'mapPickerTitle': 'Pilih Lokasi',
      'writeStory': 'Tulis cerita Anda...',
      'tapToBrowse': 'Ketuk untuk memilih',
      'upload': 'Unggah',
      'selectImage': 'Silakan pilih gambar terlebih dahulu',
      'enterDescription': 'Silakan masukkan deskripsi',
      'storyUploaded': 'Cerita berhasil diunggah!',
      'failedPickImage': 'Gagal memilih gambar',

      // General
      'pageNotFound': 'Halaman tidak ditemukan',
      'language': 'Bahasa',
      'languageSettings': 'Pengaturan Bahasa',
      'chooseLanguage': 'Pilih bahasa yang ingin digunakan.',
      'useSystemLanguage': 'Ikuti bahasa perangkat',
      'languageIndonesian': 'Bahasa Indonesia',
      'languageEnglish': 'English',
      'errorNoInternet':
          'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
      'errorRequestTimeout':
          'Permintaan terlalu lama diproses. Silakan coba lagi sebentar lagi.',
      'errorServer': 'Server sedang bermasalah. Silakan coba lagi nanti.',
      'errorSessionExpired': 'Sesi Anda sudah berakhir. Silakan masuk kembali.',
      'errorDataNotFound': 'Data tidak ditemukan.',
      'errorStoryNotFound': 'Cerita tidak ditemukan atau sudah tidak tersedia.',
      'errorImageTooLarge':
          'Ukuran gambar terlalu besar. Pilih gambar yang lebih kecil.',
      'errorInvalidCredentials':
          'Email atau kata sandi salah. Periksa lalu coba lagi.',
      'errorEmailAlreadyRegistered':
          'Email ini sudah terdaftar. Silakan gunakan email lain.',
      'errorImagePermissionDenied': 'Izin akses kamera/galeri ditolak.',
      'errorLocationPermissionDenied':
          'Izin lokasi ditolak. Anda tetap bisa memilih lokasi secara manual di peta.',
      'errorLocationPermissionPermanentlyDenied':
          'Izin lokasi ditolak permanen. Aktifkan dari pengaturan perangkat untuk memakai lokasi saat ini.',
      'errorLocationServiceDisabled':
          'Layanan lokasi/GPS nonaktif. Aktifkan lalu coba lagi.',
      'errorAddressUnavailable':
          'Alamat tidak tersedia untuk lokasi ini. Koordinat akan ditampilkan.',
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
      'errorPickImageFriendly': 'Gagal memilih gambar. Silakan coba lagi.',
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
  String get beFirstStory => _translate('beFirstStory');
  String get retry => _translate('retry');

  // Story Detail
  String get storyDetail => _translate('storyDetail');

  // Add Story
  String get newStory => _translate('newStory');
  String get noImageSelected => _translate('noImageSelected');
  String get camera => _translate('camera');
  String get gallery => _translate('gallery');
  String get description => _translate('description');
  String get storyDetails => _translate('storyDetails');
  String get location => _translate('location');
  String get storyLocation => _translate('storyLocation');
  String get locationPinned => _translate('locationPinned');
  String get pickLocationOnMap => _translate('pickLocationOnMap');
  String get changeLocation => _translate('changeLocation');
  String get removeLocation => _translate('removeLocation');
  String get useCurrentLocation => _translate('useCurrentLocation');
  String get freeTierLabel => _translate('freeTierLabel');
  String get paidTierLabel => _translate('paidTierLabel');
  String get selectedLocation => _translate('selectedLocation');
  String get noLocationSelectedYet => _translate('noLocationSelectedYet');
  String get locationOptional => _translate('locationOptional');
  String get locationPaidOnly => _translate('locationPaidOnly');
  String get tapMapToSelectLocation => _translate('tapMapToSelectLocation');
  String get confirmLocation => _translate('confirmLocation');
  String get locationCoordinates => _translate('locationCoordinates');
  String get locationAddress => _translate('locationAddress');
  String get tapMarkerForAddress => _translate('tapMarkerForAddress');
  String get resolvingAddress => _translate('resolvingAddress');
  String get addressNotFound => _translate('addressNotFound');
  String get failedLoadAddress => _translate('failedLoadAddress');
  String get mapPickerTitle => _translate('mapPickerTitle');
  String get writeStory => _translate('writeStory');
  String get tapToBrowse => _translate('tapToBrowse');
  String get upload => _translate('upload');
  String get selectImage => _translate('selectImage');
  String get enterDescription => _translate('enterDescription');
  String get storyUploaded => _translate('storyUploaded');
  String get failedPickImage => _translate('failedPickImage');

  // General
  String get pageNotFound => _translate('pageNotFound');
  String get language => _translate('language');
  String get languageSettings => _translate('languageSettings');
  String get chooseLanguage => _translate('chooseLanguage');
  String get useSystemLanguage => _translate('useSystemLanguage');
  String get languageIndonesian => _translate('languageIndonesian');
  String get languageEnglish => _translate('languageEnglish');
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
  String get errorLocationPermissionDenied =>
      _translate('errorLocationPermissionDenied');
  String get errorLocationPermissionPermanentlyDenied =>
      _translate('errorLocationPermissionPermanentlyDenied');
  String get errorLocationServiceDisabled =>
      _translate('errorLocationServiceDisabled');
  String get errorAddressUnavailable => _translate('errorAddressUnavailable');
  String get errorGenericFriendly => _translate('errorGenericFriendly');
  String get errorLoginFailedFriendly => _translate('errorLoginFailedFriendly');
  String get errorRegisterFailedFriendly =>
      _translate('errorRegisterFailedFriendly');
  String get errorLoadStoriesFriendly => _translate('errorLoadStoriesFriendly');
  String get errorLoadStoryDetailFriendly =>
      _translate('errorLoadStoryDetailFriendly');
  String get errorUploadStoryFriendly => _translate('errorUploadStoryFriendly');
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
