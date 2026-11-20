import 'dart:io';

class MatrixException implements Exception {
  final String message;
  MatrixException(this.message);
  @override
  String toString() => message;
}

class Matrix {
  final List<List<double>> data;

  Matrix(this.data) {
    if (data.isEmpty || data[0].isEmpty) {
      throw MatrixException('Матрица не может быть пустой.');
    }
    if (data.any((row) => row.length != data[0].length)) {
      throw MatrixException('Строки матрицы имеют разную длину.');
    }
  }

  int get rows => data.length;
  int get cols => data[0].length;

  Matrix operator +(Matrix o) => _combine(o, (a, b) => a + b, 'сложения');
  Matrix operator -(Matrix o) => _combine(o, (a, b) => a - b, 'вычитания');

  Matrix _combine(Matrix o, double Function(double, double) f, String op) {
    if (rows != o.rows || cols != o.cols) {
      throw MatrixException(
          'Размеры несовместимы для $op: ${rows}x$cols и ${o.rows}x${o.cols}.');
    }
    return Matrix([
      for (int i = 0; i < rows; i++)
        [for (int j = 0; j < cols; j++) f(data[i][j], o.data[i][j])]
    ]);
  }

  Matrix scale(double k) =>
      Matrix([for (final r in data) [for (final v in r) v * k]]);

  Matrix multiply(Matrix o) {
    if (cols != o.rows) {
      throw MatrixException(
          'Умножение невозможно: столбцов первой ($cols) != строк второй (${o.rows}).');
    }
    return Matrix([
      for (int i = 0; i < rows; i++)
        [
          for (int j = 0; j < o.cols; j++)
            [for (int k = 0; k < cols; k++) data[i][k] * o.data[k][j]]
                .reduce((a, b) => a + b)
        ]
    ]);
  }

  Matrix transpose() => Matrix([
        for (int j = 0; j < cols; j++) [for (int i = 0; i < rows; i++) data[i][j]]
      ]);

  double determinant() {
    if (rows != cols) {
      throw MatrixException('Определитель существует только у квадратных матриц.');
    }
    final m = [for (final r in data) List<double>.from(r)];
    double det = 1;
    for (int c = 0; c < rows; c++) {
      int pivot = c;
      for (int r = c + 1; r < rows; r++) {
        if (m[r][c].abs() > m[pivot][c].abs()) pivot = r;
      }
      if (m[pivot][c].abs() < 1e-12) return 0;
      if (pivot != c) {
        final t = m[pivot];
        m[pivot] = m[c];
        m[c] = t;
        det = -det;
      }
      det *= m[c][c];
      for (int r = c + 1; r < rows; r++) {
        final f = m[r][c] / m[c][c];
        for (int k = c; k < rows; k++) {
          m[r][k] -= f * m[c][k];
        }
      }
    }
    return det;
  }

  static String fmt(double v) {
    final r = double.parse(v.toStringAsFixed(6));
    return r == r.truncateToDouble() ? r.toInt().toString() : r.toString();
  }

  @override
  String toString() => data.map((r) => r.map(fmt).join('\t')).join('\n');
}

Matrix readMatrix(String name) {
  stdout.write('Матрица $name: количество строк и столбцов (например, 2 3): ');
  final size = (stdin.readLineSync() ?? '').trim().split(RegExp(r'\s+'));
  final r = size.length == 2 ? int.tryParse(size[0]) : null;
  final c = size.length == 2 ? int.tryParse(size[1]) : null;
  if (r == null || c == null || r <= 0 || c <= 0) {
    throw MatrixException('Некорректный размер матрицы.');
  }
  final rowsData = <List<double>>[];
  for (int i = 0; i < r; i++) {
    stdout.write('  Строка ${i + 1} ($c чисел через пробел): ');
    final parts = (stdin.readLineSync() ?? '')
        .trim()
        .replaceAll(',', '.')
        .split(RegExp(r'\s+'));
    final nums = parts.map(double.tryParse).toList();
    if (parts.length != c || nums.any((n) => n == null)) {
      throw MatrixException('Некорректный ввод строки: нужно ровно $c чисел.');
    }
    rowsData.add(nums.cast<double>());
  }
  return Matrix(rowsData);
}

void main() {
  print('Калькулятор матриц');
  print('1 - Сложение\n2 - Вычитание\n3 - Умножение на число\n'
      '4 - Умножение матриц\n5 - Транспонирование\n6 - Определитель');
  stdout.write('Выберите операцию (1-6): ');
  final choice = (stdin.readLineSync() ?? '').trim();

  try {
    switch (choice) {
      case '1':
        final a = readMatrix('A');
        final b = readMatrix('B');
        print('Результат:\n${a + b}');
      case '2':
        final a = readMatrix('A');
        final b = readMatrix('B');
        print('Результат:\n${a - b}');
      case '3':
        final a = readMatrix('A');
        stdout.write('Введите число: ');
        final k = double.tryParse(
            (stdin.readLineSync() ?? '').trim().replaceAll(',', '.'));
        if (k == null) throw MatrixException('Некорректное число.');
        print('Результат:\n${a.scale(k)}');
      case '4':
        final a = readMatrix('A');
        final b = readMatrix('B');
        print('Результат:\n${a.multiply(b)}');
      case '5':
        print('Результат:\n${readMatrix('A').transpose()}');
      case '6':
        print('Определитель: ${Matrix.fmt(readMatrix('A').determinant())}');
      default:
        print('Ошибка: неизвестная операция "$choice".');
    }
  } on MatrixException catch (e) {
    print('Ошибка: $e');
  }
}
