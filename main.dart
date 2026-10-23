
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Calculadora(),
  ));
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String visor = '0';
  double primeiroNumero = 0;
  String operacao = '';
  bool novoNumero = false;

  final Color rosa = const Color(0xFFF5D6E3);
  final Color lilas = const Color(0xFFE5DDF7);
  final Color destaque = const Color(0xFFC8B6EB);
  final Color texto = const Color(0xFF55465F);

  void pressionar(String tecla) {
    if ('0123456789'.contains(tecla) && tecla.length == 1) {
      setState(() {
        if (novoNumero || visor == 'Erro') {
          visor = tecla;
          novoNumero = false;
        } else {
          visor = visor == '0' ? tecla : visor + tecla;
        }
      });
    } else if (tecla == '.') {
      setState(() {
        if (novoNumero || visor == 'Erro') {
          visor = '0.';
          novoNumero = false;
        } else if (!visor.contains('.')) {
          visor += '.';
        }
      });
    } else if (tecla == 'C') {
      setState(() {
        visor = '0';
        primeiroNumero = 0;
        operacao = '';
        novoNumero = false;
      });
    } else if (tecla == '⌫') {
      setState(() {
        if (visor.length > 1 && visor != 'Erro' && !novoNumero) {
          visor = visor.substring(0, visor.length - 1);
        } else {
          visor = '0';
          novoNumero = false;
        }
      });
    } else if (tecla == 'n!') {
      fatorial();
    } else if (tecla == '√') {
      raizQuadrada();
    } else if (['+', '−', '×', '÷'].contains(tecla)) {
      if (visor == 'Erro') return;

      setState(() {
        primeiroNumero = double.parse(visor);
        operacao = tecla;
        novoNumero = true;
      });
    } else if (tecla == '=') {
      calcular();
    }
  }

  void calcular() {
    if (operacao.isEmpty || visor == 'Erro') return;

    double segundoNumero = double.parse(visor);
    double resultado = 0;

    if (operacao == '÷' && segundoNumero == 0) {
      erro('Não é possível dividir por zero.');
      return;
    }

    switch (operacao) {
      case '+':
        resultado = primeiroNumero + segundoNumero;
        break;
      case '−':
        resultado = primeiroNumero - segundoNumero;
        break;
      case '×':
        resultado = primeiroNumero * segundoNumero;
        break;
      case '÷':
        resultado = primeiroNumero / segundoNumero;
        break;
    }

    operacao = '';
    mostrarResultado(resultado);
  }

  void fatorial() {
    if (visor == 'Erro') return;

    double numero = double.parse(visor);

    if (numero < 0 ||
        numero != numero.roundToDouble() ||
        numero > 170) {
      erro('Digite um número inteiro entre 0 e 170.');
      return;
    }

    double resultado = 1;

    for (int i = 1; i <= numero.toInt(); i++) {
      resultado *= i;
    }

    mostrarResultado(resultado);
  }

  void raizQuadrada() {
    if (visor == 'Erro') return;

    double numero = double.parse(visor);

    if (numero < 0) {
      erro('Não existe raiz real de número negativo.');
      return;
    }

    mostrarResultado(sqrt(numero));
  }

  void mostrarResultado(double resultado) {
    setState(() {
      if (!resultado.isFinite) {
        visor = 'Erro';
      } else if (resultado.abs() < 1e15 &&
          resultado == resultado.roundToDouble()) {
        visor = resultado.toInt().toString();
      } else {
        visor = resultado.toString();
      }

      novoNumero = true;
    });
  }

  void erro(String mensagem) {
    setState(() {
      visor = 'Erro';
      operacao = '';
      novoNumero = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Widget botao(String titulo) {
    bool especial = ['+', '−', '×', '÷', '='].contains(titulo);
    bool rosaBotao = ['C', 'n!', '√'].contains(titulo);

    return ElevatedButton(
      onPressed: () => pressionar(titulo),
      style: ElevatedButton.styleFrom(
        backgroundColor: especial
            ? destaque
            : rosaBotao
                ? rosa
                : lilas,
        foregroundColor: texto,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          titulo,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget linha(List<String> teclas) {
    return Expanded(
      child: Row(
        children: teclas.map((tecla) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: botao(tecla),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FC),
      appBar: AppBar(
        title: Text(
          'Calculadora',
          style: TextStyle(
            color: texto,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFF8FC),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 110,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8EAF4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  visor,
                  style: TextStyle(
                    color: texto,
                    fontSize: 42,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  linha(['n!', 'C', '⌫', '÷']),
                  linha(['7', '8', '9', '×']),
                  linha(['4', '5', '6', '−']),
                  linha(['1', '2', '3', '+']),
                  linha(['√', '0', '.', '=']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
