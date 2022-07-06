// ignore_for_file: public_member_api_docs, sort_constructors_first
enum TipoToken { numero, mais }

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
  final String entrada;
  // final _NUMEROS = '0123456789';

  String peek() {
    return entrada[posicao];
  }

  Token proximoToken() {
    var buffer = StringBuffer();

    if (int.tryParse(peek()) != null) {
      do {
        buffer.write(peek());
        posicao += 1;

        if (posicao >= entrada.length) {
          break;
        }
      } while (int.tryParse(peek()) != null);

      return Token(TipoToken.numero, buffer.toString());
    }

    if (peek() == '+') {
      posicao += 1;
      return Token(TipoToken.mais, '+');
    }

    return Token(TipoToken.numero, buffer.toString());
  }
}
