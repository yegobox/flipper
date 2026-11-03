import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../theme/flo_theme.dart';
import '../widgets/flo/flo_block_renderer.dart';
import 'flo_team_controller.dart';
import 'flo_team_models.dart';
import 'flo_team_repository.dart' show FloTeamException;

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

/// Where a thread stands: idea, to do, doing, done, or a discussion.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.thread});

  final FloTeamThread thread;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final (IconData icon, String label, Color bg, Color fg) = !thread.isIdea
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

// --- Board ---------------------------------------------------------------------

class _Board extends ConsumerWidget {
  const _Board({
    required this.filter,
    required this.onFilter,
    required this.onOpen,
    required this.onMembers,
  });

  final FloTeamFilter filter;
  final ValueChanged<FloTeamFilter> onFilter;
  final ValueChanged<String> onOpen;

  /// Null unless the user may manage members.
  final VoidCallback? onMembers;

  Future<void> _newThread(
      BuildContext context, WidgetRef ref, String kind) async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (_) => _NewThreadDialog(kind: kind),
    );
    if (result == null || !context.mounted) return;
    await _guard(
      context,
      () => ref
          .read(floTeamControllerProvider.notifier)
          .createThread(kind: kind, title: result.$1, body: result.$2),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final state = ref.watch(floTeamControllerProvider);
    final threads = state.board.filtered(filter);

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.floTeamBoardTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: FloTheme.ink1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.floTeamSubtitle,
          style: const TextStyle(fontSize: 13, color: FloTheme.ink3),
        ),
      ],
    );
    final members = onMembers != null
        ? TextButton(
            key: const Key('flo-team-open-members'),
            style: _quietButton,
            onPressed: onMembers,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Facepile(members: state.members),
                const SizedBox(width: 8),
                Text(l10n.floTeamMembers),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _Facepile(members: state.members),
          );
    final newDiscussion = OutlinedButton.icon(
      key: const Key('flo-team-new-discussion'),
      style: _secondaryButton,
      onPressed: () => _newThread(context, ref, 'discussion'),
      icon: const Icon(Icons.forum_outlined, size: 18),
      label: Text(l10n.floTeamNewDiscussion),
    );
    final newIdea = FilledButton.icon(
      key: const Key('flo-team-new-idea'),
      style: _primaryButton,
      onPressed: () => _newThread(context, ref, 'idea'),
      icon: const Icon(Icons.lightbulb_outline, size: 18),
      label: Text(l10n.floTeamNewIdea),
    );

    return _Capped(
      maxWidth: _boardMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: LayoutBuilder(
              builder: (context, box) => box.maxWidth >= 720
                  ? Row(
                      children: [
                        Expanded(child: title),
                        const SizedBox(width: 16),
                        members,
                        const SizedBox(width: 8),
                        newDiscussion,
                        const SizedBox(width: 8),
                        newIdea,
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(child: title),
                            const SizedBox(width: 8),
                            members,
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: newDiscussion),
                            const SizedBox(width: 8),
                            Expanded(child: newIdea),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          _FilterTabs(
            board: state.board,
            selected: filter,
            onSelected: onFilter,
          ),
          Expanded(
            child: threads.isEmpty
                ? _EmptyColumn(filter: filter)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    itemCount: threads.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _ThreadCard(
                      thread: threads[i],
                      onOpen: () => onOpen(threads[i].id),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

String _filterLabel(BuildContext context, FloTeamFilter f) {
  final l10n = context.flipperL10n;
  return switch (f) {
    FloTeamFilter.ideas => l10n.floTeamIdeas,
    FloTeamFilter.todo => l10n.floTeamTodo,
    FloTeamFilter.doing => l10n.floTeamDoing,
    FloTeamFilter.done => l10n.floTeamDone,
    FloTeamFilter.discussions => l10n.floTeamDiscussions,
  };
}

IconData _filterIcon(FloTeamFilter f) => switch (f) {
      FloTeamFilter.ideas => Icons.lightbulb_outline,
      FloTeamFilter.todo => Icons.radio_button_unchecked,
      FloTeamFilter.doing => Icons.timelapse,
      FloTeamFilter.done => Icons.check_circle_outline,
      FloTeamFilter.discussions => Icons.forum_outlined,
    };

/// The board's columns as underlined tabs, each with how many it holds.
class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.board,
    required this.selected,
    required this.onSelected,
  });

  final FloTeamBoard board;
  final FloTeamFilter selected;
  final ValueChanged<FloTeamFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: FloTheme.line)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final f in FloTeamFilter.values)
              _FilterTab(
                key: Key('flo-team-filter-${f.name}'),
                icon: _filterIcon(f),
                label: _filterLabel(context, f),
                count: board.filtered(f).length,
                selected: f == selected,
                onTap: () => onSelected(f),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? FloTheme.ink1 : FloTheme.ink3;
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(FloTheme.radiusSm),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? FloTheme.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? FloTheme.blue : fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: fg,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              constraints: const BoxConstraints(minWidth: 20),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: selected ? FloTheme.blueTint : FloTheme.surface2,
                borderRadius: BorderRadius.circular(FloTheme.radiusPill),
              ),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? FloTheme.blueDeep : FloTheme.ink3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyColumn extends StatelessWidget {
  const _EmptyColumn({required this.filter});

  final FloTeamFilter filter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: FloTheme.surface2,
                shape: BoxShape.circle,
              ),
              child: Icon(_filterIcon(filter), size: 26, color: FloTheme.ink3),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.floTeamEmptyColumn,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: FloTheme.ink1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.floTeamEmptyHint,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: FloTheme.ink3),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreadCard extends ConsumerStatefulWidget {
  const _ThreadCard({required this.thread, required this.onOpen});

  final FloTeamThread thread;
  final VoidCallback onOpen;

  @override
  ConsumerState<_ThreadCard> createState() => _ThreadCardState();
}

