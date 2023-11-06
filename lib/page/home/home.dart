import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_test/common/lazy_load.dart';
import 'package:to_do_test/common/size_config.dart';
import 'package:to_do_test/page/home/home_controller.dart';
import 'package:to_do_test/page/pin_code/pin_code_screen.dart';
import 'package:to_do_test/provider/sf_provider.dart';
import 'package:to_do_test/provider/timeout_provider.dart';

double defaultSize = SizeConfig.defaultSize ?? 0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  late HomeController homeController;
  String status = 'TODO';
  SFProvider sfProvider = SFProvider();
  late TimeoutProvider _timeoutProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    homeController = HomeController(context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _timeoutProvider = context.read<TimeoutProvider>();
      _timeoutProvider.addTimeoutListener(_handleTimeout);
      _timeoutProvider.start();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print('resumed');
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.paused:
        print('paused');
        break;
      case AppLifecycleState.detached:
        print('detached');
        break;
    }
  }

  void dispose() {
    super.dispose();
    _tabController.dispose();
    homeController.scrollController.dispose();
  }

  void _handleTimeout() async {
    log('timeout: ${DateTime.now().toIso8601String()} }');
    sfProvider.removeFromSF(SFProvider.sfPinCodeKey);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PinCodeScreen()),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider.value(
      value: homeController,
      child: Consumer<HomeController>(builder: (context, con, _) {
        return Column(
          children: [
            header(con),
            _bodyList(con),
            SizedBox(height: defaultSize * 2.5),
          ],
        );
      }),
    ));
  }

  Widget header(HomeController con) {
    return Container(
      height: defaultSize * 33.0,
      child: Stack(
        children: [
          Container(
            height: defaultSize * 28.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromRGBO(235, 237, 253, 1.0),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(48),
                    bottomRight: Radius.circular(48)),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 10),
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50.0, right: 16.0),
                height: defaultSize * 4.0,
                width: defaultSize * 4.0,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
              )
            ],
          ),
          Positioned(
            left: defaultSize * 4.0,
            top: defaultSize * 10.0,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HI! User',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36.0,
                      color: Color(0xFF757575)),
                ),
                SizedBox(height: 8.0),
                Text(
                  'This is just a sample UI. \nOpen to create your style :D',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF757575)),
                )
              ],
            ),
          ),
          Positioned(
            left: defaultSize * 4.8,
            right: defaultSize * 4.8,
            top: defaultSize * 26.0,
            child: PreferredSize(
              preferredSize: Size.fromHeight(200.0),
              child: Container(
                height: defaultSize * 5.0,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: _tabbarToDo(con),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _tabbarToDo(HomeController con) {
    return TabBar(
      controller: _tabController,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      onTap: (index) async {
        if (index == 0) {
          setState(() {
            status = 'TODO';
          });
          con.loadData("TODO", isReset: true, limit: 20);
        } else if (index == 1) {
          setState(() {
            status = 'DOING';
          });
          con.loadData("DOING", isReset: true, limit: 20);
        } else {
          setState(() {
            status = 'DONE';
          });
          con.loadData("DONE", isReset: true, limit: 20);
        }
      },
      labelColor: Colors.white,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(153, 204, 255, 1),
              Color.fromRGBO(153, 153, 255, 1)
            ]),
      ),
      unselectedLabelColor: Colors.grey,
      tabs: <Widget>[
        Tab(child: Text('To-Do')),
        Tab(
          child: Text('Doing'),
        ),
        Tab(child: Text('Done'))
      ],
    );
  }

  // Widget _sectionList(HomeController con) {
  //   return Expanded(child: ListView);
  // }

  Widget _bodyList(HomeController con) {
    return LazyLoad(
      onBottom: () async {
        setState(() {
          con.isLoadMore = true;
        });
        await Future.delayed(const Duration(seconds: 2));
        await con.loadData(status, limit: 10);
        setState(() {
          con.isLoadMore = false;
        });
      },
      child: Expanded(
          child: ListView.builder(
              controller: con.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: con.tasks.length,
              itemBuilder: (context, index) {
                var task = con.tasks[index];
                return Dismissible(
                  key: Key('${task.id}'),
                  onDismissed: (e) {
                    con.onDelete(index);
                  },
                  background: Container(
                    color: Colors.red,
                    child: Column(
                      children: [
                        Icon(Icons.delete_forever,
                            color: Colors.white, size: 30.0),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 5.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${task.title}'),
                                  Text('${task.description}'),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.more_vert,
                              size: defaultSize * 1.5,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ],
                        ),
                        if (index == con.tasks.length - 1)
                          Visibility(
                              visible: con.isLoadMore,
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ))
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
