part of 'flo_team_view.dart';

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
