import 'package:flutter/material.dart';
import 'package:to_do_test/common/size_config.dart';
import 'package:to_do_test/page/pin_code/pin_code_screen.dart';
import 'package:to_do_test/service/api_service.dart';

void main() async {
  await ApiService.initDioClient();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => PinCodeScreen());
      },
    );
  }
}
