import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_test/common/size_config.dart';
import 'package:to_do_test/page/pin_code/pincode_controller.dart';
import 'package:to_do_test/provider/sf_provider.dart';
import 'package:to_do_test/provider/timeout_provider.dart';

double defaultSize = SizeConfig.defaultSize ?? 0;

class PinCodeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PinCodeScreen();
}

class _PinCodeScreen extends State<PinCodeScreen> with WidgetsBindingObserver {
  late PinCodeController pinCodeController;
  SFProvider sfProvider = SFProvider();

  @override
  void initState() {
    super.initState();
    pinCodeController = PinCodeController(context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<TimeoutProvider>().stop();
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 237, 253, 1.0),
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: pinCodeController,
          child: Consumer<PinCodeController>(
            builder: (context, con, _) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: defaultSize * 2.4),
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: defaultSize * 10.0),
                  Center(
                    child: Text(
                        'This is just sample UI \n Open to create your style :D',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF757575))),
                  ),
                  SizedBox(height: defaultSize * 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: EdgeInsets.all(defaultSize * 1.6),
                        width: defaultSize * 1.6,
                        height: defaultSize * 1.6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: index < con.enteredPin.length
                                ? Colors.grey.shade700
                                : Colors.grey.withOpacity(0.3)),
                      );
                    }),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(
                      top: defaultSize * 1.6,
                      bottom: defaultSize * 3.2,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: defaultSize * 2.3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              NumpadButton(
                                text: '1',
                                onPressed: () async => await con.setValue('1'),
                              ),
                              NumpadButton(
                                text: '2',
                                onPressed: () async => await con.setValue('2'),
                              ),
                              NumpadButton(
                                text: '3',
                                onPressed: () async => await con.setValue('3'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: defaultSize * 1.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              NumpadButton(
                                text: '4',
                                onPressed: () async => await con.setValue('4'),
                              ),
                              NumpadButton(
                                text: '5',
                                onPressed: () async => await con.setValue('5'),
                              ),
                              NumpadButton(
                                text: '6',
                                onPressed: () async => await con.setValue('6'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: defaultSize * 1.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              NumpadButton(
                                text: '7',
                                onPressed: () async => await con.setValue('7'),
                              ),
                              NumpadButton(
                                text: '8',
                                onPressed: () async => await con.setValue('8'),
                              ),
                              NumpadButton(
                                text: '9',
                                onPressed: () async => await con.setValue('9'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: defaultSize * 1.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: defaultSize * 7.0,
                                width: defaultSize * 7.0,
                              ),
                              NumpadButton(
                                text: '0',
                                onPressed: () async => await con.setValue('0'),
                              ),
                              NumpadButton(
                                onPressed: () async => await con.deleteValue(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

class NumpadButton extends StatelessWidget {
  final String? text;
  final bool showButton;
  final Function()? onPressed;

  const NumpadButton(
      {Key? key, this.text, this.showButton = true, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return text != null
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.3),
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.6),
                shape: CircleBorder(),
                fixedSize: Size(defaultSize * 7.0, defaultSize * 7.0)),
            child: Text(
              text ?? '',
              style: TextStyle(
                fontSize: defaultSize * 3.2,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: onPressed)
        : Container(
            padding: EdgeInsets.symmetric(vertical: defaultSize * 1),
            height: defaultSize * 7.0,
            width: defaultSize * 7.0,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: defaultSize * 2.4,
                ),
                onPressed: onPressed),
          );
  }
}
