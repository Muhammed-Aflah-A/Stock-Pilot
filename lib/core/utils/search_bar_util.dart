class SearchBarUtil {
  static List<T> getFilteredList<T>({
    required List<T> sourceList,
    required String query,
    required String Function(T) searchField,
  }) {
    if (query.isEmpty) {
      return List.from(sourceList);
    }
    final String lowerQuery = query.toLowerCase();
    return sourceList.where((item) {
      final String fieldValue = searchField(item).toLowerCase();
      return fieldValue.contains(lowerQuery);
    }).toList();
  }
}
