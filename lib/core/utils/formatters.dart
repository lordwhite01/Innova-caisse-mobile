import 'package:intl/intl.dart';

final _amount = NumberFormat('#,##0', 'fr');
final _date = DateFormat('dd/MM/yyyy');

/// Affiche un montant en FCFA, ex. "30 000 FCFA".
String formatFcfa(int value) =>
    '${_amount.format(value).replaceAll('\u202F', ' ')} FCFA';

String formatDate(DateTime date) => _date.format(date);
