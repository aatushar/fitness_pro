import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/format/formatters.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/member_subscription_entity.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../domain/entities/subscription_summary_entity.dart';
import '../../blocs/subscription/member_fees_cubit.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/subscription/subscription_status_chip.dart';
import 'activate_subscription_sheet.dart';

/// Admin page: every member with their subscription status, and the button
/// that records a received fee and gives the member access.
/// Needs a [MemberFeesCubit].
class MemberSubscriptionsPage extends StatelessWidget {
  const MemberSubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MemberFeesCubit, MemberFeesState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<MemberFeesCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  ResponsiveCenter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const AppBackButton(),
                            Expanded(
                              child: Text('Member Fees',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700,
                                  color: palette.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 38),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _Content(state: state),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final MemberFeesState state;
  const _Content({required this.state});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (state.status == MemberFeesStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == MemberFeesStatus.failure && state.members.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.cloud_off_rounded, size: 44, color: palette.textMuted),
            const SizedBox(height: 12),
            Text(state.message ?? 'Could not load members.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: palette.textMuted),
            ),
            TextButton(
              onPressed: () => context.read<MemberFeesCubit>().load(),
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    final visible = state.visibleMembers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.summary != null) _SummaryCard(summary: state.summary!),
        const SizedBox(height: 16),
        const _SearchField(),
        const SizedBox(height: 12),
        _FilterChips(state: state),
        const SizedBox(height: 16),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                state.members.isEmpty
                    ? 'No members in your gym yet.'
                    : 'No members match.',
                style: TextStyle(fontSize: 14, color: palette.textMuted),
              ),
            ),
          )
        else
          for (final m in visible) _MemberTile(member: m),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final SubscriptionSummaryEntity summary;
  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return GradientHeroCard(
      child: HeroFigure(
        caption: 'FEES COLLECTED THIS MONTH',
        value: formatTaka(summary.collectedThisMonth),
        note: '${summary.totalMembers} members',
        badge: '${summary.active} active · ${summary.expiringSoon} ending soon · '
            '${summary.expired} expired · ${summary.notSubscribed} no plan',
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    OutlineInputBorder outline(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c),
        );

    return TextField(
      onChanged: context.read<MemberFeesCubit>().setSearch,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search name, email or phone',
        hintStyle: TextStyle(fontSize: 13, color: palette.textMuted),
        prefixIcon: Icon(Icons.search_rounded, color: palette.textMuted),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: outline(palette.border),
        enabledBorder: outline(palette.border),
        focusedBorder: outline(AppColors.purple),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final MemberFeesState state;
  const _FilterChips({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = state.summary;
    final options = <(String, SubscriptionStatus?)>[
      ('All', null),
      ('Expired${s == null ? '' : ' (${s.expired})'}', SubscriptionStatus.expired),
      ('Ending soon${s == null ? '' : ' (${s.expiringSoon})'}', SubscriptionStatus.expiringSoon),
      ('Active${s == null ? '' : ' (${s.active})'}', SubscriptionStatus.active),
      ('No plan${s == null ? '' : ' (${s.notSubscribed})'}', SubscriptionStatus.none),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (label, status) in options)
          ChoiceChip(
            label: Text(label),
            selected: state.filter == status,
            selectedColor: AppColors.purple,
            labelStyle: TextStyle(
              fontSize: 12,
              color: state.filter == status
                  ? Colors.white
                  : context.palette.textPrimary,
            ),
            onSelected: (_) => context.read<MemberFeesCubit>().setFilter(status),
          ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  final MemberSubscriptionEntity member;
  const _MemberTile({required this.member});

  String get _subtitle {
    final end = member.endDate;
    if (end == null) return 'No subscription yet';
    return switch (member.status) {
      SubscriptionStatus.expired => 'Expired on ${formatDate(end)}',
      _ => '${member.daysLeft} ${member.daysLeft == 1 ? 'day' : 'days'} left · '
          'until ${formatDate(end)}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final renew = member.status != SubscriptionStatus.none;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InitialsAvatar(
                  initials: member.username.isEmpty
                      ? '?'
                      : member.username.substring(0, 1).toUpperCase(),
                  color: AppColors.purple,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.username,
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(_subtitle,
                        style: TextStyle(fontSize: 11, color: palette.textMuted),
                      ),
                      if (member.phone != null && member.phone!.isNotEmpty)
                        Text(member.phone!,
                          style: TextStyle(fontSize: 11, color: palette.textMuted),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(child: SubscriptionStatusChip(status: member.status)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => showActivateSubscriptionSheet(context, member),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  renew ? Icons.autorenew_rounded : Icons.verified_outlined,
                  size: 18,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(renew ? 'Receive fee & renew' : 'Receive fee & activate'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
