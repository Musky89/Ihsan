import 'package:flutter/material.dart';

import 'theme.dart';

class IhsanScreenSpec {
  const IhsanScreenSpec({
    required this.id,
    required this.phase,
    required this.category,
    required this.title,
    required this.headline,
    required this.summary,
    required this.mood,
    required this.icon,
    this.tags = const <String>[],
    this.bullets = const <String>[],
  });

  final int id;
  final String phase;
  final String category;
  final String title;
  final String headline;
  final String summary;
  final SacredMood mood;
  final IconData icon;
  final List<String> tags;
  final List<String> bullets;
}

class IhsanOnboardingSlide {
  const IhsanOnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.caption,
    required this.mood,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String caption;
  final SacredMood mood;
  final IconData icon;
}

class PrayerWindow {
  const PrayerWindow({
    required this.name,
    required this.time,
    required this.mood,
    required this.remaining,
  });

  final String name;
  final String time;
  final SacredMood mood;
  final String remaining;
}

class ContentCardData {
  const ContentCardData({
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.mood,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String meta;
  final SacredMood mood;
  final IconData icon;
}

class FeedPost {
  const FeedPost({
    required this.author,
    required this.title,
    required this.body,
    required this.reaction,
    required this.mood,
  });

  final String author;
  final String title;
  final String body;
  final String reaction;
  final SacredMood mood;
}

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.mood,
  });

  final String title;
  final String body;
  final String time;
  final SacredMood mood;
}

class FamilyMemberStatus {
  const FamilyMemberStatus({
    required this.name,
    required this.focus,
    required this.prayerScore,
    required this.hifzScore,
  });

  final String name;
  final String focus;
  final double prayerScore;
  final double hifzScore;
}

class ChatMessage {
  const ChatMessage({
    required this.author,
    required this.body,
    required this.citation,
    required this.isUser,
  });

  final String author;
  final String body;
  final String citation;
  final bool isUser;
}

IhsanScreenSpec spec({
  required int id,
  required String phase,
  required String category,
  required String title,
  required String headline,
  required String summary,
  required SacredMood mood,
  required IconData icon,
  List<String> tags = const <String>[],
  List<String> bullets = const <String>[],
}) {
  return IhsanScreenSpec(
    id: id,
    phase: phase,
    category: category,
    title: title,
    headline: headline,
    summary: summary,
    mood: mood,
    icon: icon,
    tags: tags,
    bullets: bullets,
  );
}

const List<IhsanOnboardingSlide> onboardingSlides = <IhsanOnboardingSlide>[
  IhsanOnboardingSlide(
    title: 'Never Miss a Prayer',
    subtitle: 'Atmospheric prayer guidance that shifts with the day.',
    caption: 'Accurate times, Qibla direction, and gentle reminders.',
    mood: SacredMood.rose,
    icon: Icons.nightlight_round,
  ),
  IhsanOnboardingSlide(
    title: 'The Quran, Beautifully',
    subtitle: 'Immersive reading on warm parchment with reverent motion.',
    caption: 'Arabic-first typography, audio, plans, and bookmarks.',
    mood: SacredMood.parchment,
    icon: Icons.menu_book_rounded,
  ),
  IhsanOnboardingSlide(
    title: 'Your Ummah, Connected',
    subtitle: 'A premium Muslim network for knowledge and community.',
    caption: 'Masjids, events, courses, and private spaces built with adab.',
    mood: SacredMood.indigo,
    icon: Icons.groups_rounded,
  ),
];

const List<PrayerWindow> prayerSchedule = <PrayerWindow>[
  PrayerWindow(
    name: 'Fajr',
    time: '5:21 AM',
    mood: SacredMood.rose,
    remaining: 'Completed',
  ),
  PrayerWindow(
    name: 'Dhuhr',
    time: '12:38 PM',
    mood: SacredMood.gold,
    remaining: 'Completed',
  ),
  PrayerWindow(
    name: 'Asr',
    time: '4:14 PM',
    mood: SacredMood.gold,
    remaining: 'In 2h 34m',
  ),
  PrayerWindow(
    name: 'Maghrib',
    time: '6:47 PM',
    mood: SacredMood.rose,
    remaining: 'In 5h 07m',
  ),
  PrayerWindow(
    name: 'Isha',
    time: '8:05 PM',
    mood: SacredMood.indigo,
    remaining: 'In 6h 25m',
  ),
];

const List<ContentCardData> surahCards = <ContentCardData>[
  ContentCardData(
    title: 'Al-Kahf',
    subtitle: 'The Cave',
    meta: '110 verses · Makki',
    mood: SacredMood.parchment,
    icon: Icons.auto_stories_rounded,
  ),
  ContentCardData(
    title: 'Yasin',
    subtitle: 'The Heart of the Quran',
    meta: '83 verses · Makki',
    mood: SacredMood.gold,
    icon: Icons.bookmark_added_rounded,
  ),
  ContentCardData(
    title: 'Al-Mulk',
    subtitle: 'The Sovereignty',
    meta: '30 verses · Makki',
    mood: SacredMood.indigo,
    icon: Icons.nights_stay_rounded,
  ),
];

const List<ContentCardData> duaCards = <ContentCardData>[
  ContentCardData(
    title: 'Morning Adhkar',
    subtitle: 'Begin with remembrance',
    meta: '12 duas',
    mood: SacredMood.rose,
    icon: Icons.wb_sunny_outlined,
  ),
  ContentCardData(
    title: 'After Prayer',
    subtitle: 'Follow every salah with dhikr',
    meta: '6 duas',
    mood: SacredMood.gold,
    icon: Icons.mosque_outlined,
  ),
  ContentCardData(
    title: 'Before Sleep',
    subtitle: 'Nighttime protection',
    meta: '5 duas',
    mood: SacredMood.indigo,
    icon: Icons.bedtime_outlined,
  ),
];

const List<ContentCardData> courseCards = <ContentCardData>[
  ContentCardData(
    title: 'Tafsir Foundations',
    subtitle: 'Understand revelation with context and clarity.',
    meta: '12 lessons · Premium',
    mood: SacredMood.indigo,
    icon: Icons.ondemand_video_rounded,
  ),
  ContentCardData(
    title: 'Fiqh of Prayer',
    subtitle: 'A structured guide across madhab nuance.',
    meta: '8 lessons · Free',
    mood: SacredMood.gold,
    icon: Icons.school_rounded,
  ),
  ContentCardData(
    title: 'Arabic for Quran',
    subtitle: 'Build vocabulary through reflection and repetition.',
    meta: '16 lessons · Premium',
    mood: SacredMood.teal,
    icon: Icons.translate_rounded,
  ),
];

