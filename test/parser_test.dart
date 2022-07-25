import 'package:compilador/compilador.dart';
import 'package:compilador/parser.dart';
import 'package:test/test.dart';

const epsilon = 0.01;

void main() {
  test('1 + 1', () {
    const entrada = '1 + 1';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 2;

    final parser = Parser(tokenizador);

    expect(parser.parse(), resultadoResperado);
  });

  test('1 - 1', () {
    const entrada = '1 - 1';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 0;

    final parser = Parser(tokenizador);

    expect(parser.parse(), resultadoResperado);
  });

  test('1 + 1 + 1', () {
    const entrada = '1 + 1 + 1';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 3;

    final parser = Parser(tokenizador);

    expect(parser.parse(), resultadoResperado);
  });

  test('1 + 2 * 3', () {
    const entrada = '1 + 2 * 3';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 7;

    final parser = Parser(tokenizador);

    expect(parser.parse(), resultadoResperado);
  });

  test('(1 + 2) * 3', () {
    const entrada = '(1 + 2) * 3';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 9;

    final parser = Parser(tokenizador);

    expect(parser.parse(), resultadoResperado);
  });

  test('(1 + 2) * (3 * 2)', () {
    const entrada = '(1 + 2) * (3 * 2)';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 18;

    final parser = Parser(tokenizador);

    expect(parser.parse(), resultadoResperado);
  });

  test('(1 + 2) + (3 * 2)', () {
    const entrada = '(1 + 2) + (3 * 2)';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 9;

    final parser = Parser(tokenizador);

    expect(parser.parse(), resultadoResperado);
  });

  test('2 - 5 * 2', () {
    const entrada = '2 - 5 * 2';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = -8;

    final parser = Parser(tokenizador);

    expect(parser.parse(), resultadoResperado);
  });

  test('1+2*3-(4+2)', () {
    const entrada = '1+2*3-(4+2)';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 1;

    final parser = Parser(tokenizador);

    expect(parser.parse(), resultadoResperado);
  });

  test('2^5', () {
    const entrada = '2^5';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 32;
    final parser = Parser(tokenizador);
    expect(parser.parse(), resultadoResperado);
  });

  test('2^5^2', () {
    const entrada = '2^5^2';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 1024;
    final parser = Parser(tokenizador);
    expect(parser.parse(), resultadoResperado);
  });

  test('10/2', () {
    const entrada = '10/2';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 5;
    final parser = Parser(tokenizador);
    expect(parser.parse(), resultadoResperado);
  });

  test('10 / 2 + 3.14', () {
    const entrada = '10 / 2 + 3.14';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 8.14;
    final parser = Parser(tokenizador);
    expect(parser.parse(), closeTo(resultadoResperado, epsilon));
  });

  test('1+2*3^4', () {
    const entrada = '1+2*3^4';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 163;
    final parser = Parser(tokenizador);
    expect(parser.parse(), closeTo(resultadoResperado, epsilon));
  });

  test('(1+2)*3^4', () {
    const entrada = '(1+2)*3^4';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 243;
    final parser = Parser(tokenizador);
    expect(parser.parse(), closeTo(resultadoResperado, epsilon));
  });

  test('1+(2*3)^4', () {
    const entrada = '1+(2*3)^4';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 1297;
    final parser = Parser(tokenizador);
    expect(parser.parse(), closeTo(resultadoResperado, epsilon));
  });

  test('1+(2*3)+exp[4]', () {
    const entrada = '1+(2*3)+exp[4]';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 61.59;
    final parser = Parser(tokenizador);
    expect(parser.parse(), closeTo(resultadoResperado, epsilon));
  });

  test('1+(2*3)+exp[(2+1+1)]', () {
    const entrada = '1+(2*3)+exp[(2+1+1)]';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 61.59;
    final parser = Parser(tokenizador);
    expect(parser.parse(), closeTo(resultadoResperado, epsilon));
  });

  test('exp[(3^3)]*(1-1)', () {
    const entrada = 'exp[(3^3)]*(1-1)';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 0;
    final parser = Parser(tokenizador);
    expect(parser.parse(), closeTo(resultadoResperado, epsilon));
  });

  test('exp[(3^3)]*(1+1)', () {
    const entrada = 'exp[(3^3)]*(1+1)';
    final tokenizador = Tokenizador(entrada);
    const resultadoResperado = 1064096481203.59;
    final parser = Parser(tokenizador);
    expect(parser.parse(), closeTo(resultadoResperado, epsilon));
  });
}