class _ThreadCardState extends ConsumerState<_ThreadCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(floTeamControllerProvider);
    final thread = widget.thread;
    final unread = state.board.unreadIn(thread.id);
    final replies = state.board.posts[thread.id]?.length ?? 0;
    final assignee = _who(context, state, thread.assigneeUserId);
    final updated = thread.updatedAt ?? thread.createdAt;
    final overdue = _isOverdue(thread);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: FloTheme.surface,
          borderRadius: BorderRadius.circular(FloTheme.radiusMd),
          border: Border.all(
            color: _hover ? FloTheme.blueTint2 : FloTheme.line,
          ),
          boxShadow: [_hover ? FloTheme.sh2 : FloTheme.sh1],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: Key('flo-team-thread-${thread.id}'),
            borderRadius: BorderRadius.circular(FloTheme.radiusMd),
            onTap: widget.onOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (thread.isIdea)
                    _VoteButton(thread: thread)
                  else
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: FloTheme.violetTint,
                        borderRadius: BorderRadius.circular(FloTheme.radiusSm),
                      ),
                      child: const Icon(Icons.forum_outlined,
                          size: 20, color: FloTheme.violet),
                    ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thread.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.1,
                            color: FloTheme.ink1,
                          ),
                        ),
                        if (thread.body.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            thread.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              height: 1.4,
                              color: FloTheme.ink2,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 14,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _Avatar(
                                  userId: thread.authorUserId,
                                  name: _knownName(state, thread.authorUserId),
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _who(context, state, thread.authorUserId),
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: FloTheme.ink2,
                                  ),
                                ),
                                if (updated != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    _when(updated),
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: FloTheme.ink3,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (assignee.isNotEmpty)
                              _Meta(
                                icon: Icons.assignment_ind_outlined,
                                label: assignee,
                              ),
                            if (thread.dueDate != null)
                              _Meta(
                                icon: Icons.event_outlined,
                                label: _when(thread.dueDate!),
                                color: overdue ? FloTheme.lossInk : null,
                              ),
                            _Meta(
                              icon: Icons.chat_bubble_outline,
                              label: '$replies',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (unread > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: FloTheme.blue,
                        borderRadius:
                            BorderRadius.circular(FloTheme.radiusPill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.alternate_email,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            '$unread',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 1),
                    child: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: _hover ? FloTheme.ink2 : FloTheme.ink4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The member's name if the server knows it (for initials), else null.
String? _knownName(FloTeamState state, String? userId) {
  for (final m in state.members) {
    if (m.userId == userId) return m.name;
  }
  return null;
}

class _VoteButton extends ConsumerWidget {
  const _VoteButton({required this.thread});

  final FloTeamThread thread;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voted = thread.voted;
    final fg = voted ? FloTheme.blue : FloTheme.ink2;
    return Material(
      color: voted ? FloTheme.blueTint : FloTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FloTheme.radiusSm),
        side: BorderSide(color: voted ? FloTheme.blueTint2 : FloTheme.line),
      ),
      child: InkWell(
        key: Key('flo-team-vote-${thread.id}'),
        borderRadius: BorderRadius.circular(FloTheme.radiusSm),
        onTap: () => _guard(
          context,
          () => ref.read(floTeamControllerProvider.notifier).toggleVote(thread),
        ),
        child: SizedBox(
          width: 46,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                voted ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                size: 16,
                color: fg,
              ),
              const SizedBox(height: 2),
              Text(
                '${thread.votes}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: voted ? FloTheme.blueDeep : FloTheme.ink1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _field(String label) => InputDecoration(
      labelText: label,
      floatingLabelStyle: const TextStyle(color: FloTheme.blue),
      filled: true,
      fillColor: FloTheme.surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FloTheme.radiusSm),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FloTheme.radiusSm),
        borderSide: const BorderSide(color: FloTheme.blue, width: 1.5),
      ),
    );

/// A dialog in Flo's style: rounded, white, with an icon beside the title.
class _FloDialog extends StatelessWidget {
  const _FloDialog({
    required this.icon,
    required this.title,
    required this.content,
    required this.actions,
  });

  final IconData icon;
  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: FloTheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FloTheme.radiusLg),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: FloTheme.blueTint,
              borderRadius: BorderRadius.circular(FloTheme.radiusSm),
            ),
            child: Icon(icon, size: 20, color: FloTheme.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: FloTheme.ink1,
              ),
            ),
          ),
        ],
      ),
      content: content,
      actions: actions,
    );
  }
}

