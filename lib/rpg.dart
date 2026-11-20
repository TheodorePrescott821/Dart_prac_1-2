import 'dart:math';

final Random _random = Random();

abstract interface class Combatant {
  int attack();
  void defend(int damage);
  bool isAlive();
}

abstract class Character implements Combatant {
  static const int maxHealth = 100;

  final String name;
  int health = maxHealth;
  int level;

  Character(this.name, {this.level = 1});

  @override
  int attack();

  @override
  void defend(int damage) {
    health = max(0, health - damage);
  }

  @override
  bool isAlive() => health > 0;

  @override
  String toString() => '$name ($runtimeType, HP: $health)';
}

class Warrior extends Character {
  Warrior(super.name, {super.level});

  @override
  int attack() => 15 + level * 2;

  @override
  void defend(int damage) {
    final reduced = (damage * 0.8).round();
    print('  $name блокирует 20% урона: $damage -> $reduced');
    super.defend(reduced);
  }
}

class Mage extends Character {
  Mage(super.name, {super.level});

  @override
  int attack() {
    final damage = 10 + level * 3;
    health = min(Character.maxHealth, health + 5);
    print('  $name лечится на 5 HP после атаки');
    return damage;
  }
}

class Rogue extends Character {
  Rogue(super.name, {super.level});

  @override
  int attack() {
    final base = 12 + level * 2;
    if (_random.nextDouble() < 0.2) {
      print('  $name наносит критический удар!');
      return base * 3;
    }
    return base;
  }

  @override
  void defend(int damage) {
    if (_random.nextBool()) {
      print('  $name уворачивается от атаки!');
      return;
    }
    super.defend(damage);
  }
}

Character fight(Character a, Character b) {
  int round = 1;
  Character attacker = a;
  Character defender = b;

  while (a.isAlive() && b.isAlive()) {
    print('Раунд $round: ${attacker.name} атакует ${defender.name}');
    final damage = attacker.attack();
    print('  Урон: $damage');
    defender.defend(damage);
    print('  $a | $b');

    final tmp = attacker;
    attacker = defender;
    defender = tmp;
    round++;
  }
  return a.isAlive() ? a : b;
}

void main() {
  final warrior = Warrior('Конан');
  final mage = Mage('Мерлин');
  final rogue = Rogue('Тень');

  print('=== Бой: ${warrior.name} vs ${mage.name} ===');
  final winner1 = fight(warrior, mage);
  print('Победитель: ${winner1.name}\n');

  print('=== Бой: ${winner1.name} vs ${rogue.name} ===');
  final winner2 = fight(winner1..health = Character.maxHealth, rogue);
  print('Победитель: ${winner2.name}');
}
