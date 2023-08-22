import 'package:equatable/equatable.dart';

class CustomError extends Equatable {
  final String errMag;

  const CustomError({
    this.errMag = '',
  });

  @override
  List<Object> get props => [errMag];

  @override
  String toString() => 'CustomError(errMag: $errMag)';
}
