extension StringNullablity on String? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  bool isNotNullOrEmpty() {
    return !isNullOrEmpty();
  }

  String orEmpty() {
    if (isNullOrEmpty()) return "";
    return this!;
  }

  bool isNotNullAndEmpty() {
    return this != null && this!.isNotEmpty;
  }

  String orDash() {
    if (isNullOrEmpty()) {
      return "-";
    } else {
      return this!;
    }
  }

  String ifEmpty(String another) {
    if (isNullOrEmpty()) {
      return another;
    } else {
      return this!;
    }
  }

  String removeExtras() {
    if (isNullOrEmpty()) return "";
    var trimmedString = this!.trim();
    var firstReplacedString = trimmedString.replaceAll("-", "");
    var finalReplacedString = firstReplacedString.replaceAll("+", "");
    return finalReplacedString;
  }

  bool isEqualIgnoreCase(String? another) {
    if (isNullOrEmpty() || another.isNullOrEmpty()) return this == another;
    return this!.toLowerCase() == another!.toLowerCase();
  }

  String withColon(dynamic value) {
    return "$this: ${value.toString()}";
  }

  String withEndSpace() {
    return "$this ";
  }

  String addColon() {
    return "$this:";
  }

  String withComma(dynamic value) {
    return "$this, ${value.toString()}";
  }

  String withEndDot() {
    return "$this.";
  }

  String withAnother(dynamic value) {
    if (value != null) {
      return "$this ${value.toString()}";
    } else {
      return "$this ";
    }
  }

  String addEndSpace() {
    return "$this ";
  }

  String addNewLine() {
    return "$this\n";
  }

  String withBrackets(dynamic value) {
    if (isNullOrEmpty()) return "(${value.toString()})";
    return "$this (${value.toString()})";
  }
}

bool notNull(String? data) {
  return data.isNotNullOrEmpty();
}

String orEmpty(String? data) {
  return data.orEmpty();
}
