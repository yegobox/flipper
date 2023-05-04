import 'package:flipper_dashboard/reponsiveness.dart';
import 'package:flutter/material.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key,
        String userName, String userProfileImg) =>
    AppBar(
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Image.asset(
                    "assets/logo.png",
                    width: 28,
                  ),
                ),
              ],
            )
          : IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                key.currentState!.openDrawer();
              }),
      title: Container(
        child: Row(
          children: [
            Visibility(
              visible: !ResponsiveWidget.isSmallScreen(context),
              child: Text(
                'Flipper',
                style: TextStyle(
                    color: Color(0xFFA4A6B3),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Container()),
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Color(0xFF363740),
                ),
                onPressed: () {}),
            Stack(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF363740).withOpacity(.7),
                    ),
                    onPressed: () {}),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 12,
                    height: 12,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Color(0xFF3C19C0),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Color(0xFFF7F8FC), width: 2)),
                  ),
                )
              ],
            ),
            Container(
              width: 1,
              height: 22,
              color: Color(0xFFF7F8FC),
            ),
            SizedBox(
              width: 24,
            ),
            Text(userName,
                style: TextStyle(
                  color: Color(0xFFA4A6B3),
                )),
            SizedBox(
              width: 16,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFF3C19C0).withOpacity(.5),
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: Color(0xFFF7F8FC),
                  backgroundImage: NetworkImage(userProfileImg),
                ),
              ),
            )
          ],
        ),
      ),
      iconTheme: IconThemeData(color: Color(0xFF363740)),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
