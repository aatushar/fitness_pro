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
import '../../../core/l10n/app_strings.dart';

/// Admin page: list, add, edit, deactivate and delete gyms.
/// Needs an [AdminGymsCubit].
class AdminGymsPage extends StatelessWidget {
  const AdminGymsPage({super.key});

  Future<void> _edit(BuildContext context, [GymEntity? gym]) async {
    final v = await showFormDialog(
      context,
      title: gym == null ? 'Add gym'.tr(context) : 'Edit gym'.tr(context),
      fields: [
        FormFieldSpec('Gym name'.tr(context), initial: gym?.gymName ?? ''),
        FormFieldSpec('Email'.tr(context),
            initial: gym?.gymEmail ?? '', keyboard: TextInputType.emailAddress),
        FormFieldSpec('City'.tr(context), initial: gym?.city ?? ''),
        FormFieldSpec('Phone'.tr(context),
            initial: gym?.phoneNumber ?? '', keyboard: TextInputType.phone),
      ],
    );
    if (v == null || !context.mounted) return;
    final error = await context.read<AdminGymsCubit>().save(
        gymsId: gym?.gymsId, name: v[0], email: v[1], city: v[2], phone: v[3]);
    if (context.mounted) {
      showMessage(context, error ?? (gym == null ? 'Gym added.'.tr(context) : 'Gym updated.'.tr(context)),
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
        label: Text('Add gym'.tr(context)),
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
                            child: Text('Gyms'.tr(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700,
                                color: palette.textPrimary, letterSpacing: AppStrings.spacing(-0.3),
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
          Text(state.message ?? 'Could not load gyms.'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: palette.textMuted)),
          TextButton(onPressed: cubit.load, child: Text('Try again'.tr(context))),
        ]),
      );
    }
    if (state.gyms.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Text('No gyms yet. Tap "Add gym" to create one.'.tr(context),
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
              tooltip: 'Actions'.tr(context),
              onSelected: (a) async {
                if (a == 'edit') {
                  onEdit(g);
                } else if (a == 'toggle') {
                  await _report(context,
                      cubit.setStatus(g.gymsId, g.isActive ? 'INACTIVE' : 'ACTIVE'),
                      g.isActive ? 'Gym deactivated.'.tr(context) : 'Gym activated.'.tr(context));
                } else if (a == 'delete') {
                  final ok = await confirmAction(context,
                      title: 'Delete gym?'.tr(context),
                      message: AppStrings.t(context, '${g.gymName} will be removed from the gym list.', '${g.gymName} জিমের তালিকা থেকে মুছে যাবে।'));
                  if (ok && context.mounted) {
                    await _report(context, cubit.delete(g.gymsId), 'Gym deleted.'.tr(context));
                  }
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'edit', child: Text('Edit'.tr(context))),
                PopupMenuItem(
                    value: 'toggle',
                    child: Text(g.isActive ? 'Deactivate'.tr(context) : 'Activate'.tr(context))),
                PopupMenuItem(value: 'delete', child: Text('Delete'.tr(context))),
              ],
            ),
          ]),
        ),
    ]);
  }
}
