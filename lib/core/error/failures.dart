import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final List properties;

  const Failures([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => properties;
}

//General Failures

class ServerFailure extends Failures{}
class CacheFailure extends Failures{}
