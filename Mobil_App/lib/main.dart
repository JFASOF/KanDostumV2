import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kandostum2/app/modules/campaigns/controllers/campaign_location_controller.dart';
import 'package:kandostum2/app/modules/faq/controllers/faq_controller.dart';
import 'package:kandostum2/app/modules/locations/controllers/location_controller.dart';
import 'package:kandostum2/app/modules/login/controllers/account_controller.dart';
import 'package:kandostum2/app/modules/login/pages/splash_page.dart';
import 'package:kandostum2/app/shared/helpers/intro_splash.dart';
import 'package:provider/provider.dart';
import 'app/modules/campaigns/controllers/campaign_person_controller.dart';
import 'app/modules/profile/controllers/profile_controller.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'app/modules/profile/controllers/settings_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
      providers: [
        Provider<AccountController>.value(value: AccountController()),
        Provider<ProfileController>.value(value: ProfileController()),
        Provider<CampaignPersonController>.value(
            value: CampaignPersonController()),
        Provider<CampaignLocationController>.value(
            value: CampaignLocationController()),
        Provider<LocationController>.value(value: LocationController()),
        Provider<FaqController>.value(value: FaqController()),
        Provider<SettingsController>.value(value: SettingsController()),
      ],
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.redAccent,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kan Dostum',
            theme: theme,
            home: SplashPage(),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: [const Locale('tr', 'TR')],
          );
        },
      ),
    );
  }
}
