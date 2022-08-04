part of 'ProfileBloc.dart';

class ProfileState extends Equatable {
  final int version;
  const ProfileState({required this.version});

  @override
  List<Object> get props => [version];

}



class ProfileInitialState extends ProfileState {

  const ProfileInitialState({
    this.context,
    required this.version
  }):super(version: version);

  final BuildContext? context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class ProfileCompleteState extends ProfileState {

  const ProfileCompleteState({
    this.context,
    required this.version
  }):super(version: version);

  final BuildContext? context;
  final int version;

  @override
  List<Object> get props => [version];
}