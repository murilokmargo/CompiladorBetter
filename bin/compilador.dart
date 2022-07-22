import 'dart:io';

import 'package:compilador/compilador.dart';
import 'package:compilador/parser.dart';

void main(List<String> arguments) {
  final file = File('codigo.txt');

  final entrada = file.readAsStringSync();

  final tokenizador = Tokenizador(entrada);

  final parser = Parser(tokenizador);

  parser.parse();
}
