import 'package:bloc/bloc.dart';
import 'package:crypto_chart_mobile/features/crypto/domain/usecases/submit_request_uc.dart';
import 'package:equatable/equatable.dart';

part 'submit_request_event.dart';
part 'submit_request_state.dart';

class SubmitRequestBloc extends Bloc<SubmitRequestEvent, SubmitRequestState> {
  final SubmitRequestUc submitRequestUc;

  SubmitRequestBloc({
    required this.submitRequestUc,
  }) : super(SubmitRequestInitial()) {
    on<SubmitRequest>((event, emit) async {
      emit(SubmitRequestLoading());
      final result = await submitRequestUc(
        action: event.action,
        symbol: event.symbols
      );
      emit(SubmitRequestSuccess(result!));
    });
  }
}
