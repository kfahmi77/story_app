import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/app_localizations.dart';

import '../../common/result_state.dart';
import '../../data/api/api_service.dart';
import '../../data/model/story.dart';
import '../../data/repository/auth_repository.dart';
import '../widgets/story_card.dart';

class StoryListPage extends StatefulWidget {
  final void Function(String storyId) onStoryTapped;
  final Future<bool?> Function() onAddStory;
  final VoidCallback onLogout;

  const StoryListPage({
    super.key,
    required this.onStoryTapped,
    required this.onAddStory,
    required this.onLogout,
  });

  @override
  State<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends State<StoryListPage> {
  final _apiService = ApiService();
  final _authRepo = AuthRepository();
  final _scrollController = ScrollController();

  final List<Story> _stories = [];
  ResultState _state = ResultState.initial;
  String _errorMessage = '';
  int _page = 1;
  static const int _pageSize = 10;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchStories();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Ignore top overscroll so pull-to-refresh doesn't accidentally trigger
    // the pagination loader.
    if (position.pixels < 0) return;

    if (position.extentAfter <= 200 &&
        _state != ResultState.loading &&
        _hasMore) {
      _fetchStories();
    }
  }

  Future<void> _fetchStories() async {
    if (_state == ResultState.loading) return;

    setState(() => _state = ResultState.loading);

    try {
      final token = await _authRepo.getToken();
      if (token == null) return;

      final newStories = await _apiService.getAllStories(
        token: token,
        page: _page,
        size: _pageSize,
      );

      if (mounted) {
        setState(() {
          _stories.addAll(newStories);
          _page++;
          _hasMore = newStories.length >= _pageSize;
          _state = ResultState.success;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = _stories.isEmpty ? ResultState.error : ResultState.success;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _stories.clear();
      _page = 1;
      _hasMore = true;
      _state = ResultState.initial;
    });
    await _fetchStories();
  }

  Future<void> _logout() async {
    await _authRepo.clearSession();
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: const Color(0xFF4F46E5),
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        edgeOffset: 120.0,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFF4F46E5),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Text(
                  l10n.story,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),

                    Positioned(
                      right: -30,
                      top: -20,
                      child: Icon(
                        Icons.collections_outlined,
                        size: 150,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  tooltip: l10n.logout,
                  onPressed: _logout,
                ),
              ],
            ),

            _buildSliverBody(l10n),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final isStoryUploaded = await widget.onAddStory();
          if (isStoryUploaded == true && mounted) {
            await _refresh();
          }
        },
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          l10n.newStory,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSliverBody(AppLocalizations l10n) {
    if (_state == ResultState.error && _stories.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    size: 64,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _errorMessage,
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_state == ResultState.loading && _stories.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
        ),
      );
    }

    if (_stories.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inbox_rounded,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.noStories,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Be the first to share a story!",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == _stories.length) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF4F46E5),
              ),
            ),
          );
        }
        final story = _stories[index];
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 8.0 : 0),
          child: StoryCard(
            story: story,
            onTap: () => widget.onStoryTapped(story.id),
          ),
        );
      }, childCount: _stories.length + (_hasMore ? 1 : 0)),
    );
  }
}
