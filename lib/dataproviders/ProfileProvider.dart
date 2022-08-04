import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq/utils/ApiConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ProfileException implements Exception {

  ProfileException(error){
    print(error);
  }
}

class ProfileProvider {
  ProfileProvider(this.client);

  final Dio client;

  String apiUrl = "";

  //Get Server Config
  Future<Response?> getProfileData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();


    apiUrl = ApiConstants.BASE_URL + ApiConstants.show_by_app_key +prefs.getString("userDataKey").toString();


    try {
      Response response = await client.get(apiUrl);
      print(response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }


  Future<Response?> updateProfileData(BuildContext context,String name , String gender , String dob ,String email , String image,String userId ) async {

    FormData data;

    data = FormData.fromMap({
      "name":name,
      "gender":gender,
      "dob" : dob,
      "email": email,
      "image": image
    });

    apiUrl = ApiConstants.BASE_URL +"Users/"+ ApiConstants.update+userId;


    try {
      Response response = await client.post(apiUrl,data: data);
      return response;
    } catch (error) {
      return null;
    }
  }


}
