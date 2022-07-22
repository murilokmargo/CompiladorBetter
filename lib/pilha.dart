class Pilha<T> {
  Pilha() : _pilha = <T>[];

  final List<T> _pilha;

  void push(T elemento) {
    _pilha.add(elemento);
  }

  T pop() {
    return _pilha.removeLast();
  }

  T top() {
    return _pilha.last;
  }

  bool get isEmpty => _pilha.isEmpty;

  bool get isNotEmpty => _pilha.isNotEmpty;

  @override
  String toString() {
    return "[${_pilha.join(', ')}]";
  }
}
