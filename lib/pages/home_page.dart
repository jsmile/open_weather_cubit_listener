import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import '../../cubits/temp_settings/temp_settings_cubit.dart';
import '../../cubits/weather/weather_cubit.dart';
import '../../pages/search_page.dart';

import '../../constants/constants.dart';
import '../../utils/ansi_color.dart';
import '../../widgets/error_dialog.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 사용자가 navigator back 을 하면 null 이 될 수 있으므로 nullable 선언.
  String? city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Weather',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () async {
              // 검색 결과를 받는데 시간이 걸리므로 비동기 처리.
              city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
              debugPrint(info('### city : $city'));

              // 검색 결과가 있으면 날씨 정보를 가져옴.
              if (city != null) {
                context.read<WeatherCubit>().fetchWeather(city!);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          )
        ],
      ),
      body: _showWeather(),
    );
  }

  // 조회결과가 정상이면 날씨 정보를 보여주고,
  // Error 이면 Error Dialog 를 보여줌.
  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      // listener : error 발생여부 관찰
      // builder : 조회결과에 따른 화면 표시
      listener: (context, state) {
        if (state.status == WeatherStatus.failure) {
          errorDialog(context, state.error.errMag);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }

        if (state.status == WeatherStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if ((state.status == WeatherStatus.failure) &&
            (state.weather.name == '')) {
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }

        return ListView(
          children: [
            // MediaQuery.of(context).size.height : 화면 높이
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // TimeOfDay 의 format() 으로 local time 으로 표시
                  TimeOfDay.fromDateTime(state.weather.lastUpdated)
                      .format(context),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 10.0),
                Text(
                  state.weather.country,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showTemperature(state.weather.temp),
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20.0),
                Column(
                  children: [
                    Text(
                      showTemperature(state.weather.tempMax),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      showTemperature(state.weather.tempMin),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                showIcon(state.weather.icon),
                // 적절한 공간 배분을 위해 Expanded( flex: ) 사용
                Expanded(
                  flex: 3,
                  child: formatDescText(state.weather.discription),
                ),
                const Spacer(),
              ],
            )
          ],
        );
      },
    );
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;

    if (tempUnit == TempUnit.fahrenheit) {
      return '${(temperature * 9 / 5 + 32).toStringAsFixed(2)} ℉';
    }

    return '${temperature.toStringAsFixed(2)} ℃';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      // 외부 image 조회 시 image가 조회되는 동안 보여줄 placeholder
      placeholder: 'assets/images/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 96.0,
      height: 96.0,
    );
  }

  Widget formatDescText(String description) {
    // unicase package 사용 : 대문자로 시작하고 나머지는 소문자로 변환
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }
}