class _NewThreadDialog extends StatefulWidget {
  const _NewThreadDialog({required this.kind});

  final String kind;

  @override
  State<_NewThreadDialog> createState() => _NewThreadDialogState();
}

class _NewThreadDialogState extends State<_NewThreadDialog> {
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final isIdea = widget.kind == 'idea';
    return _FloDialog(
      icon: isIdea ? Icons.lightbulb_outline : Icons.forum_outlined,
      title: isIdea ? l10n.floTeamNewIdea : l10n.floTeamNewDiscussion,
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('flo-team-new-title'),
              controller: _title,
              autofocus: true,
              maxLength: 200,
              decoration: _field(l10n.floTeamTitleHint),
            ),
            const SizedBox(height: 4),
            TextField(
              key: const Key('flo-team-new-body'),
              controller: _body,
              minLines: 3,
              maxLines: 6,
              decoration: _field(l10n.floTeamDetailsHint)
                  .copyWith(alignLabelWithHint: true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: _quietButton,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ListenableBuilder(
          listenable: _title,
          builder: (context, _) => FilledButton(
            key: const Key('flo-team-new-submit'),
            style: _primaryButton,
            onPressed: _title.text.trim().isEmpty
                ? null
                : () => Navigator.of(context)
                    .pop((_title.text.trim(), _body.text.trim())),
            child: Text(l10n.floTeamPost),
          ),
        ),
      ],
    );
  }
}

// --- Thread --------------------------------------------------------------------

class _ThreadPanel extends ConsumerStatefulWidget {
  const _ThreadPanel({required this.thread, required this.onBack});

