part of 'submit_request_bloc.dart';

abstract class SubmitRequestEvent extends Equatable {
  const SubmitRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitRequest extends SubmitRequestEvent {
  final String action;
  final String? symbols;

  const SubmitRequest({
    required this.action,
    this.symbols,
  }) : super();

  @override
  List<Object> get props => [action];
}
