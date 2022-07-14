import 'package:compilador/compilador.dart';
import 'package:test/test.dart';

//1+23^4              //163
//(1+2)3^4             //243
//1+(23)^4             //1297
//1+(2*3)+exp[4]            //61,598150033

void main() {
  test('Apenas um dígito', () {
    //arrange
    final tokenEsperado = Token(TipoToken.numero, '2');

    final entrada = '2';

    final tokenizador = Tokenizador(entrada);
    //act
    final token = tokenizador.proximoToken();
    //assert
    expect(token, tokenEsperado);
  });
  test('Vários dígitos', () {
    //arrange
    final tokenEsperado = Token(TipoToken.numero, '420');

    final entrada = '420';

    final tokenizador = Tokenizador(entrada);
    //act
    final token = tokenizador.proximoToken();
    //assert
    expect(token, tokenEsperado);
  });

  test('Soma', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.mais, '+'),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69+420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Subtração', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.menos, '-'),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69-420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Multiplicação', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.multiplicacao, '*'),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69*420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Divisão', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.divisao, '/'),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69/420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Potência', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.potencia, '^'),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69^420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Abre parênteses', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.abreParenteses, '('),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69(420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Fecha parênteses', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.fechaParenteses, ')'),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69)420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Abre colchetes', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.abreColchetes, '['),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69[420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Fecha colchetes', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.fechaColchetes, ']'),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69]420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Exp', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.exp, 'exp'),
      Token(TipoToken.abreColchetes, '['),
      Token(TipoToken.numero, '245'),
      Token(TipoToken.fechaColchetes, ']'),
    ];

    final entrada = 'exp[245]';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Espaço', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.numero, '420'),
    ];

    final entrada = '69 420';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });

  test('Espaço2', () {
    //arrange
    final tokensEsperado = [
      Token(TipoToken.numero, '69'),
      Token(TipoToken.abreColchetes, '['),
      Token(TipoToken.numero, '420'),
      Token(TipoToken.fechaColchetes, ']'),
    ];

    final entrada = '69 [420]';

    final tokenizador = Tokenizador(entrada);

    //act
    var tokensRecebidos = [];
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    tokensRecebidos.add(tokenizador.proximoToken());
    //assert
    expect(tokensRecebidos, tokensEsperado);
  });
}
