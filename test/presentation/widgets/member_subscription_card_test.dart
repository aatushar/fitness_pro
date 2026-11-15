import 'package:fitness_pro/core/theme/app_colors.dart';
import 'package:fitness_pro/core/theme/app_palette.dart';
import 'package:fitness_pro/domain/entities/subscription_entity.dart';
import 'package:fitness_pro/domain/usecases/get_my_subscription_usecase.dart';
import 'package:fitness_pro/presentation/blocs/subscription/my_subscription_cubit.dart';
import 'package:fitness_pro/presentation/widgets/subscription/member_subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';

Future<FakeSubscriptionRepository> _pump(
  WidgetTester tester,
  SubscriptionEntity subscription,
) async {
  final repo = FakeSubscriptionRepository()..mine = subscription;
  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(
      colorScheme: const ColorScheme.light(primary: AppColors.purple),
      extensions: const [AppPalette.light],
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (_) => MySubscriptionCubit(
            GetMySubscriptionUseCase(repo),
            FakeReminderScheduler(),
          )..load(),
          child: const MemberSubscriptionCard(),
        ),
      ),
    ),
  ));
  await tester.pump();
  return repo;
}

void main() {
  testWidgets('a running test plan counts down in minutes and seconds',
      (tester) async {
    await _pump(
      tester,
      SubscriptionEntity(
        status: SubscriptionStatus.active,
        expiresAt: DateTime.now().add(const Duration(seconds: 90)),
        planMinutes: 2,
        totalDays: 1,
      ),
    );

    expect(find.text('2 minutes test plan'), findsOneWidget);
    // Big m:ss figure followed by "min left", e.g. "1:30 min left".
    final countdown = tester
        .widget<Text>(find.textContaining('min left'))
        .textSpan!
        .toPlainText();
    expect(RegExp(r'\d+:\d{2} min left').hasMatch(countdown), isTrue,
        reason: 'was "$countdown"');

    // Remove the card so its timer is cancelled.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('an expired test plan shows the pay-your-fee message',
      (tester) async {
    await _pump(
      tester,
      SubscriptionEntity(
        status: SubscriptionStatus.expired,
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        planMinutes: 1,
      ),
    );

    expect(find.text('Subscription expired'), findsOneWidget);
    expect(
      find.textContaining('Please pay your Gym subscription fee'),
      findsOneWidget,
    );
    expect(find.textContaining('min left'), findsNothing);
  });

  testWidgets('when a test plan runs out the card asks the server again',
      (tester) async {
    final repo = await _pump(
      tester,
      SubscriptionEntity(
        status: SubscriptionStatus.expiringSoon,
        expiresAt: DateTime.now().add(const Duration(milliseconds: 600)),
        planMinutes: 1,
        totalDays: 1,
      ),
    );
    // The server now says it has expired.
    repo.mine = SubscriptionEntity(
      status: SubscriptionStatus.expired,
      expiresAt: DateTime.now(),
      planMinutes: 1,
    );

    // DateTime.now() is the real clock, so let real time pass, then let the
    // card's one-second timer notice it.
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 900)));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Subscription expired'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a monthly plan shows days left', (tester) async {
    await _pump(
      tester,
      SubscriptionEntity(
        status: SubscriptionStatus.active,
        startDate: DateTime(2026, 11, 11),
        endDate: DateTime(2026, 12, 11),
        daysLeft: 30,
        totalDays: 30,
        planMonths: 1,
      ),
    );

    expect(find.text('1 Month plan'), findsOneWidget);
    expect(find.textContaining('days left'), findsOneWidget);
  });
}
