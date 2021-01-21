import 'package:flipper_login/login.dart';
import 'package:flutter/material.dart';

class SignUpLoginButton extends StatelessWidget {
  const SignUpLoginButton({Key key, this.portrait = false})
      : super(key: key);
  final bool portrait;
 
   // ignore: always_declare_return_types
   _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:true,
      builder: (BuildContext context) {
        return Padding(
          padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child:Container(
          child: const Login(),
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ));
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:50),
      child: Column(
        children: <Widget>[
         
          Padding(
            padding: const EdgeInsets.only(left:18.0,right: 18.0,top:0),
            child: Container(
              color: Colors.blue,
              
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: FlatButton(
                  onPressed: (){
                    _showModalBottomSheet(context);
                  },
                  color: Colors.blue,
                  child: Text(
                    'Create Account',
                    style:  Theme.of(context).textTheme.headline6.copyWith(color:Colors.white),
                  ),
                ),
              ),
            ),
          ),
          
          Container(
            // color: Colors.white,
             padding: const EdgeInsets.only(left:18.0,right: 18.0,top:40),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlineButton(
                color: Colors.blue,
                child: Text(
                  'Sign in',
                  style:   Theme.of(context).textTheme.headline6.copyWith(color:Colors.blue),
                ),
                onPressed: (){
                  _showModalBottomSheet(context);
                },
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}
