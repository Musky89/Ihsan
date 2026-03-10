import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'data.dart';
import 'theme.dart';

enum AppStage { splash, onboarding, shell }

class LaunchRequest {
  const LaunchRequest({
    this.screenId,
    this.tabIndex,
    this.stage,
    this.showAtlas = false,
  });

  final int? screenId;
  final int? tabIndex;
  final AppStage? stage;
  final bool showAtlas;

  static LaunchRequest fromUri(Uri uri) {
    final Map<String, String> params = uri.queryParameters;
    final int? screenId = int.tryParse(params['screen'] ?? '');
    final int? tabIndex = int.tryParse(params['tab'] ?? '');
    final bool showAtlas = params['atlas'] == '1';
    final String? stageValue = params['stage'];

    AppStage? stage;
    if (stageValue != null) {
      for (final AppStage item in AppStage.values) {
        if (item.name == stageValue) {
          stage = item;
          break;
        }
      }
    }

    return LaunchRequest(
      screenId: screenId,
      tabIndex: tabIndex,
      stage: stage,
      showAtlas: showAtlas,
    );
  }
}

final appStageProvider = NotifierProvider<AppStageNotifier, AppStage>(
  AppStageNotifier.new,
);
final shellTabProvider = NotifierProvider<ShellTabNotifier, int>(
  ShellTabNotifier.new,
);
final tasbeehCountProvider = NotifierProvider<TasbeehCountNotifier, int>(
  TasbeehCountNotifier.new,
);
final prayerTrackerProvider =
    NotifierProvider<PrayerTrackerNotifier, Set<String>>(
      PrayerTrackerNotifier.new,
    );
final aiChatProvider = NotifierProvider<AiChatController, List<ChatMessage>>(
  AiChatController.new,
);

class AppStageNotifier extends Notifier<AppStage> {
  @override
  AppStage build() => AppStage.splash;

  void setStage(AppStage stage) => state = stage;
}

class ShellTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

class TasbeehCountNotifier extends Notifier<int> {
  @override
  int build() => 27;

  void increment() => state = state + 1;

  void reset() => state = 0;
}

class PrayerTrackerNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{
    'Fajr-0',
    'Dhuhr-0',
    'Asr-0',
    'Fajr-1',
    'Dhuhr-1',
    'Maghrib-1',
    'Isha-1',
  };
}

class AiChatController extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => defaultChat;

  Future<void> send(String prompt) async {
    final String trimmed = prompt.trim();
    if (trimmed.isEmpty) {
      return;
    }

    state = <ChatMessage>[
      ...state,
      ChatMessage(author: 'You', body: trimmed, citation: '', isUser: true),
    ];

    await Future<void>.delayed(const Duration(milliseconds: 450));
    final String lowercase = trimmed.toLowerCase();

    late final ChatMessage response;
    if (lowercase.contains('ramadan')) {
      response = const ChatMessage(
        author: 'Ihsan Scholar',
        body:
            'For Ramadan, protect intention first: fasting, Quran, sadaqah, and dua before iftar. Build a rhythm you can keep every day.',
        citation: 'Quran 2:183 · Sahih al-Bukhari 1901',
        isUser: false,
      );
    } else if (lowercase.contains('zakat')) {
      response = const ChatMessage(
        author: 'Ihsan Scholar',
        body:
            'Zakat is due on eligible net assets held for a lunar year once they meet nisab. Ihsan can help calculate, but local nuance still matters.',
        citation: 'Quran 9:60 · Tirmidhi 620',
        isUser: false,
      );
    } else if (lowercase.contains('prayer') || lowercase.contains('salah')) {
      response = const ChatMessage(
        author: 'Ihsan Scholar',
        body:
            'Anchor the day around the next prayer, not the next interruption. Small consistency in salah often repairs the wider day.',
        citation: 'Quran 29:45 · Sahih Muslim 82',
        isUser: false,
      );
    } else {
      response = const ChatMessage(
        author: 'Ihsan Scholar',
        body:
            'I can help you start with Quran, prayer, duas, family habits, or learning plans. If the issue needs a ruling, consult a trusted scholar.',
        citation: 'AI guidance supplements scholarly counsel.',
        isUser: false,
      );
    }

    state = <ChatMessage>[...state, response];
  }
}

class IhsanApp extends ConsumerWidget {
  const IhsanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LaunchRequest launchRequest = LaunchRequest.fromUri(Uri.base);
    return MaterialApp(
      title: 'Ihsan',
      debugShowCheckedModeBanner: false,
      theme: buildSacredTheme(),
      home: AppEntry(launchRequest: launchRequest),
    );
  }
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key, required this.launchRequest});

  final LaunchRequest launchRequest;

  @override
  Widget build(BuildContext context) {
    if (launchRequest.showAtlas) {
      return const ScreenAtlasPage();
    }
    if (launchRequest.screenId case final int screenId) {
      return buildScreenExperience(screenById(screenId));
    }
    if (launchRequest.tabIndex case final int tabIndex) {
      return AppShell(initialTab: tabIndex);
    }
    if (launchRequest.stage case final AppStage stage) {
      switch (stage) {
        case AppStage.splash:
          return const SplashExperience();
        case AppStage.onboarding:
          return const OnboardingExperience();
        case AppStage.shell:
          return const AppShell();
      }
    }

    return const AppFlowHost();
  }
}

class AppFlowHost extends ConsumerWidget {
  const AppFlowHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStage stage = ref.watch(appStageProvider);

    switch (stage) {
      case AppStage.splash:
        return const SplashExperience();
      case AppStage.onboarding:
        return const OnboardingExperience();
      case AppStage.shell:
        return const AppShell();
    }
  }
}

class SplashExperience extends ConsumerStatefulWidget {
  const SplashExperience({super.key});

  @override
  ConsumerState<SplashExperience> createState() => _SplashExperienceState();
}

