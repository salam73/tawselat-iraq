import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tawselat/controllers/authController.dart';
import 'package:tawselat/controllers/userController.dart';
import 'package:get/get.dart';
import 'package:tawselat/controllers/orderController.dart';
import 'package:tawselat/models/order.dart';
import 'package:tawselat/screens/adminScreen/orderDetailByAdmin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:tawselat/services/fireDb.dart';
import 'package:tawselat/testing/cloudMessigeHttp.dart';

// ignore: must_be_immutable
class TableByProvinceId extends StatelessWidget {
  var orderStatusOBX = ''.obs;
  var headerStatusOBX = ''.obs;
  var orderTitleStatusOBX = ''.obs;
  var _valueOBX = 0.obs;
  var currentStatus = 0.obs;

  var fireDb = FireDb();

  var _listOption = [
    'جاهز',
    'تم الإستلام',
    'واصل',
    'راجع',
    'مؤجل',
    'قيد التوصيل',
    'تم الدفع'
  ];

  OrderModel orderModel = OrderModel();
  OrderController orderController = Get.put(OrderController());
  var statusTitleController = TextEditingController();
  var deliveryCostController = TextEditingController();

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserController _userController = Get.find();

  void updateLayout({String status}) {
    orderController.streamOrdersByProvinceAndStatus(
        status: status ?? _listOption[currentStatus.value],
        deliveryToCity: orderController.deliveryToCity.value);
    orderController.orderStatusByProvince.value =
        _listOption[currentStatus.value];
    print('provinceName: ${orderController.deliveryToCity.value}');
  }

  List<String> tokenList;

