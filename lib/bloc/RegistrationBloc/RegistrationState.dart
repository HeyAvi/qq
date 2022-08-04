part of 'RegistrationBloc.dart';

class RegistrationState extends Equatable {
  final int version;
  final Name name;
  final Email email;
  final MobileNumber mobileNumber;
  final FormzStatus? status;

  const RegistrationState({required this.version,this.name = const Name.pure(),this.email = const Email.pure(),this.mobileNumber = const MobileNumber.pure(),this.status});


  RegistrationState copyWith({
    MobileNumber? mobileNumber,
    Name? name,
    Email? email,
    FormzStatus? status,
    int? version
  }) {
    return RegistrationState(
        version: version ?? this.version,
        name: name ?? this.name,
        email: email ?? this.email,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        status: status ?? this.status
    );
  }


  @override
  List<Object> get props => [version];

}



class RegistrationInitialState extends RegistrationState {

  const RegistrationInitialState({
    this.context,
    required this.version
  }):super(version: version);

  final BuildContext? context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class RegistrationCompleteState extends RegistrationState {

  const RegistrationCompleteState({
    this.context,
    required this.version
  }):super(version: version);

  final BuildContext? context;
  final int version;

  @override
  List<Object> get props => [version];
}