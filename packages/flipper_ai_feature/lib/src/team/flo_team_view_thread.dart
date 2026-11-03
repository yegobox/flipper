part of 'flo_team_view.dart';

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
