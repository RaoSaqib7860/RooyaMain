import 'package:flutter/material.dart';
import 'package:rooya_app/Screens/AuthScreens/SignIn/sign_in.dart';
import 'package:rooya_app/Screens/AuthScreens/SignUp/sign_up.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:sizer/sizer.dart';

class SignInTabsHandle extends StatefulWidget {
  @override
  _SignInTabsHandleState createState() => _SignInTabsHandleState();
}

class _SignInTabsHandleState extends State<SignInTabsHandle>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: height * 0.030,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 7.0.h,
              ),
              SizedBox(
                height: height * 0.010,
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    text: 'Login',
                  ),
                  Tab(
                    text: 'Sign Up',
                  )
                ],
                indicator: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.green, width: 3),
                    )),
                indicatorColor: Colors.green,
                indicatorPadding: EdgeInsets.only(top: 2),
                labelColor: Colors.black,
                labelStyle:
                    TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.grey,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SignIn(
                      onSignUp: () {
                        _tabController!.animateTo(1);
                      },
                    ),
                    SignUp(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