class _SplashExperienceState extends ConsumerState<SplashExperience>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;
  Timer? _transitionTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _rotation = Tween<double>(
      begin: -0.35,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _transitionTimer = Timer(const Duration(milliseconds: 2100), () {
      if (mounted) {
        ref.read(appStageProvider.notifier).setStage(AppStage.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: sacredGradient(SacredMood.indigo)),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const _AtmosphereOverlay(mood: SacredMood.indigo),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: _rotation.value,
                          child: Transform.scale(
                            scale: _scale.value,
                            child: child,
                          ),
                        );
                      },
                      child: const BloomStar(size: 150),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'IHSAN',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The Muslim Super App',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: SacredColors.gold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Pursue Excellence.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: SacredColors.moonlight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingExperience extends ConsumerStatefulWidget {
  const OnboardingExperience({super.key});

  @override
  ConsumerState<OnboardingExperience> createState() =>
      _OnboardingExperienceState();
}

class _OnboardingExperienceState extends ConsumerState<OnboardingExperience> {
  late final PageController _pageController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _enterApp() {
    ref.read(appStageProvider.notifier).setStage(AppStage.shell);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final IhsanOnboardingSlide slide = onboardingSlides[_index];
    return DecoratedBox(
      decoration: BoxDecoration(gradient: sacredGradient(slide.mood)),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _AtmosphereOverlay(mood: slide.mood),
          SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const BloomStar(size: 42),
                      TextButton(
                        onPressed: _enterApp,
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingSlides.length,
                    onPageChanged: (int value) =>
                        setState(() => _index = value),
                    itemBuilder: (BuildContext context, int index) {
                      final IhsanOnboardingSlide item = onboardingSlides[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Spacer(),
                            Align(
                              child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  gradient: sacredGradient(item.mood),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.14),
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: SacredColors.gold.withValues(
                                        alpha: 0.18,
                                      ),
                                      blurRadius: 42,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  item.icon,
                                  color: readableForeground(item.mood),
                                  size: 64,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              item.title,
                              style: theme.textTheme.displayMedium,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              item.subtitle,
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              item.caption,
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: const <Widget>[
                                _TagChip(label: 'Privacy-first'),
                                _TagChip(label: 'Sacred Night'),
                                _TagChip(label: 'Explore before signup'),
                              ],
                            ),
                            const SizedBox(height: 36),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    onboardingSlides.length,
                    (int index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 12,
                      ),
                      width: _index == index ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _index == index
                            ? SacredColors.gold
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                  child: Column(
                    children: <Widget>[
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: SacredColors.gold,
                          foregroundColor: SacredColors.obsidian,
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: _index == onboardingSlides.length - 1
                            ? _enterApp
                            : () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 320),
                                curve: Curves.easeOutCubic,
                              ),
                        child: Text(
                          _index == onboardingSlides.length - 1
                              ? 'Enter Ihsan'
                              : 'Continue',
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () =>
                            openScreenPreview(context, screenById(5)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                        child: const Text('Preview authentication flow'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shellTabProvider.notifier).setIndex(widget.initialTab);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int index = ref.watch(shellTabProvider);
    final List<Widget> pages = <Widget>[
      const HomeDashboardPage(),
      const QuranHubPage(),
      const PrayerHubPage(),
      const CommunityHubPage(),
      const MoreHubPage(),
    ];

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: IndexedStack(index: index, children: pages),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: _FloatingNavBar(
              currentIndex: index,
              onSelected: (int value) =>
                  ref.read(shellTabProvider.notifier).setIndex(value),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.indigo,
      title: 'Asr in 2h 34m',
      subtitle:
          '${DateFormat('EEEE, d MMMM').format(DateTime.now())} · 10 Ramadan 1447',
      actions: <Widget>[
        _HeaderAction(
          icon: Icons.search_rounded,
          onPressed: () => openScreenPreview(context, screenById(62)),
        ),
        _HeaderAction(
          icon: Icons.notifications_none_rounded,
          onPressed: () => openScreenPreview(context, screenById(26)),
        ),
      ],
      children: <Widget>[
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _SectionEyebrow('Verse of the day'),
              const SizedBox(height: 12),
              Text(
                'Indeed, prayer has been decreed upon the believers a decree of specified times.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Quran 4:103',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SacredColors.gold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'Contextual bento',
          actionLabel: 'View all screens',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ScreenAtlasPage()),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: <Widget>[
            SizedBox(
              width: 220,
              child: _ActionTile(
                title: 'Prayer arc timeline',
                subtitle: 'Track the day as a luminous curve.',
                icon: Icons.timeline_rounded,
                mood: SacredMood.gold,
                onTap: () => openScreenPreview(context, screenById(14)),
              ),
            ),
            SizedBox(
              width: 160,
              child: _ActionTile(
                title: 'Continue Al-Kahf',
                subtitle: 'Ayah 28',
                icon: Icons.menu_book_rounded,
                mood: SacredMood.parchment,
                onTap: () => openScreenPreview(context, screenById(18)),
              ),
            ),
            SizedBox(
              width: 160,
              child: _ActionTile(
                title: 'Morning adhkar',
                subtitle: '12 duas',
                icon: Icons.wb_twilight_rounded,
                mood: SacredMood.rose,
                onTap: () => openScreenPreview(context, screenById(21)),
              ),
            ),
            SizedBox(
              width: 220,
              child: _ActionTile(
                title: 'Ramadan mode',
                subtitle: 'Checklist, khatm tracker, fasting ring.',
                icon: Icons.mode_night_rounded,
                mood: SacredMood.ramadan,
                onTap: () => openScreenPreview(context, screenById(53)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'Prayer rhythm',
          actionLabel: 'Open tracker',
          onTap: () => openScreenPreview(context, screenById(16)),
        ),
        const SizedBox(height: 12),
        GlassPanel(
          child: Column(
            children: prayerSchedule
                .map(
                  (PrayerWindow prayer) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: sacredAccent(
                            prayer.mood,
                          ).withValues(alpha: 0.18),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: sacredAccent(prayer.mood),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            prayer.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(prayer.time),
                        const SizedBox(width: 10),
                        Text(
                          prayer.remaining,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class QuranHubPage extends StatelessWidget {
  const QuranHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.parchment,
      title: 'The Quran, beautifully',
      subtitle: 'Immersive reading, listening, and daily continuity.',
      actions: <Widget>[
        _HeaderAction(
          icon: Icons.search_rounded,
          foregroundColor: SacredColors.obsidian,
          onPressed: () => openScreenPreview(context, screenById(62)),
        ),
      ],
      children: <Widget>[
        GlassPanel(
          invert: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _SectionEyebrow('Resume'),
              const SizedBox(height: 10),
              Text(
                'Surah Al-Kahf',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: SacredColors.obsidian,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Read with Amiri Quran typography, gold verse markers, and hidden controls.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: SacredColors.deepEarth),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () => openScreenPreview(context, screenById(18)),
                style: FilledButton.styleFrom(
                  backgroundColor: SacredColors.deepEarth,
                  foregroundColor: SacredColors.moonlight,
                ),
                child: const Text('Open reader'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'Recently read',
          actionLabel: 'Surah index',
          darkText: true,
          onTap: () => openScreenPreview(context, screenById(17)),
        ),
        const SizedBox(height: 12),
        ...surahCards.map(
          (ContentCardData card) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ContentListTile(
              card: card,
              invert: true,
              onTap: () => openScreenPreview(context, screenById(18)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _SectionHeader(
          title: 'Plans & audio',
          actionLabel: 'Audio player',
          darkText: true,
          onTap: () => openScreenPreview(context, screenById(19)),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _ActionTile(
                title: 'Reading plan',
                subtitle: 'Complete in Ramadan or across the year.',
                icon: Icons.track_changes_rounded,
                mood: SacredMood.gold,
                invert: true,
                onTap: () => openScreenPreview(context, screenById(20)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _ActionTile(
                title: 'Audio',
                subtitle: 'Mishary, Sudais, Husary, Abdul Basit.',
                icon: Icons.graphic_eq_rounded,
                mood: SacredMood.indigo,
                onTap: () => openScreenPreview(context, screenById(19)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PrayerHubPage extends StatelessWidget {
  const PrayerHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.gold,
      title: 'Prayer is the anchor',
      subtitle: 'Arc timeline, Qibla, streaks, and local calculation clarity.',
      actions: <Widget>[
        _HeaderAction(
          icon: Icons.explore_rounded,
          foregroundColor: SacredColors.moonlight,
          onPressed: () => openScreenPreview(context, screenById(15)),
        ),
      ],
      children: <Widget>[
        GestureDetector(
          onTap: () => openScreenPreview(context, screenById(14)),
          child: GlassPanel(
            child: SizedBox(
              height: 240,
              child: CustomPaint(
                painter: PrayerArcPainter(prayerSchedule: prayerSchedule),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Asr',
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(fontSize: 38),
                      ),
                      Text(
                        'In 2h 34m',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            Expanded(
              child: _ActionTile(
                title: 'Qibla compass',
                subtitle: '245° SW · 3,362 mi to Makkah',
                icon: Icons.navigation_rounded,
                mood: SacredMood.indigo,
                onTap: () => openScreenPreview(context, screenById(15)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _ActionTile(
                title: 'Weekly tracker',
                subtitle: '25 of 35 prayers completed this week.',
                icon: Icons.grid_view_rounded,
                mood: SacredMood.obsidian,
                onTap: () => openScreenPreview(context, screenById(16)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CommunityHubPage extends StatelessWidget {
  const CommunityHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.obsidian,
      title: 'Your ummah, connected',
      subtitle: 'Community, events, masjids, and trusted learning.',
      actions: <Widget>[
        _HeaderAction(
          icon: Icons.add_circle_outline_rounded,
          onPressed: () => openScreenPreview(context, screenById(28)),
        ),
      ],
      children: <Widget>[
        _SectionHeader(
          title: 'Community feed',
          actionLabel: 'Open feed',
          onTap: () => openScreenPreview(context, screenById(27)),
        ),
        const SizedBox(height: 12),
        ...communityFeed.map(
          (FeedPost post) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: sacredAccent(
                          post.mood,
                        ).withValues(alpha: 0.22),
                        child: Text(post.author.substring(0, 1)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          post.author,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      _TagChip(label: post.reaction),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(post.body),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: _ActionTile(
                title: 'Masjid finder',
                subtitle: 'Explore nearby mosques on a branded map.',
                icon: Icons.map_outlined,
                mood: SacredMood.indigo,
                onTap: () => openScreenPreview(context, screenById(29)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _ActionTile(
                title: 'Learning',
                subtitle: 'Events, courses, and article experiences.',
                icon: Icons.school_outlined,
                mood: SacredMood.gold,
                onTap: () => openScreenPreview(context, screenById(37)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MoreHubPage extends StatelessWidget {
  const MoreHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.obsidian,
      title: 'More dimensions of Muslim life',
      subtitle:
          'Services, AI, commerce, family, settings, and the full concept atlas.',
      actions: <Widget>[
        _HeaderAction(
          icon: Icons.settings_outlined,
          onPressed: () => openScreenPreview(context, screenById(24)),
        ),
      ],
      children: <Widget>[
        _SectionHeader(
          title: 'Explore phases',
          actionLabel: 'Full atlas',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ScreenAtlasPage()),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: <Widget>[
            SizedBox(
              width: 170,
              child: _ActionTile(
                title: 'AI scholar',
                subtitle: 'Cited conversational support.',
                icon: Icons.smart_toy_outlined,
                mood: SacredMood.indigo,
                onTap: () => openScreenPreview(context, screenById(50)),
              ),
            ),
            SizedBox(
              width: 170,
              child: _ActionTile(
                title: 'Zakat',
                subtitle: 'Assets, liabilities, nisab.',
                icon: Icons.calculate_outlined,
                mood: SacredMood.gold,
                onTap: () => openScreenPreview(context, screenById(43)),
              ),
            ),
            SizedBox(
              width: 170,
              child: _ActionTile(
                title: 'Family',
                subtitle: 'Shared spiritual dashboards.',
                icon: Icons.family_restroom_outlined,
                mood: SacredMood.obsidian,
                onTap: () => openScreenPreview(context, screenById(55)),
              ),
            ),
            SizedBox(
              width: 170,
              child: _ActionTile(
                title: 'Demo journey',
                subtitle: 'Run the full guided feature test.',
                icon: Icons.route_rounded,
                mood: SacredMood.teal,
                onTap: () => openScreenPreview(context, screenById(70)),
              ),
            ),
            SizedBox(
              width: 170,
              child: _ActionTile(
                title: 'Tasbeeh',
                subtitle: 'A meditative digital counter.',
                icon: Icons.touch_app_rounded,
                mood: SacredMood.rose,
                onTap: () => openScreenPreview(context, screenById(25)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'Commerce & services',
          actionLabel: 'View directories',
          onTap: () => openScreenPreview(context, screenById(39)),
        ),
        const SizedBox(height: 12),
        ...halalListings.map(
          (ContentCardData card) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ContentListTile(
              card: card,
              onTap: () => openScreenPreview(context, screenById(39)),
            ),
          ),
        ),
      ],
    );
  }
}

class AtmosphericPage extends StatelessWidget {
  const AtmosphericPage({
    super.key,
    required this.mood,
    required this.title,
    required this.subtitle,
    required this.children,
    this.actions = const <Widget>[],
  });

  final SacredMood mood;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final bool dark = mood != SacredMood.parchment;
    final Color foreground = dark
        ? SacredColors.moonlight
        : SacredColors.obsidian;
    return DecoratedBox(
      decoration: BoxDecoration(gradient: sacredGradient(mood)),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _AtmosphereOverlay(mood: mood),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const BloomStar(size: 34),
                      const Spacer(),
                      ...actions,
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.displayMedium?.copyWith(color: foreground),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: dark
                          ? SacredColors.moonlight
                          : SacredColors.deepEarth,
                    ),
                  ),
                  const SizedBox(height: 26),
                  ...children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenAtlasPage extends StatelessWidget {
  const ScreenAtlasPage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> phases = <String>[
      'Phase 1',
      'Phase 2',
      'Phase 3',
      'Phase 4',
      'System',
    ];

    return AtmosphericPage(
      mood: SacredMood.obsidian,
      title: 'Ihsan V2 screen atlas',
      subtitle:
          'All 69 concept screens organized by phase and rendered as an interactive prototype.',
      actions: <Widget>[
        _HeaderAction(
          icon: Icons.search_rounded,
          onPressed: () => openScreenPreview(context, screenById(62)),
        ),
      ],
      children: phases
          .map(
            (String phase) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: GlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(phase, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ...screensForPhase(phase).map(
                      (IhsanScreenSpec screen) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: sacredAccent(
                            screen.mood,
                          ).withValues(alpha: 0.18),
                          child: Icon(screen.icon, color: SacredColors.gold),
                        ),
                        title: Text(screen.title),
                        subtitle: Text(screen.category),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () => openScreenPreview(context, screen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class GenericExperiencePage extends StatelessWidget {
  const GenericExperiencePage({super.key, required this.spec});

  final IhsanScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    final bool dark = spec.mood != SacredMood.parchment;
    final Color foreground = dark
        ? SacredColors.moonlight
        : SacredColors.obsidian;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: sacredGradient(spec.mood)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _AtmosphereOverlay(mood: spec.mood),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _HeaderAction(
                          icon: Icons.arrow_back_rounded,
                          foregroundColor: foreground,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        _TagChip(label: spec.phase),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        BloomStar(
                          size: 56,
                          color: sacredAccent(spec.mood),
                          ringColor: foreground.withValues(alpha: 0.22),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            spec.title,
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(color: foreground),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      spec.headline,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: foreground),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      spec.summary,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: dark
                            ? SacredColors.moonlight
                            : SacredColors.deepEarth,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: spec.tags
                          .map((String tag) => _TagChip(label: tag))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    GlassPanel(
                      invert: !dark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const _SectionEyebrow('Prototype brief'),
                          const SizedBox(height: 10),
                          _MetricRow(
                            label: 'Screen number',
                            value: '${spec.id}',
                            invert: !dark,
                          ),
                          _MetricRow(
                            label: 'Category',
                            value: spec.category,
                            invert: !dark,
                          ),
                          _MetricRow(
                            label: 'Mood',
                            value: spec.mood.name,
                            invert: !dark,
                          ),
                        ],
                      ),
                    ),
                    if (spec.bullets.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 18),
                      GlassPanel(
                        invert: !dark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const _SectionEyebrow('Key experience notes'),
                            const SizedBox(height: 12),
                            ...spec.bullets.map(
                              (String bullet) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Icon(
                                        Icons.auto_awesome_rounded,
                                        size: 16,
                                        color: sacredAccent(spec.mood),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        bullet,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: invertText(!dark),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    _SectionHeader(
                      title: 'Related concept screens',
                      actionLabel: 'Open atlas',
                      darkText: !dark,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ScreenAtlasPage(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...allScreens
                        .where(
                          (IhsanScreenSpec item) =>
                              item.category == spec.category &&
                              item.id != spec.id,
                        )
                        .take(3)
                        .map(
                          (IhsanScreenSpec item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ContentListTile(
                              card: ContentCardData(
                                title: item.title,
                                subtitle: item.summary,
                                meta: item.phase,
                                mood: item.mood,
                                icon: item.icon,
                              ),
                              invert: !dark,
                              onTap: () => openScreenPreview(context, item),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrayerTimesExperiencePage extends StatelessWidget {
  const PrayerTimesExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.gold,
      title: 'Prayer arc timeline',
      subtitle:
          'Five prayers arranged across the day instead of buried in a utilitarian list.',
      children: <Widget>[
        GlassPanel(
          child: SizedBox(
            height: 260,
            child: CustomPaint(
              painter: PrayerArcPainter(prayerSchedule: prayerSchedule),
            ),
          ),
        ),
        const SizedBox(height: 18),
        ...prayerSchedule.map(
          (PrayerWindow prayer) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ContentListTile(
              card: ContentCardData(
                title: prayer.name,
                subtitle: prayer.remaining,
                meta: prayer.time,
                mood: prayer.mood,
                icon: Icons.notifications_active_outlined,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class QuranReaderExperiencePage extends StatelessWidget {
  const QuranReaderExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle arabicStyle = GoogleFonts.amiriQuran(
      fontSize: 30,
      height: 1.8,
      color: SacredColors.deepEarth,
    );
    return AtmosphericPage(
      mood: SacredMood.parchment,
      title: 'Quran reader',
      subtitle: 'Warm parchment, gold verse markers, and almost no chrome.',
      children: <Widget>[
        GlassPanel(
          invert: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                style: arabicStyle.copyWith(fontSize: 34),
              ),
              const SizedBox(height: 18),
              Text(
                'إِنَّ مَعَ الْعُسْرِ يُسْرًا ۝ فَإِذَا فَرَغْتَ فَانصَبْ ۝ وَإِلَىٰ رَبِّكَ فَارْغَب',
                textAlign: TextAlign.right,
                style: arabicStyle,
              ),
              const SizedBox(height: 16),
              Text(
                'Indeed, with hardship comes ease. So when you have finished your duties, strive in worship. And to your Lord direct your longing.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: SacredColors.deepEarth),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TasbeehExperiencePage extends ConsumerWidget {
  const TasbeehExperiencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int count = ref.watch(tasbeehCountProvider);
    final double progress = (count % 33) / 33;

    return AtmosphericPage(
      mood: SacredMood.indigo,
      title: 'Tasbeeh',
      subtitle:
          'A meditative dhikr counter that celebrates rhythm without becoming noisy.',
      children: <Widget>[
        GlassPanel(
          child: Column(
            children: <Widget>[
              Text(
                'سُبْحَانَ ٱللَّٰهِ',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 16,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        color: SacredColors.gold,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '$count',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          'of 33',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () =>
                    ref.read(tasbeehCountProvider.notifier).increment(),
                style: FilledButton.styleFrom(
                  backgroundColor: SacredColors.gold,
                  foregroundColor: SacredColors.obsidian,
                  minimumSize: const Size(180, 56),
                ),
                child: const Text('Count'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    ref.read(tasbeehCountProvider.notifier).reset(),
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommunityFeedExperiencePage extends StatelessWidget {
  const CommunityFeedExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.obsidian,
      title: 'Community feed',
      subtitle:
          'A masonry-style flow with verified masjid content and Islamic reactions.',
      children: <Widget>[
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: communityFeed
              .map(
                (FeedPost post) => SizedBox(
                  width: 170 + (post.author.length.isEven ? 30 : 0),
                  child: GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: sacredAccent(
                                post.mood,
                              ).withValues(alpha: 0.2),
                              child: Text(post.author.substring(0, 1)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(post.author)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(post.body),
                        const SizedBox(height: 12),
                        _TagChip(label: post.reaction),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class MasjidMapExperiencePage extends StatelessWidget {
  const MasjidMapExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.indigo,
      title: 'Masjid finder',
      subtitle:
          'Nearby mosques with branded map pins, next prayer context, and quick directions.',
      children: <Widget>[
        GlassPanel(
          child: SizedBox(
            height: 320,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: sacredGradient(SacredMood.indigo),
                    ),
                  ),
                ),
                ...const <Offset>[
                  Offset(0.2, 0.25),
                  Offset(0.55, 0.4),
                  Offset(0.7, 0.18),
                ].map(
                  (Offset point) => Positioned(
                    left: 220 * point.dx + 32,
                    top: 220 * point.dy + 24,
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 38,
                      color: SacredColors.gold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GlassPanel(
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.mosque_rounded),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Text('Masjid Noor'),
                                SizedBox(height: 4),
                                Text('0.8 mi · Maghrib 6:47 PM'),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ZakatCalculatorPage extends StatefulWidget {
  const ZakatCalculatorPage({super.key});

  @override
  State<ZakatCalculatorPage> createState() => _ZakatCalculatorPageState();
}

class _ZakatCalculatorPageState extends State<ZakatCalculatorPage> {
  final TextEditingController _cashController = TextEditingController(
    text: '12000',
  );
  final TextEditingController _goldController = TextEditingController(
    text: '3800',
  );
  final TextEditingController _investmentsController = TextEditingController(
    text: '7000',
  );
  final TextEditingController _businessController = TextEditingController(
    text: '2400',
  );
  final TextEditingController _liabilitiesController = TextEditingController(
    text: '3200',
  );

  @override
  void dispose() {
    _cashController.dispose();
    _goldController.dispose();
    _investmentsController.dispose();
    _businessController.dispose();
    _liabilitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double zakat = calculateZakat(
      cash: _parse(_cashController.text),
      gold: _parse(_goldController.text),
      investments: _parse(_investmentsController.text),
      businessAssets: _parse(_businessController.text),
      liabilities: _parse(_liabilitiesController.text),
      nisab: 550,
    );

    return AtmosphericPage(
      mood: SacredMood.obsidian,
      title: 'Zakat calculator',
      subtitle:
          'Comprehensive but clear inputs for cash, gold, investments, business assets, and liabilities.',
      children: <Widget>[
        GlassPanel(
          child: Column(
            children: <Widget>[
              _MoneyField(label: 'Cash / bank', controller: _cashController),
              _MoneyField(label: 'Gold / silver', controller: _goldController),
              _MoneyField(
                label: 'Investments',
                controller: _investmentsController,
              ),
              _MoneyField(
                label: 'Business assets',
                controller: _businessController,
              ),
              _MoneyField(
                label: 'Liabilities',
                controller: _liabilitiesController,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => setState(() {}),
                style: FilledButton.styleFrom(
                  backgroundColor: SacredColors.gold,
                  foregroundColor: SacredColors.obsidian,
                ),
                child: const Text('Recalculate'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _SectionEyebrow('Result'),
              const SizedBox(height: 10),
              Text(
                '\$${zakat.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                zakat == 0
                    ? 'Net assets are below the illustrative nisab threshold in this prototype.'
                    : 'This is 2.5% of your eligible net zakatable assets above the prototype nisab threshold.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AiScholarPage extends ConsumerStatefulWidget {
  const AiScholarPage({super.key});

  @override
  ConsumerState<AiScholarPage> createState() => _AiScholarPageState();
}

class _AiScholarPageState extends ConsumerState<AiScholarPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChatMessage> messages = ref.watch(aiChatProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: sacredGradient(SacredMood.obsidian),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const _AtmosphereOverlay(mood: SacredMood.obsidian),
            SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: Row(
                      children: <Widget>[
                        _HeaderAction(
                          icon: Icons.arrow_back_rounded,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 12),
                        const BloomStar(size: 42),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'AI Islamic Scholar',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: messages.length,
                      separatorBuilder: (_, unusedIndex) =>
                          const SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int index) {
                        final ChatMessage message = messages[index];
                        final bool user = message.isUser;
                        return Align(
                          alignment: user
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: GlassPanel(
                            width: 320,
                            tint: user
                                ? SacredColors.gold.withValues(alpha: 0.9)
                                : null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  message.author,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: user
                                            ? SacredColors.obsidian
                                            : SacredColors.moonlight,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  message.body,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: user
                                            ? SacredColors.obsidian
                                            : SacredColors.moonlight,
                                      ),
                                ),
                                if (message.citation.isNotEmpty) ...<Widget>[
                                  const SizedBox(height: 10),
                                  Text(
                                    message.citation,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: user
                                              ? SacredColors.deepEarth
                                              : SacredColors.gold,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText:
                                  'Ask about prayer, Quran, Ramadan, zakat...',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: () async {
                            final String prompt = _controller.text;
                            _controller.clear();
                            await ref
                                .read(aiChatProvider.notifier)
                                .send(prompt);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: SacredColors.gold,
                            foregroundColor: SacredColors.obsidian,
                            minimumSize: const Size(56, 56),
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(Icons.send_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RamadanModePage extends StatelessWidget {
  const RamadanModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.ramadan,
      title: 'Ramadan mode',
      subtitle:
          'A transformed app shell for fasting, khatm, sadaqah, and nightly worship.',
      children: <Widget>[
        GlassPanel(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: 0.72,
                        strokeWidth: 16,
                        color: SacredColors.gold,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '2h 08m',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          'until iftar',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const _ChecklistRow(label: 'Fajr'),
              const _ChecklistRow(label: 'Read 1 juz'),
              const _ChecklistRow(label: 'Give sadaqah'),
              const _ChecklistRow(label: 'Dua before iftar'),
              const _ChecklistRow(label: 'Taraweeh'),
            ],
          ),
        ),
      ],
    );
  }
}

class FamilyDashboardPage extends StatelessWidget {
  const FamilyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.obsidian,
      title: 'Family dashboard',
      subtitle:
          'Gentle household oversight for prayer rhythm, hifz, and spiritually aligned routines.',
      children: familyMembers
          .map(
            (FamilyMemberStatus member) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      member.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(member.focus),
                    const SizedBox(height: 14),
                    _ProgressMetric(
                      label: 'Prayer consistency',
                      progress: member.prayerScore,
                    ),
                    const SizedBox(height: 10),
                    _ProgressMetric(
                      label: 'Hifz progress',
                      progress: member.hifzScore,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class DemoJourneyPage extends StatefulWidget {
  const DemoJourneyPage({super.key});

  @override
  State<DemoJourneyPage> createState() => _DemoJourneyPageState();
}

class _DemoJourneyPageState extends State<DemoJourneyPage> {
  static const List<(String, String, int)> _steps = <(String, String, int)>[
    (
      'Start from Home',
      'Confirm the contextual dashboard and next-prayer emphasis.',
      13,
    ),
    (
      'Read Quran',
      'Open the immersive Quran reader and verify sacred typography.',
      18,
    ),
    (
      'Review prayer timeline',
      'Inspect the arc-based prayer visualization and daily flow.',
      14,
    ),
    (
      'Check community',
      'Browse the masonry community feed and nearby masjid discovery.',
      27,
    ),
    (
      'Open zakat flow',
      'Validate financial inputs and calculation behavior.',
      43,
    ),
    (
      'Ask the AI scholar',
      'Test cited conversational guidance with a real prompt.',
      50,
    ),
    (
      'Enter Ramadan mode',
      'Verify the transformed seasonal experience and checklist.',
      53,
    ),
    (
      'Review family dashboard',
      'Inspect family progress summaries and encouragement patterns.',
      55,
    ),
    (
      'Run global search',
      'Search across the ecosystem and confirm result quality.',
      62,
    ),
    (
      'Open screen atlas',
      'Verify full inventory access and exploratory coverage.',
      11,
    ),
  ];

  late final List<bool> _completed = List<bool>.filled(_steps.length, false);

  @override
  Widget build(BuildContext context) {
    final int completedCount = _completed.where((bool value) => value).length;
    final double progress = completedCount / _steps.length;

    return AtmosphericPage(
      mood: SacredMood.indigo,
      title: 'Guided demo journey',
      subtitle:
          'A built-in test run that walks through Ihsan\'s core product story from devotion to daily living.',
      children: <Widget>[
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _SectionEyebrow('Demo progress'),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$completedCount of ${_steps.length} checks complete',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use this journey to verify the core feature sweep before release or during demos.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 86,
                    height: 86,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 9,
                          color: SacredColors.gold,
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                        ),
                        Text('${(progress * 100).round()}%'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ..._steps.indexed.map(((int, (String, String, int)) entry) {
          final int index = entry.$1;
          final (String, String, int) item = entry.$2;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: _completed[index]
                            ? SacredColors.gold.withValues(alpha: 0.22)
                            : Colors.white.withValues(alpha: 0.08),
                        child: Icon(
                          _completed[index]
                              ? Icons.check_rounded
                              : Icons.play_arrow_rounded,
                          color: _completed[index]
                              ? SacredColors.gold
                              : SacredColors.moonlight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.$1,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: _completed[index],
                        activeThumbColor: SacredColors.gold,
                        onChanged: (bool value) {
                          setState(() => _completed[index] = value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.$2,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: SacredColors.muted),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      FilledButton(
                        onPressed: () {
                          if (item.$1 == 'Open screen atlas') {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ScreenAtlasPage(),
                              ),
                            );
                            return;
                          }
                          openScreenPreview(context, screenById(item.$3));
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: SacredColors.gold,
                          foregroundColor: SacredColors.obsidian,
                        ),
                        child: const Text('Open step'),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          setState(
                            () => _completed[index] = !_completed[index],
                          );
                        },
                        child: Text(
                          _completed[index]
                              ? 'Mark incomplete'
                              : 'Mark complete',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class NotificationCenterPage extends StatelessWidget {
  const NotificationCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.obsidian,
      title: 'Notification center',
      subtitle:
          'A calm chronological feed for reminders, content, community, and seasonal prompts.',
      children: notifications
          .map(
            (NotificationItem item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ContentListTile(
                card: ContentCardData(
                  title: item.title,
                  subtitle: item.body,
                  meta: item.time,
                  mood: item.mood,
                  icon: Icons.notifications_active_outlined,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class UniversalSearchPage extends StatefulWidget {
  const UniversalSearchPage({super.key});

  @override
  State<UniversalSearchPage> createState() => _UniversalSearchPageState();
}

class _UniversalSearchPageState extends State<UniversalSearchPage> {
  final TextEditingController _controller = TextEditingController(
    text: 'quran',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String query = _controller.text.trim().toLowerCase();
    final List<IhsanScreenSpec> results = allScreens.where((
      IhsanScreenSpec item,
    ) {
      final String haystack =
          '${item.title} ${item.summary} ${item.category} ${item.tags.join(' ')}'
              .toLowerCase();
      return query.isEmpty || haystack.contains(query);
    }).toList();

    return AtmosphericPage(
      mood: SacredMood.obsidian,
      title: 'Global search',
      subtitle:
          'Search Quran, duas, community, services, and every concept screen from one place.',
      children: <Widget>[
        TextField(
          controller: _controller,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: 'Search for Quran, dua, events, services...',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const <Widget>[
            _TagChip(label: 'All'),
            _TagChip(label: 'Quran'),
            _TagChip(label: 'Duas'),
            _TagChip(label: 'Articles'),
            _TagChip(label: 'Community'),
          ],
        ),
        const SizedBox(height: 18),
        ...results
            .take(12)
            .map(
              (IhsanScreenSpec item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ContentListTile(
                  card: ContentCardData(
                    title: item.title,
                    subtitle: item.summary,
                    meta: item.phase,
                    mood: item.mood,
                    icon: item.icon,
                  ),
                  onTap: () => openScreenPreview(context, item),
                ),
              ),
            ),
      ],
    );
  }
}

class AccessibilitySettingsPage extends StatefulWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  State<AccessibilitySettingsPage> createState() =>
      _AccessibilitySettingsPageState();
}

class _AccessibilitySettingsPageState extends State<AccessibilitySettingsPage> {
  double _fontScale = 1.0;
  double _arabicScale = 1.1;
  bool _reduceMotion = false;
  bool _highContrast = false;

  @override
  Widget build(BuildContext context) {
    return AtmosphericPage(
      mood: SacredMood.obsidian,
      title: 'Accessibility settings',
      subtitle:
          'Arabic sizing, contrast, motion, and interaction controls made first-class.',
      children: <Widget>[
        GlassPanel(
          child: Column(
            children: <Widget>[
              _SwitchRow(
                label: 'Reduce motion',
                value: _reduceMotion,
                onChanged: (bool value) =>
                    setState(() => _reduceMotion = value),
              ),
              _SwitchRow(
                label: 'High contrast mode',
                value: _highContrast,
                onChanged: (bool value) =>
                    setState(() => _highContrast = value),
              ),
              const SizedBox(height: 10),
              _SliderRow(
                label: 'Body text size',
                value: _fontScale,
                min: 0.8,
                max: 1.5,
                onChanged: (double value) => setState(() => _fontScale = value),
              ),
              _SliderRow(
                label: 'Arabic text size',
                value: _arabicScale,
                min: 0.9,
                max: 1.7,
                onChanged: (double value) =>
                    setState(() => _arabicScale = value),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.width,
    this.tint,
    this.invert = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final double? width;
  final Color? tint;
  final bool invert;

  @override
  Widget build(BuildContext context) {
    final Color fill =
        tint ??
        (invert
            ? Colors.white.withValues(alpha: 0.72)
            : Colors.white.withValues(alpha: 0.08));
    final Color border = invert
        ? Colors.black.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class BloomStar extends StatelessWidget {
  const BloomStar({
    super.key,
    required this.size,
    this.color = SacredColors.gold,
    this.ringColor,
  });

  final double size;
  final Color color;
  final Color? ringColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: BloomStarPainter(
        color: color,
        ringColor: ringColor ?? SacredColors.moonlight.withValues(alpha: 0.12),
      ),
    );
  }
}

class BloomStarPainter extends CustomPainter {
  BloomStarPainter({required this.color, required this.ringColor});

  final Color color;
  final Color ringColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2;
    final Paint ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06;
    canvas.drawCircle(center, radius * 0.9, ringPaint);

    final Path path = Path();
    for (int i = 0; i < 16; i++) {
      final double angle = (math.pi * 2 / 16) * i - math.pi / 2;
      final double pointRadius = i.isEven ? radius * 0.72 : radius * 0.38;
      final Offset point = Offset(
        center.dx + math.cos(angle) * pointRadius,
        center.dy + math.sin(angle) * pointRadius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    final Paint fillPaint = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          color.withValues(alpha: 0.96),
          color.withValues(alpha: 0.72),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant BloomStarPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.ringColor != ringColor;
  }
}

class PrayerArcPainter extends CustomPainter {
  PrayerArcPainter({required this.prayerSchedule});

  final List<PrayerWindow> prayerSchedule;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height * 0.82);
    final Rect rect = Rect.fromCircle(
      center: center,
      radius: size.width * 0.36,
    );
    final Paint track = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi, math.pi, false, track);

    final List<Color> colors = prayerSchedule
        .map((PrayerWindow prayer) => sacredAccent(prayer.mood))
        .toList();
    final Paint gradientTrack = Paint()
      ..shader = SweepGradient(
        startAngle: math.pi,
        endAngle: math.pi * 2,
        colors: colors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi, math.pi * 0.72, false, gradientTrack);

    for (int i = 0; i < prayerSchedule.length; i++) {
      final double t = i / (prayerSchedule.length - 1);
      final double angle = math.pi + math.pi * t;
      final Offset point = Offset(
        center.dx + math.cos(angle) * size.width * 0.36,
        center.dy + math.sin(angle) * size.width * 0.36,
      );
      final Paint dotPaint = Paint()
        ..color = sacredAccent(prayerSchedule[i].mood);
      canvas.drawCircle(point, 9, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PrayerArcPainter oldDelegate) => false;
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({required this.currentIndex, required this.onSelected});

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const List<(IconData, String)> items = <(IconData, String)>[
      (Icons.home_rounded, 'Home'),
      (Icons.menu_book_rounded, 'Quran'),
      (Icons.schedule_rounded, 'Prayer'),
      (Icons.groups_rounded, 'Community'),
      (Icons.widgets_outlined, 'More'),
    ];

    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List<Widget>.generate(items.length, (int index) {
          final bool active = index == currentIndex;
          final (IconData icon, String label) = items[index];
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelected(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: active ? SacredColors.gold : SacredColors.muted,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: active ? SacredColors.gold : SacredColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.onPressed,
    this.foregroundColor = SacredColors.moonlight,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(icon, color: foregroundColor, size: 20),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.mood,
    required this.onTap,
    this.invert = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final SacredMood mood;
  final VoidCallback onTap;
  final bool invert;

  @override
  Widget build(BuildContext context) {
    final Color textColor = invert
        ? SacredColors.obsidian
        : SacredColors.moonlight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: GlassPanel(
        invert: invert,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: sacredAccent(
                  mood,
                ).withValues(alpha: invert ? 0.18 : 0.22),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: sacredAccent(mood)),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: invert ? SacredColors.deepEarth : SacredColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentListTile extends StatelessWidget {
  const _ContentListTile({required this.card, this.onTap, this.invert = false});

  final ContentCardData card;
  final VoidCallback? onTap;
  final bool invert;

  @override
  Widget build(BuildContext context) {
    final Color titleColor = invert
        ? SacredColors.obsidian
        : SacredColors.moonlight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: GlassPanel(
        invert: invert,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: sacredGradient(card.mood),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(card.icon, color: readableForeground(card.mood)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    card.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: titleColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    card.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: invert
                          ? SacredColors.deepEarth
                          : SacredColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.meta,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: invert
                          ? SacredColors.deepEarth
                          : SacredColors.gold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: invert ? SacredColors.deepEarth : SacredColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: SacredColors.moonlight),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
    this.darkText = false,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;
  final bool darkText;

  @override
  Widget build(BuildContext context) {
    final Color textColor = darkText
        ? SacredColors.obsidian
        : SacredColors.moonlight;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: textColor),
          ),
        ),
        TextButton(onPressed: onTap, child: Text(actionLabel)),
      ],
    );
  }
}

class _SectionEyebrow extends StatelessWidget {
  const _SectionEyebrow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        letterSpacing: 1.8,
        color: SacredColors.gold,
      ),
    );
  }
}

class _AtmosphereOverlay extends StatelessWidget {
  const _AtmosphereOverlay({required this.mood});

  final SacredMood mood;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    sacredAccent(mood).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -120,
            bottom: -180,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    SacredColors.rose.withValues(alpha: 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.invert,
  });

  final String label;
  final String value;
  final bool invert;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: invert ? SacredColors.deepEarth : SacredColors.muted,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: invert ? SacredColors.obsidian : SacredColors.moonlight,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoneyField extends StatelessWidget {
  const _MoneyField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, prefixText: '\$'),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          const Icon(Icons.check_circle_rounded, color: SacredColors.gold),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({required this.label, required this.progress});

  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Text('${(progress * 100).round()}%'),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            color: SacredColors.gold,
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      activeThumbColor: SacredColors.gold,
      onChanged: onChanged,
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: SacredColors.gold,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

void openScreenPreview(BuildContext context, IhsanScreenSpec spec) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => buildScreenExperience(spec)));
}

Widget buildScreenExperience(IhsanScreenSpec spec) {
  switch (spec.id) {
    case 14:
      return const PrayerTimesExperiencePage();
    case 18:
      return const QuranReaderExperiencePage();
    case 25:
      return const TasbeehExperiencePage();
    case 26:
      return const NotificationCenterPage();
    case 27:
      return const CommunityFeedExperiencePage();
    case 29:
      return const MasjidMapExperiencePage();
    case 43:
      return const ZakatCalculatorPage();
    case 50:
      return const AiScholarPage();
    case 53:
      return const RamadanModePage();
    case 55:
      return const FamilyDashboardPage();
    case 62:
      return const UniversalSearchPage();
    case 64:
      return const AccessibilitySettingsPage();
    case 70:
      return const DemoJourneyPage();
    default:
      return GenericExperiencePage(spec: spec);
  }
}

double calculateZakat({
  required double cash,
  required double gold,
  required double investments,
  required double businessAssets,
  required double liabilities,
  required double nisab,
}) {
  final double totalAssets = cash + gold + investments + businessAssets;
  final double netAssets = math.max(0, totalAssets - liabilities);
  if (netAssets < nisab) {
    return 0;
  }
  return netAssets * 0.025;
}

double _parse(String value) {
  return double.tryParse(value.trim()) ?? 0;
}

Color invertText(bool invert) {
  return invert ? SacredColors.obsidian : SacredColors.moonlight;
}
