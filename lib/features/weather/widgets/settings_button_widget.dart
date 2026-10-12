import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/extensions/unified_extensions.dart';

import 'settings_sheet_widget.dart';

/// AppBar action that opens the settings sheet.
class SettingsButtonWidget extends StatelessWidget {
  const SettingsButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings_outlined),
      onPressed: () => showAppSheet<void>(
        const SettingsSheetWidget(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSize.s20.r),
          ),
        ),
      ),
    );
  }
}
