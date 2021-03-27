import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tawselat/layout/tableByUserId.dart';
import 'package:get/get.dart';
import 'package:tawselat/controllers/authController.dart';
import 'package:tawselat/controllers/orderController.dart';
import 'package:tawselat/controllers/themeController.dart';
import 'package:tawselat/controllers/userController.dart';
import 'package:tawselat/models/order.dart';
import 'package:tawselat/models/user.dart';
import 'package:tawselat/screens/adminScreen/orderInputByAdmin.dart';
import 'package:tawselat/screens/homeAdmin.dart';
import 'package:tawselat/services/fireDb.dart';
// import 'flutter_web2/tutorial/getOrderList.dart';
import 'package:tawselat/screens/OrdersListByUser.dart';
import 'package:tawselat/testing/mainTest.dart';

// ignore: must_be_immutable
class UsersLayout extends StatelessWidget {
  // var userList = FireDb().getUsers();

  final OrderController orderController = Get.put(OrderController());
  // final AuthController _authController = Get.find();
  final ThemeController _themeController = Get.put(ThemeController());

  // final UserModel userModel = Get.put(UserModel());
  getLightIcon() {
    if (_themeController.themeChange) {
      return Icon(Icons.lightbulb);
    } else {
      return Icon(Icons.lightbulb_outline);
    }
  }

  getUserName() {
    // return GetX<UserController>(
    //   init: Get.put(UserController()),
    //   initState: (_) async {
    //     Get.find<UserController>().user =
    //         await FireDb().getUser(uid: Get.find<AuthController>().user.uid);
    //   },
    //   builder: (_userController) {
    //     return Text((_userController.user == null)
    //         ? ""
    //         : _userController.user.name.toString());
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Obx(
              () => IconButton(
                icon: getLightIcon(),
                onPressed: () {
                  if (Get.isDarkMode) {
                    Get.changeTheme(ThemeData.light());
                    _themeController.themeChange = false;
                  } else {
                    Get.changeTheme(ThemeData.dark());
                    _themeController.themeChange = true;
                  }
                },
              ),
            ),
          ],
        ),
        body: Center(
          child: StreamBuilder(
              stream: FireDb().getUserList(role: 'shopOwner'),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Wrap(
                  // direction: Axis.vertical,
                  children: snapshot.data.docs.map((e) {
                    return InkWell(
                      onTap: () {
                        print(e.id.toString());

                        orderController.clientId.value = e.id;
                        // orderController.orderStatus.value = 'جاهز';
                        Get.find<UserController>().currentUser.value =
                            e['name'];

                        Get.to(TableByUserId(
                          tokenEmail: e['email'],
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          // alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.29,
                          height: MediaQuery.of(context).size.height * 0.15,
                          color: Colors.amberAccent,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Container(
                                //   alignment: Alignment.centerRight,
                                //   child: Text(
                                //     '${e['name']}',
                                //     style: TextStyle(fontSize: 20),
                                //   ),
                                // ),
                                // Divider(
                                //   color: Colors.black,
                                // ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${e['shopName']}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }
}
