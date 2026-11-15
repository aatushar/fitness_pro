import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/gym_entity.dart';
import '../../blocs/admin/admin_gyms_cubit.dart';
import '../../blocs/admin/admin_users_cubit.dart' show LoadStatus;
import '../../widgets/app_back_button.dart';
import '../../widgets/dashboard/dashboard_cards.dart';
import '../../widgets/form_dialog.dart';

/// Admin page: list, add, edit, deactivate and delete gyms.
/// Needs an [AdminGymsCubit].
class AdminGymsPage extends StatelessWidget {
  const AdminGymsPage({super.key});

  Future<void> _edit(BuildContext context, [GymEntity? gym]) async {
    final v = await showFormDialog(
      context,
      title: gym == null ? 'Add gym' : 'Edit gym',
      fields: [
        FormFieldSpec('Gym name', initial: gym?.gymName ?? ''),
        FormFieldSpec('Email',
            initial: gym?.gymEmail ?? '', keyboard: TextInputType.emailAddress),
        FormFieldSpec('City', initial: gym?.city ?? ''),
        FormFieldSpec('Phone',
            initial: gym?.phoneNumber ?? '', keyboard: TextInputType.phone),
      ],
    );
    if (v == null || !context.mounted) return;
    final error = await context.read<AdminGymsCubit>().save(
        gymsId: gym?.gymsId, name: v[0], email: v[1], city: v[2], phone: v[3]);
    if (context.mounted) {
      showMessage(context, error ?? (gym == null ? 'Gym added.' : 'Gym updated.'),
          error: error != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context),
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add gym'),
      ),
      body: SafeArea(
        child: BlocBuilder<AdminGymsCubit, AdminGymsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<AdminGymsCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                children: [
                  ResponsiveCenter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const AppBackButton(),
                          Expanded(
                            child: Text('Gyms',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700,
                                color: palette.textPrimary, letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 38),
                        ]),
                        const SizedBox(height: 16),
                        _Body(state: state, onEdit: (g) => _edit(context, g)),
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

class _Body extends StatelessWidget {
  final AdminGymsState state;
  final void Function(GymEntity) onEdit;
  const _Body({required this.state, required this.onEdit});

  Future<void> _report(BuildContext context, Future<String?> result, String ok) async {
    final error = await result;
    if (context.mounted) showMessage(context, error ?? ok, error: error != null);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final cubit = context.read<AdminGymsCubit>();

    if (state.status == LoadStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == LoadStatus.failure && state.gyms.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(children: [
          Icon(Icons.cloud_off_rounded, size: 44, color: palette.textMuted),
          const SizedBox(height: 12),
          Text(state.message ?? 'Could not load gyms.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: palette.textMuted)),
          TextButton(onPressed: cubit.load, child: const Text('Try again')),
        ]),
      );
    }
    if (state.gyms.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Text('No gyms yet. Tap "Add gym" to create one.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: palette.textMuted)),
        ),
      );
    }

    return Column(children: [
      for (final g in state.gyms)
        DashboardListTile(
          leading: const IconBadge(
              icon: Icons.fitness_center_rounded, color: AppColors.purple),
          title: g.gymName,
          subtitle: [
            if (g.city != null) g.city!,
            if (g.phoneNumber != null) g.phoneNumber!,
            if (g.gymEmail != null) g.gymEmail!,
          ].join(' · '),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Flexible(child: StatusChip(
              label: g.status[0] + g.status.substring(1).toLowerCase(),
              tone: g.isActive ? ChipTone.success : ChipTone.danger,
            )),
            PopupMenuButton<String>(
              tooltip: 'Actions',
              onSelected: (a) async {
                if (a == 'edit') {
                  onEdit(g);
                } else if (a == 'toggle') {
                  await _report(context,
                      cubit.setStatus(g.gymsId, g.isActive ? 'INACTIVE' : 'ACTIVE'),
                      g.isActive ? 'Gym deactivated.' : 'Gym activated.');
                } else if (a == 'delete') {
                  final ok = await confirmAction(context,
                      title: 'Delete gym?',
                      message: '${g.gymName} will be removed from the gym list.');
                  if (ok && context.mounted) {
                    await _report(context, cubit.delete(g.gymsId), 'Gym deleted.');
                  }
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(
                    value: 'toggle',
                    child: Text(g.isActive ? 'Deactivate' : 'Activate')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ]),
        ),
    ]);
  }
}
