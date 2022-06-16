import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mobile_auth/homescreen.dart';


class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  var phone = "";
  var otp = "";
  String verificationID = "";
  final auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  final _myFormKey = GlobalKey<FormState>();
  final  phonecontroller = TextEditingController();
  final  otpcontroller  = TextEditingController();

  void verifyOTP() async{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpcontroller.text);

    await auth.signInWithCredential(credential).then(
            (value){
              print("Your are logged In successfully");
              // Fluttertoast.showToast(
              //   msg:"Your are logged In successfully",
              //   toastLength: Toast.LENGTH_SHORT,
              //   gravity: ToastGravity.CENTER,
              //   timeInSecForIosWeb: 1,
              //   backgroundColor: Colors.lightBlueAccent,
              //   textColor: Colors.black,
              //   fontSize: 16.0,
              // );
            },
    ).whenComplete(
            (){
              Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => HomeScreen(),),);
            }
    );
  }

  void loginWithPhone() async{
    auth.verifyPhoneNumber(
        phoneNumber: "+91" + phonecontroller.text,
        verificationCompleted:(PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value){
            print("You are logged in successfully");
          });
        },
        verificationFailed: (FirebaseAuthException e){
          print(e.message);
        },
        codeSent: (String verificationId,int? resendToken){
          otpVisibility = true;
          verificationID = verificationId;
          setState((){});
        },
        codeAutoRetrievalTimeout: (String verificationId){

        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 18
          ),
        ),
      ),

      body: Container(

        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,



        child: Stack(
            children: <Widget>[
              Positioned(
                child: SingleChildScrollView(
                  child: Form(
                    key: _myFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:<Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 20.0),
                          child: TextFormField(
                            controller: phonecontroller,

                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Mobile number';
                              }
                              if (value.length != 10) {
                                return 'Mobile number should be of 10 digits';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Mobile number",
                              hintText: "Enter your Mobile number",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blueAccent,
                                    width: 1.0,),
                                  borderRadius : BorderRadius.circular(5.0),
                                )
                            ),
                          ),

                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Visibility(
                            visible: otpVisibility,
                            child: TextFormField(
                              obscureText: true,
                              controller: otpcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter OTP';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText:"Verify Code",
                                  hintText: "Enter your verification code",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1.0,),
                                    borderRadius : BorderRadius.circular(5.0),
                                  )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                        icon: Icon(Icons.login),
                        label: Text(otpVisibility ? "Verify" : "Login",),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue[800],
                            elevation: 6,
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 150.0)
                        ),
                      onPressed: () async {
                        if (_myFormKey.currentState!.validate() && otpVisibility ) {
                          verifyOTP();
                        }
                        else{
                          loginWithPhone();
                        }
                      },
                    ),
                  ),
                ),
              ),

            ]
        ),

      ) ,
    );
  }
}
