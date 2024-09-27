part of 'submit_request_bloc.dart';

abstract class SubmitRequestState extends Equatable {
  const SubmitRequestState();

  @override
  List<Object> get props => [];
}

class SubmitRequestInitial extends SubmitRequestState {}

class SubmitRequestLoading extends SubmitRequestState {}

class SubmitRequestSuccess extends SubmitRequestState {
  final Stream dataEntity;

  const SubmitRequestSuccess(this.dataEntity);

  @override
  List<Object> get props => [
        dataEntity,
      ];
}

class SubmitRequestFailure extends SubmitRequestState {}
