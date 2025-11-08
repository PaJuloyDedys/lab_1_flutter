String? validateEmail(String v) {
  if (v.isEmpty) return 'Email is required';
  if (!v.contains('@') || !v.contains('.')) return 'Invalid email';
  return null;
}

String? validateName(String v) {
  if (v.isEmpty) return 'Name is required';
  final ok =
  RegExp(r'^[A-Za-zА-Яа-яІіЇїЄє\s\-]{2,}$').hasMatch(v.trim());
  return ok ? null : 'Only letters, 2+ chars';
}

String? validatePassword(String v) {
  if (v.length < 6) return 'Min 6 chars';
  if (!RegExp(r'.*\d').hasMatch(v)) return 'Add at least 1 digit';
  return null;
}
