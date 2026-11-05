part of 'flo_team_view.dart';

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
    FloTeamFilter.support => l10n.floTeamSupport,
  };
}

IconData _filterIcon(FloTeamFilter f) => switch (f) {
      FloTeamFilter.ideas => Icons.lightbulb_outline,
      FloTeamFilter.todo => Icons.radio_button_unchecked,
      FloTeamFilter.doing => Icons.timelapse,
      FloTeamFilter.done => Icons.check_circle_outline,
      FloTeamFilter.discussions => Icons.forum_outlined,
      FloTeamFilter.support => Icons.support_agent,
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
              // Only a support business ever gets support threads.
              if (f != FloTeamFilter.support ||
                  f == selected ||
                  board.filtered(f).isNotEmpty)
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
    final posts = state.board.posts[thread.id] ?? const <FloTeamPost>[];
    final replies = posts.length;
    final customer = _supportCustomer(thread, posts);
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
                      child: Icon(
                          thread.isSupport
                              ? Icons.support_agent
                              : Icons.forum_outlined,
                          size: 20,
                          color: FloTheme.violet),
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
                                  name: customer ??
                                      _knownName(state, thread.authorUserId),
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  customer ??
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
