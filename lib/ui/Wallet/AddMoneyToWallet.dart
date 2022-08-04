import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/bloc/WalletBloc/WalletBloc.dart';
import 'package:qq/repository/WalletRepository.dart';
import 'package:qq/ui/Wallet/Wallet.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMoneyToWallet extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocProvider(
        create: (_) => WalletBloc(WalletRepository(Dio())),
        child: AddMoneyToWalletSateful(),
      ),
    );
  }
}


class AddMoneyToWalletSateful extends StatefulWidget {
  const AddMoneyToWalletSateful({Key? key}) : super(key: key);

  @override
  _AddMoneyToWalletState createState() => _AddMoneyToWalletState();
}


class _AddMoneyToWalletState extends State<AddMoneyToWalletSateful> {

  TextEditingController walletController = new TextEditingController();
  String userId = "";

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();

  }

  Future<void> getSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId").toString();
  }

  Future<bool> _willPopCallback() async {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leadingWidth: 250.w,
              automaticallyImplyLeading: false,
              toolbarHeight: 500.h,
              title: Container(
                padding: EdgeInsets.only(left: 10.w),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: ImageIcon( AssetImage("assets/left-arrow.png", ), color: Colors.black,size: 20.sp,),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Text("Wallet", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Color(0xff3E3C3C),
                        ),),
                        /*Text("Rs. 500.00", style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xff3E3C3C),
                    ),)*/
                      ],
                    )
                  ],
                ),
              )
          ),
        ),
        body: BlocBuilder<WalletBloc, WalletState>(
          builder: (context,state){
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w,right: 15.w,bottom: 20.h,top: 30.h),
                  child: TextField(
                      keyboardType: TextInputType.number,
                      controller: walletController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.h),),
                          labelText: 'Add Money to Wallet',
                          hintText: 'Add Money to Wallet',
                          //suffixIcon: Icon(Icons.wallet_giftcard_sharp, color: ColorConstants.primaryColor3),
                          errorText: (state.amountMoney.valid) ? null : (state.amountMoney.value != "" && !state.amountMoney.valid) ? "Invalid Amount" : null,
                          errorStyle: TextStyle(color: Colors.red)
                      ),
                      onChanged: (value) {
                        context.read<WalletBloc>().add(AmountMoneyChanged(amountMoney: value));
                      }
                  ),
                ),

                SubmitButton()
              ],
            );
          },
        )
    ), onWillPop: _willPopCallback);
  }




}



class SubmitButton extends StatefulWidget {
  @override
  SubmitButtonState createState() => SubmitButtonState();
}

class SubmitButtonState extends State<SubmitButton>  {

  String userId = "";

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();

  }

  Future<void> getSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId").toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if(state is WalletCompleteState){
          Navigator.push(context, MaterialPageRoute(builder: (Context)=>Wallet()));
        }
      },
      child: InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 15.w,right: 15.w),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: ColorConstants.primaryColor3,
              borderRadius: BorderRadius.circular(10.h)

          ),
          child: Center(
            child: Text('ADD',style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp
            ),),
          ),
        ),
        onTap: (){
          BlocProvider.of<WalletBloc>(context).add(SubmitWalletEvent(context: context, amount: BlocProvider.of<WalletBloc>(context).state.amountMoney.value,userId: userId,status:"COMPLETED"));
        },
      ),
    );
  }

}











