part of 'ProfileBloc.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileDataEvent extends ProfileEvent {
  const GetProfileDataEvent({required this.context});

  final BuildContext context;


  @override
  List<Object> get props => [context];

}


class UpdateProfileDataEvent extends ProfileEvent {
  const UpdateProfileDataEvent({required this.context,required this.name,required this.gender,required this.dob,required this.email,required this.image,required this.userId});

  final BuildContext context;
  final String name;
  final String gender;
  final String dob;
  final String email;
  final String image;
  final String userId;


  @override
  List<Object> get props => [context];

}

