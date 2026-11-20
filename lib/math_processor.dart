import 'dart:math';

class MathProcessor {
  final List<int> numbers;

  MathProcessor(this.numbers);

  List<int> process(int Function(int) handler) => numbers.map(handler).toList();

  static List<int> getRandomNumbers(int count, {int max = 100}) {
    final random = Random();
    return List.generate(count, (_) => random.nextInt(max) + 1);
  }
}

void main() {
  final numbers = MathProcessor.getRandomNumbers(5);
  final processor = MathProcessor(numbers);

  print('Исходный список: $numbers');
  print('Квадраты: ${processor.process((x) => x * x)}');
  print('Удвоение: ${processor.process((x) => x * 2)}');
  print('Инкремент: ${processor.process((x) => x + 1)}');
}
