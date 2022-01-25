// import 'package:flipper_view_models/login_viewmodel.dart';
// import 'package:flipper_view_models/login_viewmodel.dart';
import 'package:flipper_web/core/constants/color_constants.dart';
import 'package:flipper_web/core/widgets/input_widget.dart';
import 'package:flipper_web/web_view.dart';

import 'package:fluent_ui/fluent_ui.dart';
// import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

import 'screens/login/components/slider_widget.dart';

class Login extends StatefulWidget {
  Login({required this.title});
  final String title;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  var tweenLeft = Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
      .chain(CurveTween(curve: Curves.ease));
  var tweenRight = Tween<Offset>(begin: Offset(0, 0), end: Offset(2, 0))
      .chain(CurveTween(curve: Curves.ease));

  AnimationController? _animationController;

  var _isMoved = false;

  bool isChecked = false;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
                // color: Colors.white,
                child: SliderWidget(),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
                color: bgColor,
                child: Center(
                  child: Card(
                    //elevation: 5,
                    color: bgColor,
                    child: Container(
                      padding: EdgeInsets.all(42),
                      width: MediaQuery.of(context).size.width / 3.6,
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                          ),
                          Image.asset("assets/logo/logo_icon.png", scale: 3),
                          SizedBox(height: 24.0),
                          Flexible(
                            child: Stack(
                              children: [
                                SlideTransition(
                                  position:
                                      _animationController!.drive(tweenRight),
                                  child: Stack(
                                    fit: StackFit.loose,
                                    clipBehavior: Clip.none,
                                    children: [
                                      _loginScreen(context),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container _loginScreen(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 0.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputWidget(
              keyboardType: TextInputType.phone,
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              onChanged: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                if (value == null) {
                  return "Please enter phone number";
                }
                // regex to validate a Afghanistan, Albania, Algeria, Andorra, Angola, Antigua & Deps, Argentina, Armenia, Australia, Austria,
                //Azerbaijan, Bahamas, Bahrain, Bangladesh, Barbados, Belarus,
                //Belgium, Belize, Benin, Bhutan, Bolivia, Bosnia Herzegovina,
                //Botswana, Brazil, Brunei, Bulgaria, Burkina, Burundi,
                //Cambodia, Cameroon, Canada, Cape Verde, Central African Rep,
                //Chad, Chile, China, Colombia, Comoros, Congo, Congo {Democratic Rep},
                //Costa Rica, Croatia, Cuba, Cyprus, Czech Republic, Denmark, Djibouti, Dominica,
                //Dominican Republic, East Timor, Ecuador, Egypt, El Salvador, Equatorial Guinea,
                //Eritrea, Estonia, Ethiopia, Fiji, Finland, France, Gabon, Gambia, Georgia, Germany,
                //Ghana, Greece, Grenada, Guatemala, Guinea, Guinea-Bissau, Guyana, Haiti, Honduras,
                //Hungary, Iceland, India, Indonesia, Iran, Iraq, Ireland {Republic}, Israel, Italy,
                //Ivory Coast, Jamaica, Japan, Jordan, Kazakhstan, Kenya, Kiribati, Korea North,
                //Korea South, Kosovo, Kuwait, Kyrgyzstan, Laos, Latvia, Lebanon, Lesotho, Liberia,
                //Libya, Liechtenstein, Lithuania, Luxembourg, Macedonia, Madagascar, Malawi, Malaysia,
                //Maldives, Mali, Malta, Marshall Islands, Mauritania, Mauritius, Mexico, Micronesia,
                //Moldova, Monaco, Mongolia, Montenegro, Morocco, Mozambique, Myanmar, {Burma}, Namibia,
                //Nauru, Nepal, Netherlands, New Zealand, Nicaragua, Niger, Nigeria, Norway, Oman, Pakistan,
                //Palau, Panama, Papua New Guinea, Paraguay, Peru, Philippines, Poland, Portugal, Qatar,
                //Romania, Russian Federation, Rwanda, St Kitts & Nevis, St Lucia, Saint Vincent & the Grenadines,
                //Samoa, San Marino, Sao Tome & Principe, Saudi Arabia, Senegal, Serbia, Seychelles,
                //Sierra Leone, Singapore, Slovakia, Slovenia, Solomon Islands, Somalia, South Africa,
                //South Sudan, Spain, Sri Lanka, Sudan, Suriname, Swaziland, Sweden, Switzerland,
                //Syria, Taiwan, Tajikistan, Tanzania, Thailand, Togo, Tonga, Trinidad & Tobago, Tunisia,
                //Turkey, Turkmenistan, Tuvalu, Uganda, Ukraine, United Arab Emirates, United Kingdom,
                //United States, Uruguay, Uzbekistan, Vanuatu, Vatican City, Venezuela, Vietnam, Yemen,
                //Zambia, Zimbabwe, phone number
                if (!RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                    .hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
              },

              topLabel: "Phone number",

              hintText: "Enter Phone number",
              // prefixIcon: FlutterIcons.chevron_left_fea,
            ),
            SizedBox(height: 8.0),
            Button(
              child: Text("Sign In"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashBoard()),
                  );
                }
              },
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
