import 'package:flipper_login/login.dart';
import 'package:flutter/material.dart';

class ButtonPortrait extends StatefulWidget {
  const ButtonPortrait({Key key})
      : super(key: key);
 
  @override
  _ButtonPortraitState createState() => _ButtonPortraitState();
}

class _ButtonPortraitState extends State<ButtonPortrait> {
   // ignore: always_declare_return_types
   _showModalBottomSheet(context) {
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
    return AspectRatio(
      aspectRatio: 2 / 2,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 20,
            ),
            Container(
              color: Colors.blue,
              child: SizedBox(
                width: 380,
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
            Container(
              height: 20,
            ),
            Container(
              // color: Colors.white,
              child: SizedBox(
                width: 380,
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
            Container(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
