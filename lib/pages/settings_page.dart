import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/temp_settings/temp_settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          // leading: const FlutterLogo(),  // leading 은 title 앞에 배치됨.
          title: const Text('Temperature Unit'),
          subtitle: const Text('defalut: Celcius'),
          trailing: Switch(
            value: context.watch<TempSettingsCubit>().state.tempUnit ==
                TempUnit.celcius,
            // parm 을 사용하지 않을 것이므로 _ 로 표시.
            onChanged: (_) {
              context.read<TempSettingsCubit>().toggelTempUnit();
            },
          ),
        ),
      ),
    );
  }
}
