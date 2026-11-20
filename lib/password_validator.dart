class PasswordValidator {
  static const int minLength = 8;
  static const bool requireDigit = true;

  static bool validate(String password) {
    if (password.length < minLength) return false;
    if (requireDigit && !password.contains(RegExp(r'\d'))) return false;
    return true;
  }
}

void main() {
  const passwords = ['abc123', 'password', 'password1', 'Qwerty2024'];

  for (final p in passwords) {
    print('"$p": ${PasswordValidator.validate(p) ? 'подходит' : 'не подходит'}');
  }
}
