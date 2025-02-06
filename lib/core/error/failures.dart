abstract class Failures {
  final String message;
  const Failures(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failures {
  ServerFailure(super.message);
}

class CacheFailure extends Failures {
  CacheFailure(super.message);
}

class TimeoutFailure extends Failures {
  TimeoutFailure(super.message);
}

class UnauthorizedFailure extends Failures {
  UnauthorizedFailure(super.message);
}

class FormatFailure extends Failures {
  FormatFailure(super.message);
}
