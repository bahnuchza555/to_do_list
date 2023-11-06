import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_test/common/size_config.dart';
import 'package:to_do_test/page/pin_code/pin_code_screen.dart';
import 'package:to_do_test/provider/timeout_provider.dart';
import 'package:to_do_test/service/api_service.dart';

void main() async {
  await ApiService.initDioClient();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TimeoutProvider>(create: (_) => TimeoutProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  void _handleUserInteraction(_) {
    context.read<TimeoutProvider>().reset();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Listener(
      onPointerDown: _handleUserInteraction,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => PinCodeScreen());
        },
      ),
    );
  }
}
