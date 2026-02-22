import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../common/app_localizations.dart';
import '../../common/map_constants.dart';
import '../../common/user_friendly_error.dart';
import '../../data/service/reverse_geocoding_service.dart';

class StoryLocationMapSection extends StatefulWidget {
  final double latitude;
  final double longitude;

  const StoryLocationMapSection({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<StoryLocationMapSection> createState() =>
      _StoryLocationMapSectionState();
}

class _StoryLocationMapSectionState extends State<StoryLocationMapSection> {
  final _reverseGeocodingService = ReverseGeocodingService();

  String? _addressLabel;
  String? _addressError;
  bool _isResolvingAddress = false;

  LatLng get _point => LatLng(widget.latitude, widget.longitude);

  Future<void> _resolveAddressIfNeeded() async {
    if (_addressLabel != null || _isResolvingAddress) return;

    setState(() {
      _isResolvingAddress = true;
      _addressError = null;
    });

    try {
      final label = await _reverseGeocodingService.getAddressLabel(
        latitude: widget.latitude,
        longitude: widget.longitude,
      );

      if (!mounted) return;

      setState(() {
        _addressLabel = label;
        _addressError = label == null
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

  Future<void> _showAddressSheet() async {
    await _resolveAddressIfNeeded();
    if (!mounted) return;

    final l10n = AppLocalizations.of(context);
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
                  _addressLabel ?? _addressError ?? l10n.addressNotFound,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${l10n.locationCoordinates}: ${widget.latitude.toStringAsFixed(5)}, ${widget.longitude.toStringAsFixed(5)}',
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.storyLocation,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: FlutterMap(
                  options: MapOptions(initialCenter: _point, initialZoom: 15),
                  children: [
                    TileLayer(
                      urlTemplate: kOsmTileUrlTemplate,
                      userAgentPackageName: kOsmUserAgentPackageName,
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _point,
                          width: 52,
                          height: 52,
                          child: GestureDetector(
                            onTap: _showAddressSheet,
                            child: const _MapPinMarker(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.tapMarkerForAddress,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.locationCoordinates}: ${widget.latitude.toStringAsFixed(5)}, ${widget.longitude.toStringAsFixed(5)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    if (_isResolvingAddress) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.resolvingAddress,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '© OpenStreetMap',
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

class _MapPinMarker extends StatelessWidget {
  const _MapPinMarker();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF06B6D4),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.location_on_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
