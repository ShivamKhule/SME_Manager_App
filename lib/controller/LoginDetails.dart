import 'package:flutter/material.dart';

class Logindetails extends ChangeNotifier {
  String userEmail;
  double? salesAmt = 0;
  double? purchaseAmt = 0;

  // Profile Details
  String? cmpName;
  String? ownerName;
  String? address;
  String? mobile;
  String? gstin;
  String? profile_image;
  String? business_domain;

  Logindetails(
      {required this.userEmail, this.salesAmt, this.purchaseAmt, this.address});

  void setSalesAmt(double salesAmt) {
    this.salesAmt = salesAmt;
    notifyListeners();
  }

  void setUserEmail(String userEmail) {
    this.userEmail = userEmail;
    notifyListeners();
  }

  void setPurchaseAmt(double purchseAmt) {
    this.purchaseAmt = purchaseAmt;
    notifyListeners();
  }

  void setUserDetails(
      String cmpName,
      String ownerName,
      String address,
      String mobile,
      String gstin,
      String profile_image,
      String business_domain) {
    this.address;
    this.business_domain;
    this.cmpName;
    this.mobile;
    this.gstin;
    this.profile_image;
    notifyListeners();
  }
}
