class ProfileModel {
  String companyName;
  String ownerName;
  String gstin;
  String mobile;
  String businessDomain;
  String addressLine1;
  String addressLine2;
  String landmark;
  String city;
  String district;
  String state;
  String pincode;
  String profileImage;

  ProfileModel({
    required this.companyName,
    required this.ownerName,
    required this.gstin,
    required this.mobile,
    required this.businessDomain,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
    required this.profileImage,
  });

  /// Converts object to Map for database insertion
  Map<String, dynamic> profileModelMap() {
    return {
      'company_name': companyName,
      'owner_name': ownerName,
      'gstin': gstin,
      'mobile': mobile,
      'business_domain': businessDomain,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'landmark': landmark,
      'city': city,
      'district': district,
      'state': state,
      'pincode': pincode,
      'profile_image': profileImage
    };
  }

  /// Returns an empty list, similar to `todomodelList()`
  List<Map<String, dynamic>> profileModelList() {
    return [];
  }
}
