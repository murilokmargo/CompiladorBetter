// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:math' as math;
import 'package:compilador/compilador.dart';
import 'package:compilador/pilha.dart';

const f = 'F';
const tLinha = "T'";
const t = "T";
const pLinha = "P'";
const p = 'P';
const eLinha = "E'";
const e = 'E';
const fimDeCadeia = '\$';
const mais = '+';
const menos = '-';
const multiplicacao = '*';
const divisao = '/';
const exponencial = '^';
const exp = 'exp';
const abreParenteses = '(';
const fechaParenteses = ')';
const fechaColchetes = ']';
const abreColchetes = '[';
const id = 'id';
const vazio = 'ϵ';

class Chave {
  final String terminal;
  final TipoToken simbolo;
  Chave(this.terminal, this.simbolo);

  @override
  bool operator ==(covariant Chave other) {
    if (identical(this, other)) return true;

    return other.terminal == terminal && other.simbolo == simbolo;
  }

  @override
  int get hashCode => terminal.hashCode ^ simbolo.hashCode;
}

class Parser {
  Parser(this.tokenizador);

  final Tokenizador tokenizador;
  final tabela = criaTabela();
  num parse() {
    var token = tokenizador.proximoToken();
    if (token.tipo == TipoToken.erro) {
      print("Erro léxico:  token'${token.lexema}' não reconhecido. ");
      exit(1);
    }
    final pilha = Pilha<String>();
    final pilhaOperando = <Token>[];
    final pilhaOperador = Pilha<Token>();
    pilha.push(fimDeCadeia);
    pilha.push(e);

    while (pilha.top() != fimDeCadeia) {
      if (matchToken(pilha.top(), token)) {
        if (token.tipo == TipoToken.numero) {
          pilhaOperando.add(token);
        } else if (token.tipo == TipoToken.abreParenteses) {
          pilhaOperador.push(token);
        } else if (token.tipo == TipoToken.fechaParenteses) {
          while (pilhaOperador.isNotEmpty &&
              pilhaOperador.top().tipo != TipoToken.abreParenteses) {
            pilhaOperando.add(pilhaOperador.pop());
          }
          if (pilhaOperador.isNotEmpty) {
            pilhaOperador.pop();
          }
        } else if (ops.contains(token.tipo)) {
          while (pilhaOperador.isNotEmpty &&
              pilhaOperador.top().tipo != TipoToken.abreParenteses &&
              precede(pilhaOperador.top(), token)) {
            pilhaOperando.add(pilhaOperador.pop());
          }
          pilhaOperador.push(token);
        }

        //print("Deu match: ${pilha.top()} com a nossa entrada: ${token.lexema}, então removemos o ${pilha.top()}");
        pilha.pop();
        token = tokenizador.proximoToken();
        if (token.tipo == TipoToken.erro) {
          print("Erro léxico:  token'${token.lexema}' não reconhecido. ");
          exit(1);
        }
      } else if (isTerminal(pilha.top())) {
        print('Erro sintático: o símbolo ${token.lexema} não é reconhecido.');
        exit(1);
      } else if (tabela[Chave(pilha.top(), token.tipo)] == null) {
        print('Erro sintático: o símbolo ${token.lexema} não é reconhecido.');
        exit(1);
      } else if (tabela[Chave(pilha.top(), token.tipo)] != null) {
        //print('Empilhou: ${tabela[Chave(pilha.top(), token.tipo)]!.reversed} na pilha: $pilha e saiu: ${pilha.top()} ');
        var elementos = tabela[Chave(pilha.top(), token.tipo)]!.reversed;
        pilha.pop();
        for (var elemento in elementos) {
          if (elemento != vazio) {
            pilha.push(elemento);
          }
        }
      }
    }
    while (pilhaOperador.isNotEmpty) {
      pilhaOperando.add(pilhaOperador.pop());
    }
    //print("Pilha operandos: $pilhaOperando");
    // print("E o resultado é: ${evaluate(pilhaOperando)}");
    return num.parse(evaluate(pilhaOperando));
  }
}

