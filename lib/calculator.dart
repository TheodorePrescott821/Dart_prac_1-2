import 'dart:io';

double? calculate(double a, String op, double b) {
  switch (op) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      return b == 0 ? null : a / b;
    case '%':
      return b == 0 ? null : a % b;
    default:
      return null;
  }
}

double? readNumber(String prompt) {
  stdout.write(prompt);
  final input = stdin.readLineSync()?.trim().replaceAll(',', '.');
  return double.tryParse(input ?? '');
}

String format(double value) =>
    value == value.truncateToDouble() ? value.toInt().toString() : value.toString();

void main() {
  final a = readNumber('Введите первое число: ');
  final b = readNumber('Введите второе число: ');

  stdout.write('Введите оператор (+, -, *, /, %): ');
  final op = stdin.readLineSync()?.trim() ?? '';

  if (a == null || b == null) {
    print('Ошибка: некорректный ввод числа.');
    return;
  }

  const allowed = ['+', '-', '*', '/', '%'];
  if (!allowed.contains(op) || op.isEmpty) {
    print('Ошибка: неизвестный оператор "$op".');
    return;
  }

  final isDivision = op == '/' || op == '%';
  if (isDivision && b == 0) {
    print('Ошибка: деление на ноль.');
    return;
  }

  final result = calculate(a, op, b);
  print(result == null
      ? 'Ошибка вычисления.'
      : '${format(a)} $op ${format(b)} = ${format(result)}');

  // Приоритет операторов: * и / выполняются раньше + и -
  print('Приоритет: 2 + 3 * 4 = ${2 + 3 * 4}, (2 + 3) * 4 = ${(2 + 3) * 4}');
}
