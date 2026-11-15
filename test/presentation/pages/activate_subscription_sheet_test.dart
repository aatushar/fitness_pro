import 'package:fitness_pro/core/theme/app_colors.dart';
import 'package:fitness_pro/core/theme/app_palette.dart';
import 'package:fitness_pro/domain/entities/member_subscription_entity.dart';
import 'package:fitness_pro/domain/entities/subscription_entity.dart';
import 'package:fitness_pro/domain/usecases/activate_subscription_usecase.dart';
import 'package:fitness_pro/domain/usecases/get_member_subscriptions_usecase.dart';
import 'package:fitness_pro/presentation/blocs/subscription/member_fees_cubit.dart';
import 'package:fitness_pro/presentation/pages/subscriptions/member_subscriptions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';

/// The admin's "receive fee" flow, driven through the real widgets: open the
/// sheet from the member list, fill it in, confirm, and see the repository
/// receive exactly what was typed.

ThemeData _theme(Brightness b) {
  final dark = b == Brightness.dark;
  return ThemeData(
    brightness: b,
    scaffoldBackgroundColor: dark ? AppColors.darkBg : AppColors.lightBg,
    colorScheme: dark
        ? const ColorScheme.dark(
            primary: AppColors.purple, surface: AppColors.darkSurface)
        : const ColorScheme.light(
            primary: AppColors.purple, surface: AppColors.lightSurface),
    extensions: [dark ? AppPalette.dark : AppPalette.light],
  );
}

MemberSubscriptionEntity _member({
  SubscriptionStatus status = SubscriptionStatus.expired,
  DateTime? endDate,
}) =>
    MemberSubscriptionEntity(
      userId: 12,
      username: 'rakib',
      email: 'rakib@gmail.com',
      status: status,
      endDate: endDate ?? DateTime(2026, 11, 10),
      lastAmount: 1500,
    );

