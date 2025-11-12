import 'package:flutter/material.dart';
import 'package:visionscan/I10n/app_localizations.dart';

extension Context on BuildContext {

  AppLocalizations? get localization => AppLocalizations.of(this);
}
