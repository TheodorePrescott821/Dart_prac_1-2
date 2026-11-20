import 'dart:convert';
import 'dart:math';

abstract class Shape {
  Shape();

  double area();

  factory Shape.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'circle':
        return Circle((json['radius'] as num).toDouble());
      case 'rectangle':
        return Rectangle(
          (json['width'] as num).toDouble(),
          (json['height'] as num).toDouble(),
        );
      default:
        throw FormatException('Неизвестный тип фигуры: ${json['type']}');
    }
  }
}

class Circle extends Shape {
  final double radius;

  Circle(this.radius);

  @override
  double area() => pi * radius * radius;
}

class Rectangle extends Shape {
  final double width;
  final double height;

  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

void main() {
  const jsonStrings = [
    '{"type": "circle", "radius": 5}',
    '{"type": "rectangle", "width": 4, "height": 6}',
    '{"type": "triangle"}',
  ];

  for (final s in jsonStrings) {
    try {
      final shape = Shape.fromJson(jsonDecode(s) as Map<String, dynamic>);
      print('${shape.runtimeType}: площадь = ${shape.area().toStringAsFixed(2)}');
    } on FormatException catch (e) {
      print('Ошибка: ${e.message}');
    }
  }
}
