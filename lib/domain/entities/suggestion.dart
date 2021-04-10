import 'package:equatable/equatable.dart';

class Suggestion extends Equatable {
  final String description;
  final String city;
  const Suggestion({
    required this.city,
    required this.description,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        description,
        city,
      ];
}
