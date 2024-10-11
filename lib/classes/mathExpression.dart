import 'package:math_expressions/math_expressions.dart';
import 'package:math_keyboard/math_keyboard.dart';
String simply(String input) {
// Remplacer \log_e(e) par 1
  String step1 = input.replaceAll(RegExp(r'\\cdot\\log_{{e}}\({e}\)'), '');

  String result = step1.replaceAll(RegExp(r"[+-]?(\\log_{{e}}\({e}\)|\\log_{{e}}\({e}\))"),'1');

  // Remplacer \log_e(x) par ln(x)
  String step2 =
  result.replaceAllMapped(RegExp(r'\\log_{{e}}\(([^)]+)\)'), (match) {
    return '\\ln(${match.group(1)})'; // Utilisation de match.group(1) pour insérer le contenu entre les parenthèses
  });
  return step2;
}



class Fonction{
  static String derive(String fct){

    Parser p = Parser();
    Expression exp = p.parse(fct);
    exp = exp.simplify();
    Expression expDerived = exp.derive('x');
    expDerived = expDerived.simplify();
    final texNode = convertMathExpressionToTeXNode(expDerived);
    final texString = texNode.buildTeXString();
    final texStr = simply(texString);
    return  texStr;
  }
}

