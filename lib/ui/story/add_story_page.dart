import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/app_flavor.dart';
import '../../common/app_localizations.dart';
import '../../common/language_settings_sheet.dart';
import '../../common/result_state.dart';
import '../../common/user_friendly_error.dart';
import '../../data/api/api_service.dart';
import '../../data/model/location_selection.dart';
import '../../data/repository/auth_repository.dart';

class AddStoryPage extends StatefulWidget {
  final VoidCallback onStoryUploaded;

  const AddStoryPage({super.key, required this.onStoryUploaded});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _descriptionController = TextEditingController();
  final _apiService = ApiService();
  final _authRepo = AuthRepository();
  final _imagePicker = ImagePicker();

  Uint8List? _imageBytes;
  String? _fileName;
  LocationSelection? _selectedLocation;
  ResultState _state = ResultState.initial;
  String _errorMessage = '';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _fileName = pickedFile.name;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              UserFriendlyError.message(
                e,
                l10n,
                context: ErrorMessageContext.imagePicker,
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _pickLocationOnMap() async {
    if (!AppFlavor.isPaid) return;

    final result = await context.push<LocationSelection>(
      '/stories/add/location-picker',
      extra: _selectedLocation,
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  void _removeLocation() {
    setState(() {
      _selectedLocation = null;
    });
  }

  Future<void> _upload() async {
    final l10n = AppLocalizations.of(context);

    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectImage),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterDescription),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _state = ResultState.loading;
      _errorMessage = '';
    });

    try {
      final token = await _authRepo.getToken();
      if (token == null) return;

      await _apiService.addStory(
        token: token,
        description: _descriptionController.text.trim(),
        photoBytes: _imageBytes!,
        fileName: _fileName ?? 'photo.jpg',
        lat: AppFlavor.isPaid ? _selectedLocation?.lat : null,
        lon: AppFlavor.isPaid ? _selectedLocation?.lon : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.storyUploaded),
            backgroundColor: const Color(0xFF10B981), // Emerald green
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        widget.onStoryUploaded();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = ResultState.error;
          _errorMessage = UserFriendlyError.message(
            e,
            AppLocalizations.of(context),
            context: ErrorMessageContext.addStory,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          l10n.newStory,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            tooltip: l10n.language,
            onPressed: () => showLanguageSettingsSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Picker "Dropzone" Area
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _imageBytes != null
                        ? const Color(0xFF4F46E5).withValues(alpha: 0.3)
                        : Colors.grey.shade300,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: _imageBytes != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.memory(_imageBytes!, fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.6),
                                ],
                                stops: const [0.7, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.9,
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF4F46E5,
                              ).withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate_rounded,
                              size: 48,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noImageSelected,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade500,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            l10n.tapToBrowse,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: Text(
                      l10n.camera,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4F46E5),
                      side: const BorderSide(color: Color(0xFF4F46E5)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded),
                    label: Text(
                      l10n.gallery,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF06B6D4),
                      side: const BorderSide(color: Color(0xFF06B6D4)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            _buildLocationSection(l10n),
            const SizedBox(height: 32),

            // Description Input
            Text(
              l10n.storyDetails,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                style: GoogleFonts.poppins(fontSize: 15),
                decoration: InputDecoration(
                  hintText: l10n.writeStory,
                  alignLabelWithHint: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Error Display
            if (_state == ResultState.error)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 32),

            // Upload Button
            Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _state == ResultState.loading ? null : _upload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _state == ResultState.loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_upload_rounded),
                          const SizedBox(width: 8),
                          Text(
                            l10n.upload,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(AppLocalizations l10n) {
    final isPaidVariant = AppFlavor.isPaid;
    final selectedLocation = _selectedLocation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.location,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:
                    (isPaidVariant
                            ? const Color(0xFF10B981)
                            : Colors.grey.shade500)
                        .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                isPaidVariant ? l10n.paidTierLabel : l10n.freeTierLabel,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isPaidVariant
                      ? const Color(0xFF047857)
                      : Colors.grey.shade700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          isPaidVariant ? l10n.locationOptional : l10n.locationPaidOnly,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: isPaidVariant ? _pickLocationOnMap : null,
          icon: Icon(
            selectedLocation == null
                ? Icons.map_outlined
                : Icons.edit_location_alt_rounded,
          ),
          label: Text(
            selectedLocation == null
                ? l10n.pickLocationOnMap
                : l10n.changeLocation,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEEF2FF),
            foregroundColor: const Color(0xFF4F46E5),
            disabledBackgroundColor: Colors.grey.shade200,
            disabledForegroundColor: Colors.grey.shade500,
            elevation: 0,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: selectedLocation == null
              ? Container(
                  key: const ValueKey('no-location'),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_off_rounded,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.noLocationSelectedYet,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  key: const ValueKey('selected-location'),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF06B6D4,
                              ).withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: Color(0xFF0891B2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.selectedLocation,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  '${l10n.locationCoordinates}: ${selectedLocation.coordinateLabel}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.removeLocation,
                            onPressed: _removeLocation,
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                      if (selectedLocation.addressLabel != null &&
                          selectedLocation.addressLabel!.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          selectedLocation.addressLabel!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            height: 1.4,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
