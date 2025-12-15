import 'package:flutter/widgets.dart';
import 'package:stock_pilot/data/models/user_profle_model.dart';
import 'package:stock_pilot/data/services/hive_service_layer.dart';

class ProfileCreationProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  String? fullName;
  final shopNameFocus = FocusNode();
  String? shopName;
  final shopAdressFocus = FocusNode();
  String? shopAdress;
  final phoneNumberFocus = FocusNode();
  String? phoneNumber;
  final emailFocus = FocusNode();
  String? gmail;

  final HiveServiceLayer hiveService;
  ProfileCreationProvider({required this.hiveService});

  Future<void> addUser(UserProfile user) async {
    await hiveService.addUser(user);
  }
}
