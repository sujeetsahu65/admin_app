// import 'package:flutter/material.dart';

class Order {
  final String userEmail;
  final String userMobileNo;
  final String userAddress;
  final String userZipcode;
  final String userCity;
  final String userBuildingNo;
  final String userNote;
  final String firstName;
  final String lastName;
  // final String userFullName;
  final int orderId;
  final DateTime orderDateTime;
  final int waiterId;
  final double deliveryPartnerCost;
  final int deliveryStatusInformation;
  final String orderNO;
  final int deliveryTypeId;
  final int deliveryPartnerId;
  final String deliveryType;
  final String deliveryTypeImg;
  final String paymentMode;
  final int paymentModeId;
  final int paymentStatusId;
  final int ordersStatusId;
  final int preOrderBooking;
  // final int sendEmailOrderSetTime;
  // final int sendSmsOrderSetTime;
  // final int sendEmailOrderOntheway;
  // final int sendSmsOrderOntheway;
  // final int sendEmailOrderCancel;
  // final int sendSmsOrderCancel;
  final int orderLanguageId;
  final DateTime? orderTimerStartTime;
  final String? setOrderMinutTime;
  final double foodItemSubtotalAmt;
  final double totalItemTaxAmt;
  final double discountAmt;
  final double regOfferAmount;
  final double deliveryCharges;
  final double extraDeliveryCharges;
  final double minimumOrderPrice;
  final double grandTotal;
  final double finalPayableAmount;
  // final String orderFrom;
  final String qrcodeOrderLabel;
  final double bonusValueUsed;
  final double bonusValueGet;
  final int userId;
  final int doneStatus;
  final double orderUserDistance;
  final int preOrderResponseAlertTime;
  // final String? fcmToken;
  final double deliveryCouponAmt;
  final double couponDiscount;
  final int comboOfferApplied;

  Order({
    required this.userEmail,
    required this.userMobileNo,
    required this.userAddress,
    required this.userZipcode,
    required this.userCity,
    required this.userBuildingNo,
    required this.userNote,
    // required this.userFullName,
    required this.firstName,
    required this.lastName,
    required this.orderId,
    required this.orderDateTime,
    required this.waiterId,
    required dynamic deliveryPartnerCost,
    required this.deliveryStatusInformation,
    required this.orderNO,
    required this.deliveryTypeId,
    required this.deliveryPartnerId,
    required this.deliveryType,
    required this.deliveryTypeImg,
    required this.paymentMode,
    required this.paymentModeId,
    required this.paymentStatusId,
    required this.ordersStatusId,
    required this.preOrderBooking,
    // required this.sendEmailOrderSetTime,
    // required this.sendSmsOrderSetTime,
    // required this.sendEmailOrderOntheway,
    // required this.sendSmsOrderOntheway,
    // required this.sendEmailOrderCancel,
    // required this.sendSmsOrderCancel,
    required this.orderLanguageId,
    required this.orderTimerStartTime,
    required this.setOrderMinutTime,
    required dynamic foodItemSubtotalAmt,
    required dynamic totalItemTaxAmt,
    required dynamic discountAmt,
    required dynamic regOfferAmount,
    required dynamic deliveryCharges,
    required dynamic extraDeliveryCharges,
    required dynamic minimumOrderPrice,
    required dynamic grandTotal,
    required dynamic finalPayableAmount,
    // required this.orderFrom,
    required this.qrcodeOrderLabel,
    required dynamic bonusValueUsed,
    required dynamic bonusValueGet,
    required this.userId,
    required this.doneStatus,
    required dynamic orderUserDistance,
    required this.preOrderResponseAlertTime,
    // required this.fcmToken,
    required dynamic deliveryCouponAmt,
    required dynamic couponDiscount,
    required this.comboOfferApplied,
  })  : foodItemSubtotalAmt = _convertToDouble(foodItemSubtotalAmt),
        deliveryPartnerCost = _convertToDouble(deliveryPartnerCost),
        totalItemTaxAmt = _convertToDouble(totalItemTaxAmt),
        discountAmt = _convertToDouble(discountAmt),
        regOfferAmount = _convertToDouble(regOfferAmount),
        deliveryCharges = _convertToDouble(deliveryCharges),
        extraDeliveryCharges = _convertToDouble(extraDeliveryCharges),
        minimumOrderPrice = _convertToDouble(minimumOrderPrice),
        grandTotal = _convertToDouble(grandTotal),
        finalPayableAmount = _convertToDouble(finalPayableAmount),
        bonusValueUsed = _convertToDouble(bonusValueUsed),
        bonusValueGet = _convertToDouble(bonusValueGet),
        orderUserDistance = _convertToDouble(orderUserDistance),
        deliveryCouponAmt = _convertToDouble(deliveryCouponAmt),
        couponDiscount = _convertToDouble(couponDiscount);

