List<String> parseSize(String? sizeString) {
  if (sizeString == null || sizeString.trim().isEmpty) {
    return [];
  }

  return sizeString
      .replaceAll(',', ' ')
      .split(' ')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}