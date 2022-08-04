import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qq/dataproviders/EnterNumberProvider.dart';
import 'package:qq/dataproviders/ProfileProvider.dart';

class ProfileRepository{

  final Dio client;

  late final ProfileProvider provider ;

  ProfileRepository(this.client){
    provider = new ProfileProvider(client);
  }


  Future<Response?> getProfileData(BuildContext context ) => provider.getProfileData(context);

  Future<Response?> updateProfileData(BuildContext context,String name , String gender , String dob ,String email , String image , String userId) => provider.updateProfileData(context,name,gender,dob,email,image,userId);

}