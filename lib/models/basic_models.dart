class ContactUs {
  String orgName;
  String address;
  String emailId;
  String phone;
  int onlineOrdering;
  int onlineOrderingFeature;
  int preBooking;
  int preBookingFeature;
  int printNoOfCopy;
  int printStyle;
  int deviceTypePrint;
  int orientation;
  // String orgCity;
  // String orgZipcode;
  // String latitude;
  // String longitude;

  ContactUs({
    required this.orgName,
    required this.address,
    required this.emailId,
    required this.phone,
    required this.onlineOrdering,
    required this.onlineOrderingFeature,
    required this.preBooking,
    required this.preBookingFeature,
    required this.printNoOfCopy,
    required this.printStyle,
    required this.deviceTypePrint,
    required this.orientation,
    // required this.orgCity,
    // required this.orgZipcode,
    // required this.latitude,
    // required this.longitude,
  });

  factory ContactUs.fromJson(Map<String, dynamic> json) {
    return ContactUs(
      orgName: json['org_name'],
      address: json['address'],
      emailId: json['email_id'],
      phone: json['phone'],
      onlineOrdering: json['online_ordering'],
      onlineOrderingFeature: json['online_ordering_feature'],
      preBooking: json['pre_booking'],
      preBookingFeature: json['pre_booking_feature'],
      printNoOfCopy: json['print_no_of_copy'],
      printStyle: json['print_style'],
      deviceTypePrint: json['device_type_print'],
      orientation: json['orientation'],
      // orgCity: json['org_city'],
      // orgZipcode: json['org_zipcode'],
      // latitude: json['latitude'],
      // longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'org_name': orgName,
      'address': address,
      'email_id': emailId,
      'phone': phone,
      'online_ordering': onlineOrdering,
      'online_ordering_feature': onlineOrderingFeature,
      'pre_booking': preBooking,
      'pre_booking_feature': preBookingFeature,
      'print_no_of_copy': printNoOfCopy,
      'print_style': printStyle,
      'device_type_print': deviceTypePrint,
      'orientation': orientation,
      // 'org_city': orgCity,
      // 'org_zipcode': orgZipcode,
      // 'latitude': latitude,
      // 'longitude': longitude,
    };
  }

  // Factory method for initial default state
  factory ContactUs.initial() {
    return ContactUs(
      orgName: '',
      address: '',
      emailId: '',
      phone: '',
      onlineOrdering: 0,
      onlineOrderingFeature: 0,
      preBooking: 0,
      preBookingFeature: 0,
      printNoOfCopy: 0,
      printStyle: 0,
      deviceTypePrint: 0,
      orientation: 0,
      // orgCity: '',
      // orgZipcode: '',
      // latitude: '',
      // longitude: '',
    );
  }
}

class LocationMaster {
  String locName;
  String disName;
  // String locAddress;
  // String locImage;
  String locLogo;
  // String locFavicon;
  // int displayOrder;
  // int activeStatus;
  // int activeEmailStatus;
  // int deactiveEmailStatus;
  // String website;
  // String businessId;
  // String locationType;
  // int websiteType;
  // String siteUrl;

  LocationMaster({
    required this.locName,
    required this.disName,
    // required this.locAddress,
    // required this.locImage,
    required this.locLogo,
    // required this.locFavicon,
    // required this.displayOrder,
    // required this.activeStatus,
    // required this.activeEmailStatus,
    // required this.deactiveEmailStatus,
    // required this.website,
    // required this.businessId,
    // required this.locationType,
    // required this.websiteType,
    // required this.siteUrl,
  });

  factory LocationMaster.fromJson(Map<String, dynamic> json) {
    return LocationMaster(
      locName: json['loc_name'],
      disName: json['dis_name'],
      // locAddress: json['loc_address'],
      // locImage: json['loc_image'],
      locLogo: json['loc_logo'],
      // locFavicon: json['loc_favicon'],
      // displayOrder: json['display_order'],
      // activeStatus: json['active_status'],
      // activeEmailStatus: json['active_email_status'],
      // deactiveEmailStatus: json['deactive_email_status'],
      // website: json['website'],
      // businessId: json['businessid'],
      // locationType: json['location_type'],
      // websiteType: json['website_type'],
      // siteUrl: json['site_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loc_name': locName,
      'dis_name': disName,
      // 'loc_address': locAddress,
      // 'loc_image': locImage,
      'loc_logo': locLogo,
      // 'loc_favicon': locFavicon,
      // 'display_order': displayOrder,
      // 'active_status': activeStatus,
      // 'active_email_status': activeEmailStatus,
      // 'deactive_email_status': deactiveEmailStatus,
      // 'website': website,
      // 'businessid': businessId,
      // 'location_type': locationType,
      // 'website_type': websiteType,
      // 'site_url': siteUrl,
    };
  }

  // Factory method for initial default state
  factory LocationMaster.initial() {
    return LocationMaster(
      locName: '',
      disName: '',
      // locAddress: '',
      // locImage: '',
      locLogo: '',
      // locFavicon: '',
      // displayOrder: 0,
      // activeStatus: 0,
      // activeEmailStatus: 0,
      // deactiveEmailStatus: 0,
      // website: '',
      // businessId: '',
      // locationType: '',
      // websiteType: 0,
      // siteUrl: '',
    );
  }
}

class OrderResponseTime {
  int responseInterval;
  int maxDuration;

  OrderResponseTime({
    required this.responseInterval,
    required this.maxDuration,
  });

  factory OrderResponseTime.fromJson(Map<String, dynamic> json) {
    return OrderResponseTime(
      responseInterval: json['response_interval'],
      maxDuration: json['max_duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_interval': responseInterval,
      'max_duration': maxDuration,
    };
  }

  // Factory method for initial default state
  factory OrderResponseTime.initial() {
    return OrderResponseTime(
      responseInterval: 0,
      maxDuration: 0,
    );
  }
}

class BasicModels {
  ContactUs contactUs;
  LocationMaster locationMaster;
  OrderResponseTime orderResponseTime;

  BasicModels({
    required this.contactUs,
    required this.locationMaster,
    required this.orderResponseTime,
  });

  factory BasicModels.fromJson(Map<String, dynamic> json) {
    return BasicModels(
      contactUs: ContactUs.fromJson(json['contact_us']),
      locationMaster: LocationMaster.fromJson(json['location_master']),
      orderResponseTime: OrderResponseTime.fromJson(json['order_response_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_us': contactUs.toJson(),
      'location_master': locationMaster.toJson(),
      'order_response_time': orderResponseTime.toJson(),
    };
  }

  // Factory method for initial default state
  factory BasicModels.initial() {
    return BasicModels(
      contactUs: ContactUs.initial(),
      locationMaster: LocationMaster.initial(),
      orderResponseTime: OrderResponseTime.initial(),
    );
  }
}
