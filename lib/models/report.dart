class Report {
  final SuccessOrders successOrders;
  final DiscountedOrders discountedOrders;
  final BonusOrders bonusOrders;
  final CouponOrders couponOrders;
  final List<PaymentModeOrder> ordersByPaymentMode;
  final List<DeliveryTypeOrder> ordersByDeliveryType;

  Report({
    required this.successOrders,
    required this.discountedOrders,
    required this.bonusOrders,
    required this.couponOrders,
    required this.ordersByPaymentMode,
    required this.ordersByDeliveryType,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      successOrders: SuccessOrders.fromJson(json['successOrders'] ?? {}),
      discountedOrders: DiscountedOrders.fromJson(json['discountedOrders'] ?? {}),
      bonusOrders: BonusOrders.fromJson(json['bonusOrders'] ?? {}),
      couponOrders: CouponOrders.fromJson(json['couponOrders'] ?? {}),
      ordersByPaymentMode: (json['ordersByPaymentMode'] as List<dynamic>?)
              ?.map((e) => PaymentModeOrder.fromJson(e))
              .toList() ??
          [],
      ordersByDeliveryType: (json['ordersByDeliveryType'] as List<dynamic>?)
              ?.map((e) => DeliveryTypeOrder.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SuccessOrders {
  final int totalOrders;
  final double totalAmount;

  SuccessOrders({
    required this.totalOrders,
    required this.totalAmount,
  });

  factory SuccessOrders.fromJson(Map<String, dynamic> json) {
    return SuccessOrders(
      totalOrders: json['tatalOrders'] ?? 0, // Provide a default value
      totalAmount: (json['totalAmount'] ?? 0).toDouble(), // Safely convert to double
    );
  }
}

class DiscountedOrders {
  final int totalOrders;
  final double totalDiscount;

  DiscountedOrders({
    required this.totalOrders,
    required this.totalDiscount,
  });

  factory DiscountedOrders.fromJson(Map<String, dynamic> json) {
    return DiscountedOrders(
      totalOrders: json['tatalOrders'] ?? 0, // Default value for int
      totalDiscount: (json['totalDiscount'] ?? 0).toDouble(), // Default value and conversion to double
    );
  }
}

class BonusOrders {
  final int totalOrders;
  final double totalBonus;

  BonusOrders({
    required this.totalOrders,
    required this.totalBonus,
  });

  factory BonusOrders.fromJson(Map<String, dynamic> json) {
    return BonusOrders(
      totalOrders: json['tatalOrders'] ?? 0,
      totalBonus: (json['totalBonus'] ?? 0).toDouble(),
    );
  }
}

class CouponOrders {
  final int totalOrders;
  final double totalCouponDiscount;

  CouponOrders({
    required this.totalOrders,
    required this.totalCouponDiscount,
  });

  factory CouponOrders.fromJson(Map<String, dynamic> json) {
    return CouponOrders(
      totalOrders: json['tatalOrders'] ?? 0,
      totalCouponDiscount: (json['totalCouponDiscount'] ?? 0).toDouble(),
    );
  }
}

class PaymentModeOrder {
  final int totalOrders;
  final double totalAmount;
  final int paymentModeId;
  final String paymentMode;

  PaymentModeOrder({
    required this.totalOrders,
    required this.totalAmount,
    required this.paymentModeId,
    required this.paymentMode,
  });

  factory PaymentModeOrder.fromJson(Map<String, dynamic> json) {
    return PaymentModeOrder(
      totalOrders: json['tatalOrders'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentModeId: json['paymentModeId'] ?? 0,
      paymentMode: json['paymentMode'] ?? '',
    );
  }
}

class DeliveryTypeOrder {
  final int totalOrders;
  final double totalAmount;
  final int deliveryTypeId;
  final String deliveryType;

  DeliveryTypeOrder({
    required this.totalOrders,
    required this.totalAmount,
    required this.deliveryTypeId,
    required this.deliveryType,
  });

  factory DeliveryTypeOrder.fromJson(Map<String, dynamic> json) {
    return DeliveryTypeOrder(
      totalOrders: json['tatalOrders'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      deliveryTypeId: json['deliveryTypeId'] ?? 0,
      deliveryType: json['deliveryType'] ?? '',
    );
  }
}
