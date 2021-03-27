import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tawselat/controllers/authController.dart';
import 'package:tawselat/controllers/orderController.dart';
import 'package:tawselat/controllers/themeController.dart';
import 'package:tawselat/controllers/userController.dart';
import 'package:tawselat/models/user.dart';
import 'package:tawselat/screens/adminScreen/sortOrdersByDate.dart';
import 'package:tawselat/services/fireDb.dart';
import 'package:tawselat/screens/OrdersListByUser.dart';

// ignore: must_be_immutable
/*class OrdersList extends StatelessWidget {
  // var userList = FireDb().getUsers();

  final OrderController orderController = Get.put(OrderController());
  final AuthController _authController = Get.find();
  final ThemeController _themeController = Get.put(ThemeController());

  final UserModel userModel = Get.put(UserModel());
  getLightIcon() {
    if (_themeController.themeChange) {
      return Icon(Icons.lightbulb);
    } else {
      return Icon(Icons.lightbulb_outline);
    }
  }

  getUserName() {
    return GetX<UserController>(
      init: Get.put(UserController()),
      initState: (_) async {
        Get.find<UserController>().user =
            await FireDb().getUser(uid: Get.find<AuthController>().user.uid);
      },
      builder: (_userController) {
        return Text((_userController.user == null)
            ? ""
            : _userController.user.name.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _authController.logOut();
            },
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder(
            stream: FireDb().getOrdersList(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return Wrap(
                children: snapshot.data.docs.map((e) {
                  return InkWell(
                    onTap: () {
                      // orderController.userId = 'ePVan9xf2YNpIiPPWkGgdF3wwf62';

                      //  print(userModel.name);
                      // e['isAdmin']
                      //     ? Get.to(HomeAdmin(
                      //         userId: e.id,
                      //       ))
                      //     : Get.to(OrdersListByUser(
                      //         userId: e.id,
                      //       ));
                      Get.to(SortOrdersByDate(
                          //userId: e.id,
                          ));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        // alignment: Alignment.center,
                        height: 140,
                        color: Colors.blueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${e['deliveryToCity']}',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${e['orderNumber']}',
                                  style: TextStyle(fontSize: 25),
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
    );
  }
}*/
