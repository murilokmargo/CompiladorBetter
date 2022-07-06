// ignore_for_file: public_member_api_docs, sort_constructors_first
enum TipoToken {
  numero,
}

class Token {
  Token(this.tipo, this.lexema);

  final TipoToken tipo;
  final String lexema;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Token && other.tipo == tipo && other.lexema == lexema;
  }

  @override
  int get hashCode => tipo.hashCode ^ lexema.hashCode;

  @override
  String toString() => 'Token(tipo: $tipo, lexema: $lexema)';
}

class Tokenizador {
  Tokenizador(this.entrada);

  int posicao = 0;
  String token = '';
  final String entrada;
  // final _NUMEROS = '0123456789';

  Token proximoToken() {
    for (var i = 0; i < entrada.length; i++) {
      final peek = entrada[posicao];

      if (int.tryParse(peek) != null) {
        token += peek;
      }
      posicao += 1;
    }
    return Token(TipoToken.numero, token);

    throw Exception("Não implementado ainda.");
  }
}
