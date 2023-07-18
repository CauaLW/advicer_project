import 'package:advicer_project/domain/features/advice_feature.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advice_event.dart';
part 'advice_state.dart';

class AdviceBloc extends Bloc<AdviceEvent, AdviceState> {
  final AdviceFeature adviceFeature;
  AdviceBloc({required this.adviceFeature}) : super(AdviceInitialState()) {
    on<AdviceRequestedEvent>((event, emit) async {
      emit(AdviceStateLoading());

      final failureOrAdvice = await adviceFeature.getAdvice();

      failureOrAdvice.fold(
        (failure) => emit(AdviceStateError(message: failure.errorMessage())),
        (advice) => emit(AdviceStateLoaded(advice: advice.advice)),
      );
    });
  }
}
