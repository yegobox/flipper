import 'package:flipper_chat/lite/data.dart';
import 'package:flipper_chat/lite/helpers.dart';
// import 'package:flipper_chat/widgets/container_dashed/container_dashed.dart';
import 'package:flutter/material.dart';

import 'container_dashed/container_dashed.dart';

class Historys extends StatelessWidget {
  const Historys({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        itemCount: DataW.listHistory.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemBuilder: (__, index) {
          final history = DataW.listHistory[index];
          return Container(
            margin: const EdgeInsets.only(right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ContainerDashed(
                        boxShape: BoxShape.circle,
                        strokeColor: Colors.blue,
                        strokeCap: StrokeCap.round,
                        strokeWidth: 2,
                        blankLength: 5,
                        numLines: history.posts.length,
                        child: CircleAvatar(
                          minRadius: 30,
                          maxRadius: 30,
                          backgroundColor: Helpers.greyLigthColor,
                          backgroundImage: AssetImage(history.user.img),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Helpers.greyLigthColor,
                            backgroundImage:
                                AssetImage(history.user.imgProfile),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  history.user.name,
                  style: Helpers.txtHistoryStyle,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
