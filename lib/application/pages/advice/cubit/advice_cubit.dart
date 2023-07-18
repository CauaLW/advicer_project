import 'package:advicer_project/domain/features/advice_feature.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'advice_cubit_state.dart';

class AdviceCubit extends Cubit<AdviceCubitState> {
  final AdviceFeature adviceFeature;
  AdviceCubit({required this.adviceFeature}) : super(AdviceInitialState());

  void adviceRequested() async {
    emit(AdviceStateLoading());

    final failureOrAdvice = await adviceFeature.getAdvice();

    failureOrAdvice.fold(
      (failure) => emit(AdviceStateError(message: failure.errorMessage())),
      (advice) => emit(AdviceStateLoaded(advice: advice.advice)),
    );
  }
}
