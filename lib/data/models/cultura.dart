/// Culturas agrícolas suportadas no monitoramento.
/// O label é exibido na interface; o id é usado na persistência.
enum Cultura {
  soja('soja', 'Soja', '🌱'),
  milho('milho', 'Milho', '🌽'),
  cafe('cafe', 'Café', '☕'),
  canaDeAcucar('cana', 'Cana-de-açúcar', '🎋'),
  algodao('algodao', 'Algodão', '🤍'),
  trigo('trigo', 'Trigo', '🌾'),
  outra('outra', 'Outra', '🪴');

  const Cultura(this.id, this.label, this.emoji);

  final String id;
  final String label;
  final String emoji;

  static Cultura fromId(String? id) {
    return Cultura.values.firstWhere(
      (c) => c.id == id,
      orElse: () => Cultura.outra,
    );
  }
}
