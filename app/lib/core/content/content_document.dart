class ContentDocument {
  const ContentDocument({
    required this.path,
    required this.category,
    required this.json,
  });

  final String path;
  final String category;
  final Object? json;
}

class EducationalContentBundle {
  const EducationalContentBundle({required this.documents});

  final List<ContentDocument> documents;

  List<ContentDocument> byCategory(String category) {
    return documents
        .where((document) => document.category == category)
        .toList(growable: false);
  }
}
