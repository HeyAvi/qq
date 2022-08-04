part of 'OTPVerificationBloc.dart';

class OTPVerificationState extends Equatable {
  final int version;
  const OTPVerificationState({required this.version});

  @override
  List<Object> get props => [version];

}



class OTPVerificationInitialState extends OTPVerificationState {

  const OTPVerificationInitialState({
    this.context,
    required this.version
  }):super(version: version);

  final BuildContext? context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class OTPVerificationCompleteState extends OTPVerificationState {

  const OTPVerificationCompleteState({
    this.context,
    required this.version,
    required this.registrationRequired
  }):super(version: version);

  final BuildContext? context;
  final int version;
  final bool registrationRequired;

  @override
  List<Object> get props => [version];
}

class SendOTPCompleteState extends OTPVerificationState {

  const SendOTPCompleteState({
    this.context,
    required this.version,
  }):super(version: version);

  final BuildContext? context;
  final int version;


  @override
  List<Object> get props => [version];
}