const List<ContentCardData> halalListings = <ContentCardData>[
  ContentCardData(
    title: 'Halal Pantry',
    subtitle: 'Verified essentials for home and travel.',
    meta: 'Food · London',
    mood: SacredMood.gold,
    icon: Icons.shopping_bag_outlined,
  ),
  ContentCardData(
    title: 'The Minaret Cafe',
    subtitle: 'Prayer-friendly restaurant with verified kitchen.',
    meta: 'Restaurant · 0.9 mi',
    mood: SacredMood.rose,
    icon: Icons.restaurant_rounded,
  ),
  ContentCardData(
    title: 'Siraat Advisors',
    subtitle: 'Islamic legal and financial guidance.',
    meta: 'Services · Verified',
    mood: SacredMood.indigo,
    icon: Icons.handshake_outlined,
  ),
];

const List<FeedPost> communityFeed = <FeedPost>[
  FeedPost(
    author: 'Maryam H.',
    title: 'Friday reflection',
    body:
        'The khutbah on sabr stayed with me all week. Sharing notes for anyone who missed it.',
    reaction: 'MashaAllah',
    mood: SacredMood.rose,
  ),
  FeedPost(
    author: 'Masjid Noor',
    title: 'Youth halaqah tonight',
    body:
        'Doors open after Maghrib. Short reminder, community meal, and Q&A with Ustadh Hamza.',
    reaction: 'JazakAllah Khair',
    mood: SacredMood.gold,
  ),
  FeedPost(
    author: 'Amina S.',
    title: 'Ramadan prep checklist',
    body:
        'I turned my family plan into a printable tracker. Happy to share a template.',
    reaction: 'SubhanAllah',
    mood: SacredMood.indigo,
  ),
];

const List<NotificationItem> notifications = <NotificationItem>[
  NotificationItem(
    title: 'Asr in 2h 34m',
    body: 'Wudu refresh and a short dhikr prompt are ready.',
    time: 'Just now',
    mood: SacredMood.gold,
  ),
  NotificationItem(
    title: 'Continue Al-Kahf',
    body: 'You paused at ayah 28. Resume from your last bookmark.',
    time: '18 min ago',
    mood: SacredMood.parchment,
  ),
  NotificationItem(
    title: 'Masjid Noor posted an event',
    body: 'Community iftar registration is now open.',
    time: '1h ago',
    mood: SacredMood.indigo,
  ),
  NotificationItem(
    title: 'Morning adhkar streak',
    body: 'Seven calm starts in a row. Keep the rhythm going.',
    time: 'Today',
    mood: SacredMood.rose,
  ),
];

const List<FamilyMemberStatus> familyMembers = <FamilyMemberStatus>[
  FamilyMemberStatus(
    name: 'Aaliyah',
    focus: 'Surah Al-Mulk memorization',
    prayerScore: 0.92,
    hifzScore: 0.71,
  ),
  FamilyMemberStatus(
    name: 'Yusuf',
    focus: 'Dhuhr consistency',
    prayerScore: 0.81,
    hifzScore: 0.48,
  ),
  FamilyMemberStatus(
    name: 'Mariam',
    focus: 'Daily duas before sleep',
    prayerScore: 0.88,
    hifzScore: 0.64,
  ),
];

const List<ChatMessage> defaultChat = <ChatMessage>[
  ChatMessage(
    author: 'Ihsan Scholar',
    body:
        'Assalamu alaykum. Ask about prayer, Quran, or practice and I will answer with sources.',
    citation: 'AI guidance supplements, not replaces, real scholars.',
    isUser: false,
  ),
  ChatMessage(
    author: 'You',
    body: 'What should I focus on in the last third of the night?',
    citation: '',
    isUser: true,
  ),
  ChatMessage(
    author: 'Ihsan Scholar',
    body:
        'Prioritize sincere dua, quiet qiyam, and istighfar. The late night is a moment for intimacy and humility.',
    citation: 'Quran 17:79 · Sahih Muslim 758',
    isUser: false,
  ),
];

