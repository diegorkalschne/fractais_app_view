/// Remove o formato decimal "0" quando o double não tem casas decimais diferente de 0
///
/// Exemplo: 20.0 -> 20
/// Exemplo: 20.2 -> 20.2
String formatZeroDouble(double number, [int fractionDigits = 0]) {
  if (number == number.toInt()) {
    return number.toInt().toString();
  } else {
    return number.toStringAsFixed(fractionDigits);
  }
}
