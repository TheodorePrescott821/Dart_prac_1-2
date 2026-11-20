void main() {
  int age = 24;
  double averageGrade = 4.5;
  String name = 'Матвей';
  bool isStudent = true;

  print('Имя: $name ${name.runtimeType}');
  print('Возраст: $age ${age.runtimeType}');
  print('Средний балл: $averageGrade ${averageGrade.runtimeType}');
  print('Студент: ${isStudent ? 'да' : 'нет'} ${isStudent.runtimeType}');
}