HashMap<Chave, List<String>> criaTabela() {
  var tabela = HashMap<Chave, List<String>>();
  tabela[Chave(e, TipoToken.exp)] = [t, eLinha];
  tabela[Chave(e, TipoToken.abreParenteses)] = [t, eLinha];
  tabela[Chave(e, TipoToken.numero)] = [t, eLinha];

  tabela[Chave(eLinha, TipoToken.mais)] = [mais, t, eLinha];
  tabela[Chave(eLinha, TipoToken.menos)] = [menos, t, eLinha];
  tabela[Chave(eLinha, TipoToken.fechaParenteses)] = [vazio];
  tabela[Chave(eLinha, TipoToken.eof)] = [vazio];

  tabela[Chave(t, TipoToken.exp)] = [p, tLinha];
  tabela[Chave(t, TipoToken.abreParenteses)] = [p, tLinha];
  tabela[Chave(t, TipoToken.numero)] = [p, tLinha];

  tabela[Chave(tLinha, TipoToken.mais)] = [vazio];
  tabela[Chave(tLinha, TipoToken.menos)] = [vazio];
  tabela[Chave(tLinha, TipoToken.multiplicacao)] = [multiplicacao, p, tLinha];
  tabela[Chave(tLinha, TipoToken.divisao)] = [divisao, p, tLinha];
  tabela[Chave(tLinha, TipoToken.fechaParenteses)] = [vazio];
  tabela[Chave(tLinha, TipoToken.eof)] = [vazio];

  tabela[Chave(p, TipoToken.exp)] = [
    exp,
    abreColchetes,
    f,
    fechaColchetes,
    pLinha
  ];
  tabela[Chave(p, TipoToken.abreParenteses)] = [f, pLinha];
  tabela[Chave(p, TipoToken.numero)] = [f, pLinha];

  tabela[Chave(pLinha, TipoToken.mais)] = [vazio];
  tabela[Chave(pLinha, TipoToken.menos)] = [vazio];
  tabela[Chave(pLinha, TipoToken.multiplicacao)] = [vazio];
  tabela[Chave(pLinha, TipoToken.divisao)] = [vazio];
  tabela[Chave(pLinha, TipoToken.potencia)] = [exponencial, f, pLinha];
  tabela[Chave(pLinha, TipoToken.fechaParenteses)] = [vazio];
  tabela[Chave(pLinha, TipoToken.eof)] = [vazio];

  tabela[Chave(f, TipoToken.abreParenteses)] = [
    abreParenteses,
    e,
    fechaParenteses
  ];
  tabela[Chave(f, TipoToken.numero)] = [id];

  return tabela;
}

final peso = HashMap<TipoToken, int>.of({
  TipoToken.mais: 1,
  TipoToken.menos: 1,
  TipoToken.multiplicacao: 2,
  TipoToken.divisao: 2,
  TipoToken.potencia: 3,
  TipoToken.exp: 4,
});

const List<TipoToken> ops = [
  TipoToken.mais,
  TipoToken.menos,
  TipoToken.multiplicacao,
  TipoToken.divisao,
  TipoToken.potencia,
  TipoToken.exp
];

bool isTerminal(String simbolo) {
  return simbolo[0] != simbolo[0].toUpperCase();
}

bool precede(Token operador, Token token) {
  if (peso[operador.tipo]! >= peso[token.tipo]!) {
    return true;
  }
  return false;
}

bool matchToken(String lexema, Token token) {
  if (lexema == token.lexema) {
    return true;
  }

  if (lexema == id && (token.tipo == TipoToken.numero)) {
    return true;
  }

  return false;
}

String evaluate(List<Token> expressao) {
  final resultado = Pilha<String>();
  for (final simbolo in expressao) {
    if (simbolo.tipo == TipoToken.numero) {
      resultado.push(simbolo.lexema);
    } else if (simbolo.tipo != TipoToken.exp) {
      String operando2 = resultado.pop();
      String operando1 = resultado.pop();
      String aux = operacaoBinaria(simbolo.tipo, operando1, operando2);

      resultado.push(aux);
    } else {
      String operando = resultado.pop();

      String aux = operacaoUnaria(simbolo.tipo, operando);

      resultado.push(aux);
    }
  }
  return resultado.top().replaceAll(',', '.');
}

String operacaoBinaria(TipoToken operador, String operando1, String operando2) {
  num op1 = num.parse(operando1.replaceAll(',', '.'));
  num op2 = num.parse(operando2.replaceAll(',', '.'));
  if (operador == TipoToken.mais) {
    return (op1 + op2).toString();
  }
  if (operador == TipoToken.menos) {
    return (op1 - op2).toString();
  }
  if (operador == TipoToken.multiplicacao) {
    return (op1 * op2).toString();
  }
  if (operador == TipoToken.divisao) {
    return (op1 / op2).toString();
  }
  if (operador == TipoToken.potencia) {
    return math.pow(op1, op2).toString();
  }
  return "Erro";
}

String operacaoUnaria(TipoToken operador, String operando) {
  num op = num.parse(operando.replaceAll(',', '.'));
  return math.exp(op).toString();
}
