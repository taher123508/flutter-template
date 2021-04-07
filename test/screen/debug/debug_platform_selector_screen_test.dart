import 'package:flutter/widgets.dart';
import 'package:flutter_template/screen/debug/debug_platform_selector_screen.dart';
import 'package:flutter_template/util/keys.dart';
import 'package:flutter_template/util/locale/localization_keys.dart';
import 'package:flutter_template/viewmodel/debug/debug_platform_selector_viewmodel.dart';
import 'package:flutter_template/viewmodel/global/global_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../di/injectable_test.mocks.dart';
import '../../di/test_injectable.dart';
import '../../util/test_extensions.dart';
import '../../util/test_util.dart';
import '../seed.dart';

void main() {
  late MockGlobalViewModel globalViewModel;
  late MockDebugPlatformSelectorViewModel platformViewmodel;

  setUp(() async {
    await initTestInjectable();
    // ignore: avoid_as
    platformViewmodel = GetIt.I<DebugPlatformSelectorViewModel>() as MockDebugPlatformSelectorViewModel;
    // ignore: avoid_as
    globalViewModel = GetIt.I<GlobalViewModel>() as MockGlobalViewModel;
  });

  testWidgets('Test debug select platform screen initial state', (tester) async {
    seedGlobalViewModel();

    const sut = DebugPlatformSelectorScreen();
    final testWidget = await TestUtil.loadScreen(tester, sut);
    await TestUtil.takeScreenshotForAllSizes(tester, testWidget, 'debug_platform_selector_screen_inital_state');
    verifyDebugPlatformViewModel();
    verifyGlobalViewModel();
  });

  testWidgets('Test debug screen select platform and select correct platform', (tester) async {
    seedGlobalViewModel();
    when(globalViewModel.targetPlatform).thenReturn(TargetPlatform.android);

    const sut = DebugPlatformSelectorScreen();
    final testWidget = await TestUtil.loadScreen(tester, sut);
    await TestUtil.takeScreenshotForAllSizes(tester, testWidget, 'debug_platform_selector_screen_selected_android');

    when(globalViewModel.targetPlatform).thenReturn(TargetPlatform.iOS);
    globalViewModel.notifyListeners();
    await tester.pumpAndSettle();
    await TestUtil.takeScreenshotForAllSizes(tester, testWidget, 'debug_platform_selector_screen_selected_ios');

    when(globalViewModel.targetPlatform).thenReturn(null);
    globalViewModel.notifyListeners();
    await tester.pumpAndSettle();
    await TestUtil.takeScreenshotForAllSizes(tester, testWidget, 'debug_platform_selector_screen_selected_system');
  });

  group('setCorrectPlatform', () {
    testWidgets('Test debug screen select platform click on system', (tester) async {
      seedGlobalViewModel();
      when(globalViewModel.targetPlatform).thenReturn(null);

      const sut = DebugPlatformSelectorScreen();
      await TestUtil.loadScreen(tester, sut);
      reset(platformViewmodel);

      final target = find.text(LocalizationKeys.generalLabelSystemDefault);
      expect(target, findsOneWidget);
      await tester.tap(target);
      await tester.pumpAndSettle();

      verify(globalViewModel.setSelectedPlatformToDefault()).calledOnce();
      verifyZeroInteractions(platformViewmodel);
      verifyGlobalViewModel();
    });

    testWidgets('Test debug select platform screen select ios', (tester) async {
      seedGlobalViewModel();
      when(globalViewModel.targetPlatform).thenReturn(TargetPlatform.iOS);

      const sut = DebugPlatformSelectorScreen();
      await TestUtil.loadScreen(tester, sut);
      reset(platformViewmodel);

      final target = find.text(LocalizationKeys.generalLabelIos);
      expect(target, findsOneWidget);
      await tester.tap(target);
      await tester.pumpAndSettle();

      verify(globalViewModel.setSelectedPlatformToIOS()).calledOnce();
      verifyZeroInteractions(platformViewmodel);
      verifyGlobalViewModel();
    });

    testWidgets('Test debug select platform  screen select android', (tester) async {
      seedGlobalViewModel();
      when(globalViewModel.targetPlatform).thenReturn(null);

      const sut = DebugPlatformSelectorScreen();
      await TestUtil.loadScreen(tester, sut);
      reset(platformViewmodel);

      final target = find.text(LocalizationKeys.generalLabelAndroid);
      expect(target, findsOneWidget);
      await tester.tap(target);
      await tester.pumpAndSettle();

      verify(globalViewModel.setSelectedPlatformToAndroid()).calledOnce();
      verifyZeroInteractions(platformViewmodel);
      verifyGlobalViewModel();
    });
  });

  group('Actions', () {
    testWidgets('Test debug select platform  screen on back clicked', (tester) async {
      seedGlobalViewModel();
      when(globalViewModel.targetPlatform).thenReturn(null);

      const sut = DebugPlatformSelectorScreen();
      await TestUtil.loadScreen(tester, sut);
      reset(platformViewmodel);

      final target = find.byKey(Keys.backButton);
      expect(target, findsOneWidget);
      await tester.tap(target);
      await tester.pumpAndSettle();

      verify(platformViewmodel.onBackClicked()).calledOnce();
      verifyNoMoreInteractions(platformViewmodel);
      verifyGlobalViewModel();
    });
  });
}

void verifyDebugPlatformViewModel() {
  // ignore: avoid_as
  final platformSelectorViewModel = GetIt.I<DebugPlatformSelectorViewModel>() as MockDebugPlatformSelectorViewModel;
  verify(platformSelectorViewModel.init(any)).calledOnce();
  verifyNoMoreInteractions(platformSelectorViewModel);
}
