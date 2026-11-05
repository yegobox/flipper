import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../theme/flo_theme.dart';
import '../widgets/flo/flo_block_renderer.dart';
import 'flo_team_controller.dart';
import 'flo_team_models.dart';
import 'flo_team_repository.dart' show FloTeamException;

part 'flo_team_view_board.dart';
part 'flo_team_view_thread.dart';
part 'flo_team_view_members.dart';

/// The Team tab of Flo: a board of ideas, tasks and discussions shared with
/// invited colleagues, threads where Flo joins in, and (for the owner or an
/// admin) who is in the team.
class FloTeamView extends ConsumerStatefulWidget {
  const FloTeamView({super.key});

  @override
  ConsumerState<FloTeamView> createState() => _FloTeamViewState();
}

enum _Panel { board, thread, members }

class _FloTeamViewState extends ConsumerState<FloTeamView> {
  _Panel _panel = _Panel.board;
  String? _threadId;
  FloTeamFilter _filter = FloTeamFilter.ideas;

  FloTeamController get _team => ref.read(floTeamControllerProvider.notifier);

  void _open(String threadId) {
    setState(() {
      _panel = _Panel.thread;
      _threadId = threadId;
    });
  }

  void _back() => setState(() => _panel = _Panel.board);

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final state = ref.watch(floTeamControllerProvider);
    if (state.loading) {
      return const Center(
        child: CircularProgressIndicator(key: Key('flo-team-loading')),
      );
    }
    // A failed first load has no `me` yet: that is an error to retry, not
    // "not a member".
    if (state.error != null &&
        state.board.threads.isEmpty &&
        (state.isMember || state.me == null)) {
      return _Message(
        icon: Icons.cloud_off_outlined,
        title: l10n.floTeamLoadFailed,
        body: state.error!,
        action: OutlinedButton(
          style: _secondaryButton,
          onPressed: _team.refresh,
          child: Text(l10n.retry),
        ),
      );
    }
    if (_panel == _Panel.members && state.isManager) {
      return _MembersPanel(onBack: _back);
    }
    if (!state.isMember) {
      return _Message(
        icon: Icons.groups_2_outlined,
        title: l10n.floTeamNotMemberTitle,
        body: l10n.floTeamNotMemberBody,
        action: state.isManager
            ? FilledButton.icon(
                key: const Key('flo-team-open-members'),
                style: _primaryButton,
                onPressed: () => setState(() => _panel = _Panel.members),
                icon: const Icon(Icons.group_add_outlined, size: 18),
                label: Text(l10n.floTeamMembers),
              )
            : null,
      );
    }
    final thread = state.board.threads[_threadId];
    if (_panel == _Panel.thread && thread != null) {
      return _ThreadPanel(thread: thread, onBack: _back);
    }
    return _Board(
      filter: _filter,
      onFilter: (f) => setState(() => _filter = f),
      onOpen: _open,
      onMembers: state.isManager
          ? () => setState(() => _panel = _Panel.members)
          : null,
    );
  }
}

/// Runs a team action, telling the user when it fails.
Future<void> _guard(
    BuildContext context, Future<void> Function() action) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  try {
    await action();
  } catch (e) {
    messenger?.showSnackBar(SnackBar(content: Text('$e')));
  }
}

// --- Shared pieces ---------------------------------------------------------------

/// Board and thread content stops growing past this, so lines stay readable
/// on wide desktops.
const double _boardMaxWidth = 1040;
const double _threadMaxWidth = 820;

// The thread's top bar and reply box sit in 20px of padding; this lets
// their edges line up with the posts.
const double _threadBarMaxWidth = _threadMaxWidth + 40;

final _primaryButton = FilledButton.styleFrom(
  backgroundColor: FloTheme.blue,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(FloTheme.radiusSm),
  ),
);

final _secondaryButton = OutlinedButton.styleFrom(
  backgroundColor: FloTheme.blueTint,
  foregroundColor: FloTheme.blueDeep,
  side: const BorderSide(color: FloTheme.blueTint2),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(FloTheme.radiusSm),
  ),
);

final _quietButton = TextButton.styleFrom(
  foregroundColor: FloTheme.ink2,
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(FloTheme.radiusSm),
  ),
);

/// The customer who opened a support thread, named by their own posts: they
/// are not a member, so [_who] would only call them "A teammate".
String? _supportCustomer(FloTeamThread thread, List<FloTeamPost> posts) =>
    thread.isSupport
        ? posts
            .where((p) =>
                p.isCustomer &&
                p.authorUserId == thread.authorUserId &&
                p.authorName != null)
            .map((p) => p.authorName!)
            .firstOrNull
        : null;

/// A person's name for display: their name when the server knows it,
/// otherwise "You" or "A teammate" rather than a raw user id.
String _who(BuildContext context, FloTeamState state, String? userId) {
  if (userId == null || userId.isEmpty) return '';
  for (final m in state.members) {
    if (m.userId == userId && m.name != null) return m.name!;
  }
  final l10n = context.flipperL10n;
  return userId == state.me?.userId ? l10n.floTeamYou : l10n.floTeamSomeone;
}