Future<FakeSubscriptionRepository> _openSheet(
  WidgetTester tester, {
  required Size size,
  double textScale = 1,
  MemberSubscriptionEntity? member,
  Brightness brightness = Brightness.light,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);

  final repo = FakeSubscriptionRepository()..members = [member ?? _member()];
  await tester.pumpWidget(MaterialApp(
    theme: _theme(brightness),
    home: BlocProvider(
      create: (_) => MemberFeesCubit(
        GetMemberSubscriptionsUseCase(repo),
        ActivateSubscriptionUseCase(repo),
      )..load(),
      child: const MemberSubscriptionsPage(),
    ),
  ));
  await tester.pump(const Duration(milliseconds: 100));

  // "Receive fee & renew" for a member who has paid before, "& activate" otherwise.
  final open = find.textContaining('Receive fee &');
  await tester.ensureVisible(open);
  await tester.pump();
  await tester.tap(open);
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  for (final entry in {
    'small phone': const Size(320, 568),
    'landscape phone': const Size(844, 390),
    'tablet': const Size(820, 1180),
    'desktop': const Size(1440, 900),
  }.entries) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('sheet fits · ${entry.key} · text x$scale', (tester) async {
        await _openSheet(tester, size: entry.value, textScale: scale);

        expect(find.text('Renew subscription'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('sheet is usable in dark mode too', (tester) async {
    await _openSheet(tester,
        size: const Size(390, 844), brightness: Brightness.dark);
    expect(find.text('Confirm & give access'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the amount starts as the member\'s last payment', (tester) async {
    await _openSheet(tester, size: const Size(390, 844));

    expect(find.widgetWithText(TextField, '1500'), findsOneWidget);
  });

  testWidgets('a member who never paid is offered "Activate"', (tester) async {
    await _openSheet(
      tester,
      size: const Size(390, 844),
      member: MemberSubscriptionEntity(
        userId: 13,
        username: 'new_member',
        email: 'new@gmail.com',
        status: SubscriptionStatus.none,
      ),
    );

    expect(find.text('Activate subscription'), findsOneWidget);
  });

  testWidgets('confirming sends exactly what the admin chose', (tester) async {
    final repo = await _openSheet(tester, size: const Size(390, 844));

    await tester.tap(find.text('3 months'));
    await tester.tap(find.text('bKash'));
    await tester.enterText(find.widgetWithText(TextField, '1500'), '4200');
    await tester.pump();
    await tester.ensureVisible(find.text('Confirm & give access'));
    await tester.pump();
    await tester.tap(find.text('Confirm & give access'));
    await tester.pumpAndSettle();

    expect(repo.lastActivation, {
      'userId': 12,
      'months': 3,
      'testMinutes': null,
      'amount': 4200.0,
      'paymentMethod': 'BKASH',
      'note': null,
    });
    // The sheet closed and the page told the admin it worked.
    expect(find.text('Renew subscription'), findsNothing);
    expect(find.textContaining('rakib can now use the gym until'), findsOneWidget);
  });

  testWidgets('a test plan sends minutes instead of months', (tester) async {
    final repo = await _openSheet(tester, size: const Size(390, 844));

    await tester.ensureVisible(find.text('2 minutes'));
    await tester.pump();
    await tester.tap(find.text('2 minutes'));
    await tester.pump();
    expect(find.textContaining('Test plan: access for 2 minutes'), findsOneWidget);

    await tester.ensureVisible(find.text('Confirm & give access'));
    await tester.pump();
    await tester.tap(find.text('Confirm & give access'));
    await tester.pumpAndSettle();

    expect(repo.lastActivation['testMinutes'], 2);
    expect(repo.lastActivation['months'], isNull);
    expect(find.textContaining('2-minute test plan'), findsOneWidget);
  });

  testWidgets('picking a month again cancels the test plan', (tester) async {
    final repo = await _openSheet(tester, size: const Size(390, 844));

    await tester.ensureVisible(find.text('1 minute'));
    await tester.pump();
    await tester.tap(find.text('1 minute'));
    await tester.pump();
    await tester.tap(find.text('6 months'));
    await tester.pump();
    await tester.ensureVisible(find.text('Confirm & give access'));
    await tester.pump();
    await tester.tap(find.text('Confirm & give access'));
    await tester.pumpAndSettle();

    expect(repo.lastActivation['months'], 6);
    expect(repo.lastActivation['testMinutes'], isNull);
  });

  testWidgets('an empty amount is rejected before anything is sent',
      (tester) async {
    final repo = await _openSheet(tester, size: const Size(390, 844));

    await tester.enterText(find.widgetWithText(TextField, '1500'), '');
    await tester.pump();
    await tester.ensureVisible(find.text('Confirm & give access'));
    await tester.pump();
    await tester.tap(find.text('Confirm & give access'));
    await tester.pump();

    expect(find.text('Enter the amount received.'), findsOneWidget);
    expect(repo.lastActivation, isEmpty);
    expect(find.text('Renew subscription'), findsOneWidget);
  });

  testWidgets('a server refusal is shown inside the sheet, which stays open',
      (tester) async {
    final repo = await _openSheet(tester, size: const Size(390, 844));
    repo.error = StateError('boom');

    await tester.ensureVisible(find.text('Confirm & give access'));
    await tester.pump();
    await tester.tap(find.text('Confirm & give access'));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong. Please try again.'), findsOneWidget);
    expect(find.text('Renew subscription'), findsOneWidget);
  });

  testWidgets('the preview adds the months after the current period',
      (tester) async {
    final endsLater = DateTime.now().add(const Duration(days: 20));
    await _openSheet(
      tester,
      size: const Size(390, 844),
      member: _member(status: SubscriptionStatus.active, endDate: DateTime(
          endsLater.year, endsLater.month, endsLater.day)),
    );

    expect(find.textContaining('(added after the current period)'),
        findsOneWidget);
  });
}