  final FloTeamThread thread;
  final VoidCallback onBack;

  @override
  ConsumerState<_ThreadPanel> createState() => _ThreadPanelState();
}

class _ThreadPanelState extends ConsumerState<_ThreadPanel> {
  final _reply = TextEditingController();
  final Set<String> _mentions = {};
  bool _picking = false;

  FloTeamController get _team => ref.read(floTeamControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    // Opening the thread reads its mentions. If that fails (offline) they
    // stay unread until the thread is opened again.
    Future.microtask(
      () => _team.markRead(widget.thread.id).catchError(
            (Object _) {},
            test: (e) => e is FloTeamException,
          ),
    );
  }

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _reply.text.trim();
    if (body.isEmpty) return;
    final mentions = _mentions.toList();
    await _guard(context, () async {
      await _team.post(widget.thread.id, body, mentions);
      // The user may have left the thread while it posted.
      if (!mounted) return;
      _reply.clear();
      setState(() {
        _mentions.clear();
        _picking = false;
      });
    });
  }

  Future<void> _editTask() async {
    final changes = await showDialog<Map<String, Object?>>(
      context: context,
      builder: (_) => _TaskDialog(thread: widget.thread),
    );
    if (changes == null || changes.isEmpty || !mounted) return;
    await _guard(context, () => _team.updateThread(widget.thread.id, changes));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final state = ref.watch(floTeamControllerProvider);
    final thread = widget.thread;
    final posts = state.board.posts[thread.id] ?? const <FloTeamPost>[];
    final floBusy = state.floBusy.contains(thread.id);
    final me = state.me?.userId;
    final created = thread.createdAt ?? thread.updatedAt;
    final assignee = _who(context, state, thread.assigneeUserId);
    final floStyle = _secondaryButton.copyWith(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );

    final header = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FloTheme.surface,
        borderRadius: BorderRadius.circular(FloTheme.radiusLg),
        border: Border.all(color: FloTheme.line),
        boxShadow: const [FloTheme.sh1],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusPill(thread: thread),
                const SizedBox(height: 10),
                Text(
                  thread.title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: FloTheme.ink1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Avatar(
                      userId: thread.authorUserId,
                      name: _knownName(state, thread.authorUserId),
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        [
                          _who(context, state, thread.authorUserId),
                          if (created != null) _when(created),
                        ].join(' · '),
                        style: const TextStyle(
                          fontSize: 13,
                          color: FloTheme.ink3,
                        ),
                      ),
                    ),
                  ],
                ),
                if (thread.body.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    thread.body,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.5,
                      color: FloTheme.ink2,
                    ),
                  ),
                ],
                if (assignee.isNotEmpty || thread.dueDate != null) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 16,
                    runSpacing: 6,
                    children: [
                      if (assignee.isNotEmpty)
                        _Meta(
                          icon: Icons.assignment_ind_outlined,
                          label: '${l10n.floTeamAssignee}: $assignee',
                        ),
                      if (thread.dueDate != null)
                        _Meta(
                          icon: Icons.event_outlined,
                          label:
                              '${l10n.floTeamDue}: ${_when(thread.dueDate!)}',
                          color: _isOverdue(thread) ? FloTheme.lossInk : null,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (thread.isIdea) ...[
            const SizedBox(width: 16),
            _VoteButton(thread: thread),
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Capped(
          maxWidth: _threadBarMaxWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
            child: Row(
              children: [
                IconButton(
                  key: const Key('flo-team-back'),
                  tooltip: l10n.back,
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back, color: FloTheme.ink2),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        key: const Key('flo-team-ask-flo'),
                        style: floStyle,
                        onPressed: floBusy
                            ? null
                            : () =>
                                _guard(context, () => _team.askFlo(thread.id)),
                        icon: const Icon(Icons.auto_awesome, size: 16),
                        label: Text(l10n.floAskFlo),
                      ),
                      OutlinedButton.icon(
                        key: const Key('flo-team-summarize'),
                        style: floStyle,
                        onPressed: floBusy
                            ? null
                            : () => _guard(
                                  context,
                                  () =>
                                      _team.askFlo(thread.id, summarize: true),
                                ),
                        icon: const Icon(Icons.summarize_outlined, size: 16),
                        label: Text(l10n.floTeamSummarize),
                      ),
                      if (thread.isIdea)
                        FilledButton.icon(
                          key: const Key('flo-team-task'),
                          style: _primaryButton.copyWith(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                          ),
                          onPressed: _editTask,
                          icon: const Icon(Icons.task_alt, size: 16),
                          label: Text(l10n.floTeamTask),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            children: [
              _Capped(
                maxWidth: _threadMaxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    header,
                    const SizedBox(height: 20),
                    for (final post in posts)
                      _PostTile(
                        post: post,
                        author: _who(context, state, post.authorUserId),
                        knownName: _knownName(state, post.authorUserId),
                      ),
                    if (floBusy)
                      Padding(
                        key: const Key('flo-team-flo-busy'),
                        padding: const EdgeInsets.only(top: 4, bottom: 12),
                        child: Row(
                          children: [
                            const _Avatar.flo(size: 32),
                            const SizedBox(width: 12),
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: FloTheme.violet,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.floTeamFloThinking,
                              style: const TextStyle(
                                color: FloTheme.violet,
                                fontWeight: FontWeight.w600,
                              ),
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
        _Capped(
          maxWidth: _threadBarMaxWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_picking)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final m
                            in state.members.where((m) => m.userId != me))
                          FilterChip(
                            key: Key('flo-team-mention-${m.userId}'),
                            avatar: _Avatar(
                                userId: m.userId, name: m.name, size: 20),
                            label: Text('@${m.displayName}'),
                            selected: _mentions.contains(m.userId),
                            showCheckmark: false,
                            selectedColor: FloTheme.blueTint,
                            backgroundColor: FloTheme.surface,
                            side: BorderSide(
                              color: _mentions.contains(m.userId)
                                  ? FloTheme.blueTint2
                                  : FloTheme.line,
                            ),
                            shape: const StadiumBorder(),
                            onSelected: (on) => setState(
                              () => on
                                  ? _mentions.add(m.userId)
                                  : _mentions.remove(m.userId),
                            ),
                          ),
                      ],
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                  decoration: BoxDecoration(
                    color: FloTheme.surface,
                    borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                    border: Border.all(color: FloTheme.lineStrong),
                    boxShadow: const [FloTheme.sh2],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        key: const Key('flo-team-mention'),
                        tooltip: l10n.floTeamMention,
                        onPressed: () => setState(() => _picking = !_picking),
                        icon: Icon(
                          Icons.alternate_email,
                          color: _mentions.isEmpty && !_picking
                              ? FloTheme.ink3
                              : FloTheme.blue,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          key: const Key('flo-team-reply'),
                          controller: _reply,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: l10n.floTeamReplyHint,
                            hintStyle: const TextStyle(color: FloTheme.ink4),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        key: const Key('flo-team-send'),
                        style: _primaryButton.copyWith(
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                        onPressed: _send,
                        icon: const Icon(Icons.send_rounded, size: 16),
                        label: Text(l10n.floTeamPost),
                      ),
                    ],
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

class _PostTile extends StatelessWidget {
  const _PostTile({
    required this.post,
    required this.author,
    required this.knownName,
  });

  final FloTeamPost post;
  final String author;

  /// The author's name if the server knows it, for their initials.
  final String? knownName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          post.isFlo
              ? const _Avatar.flo(size: 32)
              : _Avatar(
                  userId: post.authorUserId ?? '',
                  name: knownName,
                  size: 32,
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.isFlo ? 'Flo' : author,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: post.isFlo ? FloTheme.violet : FloTheme.ink1,
                      ),
                    ),
                    if (post.createdAt != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        _when(post.createdAt!),
                        style: const TextStyle(
                          fontSize: 12,
                          color: FloTheme.ink3,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: post.isFlo ? FloTheme.violetTint : FloTheme.surface,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(FloTheme.radiusMd),
                      bottomLeft: Radius.circular(FloTheme.radiusMd),
                      bottomRight: Radius.circular(FloTheme.radiusMd),
                      topLeft: Radius.circular(4),
                    ),
                    border: Border.all(
                      color:
                          post.isFlo ? const Color(0xFFE4DAF8) : FloTheme.line,
                    ),
                  ),
                  child: post.isFlo && post.blocks.isNotEmpty
                      ? FloBlockRenderer(blocks: post.blocks)
                      : Text(
                          post.body,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.45,
                            color: FloTheme.ink1,
                          ),
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

class _TaskDialog extends ConsumerStatefulWidget {
  const _TaskDialog({required this.thread});

  final FloTeamThread thread;

  @override
  ConsumerState<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends ConsumerState<_TaskDialog> {
  late FloTeamStatus _status = widget.thread.status;
  late String? _assignee = widget.thread.assigneeUserId;
  late DateTime? _due = widget.thread.dueDate;

  Future<void> _pickDue() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _due = picked);
  }

  /// Only what changed, in the API's keys.
  Map<String, Object?> _changes() {
    final t = widget.thread;
    return {
      if (_status != t.status) 'status': _status.name,
      if (_assignee != t.assigneeUserId) 'assigneeUserId': _assignee,
      if (_due != t.dueDate) 'dueDate': _due == null ? null : _date(_due!),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final members = ref.watch(floTeamControllerProvider).members;
    final statuses = {
      FloTeamStatus.idea: l10n.floTeamIdeas,
      FloTeamStatus.todo: l10n.floTeamTodo,
      FloTeamStatus.doing: l10n.floTeamDoing,
      FloTeamStatus.done: l10n.floTeamDone,
    };
    return _FloDialog(
      icon: Icons.task_alt,
      title: l10n.floTeamTask,
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<FloTeamStatus>(
              key: const Key('flo-team-task-status'),
              initialValue:
                  statuses.containsKey(_status) ? _status : FloTeamStatus.idea,
              decoration: _field(l10n.floTeamStatus),
              borderRadius: BorderRadius.circular(FloTheme.radiusSm),
              items: [
                for (final e in statuses.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (s) => setState(() => _status = s ?? _status),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              key: const Key('flo-team-task-assignee'),
              initialValue: _assignee,
              decoration: _field(l10n.floTeamAssignee),
              borderRadius: BorderRadius.circular(FloTheme.radiusSm),
              items: [
                DropdownMenuItem<String?>(
                    value: null, child: Text(l10n.floTeamNobody)),
                for (final m in members)
                  DropdownMenuItem<String?>(
                      value: m.userId, child: Text(m.displayName)),
                // Assigned to someone since removed from the team.
                if (_assignee != null &&
                    members.every((m) => m.userId != _assignee))
                  DropdownMenuItem<String?>(
                      value: _assignee, child: Text(_assignee!)),
              ],
              onChanged: (u) => setState(() => _assignee = u),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
              decoration: BoxDecoration(
                color: FloTheme.surface2,
                borderRadius: BorderRadius.circular(FloTheme.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_outlined,
                      size: 18, color: FloTheme.ink3),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${l10n.floTeamDue}: ${_due == null ? l10n.floTeamNoDate : _date(_due!)}',
                      style: const TextStyle(color: FloTheme.ink1),
                    ),
                  ),
                  IconButton(
                    key: const Key('flo-team-task-due'),
                    onPressed: _pickDue,
                    icon: const Icon(Icons.edit_calendar_outlined,
                        color: FloTheme.blue),
                  ),
                  if (_due != null)
                    IconButton(
                      key: const Key('flo-team-task-due-clear'),
                      onPressed: () => setState(() => _due = null),
                      icon: const Icon(Icons.clear, color: FloTheme.ink3),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: _quietButton,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('flo-team-task-save'),
          style: _primaryButton,
          onPressed: () => Navigator.of(context).pop(_changes()),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

// --- Members ---------------------------------------------------------------------

class _MembersPanel extends ConsumerStatefulWidget {
  const _MembersPanel({required this.onBack});

  final VoidCallback onBack;

  @override
  ConsumerState<_MembersPanel> createState() => _MembersPanelState();
}

class _MembersPanelState extends ConsumerState<_MembersPanel> {
  late Future<List<FloTeamMember>> _colleagues = _load();

  FloTeamController get _team => ref.read(floTeamControllerProvider.notifier);

  Future<List<FloTeamMember>> _load() => _team.colleagues();

  Future<void> _change(Future<void> Function() action) async {
    await _guard(context, action);
    if (mounted) {
      setState(() {
        _colleagues = _load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final state = ref.watch(floTeamControllerProvider);
    final members = state.members;
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 24),
      children: [
        _Capped(
          maxWidth: _threadMaxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    key: const Key('flo-team-back'),
                    tooltip: l10n.back,
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back, color: FloTheme.ink2),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.floTeamMembers,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: FloTheme.ink1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _CountPill(count: members.length),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _Section(
                  children: [
                    for (final m in members)
                      _PersonRow(
                        userId: m.userId,
                        name: m.name,
                        label: m.name ??
                            (m.userId == state.me?.userId
                                ? l10n.floTeamYou
                                : m.userId),
                        badge: m.isOwner ? l10n.floTeamOwner : null,
                        action: m.isOwner
                            ? null
                            : TextButton(
                                key: Key('flo-team-remove-${m.userId}'),
                                style: _quietButton.copyWith(
                                  foregroundColor: const WidgetStatePropertyAll(
                                      FloTheme.lossInk),
                                ),
                                onPressed: () =>
                                    _change(() => _team.remove(m.userId)),
                                child: Text(l10n.remove),
                              ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 10),
                child: Text(
                  l10n.floTeamInviteFromStaff.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: FloTheme.ink3,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FutureBuilder<List<FloTeamMember>>(
                  future: _colleagues,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final colleagues = snapshot.data ?? const <FloTeamMember>[];
                    if (snapshot.hasError || colleagues.isEmpty) {
                      return _Section(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              snapshot.hasError
                                  ? '${snapshot.error}'
                                  : l10n.floTeamNoColleagues,
                              style: const TextStyle(color: FloTheme.ink3),
                            ),
                          ),
                        ],
                      );
                    }
                    return _Section(
                      children: [
                        for (final c in colleagues)
                          _PersonRow(
                            userId: c.userId,
                            name: c.name,
                            label: c.displayName,
                            action: FilledButton.tonalIcon(
                              key: Key('flo-team-invite-${c.userId}'),
                              style: FilledButton.styleFrom(
                                backgroundColor: FloTheme.blueTint,
                                foregroundColor: FloTheme.blueDeep,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(FloTheme.radiusSm),
                                ),
                              ),
                              onPressed: () =>
                                  _change(() => _team.invite(c.userId)),
                              icon: const Icon(Icons.person_add_alt, size: 16),
                              label: Text(l10n.invite),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: FloTheme.surface2,
        borderRadius: BorderRadius.circular(FloTheme.radiusPill),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: FloTheme.ink2,
        ),
      ),
    );
  }
}

/// A white card holding rows split by thin lines.
class _Section extends StatelessWidget {
  const _Section({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FloTheme.surface,
        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
        border: Border.all(color: FloTheme.line),
        boxShadow: const [FloTheme.sh1],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: FloTheme.lineSoft),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.userId,
    required this.name,
    required this.label,
    this.badge,
    this.action,
  });

  final String userId;
  final String? name;
  final String label;
  final String? badge;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Row(
        children: [
          _Avatar(userId: userId, name: name, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: FloTheme.ink1,
                    ),
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: FloTheme.blueTint,
                      borderRadius: BorderRadius.circular(FloTheme.radiusPill),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: FloTheme.blueDeep,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
