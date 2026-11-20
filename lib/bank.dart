import 'dart:math';

class BankAccount {
  final String accountNumber;
  final String ownerName;
  double balance = 0;

  BankAccount(this.ownerName, {String? accountNumber})
      : accountNumber = accountNumber ?? _generateNumber();

  static final Random _random = Random();

  static String _generateNumber() =>
      List.generate(10, (_) => _random.nextInt(10)).join();

  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Сумма пополнения должна быть положительной.');
    }
    balance += amount;
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Сумма снятия должна быть положительной.');
    }
    if (amount > balance) {
      throw StateError('Недостаточно средств на счёте $accountNumber.');
    }
    balance -= amount;
  }

  void displayBalance() {
    print('Счёт $accountNumber ($ownerName): ${balance.toStringAsFixed(2)}');
  }
}

class Bank {
  final List<BankAccount> accounts = [];

  BankAccount addAccount(String ownerName) {
    BankAccount account = BankAccount(ownerName);
    while (findAccount(account.accountNumber) != null) {
      account = BankAccount(ownerName);
    }
    accounts.add(account);
    return account;
  }

  BankAccount? findAccount(String accountNumber) {
    for (final a in accounts) {
      if (a.accountNumber == accountNumber) return a;
    }
    return null;
  }

  void transfer(String fromAccountNumber, String toAccountNumber, double amount) {
    final from = findAccount(fromAccountNumber);
    final to = findAccount(toAccountNumber);
    if (from == null || to == null) {
      throw StateError('Счёт не найден.');
    }
    if (from == to) {
      throw ArgumentError('Нельзя переводить деньги на тот же счёт.');
    }
    from.withdraw(amount);
    to.deposit(amount);
  }
}

void main() {
  final bank = Bank();
  final alice = bank.addAccount('Алиса');
  final bob = bank.addAccount('Боб');

  alice.deposit(1000);
  bank.transfer(alice.accountNumber, bob.accountNumber, 250);
  alice.displayBalance();
  bob.displayBalance();

  void attempt(String title, void Function() action) {
    try {
      action();
    } on ArgumentError catch (e) {
      print('$title -> Ошибка: ${e.message}');
    } on StateError catch (e) {
      print('$title -> Ошибка: ${e.message}');
    }
  }

  attempt('Пополнение на -50', () => alice.deposit(-50));
  attempt('Снятие 5000', () => bob.withdraw(5000));
  attempt('Перевод на несуществующий счёт',
      () => bank.transfer(alice.accountNumber, '0000000000', 10));
  print('Поиск несуществующего счёта: ${bank.findAccount('1')}');
}