  void _onPressed({String clientEmail}) {
    print('user email ' + clientEmail);

    _firebaseFirestore
        .collection("cloudmessages")
        .where('userEmail', isEqualTo: clientEmail)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        tokenList.add(result.data()['token']);
        print('my tokens is' + result.data()['token']);
      });
    }).then((value) => CloudMessigeHttp().sendAndRetrieveMessage(
            title: orderModel.status,
            orderNr: orderModel.orderNumber,
            token: tokenList));

    tokenList = [];
  }

  @override
  Widget build(BuildContext context) {
    updateLayout(status: 'جاهز');
    //_onPressed();
    // _showMaterialDialog() {
    //   showDialog(
    //       context: context,
    //       builder: (_) => new AlertDialog(
    //             title: new Text("Material Dialog"),
    //             content: new Text("Hey! I'm Coflutter!"),
    //             actions: <Widget>[
    //               FlatButton(
    //                 child: Text('Close me!'),
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                 },
    //               )
    //             ],
    //           ));
    // }

    //print('orderController orderStatus:' + orderController.orderStatus.value);
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(orderController.deliveryToCity.value,
              style: GoogleFonts.cairo()),
        ),
        body: Center(
            /**/
            child: Column(
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      orderController.orderStatusByProvince.toString(),
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    orderController.allOrdersProvince.length.toString(),
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            //Obx(() => Text(orderController.allOrdersProvince.length.toString())),
            Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                statusButton(
                  title: 'جاهز',
                  controller: orderController,
                  status: 'جاهز',
                  currentIndex: 0,
                ),
                statusButton(
                  title: 'تم الإستلام',
                  controller: orderController,
                  status: 'تم الإستلام',
                  currentIndex: 1,
                ),
                statusButton(
                  title: 'واصل',
                  controller: orderController,
                  status: 'واصل',
                  currentIndex: 2,
                ),
                statusButton(
                  title: 'راجع',
                  controller: orderController,
                  status: 'راجع',
                  currentIndex: 3,
                ),
                statusButton(
                  title: 'مؤجل',
                  controller: orderController,
                  status: 'مؤجل',
                  currentIndex: 4,
                ),
                statusButton(
                  title: 'قيد التوصيل',
                  controller: orderController,
                  status: 'قيد التوصيل',
                  currentIndex: 5,
                ),
                statusButton(
                  title: 'تم الدفع',
                  controller: orderController,
                  status: 'تم الدفع',
                  currentIndex: 6,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),

            //جدول المعلومات

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text('Nr.'),
                ),
                headerTitle(
                    arbTitle: 'الرقم',
                    engTitle: 'orderNumber',
                    controller: orderController),
                headerTitle(
                    arbTitle: 'الإسم',
                    engTitle: 'customerName',
                    controller: orderController),
                headerTitle(
                    arbTitle: 'المحافظة',
                    engTitle: 'deliveryToCity',
                    controller: orderController),
                headerTitle(
                    arbTitle: 'المبلغ',
                    engTitle: 'amountAfterDelivery',
                    controller: orderController),
                headerTitle(
                    arbTitle: 'النقل',
                    engTitle: 'deliveryCost',
                    controller: orderController),
                headerTitle(
                    arbTitle: 'التاريخ',
                    engTitle: 'dateCreated',
                    controller: orderController),
                Expanded(
                  child: Text('الحالة'),
                ),
                Expanded(
                  child: Text('سبب الحالة'),
                )
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),
            SizedBox(
              height: 10,
            ),
            GetX<OrderController>(
              init: Get.put(OrderController()),
              builder: (OrderController orderController) {
                // orderController.sumAmount.value = 0;
                if (orderController != null &&
                    orderController.allOrdersProvince != null) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: orderController.allOrdersProvince.length,
                      itemBuilder: (_, index) {
                        // orderController.sumAmount.value =
                        //     orderController.sumAmount.value +
                        //         orderController
                        //             .allOrdersProvince[index].amountAfterDelivery;

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    (index + 1).toString(),
                                  ),
                                ),
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    Get.to(OrderDetailByAdmin(
                                      orderId: orderController
                                          .allOrdersProvince[index].orderId,
                                      userId: orderController
                                          .allOrdersProvince[index].byUserId,
                                    ));
                                  },
                                  child: Text(orderController
                                      .allOrdersProvince[index].orderNumber),
                                )),
                                Expanded(
                                    child: Text(orderController
                                        .allOrdersProvince[index]
                                        .customerName)),
                                Expanded(
                                    child: InkWell(
                                  child: Text(orderController
                                      .allOrdersProvince[index].deliveryToCity),
                                  onTap: () {
                                    showMadobDialog(
                                        context,
                                        orderController.allOrdersProvince[index]
                                            .deliveryToCity,
                                        orderController
                                            .allOrdersProvince[index].orderId);

                                    print(orderController
                                        .allOrdersProvince[index].orderId);
                                    print(orderController
                                        .allOrdersProvince[index]
                                        .deliveryToCity);
                                  },
                                )),
                                Expanded(
                                    child: Text(orderController
                                        .allOrdersProvince[index]
                                        .amountAfterDelivery
                                        .toString())),
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    Get.defaultDialog(
                                        textCancel: 'إلغاء',
                                        onCancel: null,
                                        textConfirm: 'ok',
                                        confirmTextColor: Colors.white,
                                        onConfirm: () {
                                          orderModel = orderController
                                              .allOrdersProvince[index];

                                          orderModel.deliveryCost = int.parse(
                                              deliveryCostController.text);

                                          // statusTitleController.text

                                          FireDb().updateOrderByUserId(
                                              order: orderModel,
                                              clientId: orderController
                                                  .allOrdersProvince[index]
                                                  .byUserId,
                                              uid: orderController
                                                  .allOrdersProvince[index]
                                                  .orderId);

                                          /*orderController.streamStatus(
                                              status: orderController
                                                  .orderStatus.value,
                                              orderByName: orderController
                                                  .orderBySortingName.value,
                                              clientId: orderController
                                                  .clientId.value);*/
                                          /*  getAllAmount(
                                              status: orderController
                                                  .orderStatus.value,
                                              sortingByName: orderController
                                                  .orderBySortingName.value);*/

                                          print(orderController
                                              .allOrdersProvince[index]
                                              .byUserId);
                                          Get.back();
                                        },
                                        title:
                                            'تغير سعر النقل ${orderController.allOrdersProvince[index].orderNumber} إلى ',
                                        content: TextField(
                                          controller: deliveryCostController,
                                        ));
                                  },
                                  child: Text(orderController
                                      .allOrdersProvince[index].deliveryCost
                                      .toString()),
                                )),
                                Expanded(
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        orderController.allOrdersProvince[index]
                                            .dateCreated
                                            .toDate()),
                                  ),
                                ),
                                Expanded(
                                    child: Text(orderController
                                        .allOrdersProvince[index].status)),

                                // هنا قسم الحالة وعن طريقة يمكن تغير الحاله
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    _valueOBX.value = 0;
                                    orderTitleStatusOBX.value = '';
                                    statusTitleController.text = '';
                                    orderStatusOBX.value = 'واصل';

                                    showMydialog(context, index);
                                  },
                                  child: Container(
                                    child: Text(orderController
                                        .allOrdersProvince[index].statusTitle),
                                    color: Colors.lightBlueAccent,
                                  ),
                                ))
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        value: 10,
                      ),
                    ),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text('المبلغ مع التوصيل: '),
                // Obx(
                //   () => Container(
                //     alignment: Alignment.centerRight,
                //     child: Text(
                //       orderController.getAllAmount().toString(),
                //     ),
                //   ),
                // ),
                // Text('كلفة النقل: '),
                // Obx(() => Text(orderController.getDeliveryCost().toString())),
                Text('صافي المبلغ: '),
                Obx(
                  () => Text(
                    (orderController.getAllAmountProvince() -
                            orderController.getDeliveryCostProvince())
                        .toString(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        )),
      ),
    );
  }

  Widget statusButton(
      {String title,
      OrderController controller,
      String status,
      int currentIndex}) {
    return RaisedButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title),
      ),
      onPressed: () {
        controller.orderStatusByProvince.value = status;
        this.currentStatus.value = currentIndex;

        controller.streamOrdersByProvinceAndStatus(
            status: status,
            deliveryToCity: orderController.deliveryToCity.value);

        print('orderController orderStatus:' +
            controller.orderStatusByProvince.value);
        /*  getAllAmount(status: status);*/
      },
    );
  }

  Widget headerTitle({
    String arbTitle,
    String engTitle,
    OrderController controller,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          controller.orderBySortingName.value = engTitle;

          // controller.streamStatus(
          //     orderByName: engTitle,
          //     status: controller.orderStatus.value,
          //     clientId: controller.clientId.value);

          print('orderController orderStatus:' +
              controller.orderStatusByUser.value);
        },
        child: Text(arbTitle),
      ),
    );
  }

  Future<dynamic> showMydialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (_) => SingleChildScrollView(
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: AlertDialog(
                  title: Text(
                    'تغير حالة الطلب ${orderController.allOrdersProvince[index].orderNumber} إلى :',
                  ),
                  content: Column(
                    children: [
                      for (int i = 0; i < _listOption.length; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _listOption[i],
                              ),
                            ),
                            Expanded(
                              child: Obx(() => Radio(
                                    value: i,
                                    groupValue: _valueOBX.value,
                                    activeColor: Color(0xFF6200EE),
                                    onChanged: (value) {
                                      _valueOBX.value = value;
                                      // orderStatus.value =
                                      //     _listOption[value];
                                      orderTitleStatusOBX.value =
                                          _listOption[value];
                                      orderStatusOBX.value = _listOption[value];
                                      // statusTitleController.text= _listOption[value];

                                      print(_valueOBX);
                                      print('orderStatusOBX.value' +
                                          orderStatusOBX.value);
                                    },
                                  )),
                            ),
                          ],
                        ),
                      Obx(
                        () => TextField(
                          controller: statusTitleController,
                          decoration: InputDecoration(
                            labelText: orderTitleStatusOBX.value,
                            labelStyle: TextStyle(fontSize: 14),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('نعم'),
                      onPressed: () {
                        orderModel = orderController.allOrdersProvince[index];

                        orderModel.status = _listOption[_valueOBX.value];

                        orderModel.statusTitle = statusTitleController.text;

                        // statusTitleController.text

                        // print('clinetid ' + orderController.clientId.value);
                        //
                        // print('client email ' +
                        //     orderController
                        //         .allOrdersProvince[index].clientEmail);

                        // _onPressed(
                        //     clientEmail: orderController
                        //         .allOrdersProvince[index].clientEmail);

                        FireDb().updateOrderByUserId(
                            order: orderModel,
                            //status: _listOption[_valueOBX.value],
                            clientId: orderModel.byUserId,
                            uid: orderController
                                .allOrdersProvince[index].orderId);

                        updateLayout();

                        // print('orderController orderStatus:' +
                        //     orderController.orderStatusByUser.value);
                        //
                        // print(_listOption[_valueOBX.value]);

                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('لا'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  Future<dynamic> showMadobDialog(
      BuildContext context, String provinceName, String orderId) {
    return showDialog(
      context: context,

      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('اختر المندوب المطلوب'),
          content: StreamBuilder(
              stream: FireDb().getMandobs(provinceName: provinceName),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      for (int i = 0; i < snapshot.data.docs.length; i++)
                        // Text(snapshot.data.docs[i].id),
                        InkWell(
                          onTap: () {
                            print('mandob id:' +
                                snapshot.data.docs[i].id); //Mandob id
                            print('order id:' + orderId);
                            FireDb().updateOrderByMandob(
                                orderId: orderId,
                                MandobId: snapshot.data.docs[i].id);
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            color: Colors.blueAccent,
                            alignment: Alignment.center,
                            constraints:
                                BoxConstraints(minWidth: 70, minHeight: 20),
                            child: Text(
                              snapshot.data.docs[i]['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return Text('nodata');
              }),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
