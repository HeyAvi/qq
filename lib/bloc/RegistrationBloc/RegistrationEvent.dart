part of 'RegistrationBloc.dart';


abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegisterEvent extends RegistrationEvent {
  const RegisterEvent({required this.context  ,required this.name,required this.email,required this.phone});

  final String name;
  final String email;
  final String phone;
  final BuildContext context;


  @override
  List<Object> get props => [context];

}


class NameChanged extends RegistrationEvent {
  const NameChanged({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class EmailChanged extends RegistrationEvent {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class MobileNumberChanged extends RegistrationEvent {
  const MobileNumberChanged({required this.mobileNumber});

  final String mobileNumber;

  @override
  List<Object> get props => [mobileNumber];
}