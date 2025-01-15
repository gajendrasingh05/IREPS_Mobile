extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (this.isEmpty) {
      return this;
    }
    List<String> parts = this.split(' ');
    String capitalized = '';
    for (String part in parts) {
      capitalized += part[0].toUpperCase() + part.substring(1) + ' ';
    }
    return capitalized.trim();
  }
}