  static double _convertToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.00;
    } else {
      throw ArgumentError('Invalid type for double conversion');
    }
  }




Order copyWith({
    String? userEmail,
    String? userMobileNo,
    String? userAddress,
    String? userZipcode,
    String? userCity,
    String? userBuildingNo,
    String? userNote,
    String? firstName,
    String? lastName,
    // String? userFullName,
    int? orderId,
    DateTime? orderDateTime,
    int? waiterId,
    double? deliveryPartnerCost,
    int? deliveryStatusInformation,
    String? orderNO,
    int? deliveryTypeId,
    int? deliveryPartnerId,
    String? deliveryType,
    String? deliveryTypeImg,
    String? paymentMode,
    int? paymentModeId,
    int? paymentStatusId,
    int? ordersStatusId,
    int? preOrderBooking,
    // bool? tableBooking,
    // int? tableBookingDuration,
    // int? tableBookingPeople,
    // int? sendEmailOrderSetTime,
    // int? sendSmsOrderSetTime,
    // int? sendEmailOrderOntheway,
    // int? sendSmsOrderOntheway,
    // int? sendEmailOrderCancel,
    // int? sendSmsOrderCancel,
    int? orderLanguageId,
    DateTime? orderTimerStartTime,
    String? setOrderMinutTime,
    double? foodItemSubtotalAmt,
    double? totalItemTaxAmt,
    double? discountAmt,
    double? regOfferAmount,
    double? deliveryCharges,
    double? extraDeliveryCharges,
    double? minimumOrderPrice,
    double? grandTotal,
    double? finalPayableAmount,
    // String? orderFrom,
    String? qrcodeOrderLabel,
    double? bonusValueUsed,
    double? bonusValueGet,
    int? userId,
    int? doneStatus,
    double? orderUserDistance,
    int? preOrderResponseAlertTime,
    // String? tableBookingResponseAlertTime,
    // String? fcmToken,
  }) {
    return Order(
      userEmail: userEmail ?? this.userEmail,
      userMobileNo: userMobileNo ?? this.userMobileNo,
      userAddress: userAddress ?? this.userAddress,
      userZipcode: userZipcode ?? this.userZipcode,
      userCity: userCity ?? this.userCity,
      userBuildingNo: userBuildingNo ?? this.userBuildingNo,
      userNote: userNote ?? this.userNote,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      // userFullName: userFullName ?? this.userFullName,
      orderId: orderId ?? this.orderId,
      orderDateTime: orderDateTime ?? this.orderDateTime,
      waiterId: waiterId ?? this.waiterId,
      deliveryPartnerCost: deliveryPartnerCost ?? this.deliveryPartnerCost,
      deliveryStatusInformation:
          deliveryStatusInformation ?? this.deliveryStatusInformation,
      orderNO: orderNO ?? this.orderNO,
      deliveryTypeId: deliveryTypeId ?? this.deliveryTypeId,
      deliveryPartnerId: deliveryPartnerId ?? this.deliveryPartnerId,
      deliveryType: deliveryType ?? this.deliveryType,
      deliveryTypeImg: deliveryTypeImg ?? this.deliveryTypeImg,
      paymentMode: paymentMode ?? this.paymentMode,
      paymentModeId: paymentModeId ?? this.paymentModeId,
      paymentStatusId: paymentStatusId ?? this.paymentStatusId,
      ordersStatusId: ordersStatusId ?? this.ordersStatusId,
      preOrderBooking: preOrderBooking ?? this.preOrderBooking,
      // tableBooking: tableBooking ?? this.tableBooking,
      // tableBookingDuration: tableBookingDuration ?? this.tableBookingDuration,
      // tableBookingPeople: tableBookingPeople ?? this.tableBookingPeople,
      // sendEmailOrderSetTime:
      //     sendEmailOrderSetTime ?? this.sendEmailOrderSetTime,
      // sendSmsOrderSetTime: sendSmsOrderSetTime ?? this.sendSmsOrderSetTime,
      // sendEmailOrderOntheway:
      //     sendEmailOrderOntheway ?? this.sendEmailOrderOntheway,
      // sendSmsOrderOntheway: sendSmsOrderOntheway ?? this.sendSmsOrderOntheway,
      // sendEmailOrderCancel: sendEmailOrderCancel ?? this.sendEmailOrderCancel,
      // sendSmsOrderCancel: sendSmsOrderCancel ?? this.sendSmsOrderCancel,
      orderLanguageId: orderLanguageId ?? this.orderLanguageId,
      orderTimerStartTime: orderTimerStartTime ?? this.orderTimerStartTime,
      setOrderMinutTime: setOrderMinutTime ?? this.setOrderMinutTime,
      foodItemSubtotalAmt: foodItemSubtotalAmt ?? this.foodItemSubtotalAmt,
      totalItemTaxAmt: totalItemTaxAmt ?? this.totalItemTaxAmt,
      discountAmt: discountAmt ?? this.discountAmt,
      regOfferAmount: regOfferAmount ?? this.regOfferAmount,
      deliveryCharges: deliveryCharges ?? this.deliveryCharges,
      extraDeliveryCharges: extraDeliveryCharges ?? this.extraDeliveryCharges,
      minimumOrderPrice: minimumOrderPrice ?? this.minimumOrderPrice,
      grandTotal: grandTotal ?? this.grandTotal,
      finalPayableAmount: finalPayableAmount ?? this.finalPayableAmount,
      // orderFrom: orderFrom ?? this.orderFrom,
      qrcodeOrderLabel: qrcodeOrderLabel ?? this.qrcodeOrderLabel,
      bonusValueUsed: bonusValueUsed ?? this.bonusValueUsed,
      bonusValueGet: bonusValueGet ?? this.bonusValueGet,
      userId: userId ?? this.userId,
      doneStatus: doneStatus ?? this.doneStatus,
      orderUserDistance: orderUserDistance ?? this.orderUserDistance,
      preOrderResponseAlertTime:
          preOrderResponseAlertTime ?? this.preOrderResponseAlertTime,
      // tableBookingResponseAlertTime: tableBookingResponseAlertTime ?? this.tableBookingResponseAlertTime,
      // fcmToken: fcmToken ?? this.fcmToken,
      deliveryCouponAmt: deliveryCouponAmt ?? this.deliveryCouponAmt,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      comboOfferApplied: comboOfferApplied ?? this.comboOfferApplied,
    );
  }








  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      userEmail: json['User']['userEmail'],
      userMobileNo: json['userMobileNo'],
      userAddress: json['userAddress'],
      userZipcode: json['userZipcode'],
      userCity: json['userCity'],
      userBuildingNo: json['userBuildingNo'],
      userNote: json['userNote'],
      // userFullName: json['userFullName'],
      firstName: json['User']['firstName'],
      lastName: json['User']['lastName'],
      orderId: json['orderId'],
      orderDateTime: DateTime.parse(json['orderDateTime']),
      waiterId: json['waiterId'],
      deliveryPartnerCost: json['deliveryPartnerCost'],
      deliveryStatusInformation: json['deliveryStatusInformation'],
      orderNO: json['orderNO'],
      deliveryTypeId: json['deliveryTypeId'],
      deliveryPartnerId: json['deliveryPartnerId'],
      deliveryType: json['DeliveryType']['deliveryType'],
      deliveryTypeImg: json['DeliveryType']['deliveryTypeImg'],
      paymentMode: json['PaymentMode']['paymentMode'],
      paymentModeId: json['paymentModeId'],
      paymentStatusId: json['paymentStatusId'],
      ordersStatusId: json['ordersStatusId'],
      preOrderBooking: json['preOrderBooking'],
      // sendEmailOrderSetTime: json['sendEmailOrderSetTime'],
      // sendSmsOrderSetTime: json['sendSmsOrderSetTime'],
      // sendEmailOrderOntheway: json['sendEmailOrderOntheway'],
      // sendSmsOrderOntheway: json['sendSmsOrderOntheway'],
      // sendEmailOrderCancel: json['sendEmailOrderCancel'],
      // sendSmsOrderCancel: json['sendSmsOrderCancel'],
      orderLanguageId: json['orderLanguageId'],
      orderTimerStartTime: json['orderTimerStartTime'] != null
          ? DateTime.parse(json['orderTimerStartTime'])
          : null,
      setOrderMinutTime: json['setOrderMinutTime'],
      foodItemSubtotalAmt: (json['foodItemSubtotalAmt'] is int)
          ? (json['foodItemSubtotalAmt'] as int).toDouble()
          : json['foodItemSubtotalAmt'],
      totalItemTaxAmt: (json['totalItemTaxAmt'] is int)
          ? (json['totalItemTaxAmt'] as int).toDouble()
          : json['totalItemTaxAmt'],
      discountAmt: (json['discountAmt'] is int)
          ? (json['discountAmt'] as int).toDouble()
          : json['discountAmt'],
      regOfferAmount: (json['regOfferAmount'] is int)
          ? (json['regOfferAmount'] as int).toDouble()
          : json['regOfferAmount'],
      deliveryCharges: (json['deliveryCharges'] is int)
          ? (json['deliveryCharges'] as int).toDouble()
          : json['deliveryCharges'],
      extraDeliveryCharges: (json['extraDeliveryCharges'] is int)
          ? (json['extraDeliveryCharges'] as int).toDouble()
          : json['extraDeliveryCharges'],
      minimumOrderPrice: (json['minimumOrderPrice'] is int)
          ? (json['minimumOrderPrice'] as int).toDouble()
          : json['minimumOrderPrice'],
      grandTotal: (json['grandTotal'] is int)
          ? (json['grandTotal'] as int).toDouble()
          : json['grandTotal'],
      finalPayableAmount: (json['finalPayableAmount'] is int)
          ? (json['finalPayableAmount'] as int).toDouble()
          : json['finalPayableAmount'],
      // orderFrom: json['orderFrom'],
      qrcodeOrderLabel: json['qrcodeOrderLabel'],
      bonusValueUsed: (json['bonusValueUsed'] is int)
          ? (json['bonusValueUsed'] as int).toDouble()
          : json['bonusValueUsed'],
      bonusValueGet: (json['bonusValueGet'] is int)
          ? (json['bonusValueGet'] as int).toDouble()
          : json['bonusValueGet'],
      userId: json['userId'],
      doneStatus: json['doneStatus'],
      orderUserDistance: (json['orderUserDistance'] is int)
          ? (json['orderUserDistance'] as int).toDouble()
          : json['orderUserDistance'],
      preOrderResponseAlertTime: json['preOrderResponseAlertTime'],
      // fcmToken: json['fcmToken'],
      deliveryCouponAmt: json['deliveryCouponAmt'],
      couponDiscount: json['couponDiscount'],
      comboOfferApplied: json['comboOfferApplied'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'userMobileNo': userMobileNo,
      'userAddress': userAddress,
      'userZipcode': userZipcode,
      'userCity': userCity,
      'userBuildingNo': userBuildingNo,
      'userNote': userNote,
      // 'userFullName': userFullName,
      'firstName': firstName,
      'lastName': lastName,
      'orderId': orderId,
      'orderDateTime': orderDateTime.toIso8601String(),
      'waiterId': waiterId,
      'deliveryPartnerCost': deliveryPartnerCost,
      'deliveryStatusInformation': deliveryStatusInformation,
      'orderNO': orderNO,
      'deliveryTypeId': deliveryTypeId,
      'deliveryPartnerId': deliveryPartnerId,
      'deliveryType': deliveryType,
      'deliveryTypeImg': deliveryTypeImg,
      'paymentMode': paymentMode,
      'paymentModeId': paymentModeId,
      'paymentStatusId': paymentStatusId,
      'ordersStatusId': ordersStatusId,
      'preOrderBooking': preOrderBooking,
      // 'sendEmailOrderSetTime': sendEmailOrderSetTime,
      // 'sendSmsOrderSetTime': sendSmsOrderSetTime,
      // 'sendEmailOrderOntheway': sendEmailOrderOntheway,
      // 'sendSmsOrderOntheway': sendSmsOrderOntheway,
      // 'sendEmailOrderCancel': sendEmailOrderCancel,
      // 'sendSmsOrderCancel': sendSmsOrderCancel,
      'orderLanguageId': orderLanguageId,
      'orderTimerStartTime': orderTimerStartTime?.toIso8601String(),
      'setOrderMinutTime': setOrderMinutTime,
      'foodItemSubtotalAmt': foodItemSubtotalAmt,
      'totalItemTaxAmt': totalItemTaxAmt,
      'discountAmt': discountAmt,
      'regOfferAmount': regOfferAmount,
      'deliveryCharges': deliveryCharges,
      'extraDeliveryCharges': extraDeliveryCharges,
      'minimumOrderPrice': minimumOrderPrice,
      'grandTotal': grandTotal,
      'finalPayableAmount': finalPayableAmount,
      // 'orderFrom': orderFrom,
      'qrcodeOrderLabel': qrcodeOrderLabel,
      'bonusValueUsed': bonusValueUsed,
      'bonusValueGet': bonusValueGet,
      'userId': userId,
      'doneStatus': doneStatus,
      'orderUserDistance': orderUserDistance,
      'preOrderResponseAlertTime': preOrderResponseAlertTime,
      // 'fcmToken': fcmToken,
      'deliveryCouponAmt': deliveryCouponAmt,
      'couponDiscount': couponDiscount,
      'comboOfferApplied': comboOfferApplied,
    };
  }
}
