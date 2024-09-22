class Settings {
  final int homeDeliveryFeature;
  final int onlineOrderingFeature;
  final int selectedCopyCount;
  final int selectedPrintFormat;
  final int orientation;
  final int maxPrintCopies;
  final List<PrintFormat> printFormats;

  Settings({
    required this.homeDeliveryFeature,
    required this.onlineOrderingFeature,
    required this.selectedCopyCount,
    required this.selectedPrintFormat,
    required this.orientation,
    required this.maxPrintCopies,
    required this.printFormats,
  });

    // copyWith method
  Settings copyWith({
    int? homeDeliveryFeature,
    int? onlineOrderingFeature,
    int? selectedCopyCount,
    int? selectedPrintFormat,
    int? orientation,
    int? maxPrintCopies,
    List<PrintFormat>? printFormats,
  }) {
    return Settings(
      homeDeliveryFeature: homeDeliveryFeature ?? this.homeDeliveryFeature,
      onlineOrderingFeature: onlineOrderingFeature ?? this.onlineOrderingFeature,
      selectedCopyCount: selectedCopyCount ?? this.selectedCopyCount,
      selectedPrintFormat: selectedPrintFormat ?? this.selectedPrintFormat,
      orientation: orientation ?? this.orientation,
      maxPrintCopies: maxPrintCopies ?? this.maxPrintCopies,
      printFormats: printFormats ?? this.printFormats,
    );
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      homeDeliveryFeature: json['home_delivery_feature'],
      onlineOrderingFeature: json['online_ordering_feature'],
      selectedCopyCount: json['selected_copy_count'],
      selectedPrintFormat: json['selected_print_format'],
      orientation: json['orientation'],
      maxPrintCopies: json['max_print_copies'],
      printFormats: (json['print_formats'] as List)
          .map((format) => PrintFormat.fromJson(format))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'home_delivery_feature': homeDeliveryFeature,
      'online_ordering_feature': onlineOrderingFeature,
      'selected_copy_count': selectedCopyCount,
      'selected_print_format': selectedPrintFormat,
      'orientation': orientation,
      // 'max_print_copies': maxPrintCopies,
      // 'print_formats': printFormats.map((format) => format.toJson()).toList(),
    };
  }
}

class PrintFormat {
  final int printFormatId;
  final String printFormatName;

  PrintFormat({
    required this.printFormatId,
    required this.printFormatName,
  });

  factory PrintFormat.fromJson(Map<String, dynamic> json) {
    return PrintFormat(
      printFormatId: json['print_format_id'],
      printFormatName: json['print_format_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'print_format_id': printFormatId,
      'print_format_name': printFormatName,
    };
  }
}
