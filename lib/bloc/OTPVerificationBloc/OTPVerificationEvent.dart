part of 'OTPVerificationBloc.dart';


abstract class OTPVerificationEvent extends Equatable {
  const OTPVerificationEvent();

  @override
  List<Object> get props => [];
}

class VerifyOTPEvent extends OTPVerificationEvent {
  const VerifyOTPEvent({required this.context  ,required this.mobileNumber,required this.otpNumber});

  final String mobileNumber;
  final String otpNumber;
  final BuildContext context;


  @override
  List<Object> get props => [context];

}

class SendOTPEvent extends OTPVerificationEvent {
  const SendOTPEvent({required this.context  ,required this.mobileNumber});

  final String mobileNumber;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}