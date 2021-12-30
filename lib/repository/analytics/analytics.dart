abstract class Analytics {
  static const eventAppBackground = 'app_background';

  void init();

  void onLoggedIn();

  void onSignedUp();

  void trackEvent(String name, {Map<String, Object?>? arguments});
}
