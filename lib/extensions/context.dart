import 'package:flutter/material.dart';
import 'package:visionscan/extensions/app_styles.dart';
import 'package:visionscan/languages/I10n/app_localizations.dart';

extension Context on BuildContext {

  AppLocalizations? get localization => AppLocalizations.of(this);
}