final List<IhsanScreenSpec> allScreens = <IhsanScreenSpec>[
  spec(
    id: 1,
    phase: 'Phase 1',
    category: 'Onboarding',
    title: 'Splash Screen',
    headline: 'Pursue Excellence.',
    summary:
        'Deep indigo launch experience with the Bloom Star, atmospheric particles, and a calm premium first impression.',
    mood: SacredMood.indigo,
    icon: Icons.auto_awesome_rounded,
    tags: <String>['Brand', 'Animation', 'Sacred Night'],
    bullets: <String>[
      '1.5-second unfolding Bloom Star.',
      'Bilingual Ihsan wordmark with moonlight tagline.',
    ],
  ),
  spec(
    id: 2,
    phase: 'Phase 1',
    category: 'Onboarding',
    title: 'Onboarding - Prayer',
    headline: 'Never Miss a Prayer',
    summary:
        'A full-bleed atmospheric prayer onboarding card that explains accuracy, reminders, and Qibla guidance.',
    mood: SacredMood.rose,
    icon: Icons.schedule_rounded,
    tags: <String>['Prayer', 'Timeline', 'Location'],
    bullets: <String>[
      'Fajr rose horizon and mosque silhouette.',
      'Explains location-aware reminders and arc visualization.',
    ],
  ),
  spec(
    id: 3,
    phase: 'Phase 1',
    category: 'Onboarding',
    title: 'Onboarding - Quran',
    headline: 'The Quran, Beautifully',
    summary:
        'A parchment-led introduction to immersive reading, Arabic-first typography, and celebrated reciters.',
    mood: SacredMood.parchment,
    icon: Icons.menu_book_rounded,
    tags: <String>['Quran', 'Arabic-first', 'Audio'],
    bullets: <String>[
      'Gold geometric framing around sacred text.',
      'Sets expectation for an immersive reader, not a utility screen.',
    ],
  ),
  spec(
    id: 4,
    phase: 'Phase 1',
    category: 'Onboarding',
    title: 'Onboarding - Community',
    headline: 'Your Ummah, Connected',
    summary:
        'A social introduction centered on local masjids, trusted community spaces, and modern Muslim belonging.',
    mood: SacredMood.indigo,
    icon: Icons.groups_rounded,
    tags: <String>['Community', 'Masjid', 'Social'],
    bullets: <String>[
      'Living gold connection lines across avatars.',
      'Clear invitation to explore before creating an account.',
    ],
  ),
  spec(
    id: 5,
    phase: 'Phase 1',
    category: 'Authentication',
    title: 'Sign Up',
    headline: 'Trust begins with clarity.',
    summary:
        'Minimal sign-up flow on obsidian glass surfaces with social auth and low-friction entry.',
    mood: SacredMood.obsidian,
    icon: Icons.person_add_alt_1_rounded,
    tags: <String>['Auth', 'Glass UI', 'Low friction'],
    bullets: <String>[
      'Email and password on frosted panels.',
      'Living gold CTA with respectful spacing.',
    ],
  ),
  spec(
    id: 6,
    phase: 'Phase 1',
    category: 'Authentication',
    title: 'Login',
    headline: 'Welcome back.',
    summary:
        'Returning-user flow with confident typography, subtle atmospheric particles, and clear recovery paths.',
    mood: SacredMood.indigo,
    icon: Icons.login_rounded,
    tags: <String>['Auth', 'Returning users', 'Calm'],
    bullets: <String>[
      'Fraunces headline over indigo gradient.',
      'Social sign-in and password recovery link.',
    ],
  ),
  spec(
    id: 7,
    phase: 'Phase 1',
    category: 'Authentication',
    title: 'OTP Verification',
    headline: 'Secure the moment.',
    summary:
        'A six-digit code flow with gold focus states, countdown feedback, and dark geometric background texture.',
    mood: SacredMood.indigo,
    icon: Icons.shield_moon_outlined,
    tags: <String>['OTP', 'Security', 'Autofill'],
    bullets: <String>[
      'Separate cells with living gold emphasis.',
      'Friendly resend state without visual noise.',
    ],
  ),
  spec(
    id: 8,
    phase: 'Phase 1',
    category: 'Authentication',
    title: 'Profile Setup',
    headline: 'Shape the app around your practice.',
    summary:
        'Location, madhab, calculation method, and identity details captured with agency and optionality.',
    mood: SacredMood.indigo,
    icon: Icons.tune_rounded,
    tags: <String>['Profile', 'Preferences', 'Madhab'],
    bullets: <String>[
      'Auto-detect location with transparent controls.',
      'Skip path respects exploration before commitment.',
    ],
  ),
  spec(
    id: 9,
    phase: 'Phase 1',
    category: 'Authentication',
    title: 'Forgot Password',
    headline: 'Recover access calmly.',
    summary:
        'A single-purpose reset flow that stays minimal, reassuring, and visually consistent.',
    mood: SacredMood.obsidian,
    icon: Icons.lock_reset_rounded,
    tags: <String>['Recovery', 'Email', 'Security'],
    bullets: <String>[
      'Focused form with quiet geometric backdrop.',
      'Single CTA with no competing distractions.',
    ],
  ),
  spec(
    id: 10,
    phase: 'Phase 1',
    category: 'Authentication',
    title: 'Email Verification',
    headline: 'Confirm your amanah.',
    summary:
        'Verification mirrors OTP but emphasizes trust and clarity around inbox/spam guidance.',
    mood: SacredMood.indigo,
    icon: Icons.mark_email_read_rounded,
    tags: <String>['Verification', 'Trust', 'Inbox'],
    bullets: <String>[
      'Consistent six-cell interaction.',
      'Moonlight support copy for reassurance.',
    ],
  ),
  spec(
    id: 11,
    phase: 'Phase 1',
    category: 'Authentication',
    title: 'Onboarding Complete',
    headline: 'You are all set.',
    summary:
        'Completion screen with Bloom Star flourish and quick-start tips for notifications, Quran plans, and community.',
    mood: SacredMood.gold,
    icon: Icons.check_circle_outline_rounded,
    tags: <String>['Success', 'Activation', 'Tips'],
    bullets: <String>[
      'Gold bloom animation confirms progress.',
      'Three quick next steps reduce empty-state anxiety.',
    ],
  ),
  spec(
    id: 12,
    phase: 'Phase 1',
    category: 'Authentication',
    title: 'Premium Paywall',
    headline: 'Transparent premium, never coercive.',
    summary:
        'An ethical upsell page comparing free and premium with clear value, trial details, and restrained motion.',
    mood: SacredMood.obsidian,
    icon: Icons.workspace_premium_outlined,
    tags: <String>['Premium', 'Ethical monetization', 'Trial'],
    bullets: <String>[
      'Monthly and yearly plans with savings badge.',
      'No manipulative dark patterns or prayer gating.',
    ],
  ),
  spec(
    id: 13,
    phase: 'Phase 1',
    category: 'Prayer',
    title: 'Home Dashboard',
    headline: 'The screen is the prayer countdown.',
    summary:
        'A time-responsive atmospheric home with oversized next-prayer typography, verse of the day, and contextual widgets.',
    mood: SacredMood.indigo,
    icon: Icons.home_rounded,
    tags: <String>['Dashboard', 'Context', 'Bento'],
    bullets: <String>[
      'Massive prayer countdown instead of a generic card.',
      'Widgets reorder by relevance throughout the day.',
    ],
  ),
  spec(
    id: 14,
    phase: 'Phase 1',
    category: 'Prayer',
    title: 'Prayer Times',
    headline: 'An arc, not a list.',
    summary:
        'Prayer times plotted across the day as a curved timeline with active states, dua context, and adhan controls.',
    mood: SacredMood.gold,
    icon: Icons.timeline_rounded,
    tags: <String>['Prayer arc', 'Adhan', 'Qibla'],
    bullets: <String>[
      'Five prayers glow along a day-night cycle.',
      'Current moment indicator moves across the arc.',
    ],
  ),
  spec(
    id: 15,
    phase: 'Phase 1',
    category: 'Prayer',
    title: 'Qibla Compass',
    headline: 'Find direction with depth.',
    summary:
        'A spatial compass with a living gold arrow, distance to Makkah, and parallax-like atmosphere.',
    mood: SacredMood.indigo,
    icon: Icons.explore_rounded,
    tags: <String>['Qibla', 'Spatial UI', 'Compass'],
    bullets: <String>[
      'Golden direction arrow points toward Makkah.',
      'Depth layers replace the flat compass trope.',
    ],
  ),
  spec(
    id: 16,
    phase: 'Phase 1',
    category: 'Prayer',
    title: 'Prayer Tracker',
    headline: 'Consistency made visible.',
    summary:
        'A weekly grid for all 35 prayers with streaks, patterns, and encouragement without gamified excess.',
    mood: SacredMood.obsidian,
    icon: Icons.grid_view_rounded,
    tags: <String>['Tracker', 'Streaks', 'Habits'],
    bullets: <String>[
      'Gold completed states, muted missed states, rose late states.',
      'Weekly and monthly summaries on frosted cards.',
    ],
  ),
  spec(
    id: 17,
    phase: 'Phase 1',
    category: 'Quran',
    title: 'Surah Index',
    headline: 'Arabic-first discovery.',
    summary:
        'A complete index of 114 surahs emphasizing Arabic names, revelation context, and recently read continuity.',
    mood: SacredMood.indigo,
    icon: Icons.list_alt_rounded,
    tags: <String>['Surahs', 'Search', 'Juz'],
    bullets: <String>[
      'Arabic acts as the visual anchor, not a subtitle.',
      'Recently read cards preserve momentum.',
    ],
  ),
  spec(
    id: 18,
    phase: 'Phase 1',
    category: 'Quran',
    title: 'Quran Reader',
    headline: 'Immersion over chrome.',
    summary:
        'A warm parchment reading surface with Amiri Quran typography, gold verse markers, and unique geometric margins.',
    mood: SacredMood.parchment,
    icon: Icons.chrome_reader_mode_rounded,
    tags: <String>['Immersive', 'Typography', 'Sacred text'],
    bullets: <String>[
      'Controls stay hidden until invited.',
      'Per-surah visual details reinforce identity and reverence.',
    ],
  ),
  spec(
    id: 19,
    phase: 'Phase 1',
    category: 'Quran',
    title: 'Audio Player',
    headline: 'Recitation with presence.',
    summary:
        'A premium audio surface with reciter identity, verse navigation, waveform, and background playback affordances.',
    mood: SacredMood.indigo,
    icon: Icons.graphic_eq_rounded,
    tags: <String>['Audio', 'Reciters', 'Playback'],
    bullets: <String>[
      'Verse-by-verse controls on frosted panels.',
      'Active verse state uses living gold to focus attention.',
    ],
  ),
  spec(
    id: 20,
    phase: 'Phase 1',
    category: 'Quran',
    title: 'Quran Reading Plan',
    headline: 'Structured khatm momentum.',
    summary:
        'Reading plans for Ramadan, yearly completion, or custom pacing visualized through arcs and streaks.',
    mood: SacredMood.obsidian,
    icon: Icons.track_changes_rounded,
    tags: <String>['Plans', 'Khatm', 'Streaks'],
    bullets: <String>[
      'Progress arcs mirror the prayer timeline language.',
      'Notification cues support daily consistency.',
    ],
  ),
  spec(
    id: 21,
    phase: 'Phase 1',
    category: 'Essentials',
    title: 'Duas & Adhkar Collection',
    headline: 'Daily remembrance, organized with care.',
    summary:
        'A searchable dua and adhkar library arranged by life moments and time of day.',
    mood: SacredMood.indigo,
    icon: Icons.favorite_outline_rounded,
    tags: <String>['Duas', 'Adhkar', 'Search'],
    bullets: <String>[
      'Morning and evening cards use contextual color moods.',
      'Bento layouts break away from repetitive stacks.',
    ],
  ),
  spec(
    id: 22,
    phase: 'Phase 1',
    category: 'Essentials',
    title: 'Dua Detail View',
    headline: 'The dua becomes the centerpiece.',
    summary:
        'A focused detail experience for Arabic, transliteration, translation, source, and repeat count.',
    mood: SacredMood.parchment,
    icon: Icons.auto_stories_outlined,
    tags: <String>['Detail', 'Arabic', 'Source'],
    bullets: <String>[
      'Large Arabic anchors the entire layout.',
      'Repeat ring supports adhkar sets elegantly.',
    ],
  ),
  spec(
    id: 23,
    phase: 'Phase 1',
    category: 'Essentials',
    title: 'Hijri Calendar',
    headline: 'A sacred calendar, not an afterthought.',
    summary:
        'Hijri-first calendar with Islamic events, Friday emphasis, and elegant month navigation.',
    mood: SacredMood.obsidian,
    icon: Icons.calendar_month_rounded,
    tags: <String>['Hijri', 'Events', 'Islamic dates'],
    bullets: <String>[
      'Hijri day gets top billing over Gregorian.',
      'Important dates use living gold iconography.',
    ],
  ),
  spec(
    id: 24,
    phase: 'Phase 1',
    category: 'Essentials',
    title: 'Settings',
    headline: 'Control without clutter.',
    summary:
        'A spacious settings hub for prayer behavior, typography, language, privacy, and appearance.',
    mood: SacredMood.obsidian,
    icon: Icons.settings_outlined,
    tags: <String>['Settings', 'Privacy', 'Theme'],
    bullets: <String>[
      'Sacred Night remains the default expression.',
      'Arabic font sizing is treated as a first-class control.',
    ],
  ),
  spec(
    id: 25,
    phase: 'Phase 1',
    category: 'Essentials',
    title: 'Digital Tasbeeh Counter',
    headline: 'Meditative, not gamified.',
    summary:
        'A focused dhikr counter with subtle haptics, ripple feedback, and a bloom celebration at 33.',
    mood: SacredMood.indigo,
    icon: Icons.touch_app_rounded,
    tags: <String>['Tasbeeh', 'Dhikr', 'Meditative'],
    bullets: <String>[
      'Large Arabic calligraphy anchors the ritual.',
      'Gold ring visualizes progress through each set.',
    ],
  ),
  spec(
    id: 26,
    phase: 'Phase 1',
    category: 'Essentials',
    title: 'Notification Center',
    headline: 'A calm inbox for what matters.',
    summary:
        'Chronological notifications for prayers, Quran reminders, content, and community alerts grouped by day.',
    mood: SacredMood.obsidian,
    icon: Icons.notifications_none_rounded,
    tags: <String>['Notifications', 'Chronological', 'Personal'],
    bullets: <String>[
      'Prayer alerts carry the color of each salah.',
      'Unread items are accented rather than shouting.',
    ],
  ),
  spec(
    id: 27,
    phase: 'Phase 2',
    category: 'Community',
    title: 'Community Feed',
    headline: 'Not another social clone.',
    summary:
        'A masonry-style community feed with Islamic reactions, featured masjid posts, and editorial visual variety.',
    mood: SacredMood.obsidian,
    icon: Icons.forum_outlined,
    tags: <String>['Feed', 'Masonry', 'Islamic reactions'],
    bullets: <String>[
      'Chronological by default to reduce manipulation.',
      'Masjid and scholar content has distinctive verified styling.',
    ],
  ),
  spec(
    id: 28,
    phase: 'Phase 2',
    category: 'Community',
    title: 'Create Post',
    headline: 'Compose with adab.',
    summary:
        'A clean composer for text, image, poll, location, and privacy selection within Islamic community contexts.',
    mood: SacredMood.indigo,
    icon: Icons.post_add_rounded,
    tags: <String>['Compose', 'Privacy', 'Posting'],
    bullets: <String>[
      'Share scopes include My Masjid and Friends Only.',
      'Atmospheric chips keep utilities lightweight.',
    ],
  ),
  spec(
    id: 29,
    phase: 'Phase 2',
    category: 'Community',
    title: 'Masjid Finder - Map View',
    headline: 'A mosque map in the Sacred Night palette.',
    summary:
        'Interactive map discovery for nearby masjids with gold pins, search, and a supporting bottom sheet.',
    mood: SacredMood.indigo,
    icon: Icons.map_outlined,
    tags: <String>['Masjids', 'Map', 'Nearby'],
    bullets: <String>[
      'Selected markers reveal prayer times and ratings.',
      'Map visuals stay on-brand instead of generic map chrome.',
    ],
  ),
  spec(
    id: 30,
    phase: 'Phase 2',
    category: 'Community',
    title: 'Masjid Detail',
    headline: 'Verified local anchors.',
    summary:
        'Masjid detail page with hero photography, prayer times, quick actions, facilities, and upcoming events.',
    mood: SacredMood.indigo,
    icon: Icons.location_city_outlined,
    tags: <String>['Masjid detail', 'Verified', 'Events'],
    bullets: <String>[
      'Large name treatment and gold badge build trust.',
      'Prayer table and events encourage repeated visits.',
    ],
  ),
  spec(
    id: 31,
    phase: 'Phase 2',
    category: 'Content',
    title: 'Islamic Content Hub',
    headline: 'Curated, never chaotic.',
    summary:
        'A discovery feed for verified articles, videos, podcasts, courses, and scholars with editorial hierarchy.',
    mood: SacredMood.obsidian,
    icon: Icons.explore_outlined,
    tags: <String>['Discover', 'Curated', 'Verified'],
    bullets: <String>[
      'Category chips filter the entire learning ecosystem.',
      'Featured hero content carries cinematic gradients.',
    ],
  ),
  spec(
    id: 32,
    phase: 'Phase 2',
    category: 'Content',
    title: 'Article Reader',
    headline: 'Editorial depth for Islamic thought.',
    summary:
        'A distraction-light article reader pairing Fraunces headlines with long-form body typography and Quran callout cards.',
    mood: SacredMood.parchment,
    icon: Icons.article_outlined,
    tags: <String>['Reading', 'Editorial', 'Long-form'],
    bullets: <String>[
      'Reading progress is visible but understated.',
      'Pull quotes and verses become visual moments.',
    ],
  ),
  spec(
    id: 33,
    phase: 'Phase 2',
    category: 'Content',
    title: 'User Profile',
    headline: 'Identity through contribution.',
    summary:
        'A profile surface combining activity, badges, saved content, and reputation with premium restraint.',
    mood: SacredMood.obsidian,
    icon: Icons.account_circle_outlined,
    tags: <String>['Profile', 'Badges', 'Activity'],
    bullets: <String>[
      'Achievements are culturally specific, not gamified trophies.',
      'Posts, saved items, and activity remain easy to scan.',
    ],
  ),
  spec(
    id: 34,
    phase: 'Phase 2',
    category: 'Content',
    title: 'Messaging',
    headline: 'Private conversation with trust.',
    summary:
        'Encrypted chat using frosted incoming bubbles, gold outgoing states, and simple attachment affordances.',
    mood: SacredMood.indigo,
    icon: Icons.chat_bubble_outline_rounded,
    tags: <String>['Messaging', 'E2E', 'Private'],
    bullets: <String>[
      'Typing states and online markers stay subtle.',
      'Security cues are present without alarmism.',
    ],
  ),
  spec(
    id: 35,
    phase: 'Phase 2',
    category: 'Learning',
    title: 'Islamic Events Calendar',
    headline: 'Events as mini-posters.',
    summary:
        'A rich events calendar with horizontal date selection, strong poster cards, and RSVP-focused decisions.',
    mood: SacredMood.obsidian,
    icon: Icons.event_note_rounded,
    tags: <String>['Events', 'Calendar', 'RSVP'],
    bullets: <String>[
      'Featured events use gold emphasis.',
      'Quick filtering keeps local discovery efficient.',
    ],
  ),
  spec(
    id: 36,
    phase: 'Phase 2',
    category: 'Learning',
    title: 'Event Detail',
    headline: 'Turn interest into attendance.',
    summary:
        'An event detail page with strong hero imagery, logistics, organizer trust signals, and a sticky RSVP bar.',
    mood: SacredMood.indigo,
    icon: Icons.confirmation_number_outlined,
    tags: <String>['Event detail', 'Organizer', 'RSVP'],
    bullets: <String>[
      'Speaker and attendee context build confidence.',
      'Sticky actions stay available without crowding the content.',
    ],
  ),
  spec(
    id: 37,
    phase: 'Phase 2',
    category: 'Learning',
    title: 'Islamic Learning Courses',
    headline: 'Structured growth for ilm.',
    summary:
        'A course catalog that balances active progress, browseable categories, instructor trust, and premium labeling.',
    mood: SacredMood.obsidian,
    icon: Icons.school_outlined,
    tags: <String>['Courses', 'Ilm', 'Progress'],
    bullets: <String>[
      'Active learning is surfaced first.',
      'Course cards emphasize credibility and continuity.',
    ],
  ),
  spec(
    id: 38,
    phase: 'Phase 2',
    category: 'Learning',
    title: 'Course Lesson View',
    headline: 'Immersion, notes, and action.',
    summary:
        'A lesson experience anchored by video, structured tabs, notes, and quiz progression inside a dark cinematic shell.',
    mood: SacredMood.indigo,
    icon: Icons.play_circle_outline_rounded,
    tags: <String>['Video', 'Notes', 'Quiz'],
    bullets: <String>[
      'Overview, notes, resources, and quiz stay one tap away.',
      'Navigation keeps learners in flow.',
    ],
  ),
  spec(
    id: 39,
    phase: 'Phase 3',
    category: 'Commerce',
    title: 'Halal Product Directory',
    headline: 'Guidance, not checkout.',
    summary:
        'A curated halal product index with verification states, category browsing, and external store visits.',
    mood: SacredMood.obsidian,
    icon: Icons.shopping_bag_outlined,
    tags: <String>['Directory', 'Affiliate', 'Verified'],
    bullets: <String>[
      'The app guides discovery rather than becoming a marketplace.',
      'Verification is visually prominent and explainable.',
    ],
  ),
  spec(
    id: 40,
    phase: 'Phase 3',
    category: 'Commerce',
    title: 'Halal Restaurant Finder',
    headline: 'Travel and eat with confidence.',
    summary:
        'A halal food discovery experience combining map, list, cuisine filters, and deep links to delivery services.',
    mood: SacredMood.indigo,
    icon: Icons.restaurant_menu_outlined,
    tags: <String>['Food', 'Map', 'Deep links'],
    bullets: <String>[
      'Distance, cuisine, and quick actions are immediately actionable.',
      'Pins and filters remain within the brand language.',
    ],
  ),
  spec(
    id: 41,
    phase: 'Phase 3',
    category: 'Commerce',
    title: 'Islamic News Feed',
    headline: 'Current affairs without clickbait.',
    summary:
        'An editorial news hub for the ummah with category rails, source attribution, and premium visual pacing.',
    mood: SacredMood.obsidian,
    icon: Icons.newspaper_outlined,
    tags: <String>['News', 'Editorial', 'Trusted sources'],
    bullets: <String>[
      'Every article foregrounds provenance.',
      'World, local, fiqh, and science categories structure the feed.',
    ],
  ),
  spec(
    id: 42,
    phase: 'Phase 3',
    category: 'Commerce',
    title: 'Hadith Collection Browser',
    headline: 'Classical collections, modern interface.',
    summary:
        'A hadith browser with major collections, grading badges, Arabic-forward presentation, and clear navigation.',
    mood: SacredMood.parchment,
    icon: Icons.library_books_outlined,
    tags: <String>['Hadith', 'Collections', 'Authentication'],
    bullets: <String>[
      'Arabic and English share the stage with reverence.',
      'Grading badges remain visible but not loud.',
    ],
  ),
  spec(
    id: 43,
    phase: 'Phase 3',
    category: 'Services',
    title: 'Zakat Calculator',
    headline: 'Clarity for an obligation.',
    summary:
        'A comprehensive zakat flow with assets, liabilities, nisab reference, and annual tracking support.',
    mood: SacredMood.obsidian,
    icon: Icons.calculate_outlined,
    tags: <String>['Zakat', 'Finance', 'Calculator'],
    bullets: <String>[
      'Net assets and nisab are made understandable.',
      'Verified charity links appear only after the calculation.',
    ],
  ),
  spec(
    id: 44,
    phase: 'Phase 3',
    category: 'Services',
    title: 'Sadaqah & Donation Hub',
    headline: 'Give with transparency.',
    summary:
        'A donations hub for vetted causes and charities with progress, urgency, and trusted verification.',
    mood: SacredMood.gold,
    icon: Icons.volunteer_activism_outlined,
    tags: <String>['Sadaqah', 'Causes', 'Charity'],
    bullets: <String>[
      'Featured causes use warm atmospheric hero treatments.',
      'Charity trust signals stay explicit and calm.',
    ],
  ),
  spec(
    id: 45,
    phase: 'Phase 3',
    category: 'Services',
    title: 'Shariah Stock Screener',
    headline: 'Educational Islamic finance clarity.',
    summary:
        'A learning-led stock screener that classifies halal, haram, and doubtful states with reasoning.',
    mood: SacredMood.obsidian,
    icon: Icons.candlestick_chart_rounded,
    tags: <String>['Stocks', 'Islamic finance', 'Education'],
    bullets: <String>[
      'Verdicts are explained, not merely color-coded.',
      'The tool educates rather than becoming a trading surface.',
    ],
  ),
  spec(
    id: 46,
    phase: 'Phase 3',
    category: 'Services',
    title: 'Hajj & Umrah Planner',
    headline: 'Prepare with serenity.',
    summary:
        'A planning tool for Hajj and Umrah featuring countdowns, checklists, duas, and verified package links.',
    mood: SacredMood.gold,
    icon: Icons.flight_takeoff_outlined,
    tags: <String>['Hajj', 'Umrah', 'Checklist'],
    bullets: <String>[
      'My Trip progress keeps preparation grounded.',
      'Guide content and links remain separated with clarity.',
    ],
  ),
  spec(
    id: 47,
    phase: 'Phase 3',
    category: 'Travel',
    title: 'Halal Travel Guide',
    headline: 'A Muslim lens on movement.',
    summary:
        'Destination storytelling for prayer, halal food, visas, and Muslim-friendly services while traveling.',
    mood: SacredMood.indigo,
    icon: Icons.travel_explore_outlined,
    tags: <String>['Travel', 'Destinations', 'Prayer-friendly'],
    bullets: <String>[
      'Cinematic destination cards highlight Muslim practicality.',
      'Travel essentials remain one tap away.',
    ],
  ),
  spec(
    id: 48,
    phase: 'Phase 3',
    category: 'Travel',
    title: 'Quran Memorization Tracker',
    headline: 'Hifz visualized as a whole.',
    summary:
        'A memorization dashboard using a geometric 30-juz motif, revision rhythm, and teacher-linked notes.',
    mood: SacredMood.obsidian,
    icon: Icons.extension_rounded,
    tags: <String>['Hifz', 'Revision', '30 juz'],
    bullets: <String>[
      'Completed juz pieces illuminate a larger pattern.',
      'Revision planning prevents memorization from becoming fragmented.',
    ],
  ),
  spec(
    id: 49,
    phase: 'Phase 3',
    category: 'Travel',
    title: 'Service Provider Directory',
    headline: 'Local Muslim services, curated.',
    summary:
        'A verified directory for schools, tutors, caterers, advisors, and healthcare professionals.',
    mood: SacredMood.obsidian,
    icon: Icons.business_center_outlined,
    tags: <String>['Directory', 'Local services', 'Verified'],
    bullets: <String>[
      'Category-led navigation reduces search friction.',
      'Suggestions make the directory community-expandable.',
    ],
  ),
  spec(
    id: 50,
    phase: 'Phase 4',
    category: 'AI',
    title: 'AI Islamic Scholar Chat',
    headline: 'Ask with sources, not certainty theater.',
    summary:
        'A conversational AI layer that cites Quran and hadith while clearly signaling its role as a supplement.',
    mood: SacredMood.obsidian,
    icon: Icons.smart_toy_outlined,
    tags: <String>['AI', 'Scholar', 'Citations'],
    bullets: <String>[
      'Responses surface citations in living gold.',
      'The disclaimer preserves trust and scholarly humility.',
    ],
  ),
  spec(
    id: 51,
    phase: 'Phase 4',
    category: 'AI',
    title: 'Personalized Dashboard',
    headline: 'A home screen that adapts to your day.',
    summary:
        'A personalized dashboard that changes by time, movement, nearby context, and spiritual rhythms.',
    mood: SacredMood.obsidian,
    icon: Icons.dashboard_customize_outlined,
    tags: <String>['For You', 'Personalization', 'Context'],
    bullets: <String>[
      'Morning adhkar, travel duas, and local events rise naturally.',
      'Personalization remains useful rather than addictive.',
    ],
  ),
  spec(
    id: 52,
    phase: 'Phase 4',
    category: 'AI',
    title: 'Smart Notifications Hub',
    headline: 'Prioritize what nourishes.',
    summary:
        'An intelligent notification layer for spiritual habits, Quran progress, Ramadan prep, and community relevance.',
    mood: SacredMood.obsidian,
    icon: Icons.auto_awesome_motion_outlined,
    tags: <String>['Smart notifications', 'Prioritization', 'Habits'],
    bullets: <String>[
      'The hub groups signals by spiritual, community, and commerce intent.',
      'AI sequencing avoids overload by highlighting what matters most.',
    ],
  ),
  spec(
    id: 53,
    phase: 'Phase 4',
    category: 'AI',
    title: 'Ramadan Mode',
    headline: 'The whole app transforms.',
    summary:
        'A seasonal mode with fasting progress, khatm tracker, daily checklist, and lantern-lit visual identity.',
    mood: SacredMood.ramadan,
    icon: Icons.mode_night_rounded,
    tags: <String>['Ramadan', 'Fasting', 'Transformation'],
    bullets: <String>[
      'The app warms as iftar approaches and blooms at Maghrib.',
      'A 30-piece khatm star turns progress into a sacred visual ritual.',
    ],
  ),
  spec(
    id: 54,
    phase: 'Phase 4',
    category: 'Super App',
    title: 'Super App Dashboard',
    headline: 'Navigate the ecosystem at a glance.',
    summary:
        'A clean service navigator using bento cards for every major Ihsan capability without becoming a wallet or marketplace.',
    mood: SacredMood.obsidian,
    icon: Icons.widgets_outlined,
    tags: <String>['Navigator', 'Bento', 'Ecosystem'],
    bullets: <String>[
      'Each capability retains its own color identity.',
      'Quick actions keep the dashboard contextual rather than static.',
    ],
  ),
  spec(
    id: 55,
    phase: 'Phase 4',
    category: 'Super App',
    title: 'Family Dashboard',
    headline: 'Encourage the household with gentleness.',
    summary:
        'A multi-member dashboard for prayer rhythm, memorization, filters, and age-aware family support.',
    mood: SacredMood.obsidian,
    icon: Icons.family_restroom_outlined,
    tags: <String>['Family', 'Children', 'Guidance'],
    bullets: <String>[
      'Each child can have prayer and hifz targets.',
      'Parents see encouragement tools instead of surveillance theater.',
    ],
  ),
  spec(
    id: 56,
    phase: 'Phase 4',
    category: 'Super App',
    title: 'Widgets & Smartwatch',
    headline: 'Keep Ihsan present off-screen.',
    summary:
        'Home screen widgets and smartwatch surfaces for prayer countdowns, Qibla, and verse of the day.',
    mood: SacredMood.indigo,
    icon: Icons.watch_outlined,
    tags: <String>['Widgets', 'Watch', 'Ambient'],
    bullets: <String>[
      'The Sacred Night palette extends beyond the main app shell.',
      'Prayer countdowns remain readable at a glance.',
    ],
  ),
  spec(
    id: 57,
    phase: 'Phase 4',
    category: 'Super App',
    title: 'Daily Reflection Journal',
    headline: 'Private reflection with spiritual prompts.',
    summary:
        'A journal for gratitude, learning, ihsan, and mood tracking in a calm parchment environment.',
    mood: SacredMood.parchment,
    icon: Icons.edit_note_outlined,
    tags: <String>['Journal', 'Reflection', 'Private'],
    bullets: <String>[
      'Prompts guide daily introspection with softness.',
      'Entries stay local-first to honor privacy.',
    ],
  ),
  spec(
    id: 58,
    phase: 'System',
    category: 'Dark Mode',
    title: 'Home Dashboard (Dark Mode)',
    headline: 'Dark mode is the primary expression.',
    summary:
        'Dark-first version of the home dashboard where gradients, glass, and glow are calibrated around the Sacred Night palette.',
    mood: SacredMood.obsidian,
    icon: Icons.dark_mode_outlined,
    tags: <String>['Dark mode', 'Home', 'Atmosphere'],
    bullets: <String>[
      'Obsidian replaces flat black for richer depth.',
      'Moonlight text stays warm and legible during late-night use.',
    ],
  ),
  spec(
    id: 59,
    phase: 'System',
    category: 'Dark Mode',
    title: 'Quran Reader (Dark Mode)',
    headline: 'Late-night comfort for sacred reading.',
    summary:
        'A dark reading variant calibrated to preserve focus and reduce strain during night recitation.',
    mood: SacredMood.obsidian,
    icon: Icons.chrome_reader_mode_outlined,
    tags: <String>['Dark mode', 'Quran', 'Comfort'],
    bullets: <String>[
      'Amber-on-indigo contrast reduces harsh glare.',
      'Controls remain hidden to preserve reverence.',
    ],
  ),
  spec(
    id: 60,
    phase: 'System',
    category: 'Dark Mode',
    title: 'Prayer Times (Dark Mode)',
    headline: 'Prayer arcs after sunset.',
    summary:
        'Night-optimized prayer visualization where the arc remains luminous without becoming loud.',
    mood: SacredMood.obsidian,
    icon: Icons.timeline_outlined,
    tags: <String>['Dark mode', 'Prayer', 'Arc'],
    bullets: <String>[
      'Gold and rose glow gently on dark fields.',
      'Transitions adapt to night-time context automatically.',
    ],
  ),
  spec(
    id: 61,
    phase: 'System',
    category: 'Dark Mode',
    title: 'Community Feed (Dark Mode)',
    headline: 'Social energy, evening restraint.',
    summary:
        'Dark mode feed variant that preserves readability, trust signals, and media hierarchy during night browsing.',
    mood: SacredMood.obsidian,
    icon: Icons.view_quilt_outlined,
    tags: <String>['Dark mode', 'Community', 'Feed'],
    bullets: <String>[
      'Masjid verification stays highly legible.',
      'Darker surfaces protect the editorial feel from flattening out.',
    ],
  ),
  spec(
    id: 62,
    phase: 'System',
    category: 'Utility',
    title: 'Global Search',
    headline: 'One search across the whole ecosystem.',
    summary:
        'A universal search for Quran, duas, content, community, and services with mixed-type result clarity.',
    mood: SacredMood.obsidian,
    icon: Icons.search_rounded,
    tags: <String>['Search', 'Universal', 'Mixed results'],
    bullets: <String>[
      'Filter chips let people narrow intent quickly.',
      'Trending prompts help warm-start empty searches.',
    ],
  ),
  spec(
    id: 63,
    phase: 'System',
    category: 'Utility',
    title: 'Error & Empty States',
    headline: 'Calm states that still guide forward.',
    summary:
        'A set of intentional empty and error states for offline moments, missing data, and new-user blank slates.',
    mood: SacredMood.obsidian,
    icon: Icons.error_outline_rounded,
    tags: <String>['Offline', 'Empty states', 'Resilience'],
    bullets: <String>[
      'Offline Quran and duas are explicitly offered.',
      'Animations reassure rather than scold.',
    ],
  ),
  spec(
    id: 64,
    phase: 'System',
    category: 'Utility',
    title: 'Accessibility Settings',
    headline: 'Ihsan is for every Muslim.',
    summary:
        'A dedicated accessibility control center for Arabic sizing, motion, contrast, color modes, and touch targets.',
    mood: SacredMood.obsidian,
    icon: Icons.accessibility_new_rounded,
    tags: <String>['Accessibility', 'Arabic size', 'Reduce motion'],
    bullets: <String>[
      'Arabic and Latin typography are controlled independently.',
      'Reduce motion and contrast tools are first-class settings.',
    ],
  ),
  spec(
    id: 65,
    phase: 'System',
    category: 'Utility',
    title: 'Onboarding Preferences',
    headline: 'Personalization begins with explicit choice.',
    summary:
        'Preference capture for madhab, reciters, topics, and notifications that powers the future AI layer responsibly.',
    mood: SacredMood.indigo,
    icon: Icons.interests_outlined,
    tags: <String>['Preferences', 'Topics', 'AI foundations'],
    bullets: <String>[
      'Chip-selection is visual and lightweight.',
      'Clear intent capture beats silent behavioral inference.',
    ],
  ),
  spec(
    id: 66,
    phase: 'System',
    category: 'Extras',
    title: 'Parental Controls',
    headline: 'Supportive boundaries for family life.',
    summary:
        'Settings for child-safe content, read-only community access, screen time, and spiritual goals.',
    mood: SacredMood.obsidian,
    icon: Icons.child_care_outlined,
    tags: <String>['Parents', 'Child safety', 'Goals'],
    bullets: <String>[
      'The system encourages without becoming punitive.',
      'Spiritual goals tie tech controls back to purpose.',
    ],
  ),
  spec(
    id: 67,
    phase: 'System',
    category: 'Extras',
    title: 'App Store Preview',
    headline: 'Marketing that looks like the product.',
    summary:
        'A store-preview screen using dramatic indigo mockups, feature badges, and social-proof framing.',
    mood: SacredMood.indigo,
    icon: Icons.mobile_friendly_outlined,
    tags: <String>['Marketing', 'Preview', 'Launch'],
    bullets: <String>[
      'The screenshot system extends the in-app identity.',
      'Core feature callouts remain concise and credible.',
    ],
  ),
  spec(
    id: 68,
    phase: 'System',
    category: 'Extras',
    title: 'Halal Certification Scanner',
    headline: 'Scan, verify, understand.',
    summary:
        'A barcode-led utility that reports halal certification status, source body, expiry, and ingredient confidence.',
    mood: SacredMood.obsidian,
    icon: Icons.qr_code_scanner_rounded,
    tags: <String>['Scanner', 'Halal', 'Verification'],
    bullets: <String>[
      'Results are explained, not just labeled.',
      'History provides useful continuity without clutter.',
    ],
  ),
  spec(
    id: 69,
    phase: 'System',
    category: 'Extras',
    title: 'Islamic Finance Education',
    headline: 'Finance literacy through an Islamic lens.',
    summary:
        'A finance education area for riba, sukuk, takaful, and screening reasoning without turning into a brokerage.',
    mood: SacredMood.obsidian,
    icon: Icons.account_balance_outlined,
    tags: <String>['Finance', 'Education', 'Shariah'],
    bullets: <String>[
      'Verdicts are paired with articles and explanations.',
      'The product teaches principle before product.',
    ],
  ),
];

IhsanScreenSpec screenById(int id) {
  return allScreens.firstWhere((IhsanScreenSpec screen) => screen.id == id);
}

List<IhsanScreenSpec> screensForPhase(String phase) {
  return allScreens
      .where((IhsanScreenSpec screen) => screen.phase == phase)
      .toList();
}
