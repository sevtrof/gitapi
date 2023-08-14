import 'package:equatable/equatable.dart';

class Repository extends Equatable {
  final String name;
  final String owner;
  final String description;
  final int stars;
  final int forks;

  const Repository({
    required this.name,
    required this.owner,
    required this.description,
    required this.stars,
    required this.forks,
  });

  @override
  List<Object?> get props => [name, description, stars, forks, owner];
}
