class LanguageContent {
  final int id;
  final String header;
  final String title;
  final int languageId;

  LanguageContent({
    required this.id,
    required this.header,
    required this.title,
    required this.languageId,
  });

  factory LanguageContent.fromJson(Map<String, dynamic> json) {
    return LanguageContent(
      id: json['id'],
      header: json['header'],
      title: json['title'],
      languageId: json['language_id'],
    );
  }
}