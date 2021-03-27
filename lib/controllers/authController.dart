import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:tawselat/controllers/deliveryBoyController.dart';
import 'package:tawselat/controllers/userController.dart';
import 'package:tawselat/layout/mainLayout.dart';
import 'package:tawselat/models/deliveryBoy.dart';
import 'package:tawselat/models/user.dart';
import 'package:tawselat/services/fireDb.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance; //Private Variable
  Rx<User> _fireUser = Rx<User>(); //Observable Varibale for State Changes

  //Getter

  User get user => _fireUser.value;
  //It will check user null or not and get values from firebase User

  @override
  void onInit() {
    _fireUser.bindStream(
        _auth.authStateChanges()); //It Will check User LoggedIn or Not
    // called immediately after the widget is allocated memory
    super.onInit();
  }

//Create User
  void createUser(
      {String name,
      String email,
      String password,
      String shopName,
      String shopAddress,
      String phoneNumber}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel _user = UserModel(
          id: userCredential.user.uid,
          email: userCredential.user.email,
          password: password,
          name: name,
          shopName: shopName,
          shopAddress: shopAddress,
          phoneNumber: phoneNumber);
      var rs = await FireDb().createNewUser(_user);
      if (rs) {
        Get.find<UserController>().user = _user;
        Get.back();
      }
    } catch (e) {
      getErrorSnack("Error While Creating Account", e.message);
    }
  }

  // void createDeliveryBoy(
  //     {String name,
  //     String email,
  //     String password,
  //     String province,
  //     String shopAddress,
  //     String phoneNumber}) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     var _user = UserModel(
  //         id: userCredential.user.uid,
  //         email: userCredential.user.email,
  //         password: password,
  //         name: name,
  //         province: province,
  //         shopName: '',
  //         shopAddress: '',
  //         phoneNumber: phoneNumber);
  //     var rs = await FireDb().createNewUser(_user);
  //     if (rs) {
  //       Get.find<UserController>().user = _user;
  //       // Get.find<AuthController>().user = _user;
  //       Get.back();
  //     }
  //   } catch (e) {
  //     getErrorSnack("Error While Creating Account", e.message);
  //   }
  // }

//Login

  void login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.find<UserController>().user =
          await FireDb().getUser(uid: userCredential.user.uid);

      Get.back();
    } catch (e) {
      getErrorSnack("Error While SignIn Account", e.message);
    }
  }

  // void loginDeliveryBoy(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     var user = Get.find<DeliveryBoyController>().deliveryBoy =
  //         await FireDb().getDeliveryBoy(uid: userCredential.user.uid);
  //
  //     Get.back();
  //     // if (user.role != null) {
  //     //   if (user.role == 'admin') Get.off(MainLayout());
  //     //   if (user.role == 'shopOwner') Get.off(Home());
  //     // } else
  //     //   print('wait');
  //   } catch (e) {
  //     getErrorSnack("Error While SignIn Account", e.message);
  //   }
  // }

//Logout
  void logOut() async {
    await _auth.signOut();
    Get.reset();
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => UserController());
  }

  //ErrorSnakBar
  void getErrorSnack(String title, String message) {
    Get.snackbar(title, message,
        snackPosition:
            SnackPosition.BOTTOM); // For Checking Error form Firebase
  }
}
