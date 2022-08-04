part of 'EnterNumberBloc.dart';


abstract class EnterNumberEvent extends Equatable {
  const EnterNumberEvent();

  @override
  List<Object> get props => [];
}

class SendOTPEvent extends EnterNumberEvent {
  const SendOTPEvent({required this.context  ,required this.mobileNumber});

  final String mobileNumber;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}

class MobileNumberChanged extends EnterNumberEvent {
  const MobileNumberChanged({required this.mobileNumber});

  final String mobileNumber;

  @override
  List<Object> get props => [mobileNumber];
}