/// The API's date form (`yyyy-MM-dd`).
String _date(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// A short, human date: "14:05" today, "6 Nov" this year, else "6 Nov 2025".
String _when(DateTime d) {
  final now = DateTime.now();
  if (d.year == now.year && d.month == now.month && d.day == now.day) {
    return DateFormat('HH:mm').format(d);
  }
  return DateFormat(d.year == now.year ? 'd MMM' : 'd MMM y').format(d);
}

bool _isOverdue(FloTeamThread t) {
  final due = t.dueDate;
  if (due == null || t.status == FloTeamStatus.done) return false;
  final now = DateTime.now();
  return due.isBefore(DateTime(now.year, now.month, now.day));
}

/// A round avatar with the person's initials, tinted from their id so each
/// colleague keeps the same colour.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.userId, required this.name, this.size = 28});

  /// A Flo avatar.
  const _Avatar.flo({this.size = 28})
      : userId = null,
        name = null;

  final String? userId;

  /// Null when the server does not know it.
  final String? name;
  final double size;

  static const _palette = [
    (FloTheme.blueTint, FloTheme.blueDeep),
    (FloTheme.violetTint, FloTheme.violet),
    (FloTheme.xpTint, Color(0xFFB45309)),
    (FloTheme.lossTint, FloTheme.lossInk),
    (Color(0xFFE0F2FE), Color(0xFF0369A1)),
  ];

  String get _initials {
    final parts = (name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    final first = parts.first.characters.first;
    final last =
        parts.length > 1 && size >= 30 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          gradient: FloTheme.gradBrand,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.auto_awesome, size: size * 0.5, color: Colors.white),
      );
    }
    final (bg, fg) = _palette[userId!.hashCode.abs() % _palette.length];
    final initials = _initials;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: FloTheme.surface, width: 1.5),
      ),
      child: initials.isEmpty
          ? Icon(Icons.person, size: size * 0.6, color: fg)
          : Text(
              initials,
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
    );
  }
}

/// Up to four overlapping member avatars, then "+N".
class _Facepile extends StatelessWidget {
  const _Facepile({required this.members});

  final List<FloTeamMember> members;

  @override
  Widget build(BuildContext context) {
    const size = 26.0;
    const step = 18.0;
    final shown = members.take(4).toList();
    final extra = members.length - shown.length;
    final count = shown.length + (extra > 0 ? 1 : 0);
    return SizedBox(
      width: count == 0 ? 0 : step * (count - 1) + size,
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: step * i,
              child: _Avatar(
                userId: shown[i].userId,
                name: shown[i].name,
                size: size,
              ),
            ),
          if (extra > 0)
            Positioned(
              left: step * shown.length,
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: FloTheme.surface2,
                  shape: BoxShape.circle,
                  border: Border.all(color: FloTheme.surface, width: 1.5),
                ),
                child: Text(
                  '+$extra',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: FloTheme.ink2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A small icon + label used for a card's or thread's details.
class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? FloTheme.ink3;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: c),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: c,
            fontWeight: color == null ? FontWeight.w500 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Where a thread stands: idea, to do, doing, done, a discussion, or a
/// support request (open or resolved).
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.thread});

  final FloTeamThread thread;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final (IconData icon, String label, Color bg, Color fg) = thread.isSupport
        ? thread.status == FloTeamStatus.done
            ? (
                Icons.check_circle_outline,
                l10n.floTeamResolved,
                FloTheme.gainTint,
                FloTheme.gainInk
              )
            : (
                Icons.support_agent,
                l10n.floTeamSupport,
                FloTheme.blueTint,
                FloTheme.blueDeep
              )
        : !thread.isIdea
            ? (
                Icons.forum_outlined,
                l10n.floTeamDiscussion,
                FloTheme.violetTint,
                FloTheme.violet
              )
            : switch (thread.status) {
                FloTeamStatus.todo => (
                    Icons.radio_button_unchecked,
                    l10n.floTeamTodo,
                    FloTheme.surface2,
                    FloTheme.ink2
                  ),
                FloTeamStatus.doing => (
                    Icons.timelapse,
                    l10n.floTeamDoing,
                    FloTheme.blueTint,
                    FloTheme.blueDeep
                  ),
                FloTeamStatus.done => (
                    Icons.check_circle_outline,
                    l10n.floTeamDone,
                    FloTheme.gainTint,
                    FloTheme.gainInk
                  ),
                _ => (
                    Icons.lightbulb_outline,
                    l10n.floTeamIdea,
                    FloTheme.xpTint,
                    const Color(0xFFB45309)
                  ),
              };
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(FloTheme.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: FloTheme.blueTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: FloTheme.blue),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: FloTheme.ink1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                body,
                textAlign: TextAlign.center,
                style: const TextStyle(color: FloTheme.ink2, height: 1.45),
              ),
              if (action != null) ...[const SizedBox(height: 20), action!],
            ],
          ),
        ),
      ),
    );
  }
}

/// Centres [child] and caps its width.
class _Capped extends StatelessWidget {
  const _Capped({required this.maxWidth, required this.child});

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
