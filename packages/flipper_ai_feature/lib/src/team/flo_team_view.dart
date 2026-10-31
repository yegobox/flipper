import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/flo_theme.dart';
import '../widgets/flo/flo_block_renderer.dart';
import 'flo_team_controller.dart';
import 'flo_team_models.dart';

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
    if (state.error != null && state.board.threads.isEmpty && state.isMember) {
      return _Message(
        title: l10n.floTeamLoadFailed,
        body: state.error!,
        action: TextButton(onPressed: _team.refresh, child: Text(l10n.retry)),
      );
    }
    if (_panel == _Panel.members && state.isManager) {
      return _MembersPanel(onBack: _back);
    }
    if (!state.isMember) {
      return _Message(
        title: l10n.floTeamNotMemberTitle,
        body: l10n.floTeamNotMemberBody,
        action: state.isManager
            ? FilledButton.icon(
                key: const Key('flo-team-open-members'),
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

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.body, this.action});

  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.groups_2_outlined, size: 40, color: FloTheme.ink3),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: FloTheme.ink1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: FloTheme.ink2),
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
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

  String _label(BuildContext context, FloTeamFilter f) {
    final l10n = context.flipperL10n;
    return switch (f) {
      FloTeamFilter.ideas => l10n.floTeamIdeas,
      FloTeamFilter.todo => l10n.floTeamTodo,
      FloTeamFilter.doing => l10n.floTeamDoing,
      FloTeamFilter.done => l10n.floTeamDone,
      FloTeamFilter.discussions => l10n.floTeamDiscussions,
    };
  }

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final f in FloTeamFilter.values)
                ChoiceChip(
                  key: Key('flo-team-filter-${f.name}'),
                  label: Text(_label(context, f)),
                  selected: f == filter,
                  onSelected: (_) => onFilter(f),
                ),
              FilledButton.tonalIcon(
                key: const Key('flo-team-new-idea'),
                onPressed: () => _newThread(context, ref, 'idea'),
                icon: const Icon(Icons.lightbulb_outline, size: 18),
                label: Text(l10n.floTeamNewIdea),
              ),
              OutlinedButton.icon(
                key: const Key('flo-team-new-discussion'),
                onPressed: () => _newThread(context, ref, 'discussion'),
                icon: const Icon(Icons.forum_outlined, size: 18),
                label: Text(l10n.floTeamNewDiscussion),
              ),
              if (onMembers != null)
                TextButton.icon(
                  key: const Key('flo-team-open-members'),
                  onPressed: onMembers,
                  icon: const Icon(Icons.group_outlined, size: 18),
                  label: Text(l10n.floTeamMembers),
                ),
            ],
          ),
        ),
        Expanded(
          child: threads.isEmpty
              ? Center(
                  child: Text(
                    l10n.floTeamEmptyColumn,
                    style: const TextStyle(color: FloTheme.ink3),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: threads.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _ThreadCard(
                    thread: threads[i],
                    onOpen: () => onOpen(threads[i].id),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ThreadCard extends ConsumerWidget {
  const _ThreadCard({required this.thread, required this.onOpen});

  final FloTeamThread thread;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(floTeamControllerProvider);
    final unread = state.board.unreadIn(thread.id);
    final replies = state.board.posts[thread.id]?.length ?? 0;
    final assignee = state.nameOf(thread.assigneeUserId);
    return Material(
      color: FloTheme.surface,
      borderRadius: BorderRadius.circular(FloTheme.radiusMd),
      child: InkWell(
        key: Key('flo-team-thread-${thread.id}'),
        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
        onTap: onOpen,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FloTheme.radiusMd),
            border: Border.all(color: FloTheme.line),
          ),
          child: Row(
            children: [
              if (thread.isIdea) _VoteButton(thread: thread),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: FloTheme.ink1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        state.nameOf(thread.authorUserId),
                        if (assignee.isNotEmpty) '→ $assignee',
                        if (thread.dueDate != null) _date(thread.dueDate!),
                        '💬 $replies',
                      ].join('  ·  '),
                      style:
                          const TextStyle(fontSize: 12.5, color: FloTheme.ink3),
                    ),
                  ],
                ),
              ),
              if (unread > 0)
                CircleAvatar(
                  radius: 11,
                  backgroundColor: FloTheme.blue,
                  child: Text(
                    '$unread',
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _date(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class _VoteButton extends ConsumerWidget {
  const _VoteButton({required this.thread});

  final FloTeamThread thread;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      key: Key('flo-team-vote-${thread.id}'),
      borderRadius: BorderRadius.circular(FloTheme.radiusSm),
      onTap: () => _guard(
        context,
        () => ref.read(floTeamControllerProvider.notifier).toggleVote(thread),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Icon(
              thread.voted ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
              size: 18,
              color: thread.voted ? FloTheme.blue : FloTheme.ink3,
            ),
            Text('${thread.votes}', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
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
    return AlertDialog(
      title: Text(
        widget.kind == 'idea' ? l10n.floTeamNewIdea : l10n.floTeamNewDiscussion,
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('flo-team-new-title'),
              controller: _title,
              autofocus: true,
              maxLength: 200,
              decoration: InputDecoration(labelText: l10n.floTeamTitleHint),
            ),
            TextField(
              key: const Key('flo-team-new-body'),
              controller: _body,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(labelText: l10n.floTeamDetailsHint),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ListenableBuilder(
          listenable: _title,
          builder: (context, _) => FilledButton(
            key: const Key('flo-team-new-submit'),
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
    // Opening the thread reads its mentions.
    Future.microtask(() => _team.markRead(widget.thread.id));
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
          child: Row(
            children: [
              IconButton(
                key: const Key('flo-team-back'),
                tooltip: l10n.back,
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  thread.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: FloTheme.ink1,
                  ),
                ),
              ),
              if (thread.isIdea) ...[
                _VoteButton(thread: thread),
                TextButton.icon(
                  key: const Key('flo-team-task'),
                  onPressed: _editTask,
                  icon: const Icon(Icons.task_alt, size: 18),
                  label: Text(l10n.floTeamTask),
                ),
              ],
            ],
          ),
        ),
        if (thread.body.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child:
                Text(thread.body, style: const TextStyle(color: FloTheme.ink2)),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                key: const Key('flo-team-ask-flo'),
                onPressed: floBusy
                    ? null
                    : () => _guard(context, () => _team.askFlo(thread.id)),
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: Text(l10n.floAskFlo),
              ),
              OutlinedButton.icon(
                key: const Key('flo-team-summarize'),
                onPressed: floBusy
                    ? null
                    : () => _guard(
                          context,
                          () => _team.askFlo(thread.id, summarize: true),
                        ),
                icon: const Icon(Icons.summarize_outlined, size: 16),
                label: Text(l10n.floTeamSummarize),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final post in posts)
                _PostTile(post: post, author: state.nameOf(post.authorUserId)),
              if (floBusy)
                Padding(
                  key: const Key('flo-team-flo-busy'),
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.floTeamFloThinking,
                    style: const TextStyle(color: FloTheme.violet),
                  ),
                ),
            ],
          ),
        ),
        if (_picking)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 6,
              children: [
                for (final m in state.members.where((m) => m.userId != me))
                  FilterChip(
                    key: Key('flo-team-mention-${m.userId}'),
                    label: Text('@${m.displayName}'),
                    selected: _mentions.contains(m.userId),
                    onSelected: (on) => setState(
                      () => on
                          ? _mentions.add(m.userId)
                          : _mentions.remove(m.userId),
                    ),
                  ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
          child: Row(
            children: [
              IconButton(
                key: const Key('flo-team-mention'),
                tooltip: l10n.floTeamMention,
                onPressed: () => setState(() => _picking = !_picking),
                icon: Icon(
                  Icons.alternate_email,
                  color: _mentions.isEmpty ? FloTheme.ink3 : FloTheme.blue,
                ),
              ),
              Expanded(
                child: TextField(
                  key: const Key('flo-team-reply'),
                  controller: _reply,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.floTeamReplyHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                key: const Key('flo-team-send'),
                onPressed: _send,
                child: Text(l10n.floTeamPost),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostTile extends StatelessWidget {
  const _PostTile({required this.post, required this.author});

  final FloTeamPost post;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.isFlo ? 'Flo' : author,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
              color: post.isFlo ? FloTheme.violet : FloTheme.ink2,
            ),
          ),
          const SizedBox(height: 4),
          if (post.isFlo && post.blocks.isNotEmpty)
            FloBlockRenderer(blocks: post.blocks)
          else
            Text(post.body, style: const TextStyle(color: FloTheme.ink1)),
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
    return AlertDialog(
      title: Text(l10n.floTeamTask),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<FloTeamStatus>(
            key: const Key('flo-team-task-status'),
            initialValue:
                statuses.containsKey(_status) ? _status : FloTeamStatus.idea,
            decoration: InputDecoration(labelText: l10n.floTeamStatus),
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
            decoration: InputDecoration(labelText: l10n.floTeamAssignee),
            items: [
              DropdownMenuItem<String?>(
                  value: null, child: Text(l10n.floTeamNobody)),
              for (final m in members)
                DropdownMenuItem<String?>(
                    value: m.userId, child: Text(m.displayName)),
            ],
            onChanged: (u) => setState(() => _assignee = u),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l10n.floTeamDue}: ${_due == null ? l10n.floTeamNoDate : _date(_due!)}',
                ),
              ),
              IconButton(
                key: const Key('flo-team-task-due'),
                onPressed: _pickDue,
                icon: const Icon(Icons.event),
              ),
              if (_due != null)
                IconButton(
                  key: const Key('flo-team-task-due-clear'),
                  onPressed: () => setState(() => _due = null),
                  icon: const Icon(Icons.clear),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('flo-team-task-save'),
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
    final members = ref.watch(floTeamControllerProvider).members;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            IconButton(
              key: const Key('flo-team-back'),
              tooltip: l10n.back,
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back),
            ),
            Text(
              l10n.floTeamMembers,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        for (final m in members)
          ListTile(
            title: Text(m.displayName),
            subtitle: m.isOwner ? Text(l10n.floTeamOwner) : null,
            trailing: m.isOwner
                ? null
                : TextButton(
                    key: Key('flo-team-remove-${m.userId}'),
                    onPressed: () => _change(() => _team.remove(m.userId)),
                    child: Text(l10n.remove),
                  ),
          ),
        const Divider(),
        FutureBuilder<List<FloTeamMember>>(
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
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.hasError
                      ? '${snapshot.error}'
                      : l10n.floTeamNoColleagues,
                  style: const TextStyle(color: FloTheme.ink3),
                ),
              );
            }
            return Column(
              children: [
                for (final c in colleagues)
                  ListTile(
                    title: Text(c.displayName),
                    trailing: FilledButton.tonal(
                      key: Key('flo-team-invite-${c.userId}'),
                      onPressed: () => _change(() => _team.invite(c.userId)),
                      child: Text(l10n.invite),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
