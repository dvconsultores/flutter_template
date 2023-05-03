class TicketModel {
  TicketModel({
    required this.name,
    required this.value,
  });

  final String name;
  final int value;

  TicketModel copyWith({
    required String name,
    required int value,
  }) =>
      TicketModel(
        name: name,
        value: value,
      );
}
