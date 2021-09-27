import 'package:flutter/material.dart';
import 'package:rooya_app/login/sign_in.dart';
import 'package:rooya_app/login/sign_up.dart';

import 'package:sizer/sizer.dart';

class SignInTabsHandle extends StatefulWidget {
  @override
  _SignInTabsHandleState createState() => _SignInTabsHandleState();
}

class _SignInTabsHandleState extends State<SignInTabsHandle> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Colors.green, //change your color here
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset('assets/images/logo.png',
          height: 7.0.h,),
          bottom: TabBar(
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
                border:
                Border(bottom: BorderSide(color: Colors.green, width: 4))),
            indicatorColor: Colors.green,
            indicatorPadding: EdgeInsets.only(top: 2),
            labelColor: Colors.black,
            labelStyle: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SignIn(onSignUp: (){
              _tabController!.animateTo(1);
            },),
            SignUp(),
          ],
        ),
      ),
    );
  }
}
