// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:io';

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
  void parse() {
    var token = tokenizador.proximoToken();
    final pilha = Pilha<String>();
    pilha.push(fimDeCadeia);
    pilha.push(e);

    while (pilha.top() != fimDeCadeia) {
      if (matchToken(pilha.top(), token)) {
        print(
            "Deu match: ${pilha.top()} com a nossa entrada: ${token.lexema}, então removemos o ${pilha.top()}");
        pilha.pop();
        token = tokenizador.proximoToken();
      } else if (isTerminal(pilha.top())) {
        print('Erro sintático: o símbolo ${token.lexema} não é reconhecido.');
        exit(1);
      } else if (tabela[Chave(pilha.top(), token.tipo)] == null) {
        print(
            'Erro sintático: o símbolo ${token.lexema} não é reconhecidoaaaa.');
        exit(1);
      } else if (tabela[Chave(pilha.top(), token.tipo)] != null) {
        print(
            'Empilhou: ${tabela[Chave(pilha.top(), token.tipo)]!.reversed} na pilha: $pilha e saiu: ${pilha.top()} ');
        var elementos = tabela[Chave(pilha.top(), token.tipo)]!.reversed;
        pilha.pop();
        for (var elemento in elementos) {
          if (elemento != vazio) {
            pilha.push(elemento);
          }
        }
      }
    }
  }
}

HashMap<Chave, List<String>> criaTabela() {
  var tabela = HashMap<Chave, List<String>>();
  tabela[Chave(e, TipoToken.exp)] = [t, eLinha];
  tabela[Chave(e, TipoToken.abreColchetes)] = [t, eLinha];
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

bool isTerminal(String simbolo) {
  return simbolo[0] != simbolo[0].toUpperCase();
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
