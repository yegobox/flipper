import 'package:flipper_models/isar/social.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/views/chat_list/chat_list_view.dart';
import 'package:flipper_socials/ui/widgets/bubble_type.dart';
import 'package:flipper_socials/ui/widgets/chat_bubble.dart';
import 'package:flipper_socials/ui/widgets/custom_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/constants.dart';

import 'home_viewmodel.dart' as social;

class HomeViewMobile extends ViewModelWidget<social.HomeViewModel> {
  const HomeViewMobile({super.key});

  @override
  Widget build(BuildContext context, social.HomeViewModel viewModel) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // set the status bar color
        statusBarIconBrightness:
            Brightness.dark, // set the status bar icons color
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Scaffold(
          body: StreamBuilder<Social>(
              stream: null,
              // stream: ProxyService.isar
              //     .socialsStream(branchId: ProxyService.box.getBranchId() ?? 0),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const ChatListView();
                } else {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Text.rich(
                          TextSpan(
                            text: 'Connect your business and reply\n',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 20,
                                height: 1.5,
                                fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: 'to your vendors instantly',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 20,
                                    height: 1.5,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 64.0, right: 144, left: 144),
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage("assets/c.png",
                                  package: "flipper_socials"),
                              radius: 80,
                            ),
                            Positioned(
                              bottom: 20,
                              right: 0,
                              child: ChatBubble(
                                clipper:
                                    CustomPainte(type: BubbleType.sendBubble),
                                alignment: Alignment.bottomCenter,
                                margin: const EdgeInsets.only(top: 20),
                                backGroundColor: const Color(0xffDFF6FF),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: const Text(
                                    "Mwiriwe?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 37.0, right: 50),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    "assets/a.png",
                                    package: "flipper_socials",
                                  ),
                                  radius: 80,
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 0,
                                  child: ChatBubble(
                                    clipper: CustomPainte(
                                        type: BubbleType.sendBubble),
                                    alignment: Alignment.bottomCenter,
                                    margin: const EdgeInsets.only(top: 20),
                                    backGroundColor: const Color(0xffDFF6FF),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      child: const Text(
                                        "Duhure dupange!",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: AssetImage("assets/b.png",
                                      package: "flipper_socials"),
                                  radius: 80,
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 0,
                                  child: ChatBubble(
                                    clipper: CustomPainte(
                                        type: BubbleType.sendBubble),
                                    alignment: Alignment.bottomCenter,
                                    margin: const EdgeInsets.only(top: 20),
                                    backGroundColor: const Color(0xffDFF6FF),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      child: const Text(
                                        'Mpa chips ebyiri',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      /// a flat button bellow
                      Padding(
                        padding: const EdgeInsets.only(top: 75.0),
                        child: SizedBox(
                          height: 45,
                          width: 140,
                          child: OutlinedButton(
                            onPressed: viewModel.sendUsIntrestRequest,
                            style: primaryButtonStyle.copyWith(
                                shape: MaterialStateProperty.resolveWith<
                                        OutlinedBorder>(
                                    (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4)))),
                            child: const Text('Add Channels',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 75.0),
                        child: SizedBox(
                          height: 45,
                          width: 140,
                          child: OutlinedButton(
                            onPressed: viewModel.returnToApps,
                            style: primaryButtonStyle.copyWith(
                                shape: MaterialStateProperty.resolveWith<
                                        OutlinedBorder>(
                                    (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4)))),
                            child: const Text('Return to Apps',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
