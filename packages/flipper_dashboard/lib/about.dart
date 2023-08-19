import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../app_data.dart';
import '../utils/link_text_span.dart';

// An about icon button used on the example's app app bar.
class AboutIconButton extends StatelessWidget {
  const AboutIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info),
      onPressed: () {
        showAppAboutDialog(context);
      },
    );
  }
}

// This [showAppAboutDialog] function is based on the [AboutDialog] example
// that exist(ed) in the Flutter Gallery App.
void showAppAboutDialog(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  final TextStyle aboutTextStyle = themeData.textTheme.bodyLarge!;
  final TextStyle footerStyle = themeData.textTheme.bodySmall!;
  final TextStyle linkStyle =
      themeData.textTheme.bodyLarge!.copyWith(color: themeData.primaryColor);

  showAboutDialog(
    context: context,
    applicationName: AppData.appName,
    applicationVersion: AppData.version,
    applicationIcon: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlexThemeModeOptionButton(
          selected: true,
          width: 30,
          height: 30,
          flexSchemeColor: FlexSchemeColor(
            primary: themeData.colorScheme.primary,
            primaryVariant: themeData.colorScheme.outlineVariant,
            secondary: themeData.colorScheme.secondary,
            secondaryVariant: themeData.colorScheme.outlineVariant,
          ),
        ),
      ],
    ),
    applicationLegalese:
        '${AppData.copyright}\n${AppData.author}\n${AppData.license}',
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 24),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                style: aboutTextStyle,
                text:
                    'Flipper is business software for managing and organizing business. '
                    '${AppData.appName} also help business in engaging with customer in a more professional way. ',
              ),
              LinkTextSpan(
                style: linkStyle,
                url: AppData.packageUrl,
                text: 'yegobox.\n\n',
              ),
              TextSpan(
                style: footerStyle,
                text: 'Built by Yegobox LTD ${AppData.version}',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
