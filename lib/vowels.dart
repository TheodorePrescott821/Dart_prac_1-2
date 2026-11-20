void main() {
  String word = 'Flutter';
  const vowels = 'aeiouy';
  int count = 0;

  for (int i = 0; i < word.length; i++) {
    if (vowels.contains(word[i].toLowerCase())) {
      count++;
    }
  }

  print('Слово: $word');
  print('Гласных букв: $count');
}
