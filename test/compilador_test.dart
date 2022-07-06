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
}
