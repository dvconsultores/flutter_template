import 'dart:math';

import 'package:flutter_detextre4/routes/search/model/ticket_model.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SearchBloc implements Bloc {
  // ? just for sohwcase
  final totalTickets = <TicketModel>[];
  final names = <String>["pepito", "pedro", "armando", "carlos", "pinocho"];
  int count = 1;

  void addTicket() {
    totalTickets.add(TicketModel(
      name: names[Random().nextInt(names.length)],
      value: count,
    ));
    count++;
  }

  // ------------------------------------------------------------------------ //

  @override
  void dispose() {}
}
