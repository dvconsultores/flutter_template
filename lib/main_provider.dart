import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_platzi_trips/utils/model/ticket.dart';

class MainProvider extends ChangeNotifier {
  // * Navigation
  int indexTab = 1;
  void setNavigationIndex(int index) {
    indexTab = index;
  }

  final totalTickets = <Ticket>[];
  final names = <String>["pepito", "pedro", "armando", "carlos", "pinocho"];
  int count = 1;

  void addTicket() {
    totalTickets.add(Ticket(
      name: names[Random().nextInt(names.length)],
      value: count,
    ));
    count++;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
