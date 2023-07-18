part of 'advice_bloc.dart';

@immutable
abstract class AdviceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdviceInitialState extends AdviceState {}

class AdviceStateLoading extends AdviceState {}

class AdviceStateLoaded extends AdviceState {
  final String advice;
  AdviceStateLoaded({required this.advice});

  @override
  List<Object?> get props => [advice];
}

class AdviceStateError extends AdviceState {
  final String message;
  AdviceStateError({required this.message});

  @override
  List<Object?> get props => [message];
}
