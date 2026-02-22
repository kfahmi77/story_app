import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../common/app_localizations.dart';
import '../../common/language_settings_sheet.dart';
import '../../common/map_constants.dart';
import '../../common/user_friendly_error.dart';
import '../../data/model/location_selection.dart';
import '../../data/service/location_service.dart';
import '../../data/service/reverse_geocoding_service.dart';

class LocationPickerPage extends StatefulWidget {
  final LocationSelection? initialSelection;

  const LocationPickerPage({super.key, this.initialSelection});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  static const _fallbackCenter = LatLng(-6.200000, 106.816666);

  final _mapController = MapController();
  final _locationService = LocationService();
  final _reverseGeocodingService = ReverseGeocodingService();

  LatLng? _selectedPoint;
  String? _selectedAddress;
  String? _addressError;
  bool _isResolvingAddress = false;
  bool _isGettingCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      _selectedPoint = LatLng(
        widget.initialSelection!.lat,
        widget.initialSelection!.lon,
      );
      _selectedAddress = widget.initialSelection!.addressLabel;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _useCurrentLocation(silentError: true);
      });
    }
  }

  Future<void> _useCurrentLocation({bool silentError = false}) async {
    if (_isGettingCurrentLocation) return;

    setState(() => _isGettingCurrentLocation = true);

    try {
      final isEnabled = await _locationService.isServiceEnabled();
      if (!isEnabled) {
        throw Exception('Location services are disabled');
      }

      var permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _locationService.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied forever');
      }

      final position = await _locationService.getCurrentPosition();
      final point = LatLng(position.latitude, position.longitude);
      _selectPoint(point, moveCamera: true);
    } catch (e) {
      if (!mounted || silentError) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            UserFriendlyError.message(
              e,
              l10n,
              context: ErrorMessageContext.location,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGettingCurrentLocation = false);
      }
    }
  }

  void _selectPoint(LatLng point, {bool moveCamera = false}) {
    setState(() {
      _selectedPoint = point;
      _selectedAddress = null;
      _addressError = null;
    });

    if (moveCamera) {
      _mapController.move(point, 16);
    }
  }

  Future<void> _resolveSelectedAddressIfNeeded() async {
    final point = _selectedPoint;
    if (point == null || _isResolvingAddress || _selectedAddress != null) {
      return;
    }

    setState(() {
      _isResolvingAddress = true;
      _addressError = null;
    });

    try {
      final address = await _reverseGeocodingService.getAddressLabel(
        latitude: point.latitude,
        longitude: point.longitude,
      );
      if (!mounted) return;
      setState(() {
        _selectedAddress = address;
        _addressError = address == null
            ? AppLocalizations.of(context).addressNotFound
            : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _addressError = UserFriendlyError.message(
          e,
          AppLocalizations.of(context),
          context: ErrorMessageContext.geocoding,
        );
      });
    } finally {
      if (mounted) {
        setState(() => _isResolvingAddress = false);
      }
    }
  }

  Future<void> _showSelectedAddressSheet() async {
    if (_selectedPoint == null) return;

    await _resolveSelectedAddressIfNeeded();
    if (!mounted) return;

    final l10n = AppLocalizations.of(context);
    final point = _selectedPoint!;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.locationAddress,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedAddress ?? _addressError ?? l10n.addressNotFound,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${l10n.locationCoordinates}: ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmSelection() {
    final point = _selectedPoint;
    if (point == null) return;

    context.pop(
      LocationSelection(
        lat: point.latitude,
        lon: point.longitude,
        addressLabel: _selectedAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedPoint = _selectedPoint;
    final center = selectedPoint ?? _fallbackCenter;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.mapPickerTitle,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            tooltip: l10n.language,
            onPressed: () => showLanguageSettingsSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 14,
                    onTap: (_, point) => _selectPoint(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: kOsmTileUrlTemplate,
                      userAgentPackageName: kOsmUserAgentPackageName,
                    ),
                    if (selectedPoint != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: selectedPoint,
                            width: 52,
                            height: 52,
                            child: GestureDetector(
                              onTap: _showSelectedAddressSheet,
                              child: const _PickerMapMarker(),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.small(
                    heroTag: 'current-location-fab',
                    tooltip: l10n.useCurrentLocation,
                    onPressed: _isGettingCurrentLocation
                        ? null
                        : () => _useCurrentLocation(),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4F46E5),
                    child: _isGettingCurrentLocation
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location_rounded),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tapMapToSelectLocation,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 10),
                if (selectedPoint != null) ...[
                  Text(
                    '${l10n.locationCoordinates}: ${selectedPoint.latitude.toStringAsFixed(5)}, ${selectedPoint.longitude.toStringAsFixed(5)}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (_isResolvingAddress)
                    Text(
                      l10n.resolvingAddress,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    )
                  else
                    Text(
                      _selectedAddress ??
                          _addressError ??
                          l10n.tapMarkerForAddress,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '© OpenStreetMap',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ] else
                  Text(
                    l10n.noLocationSelectedYet,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ElevatedButton.icon(
            onPressed: selectedPoint == null ? null : _confirmSelection,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
            ),
            icon: const Icon(Icons.check_circle_outline_rounded),
            label: Text(l10n.confirmLocation),
          ),
        ),
      ),
    );
  }
}

class _PickerMapMarker extends StatelessWidget {
  const _PickerMapMarker();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.place_rounded, color: Colors.white, size: 24),
      ),
    );
  }
}
