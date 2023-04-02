import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/widgets/bubble_type.dart';
import 'package:flipper_socials/ui/widgets/chat_bubble.dart';
import 'package:flipper_socials/ui/widgets/custom_paint.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeViewMobile extends ViewModelWidget<HomeViewModel> {
  const HomeViewMobile({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<Social>(
            stream: ProxyService.isarApi
                .socialsStream(businessId: ProxyService.box.getBranchId()!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Text("social dashboard");
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
                              text: 'to your suppliers instantly',
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
                                  clipper:
                                      CustomPainte(type: BubbleType.sendBubble),
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
                                  clipper:
                                      CustomPainte(type: BubbleType.sendBubble),
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
                          onPressed: viewModel.showBottomSheet,
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(color: Color(0xff006AFE)),
                            ),
                            shape: MaterialStateProperty.resolveWith<
                                OutlinedBorder>(
                              (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xff006AFE)),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.blue.withOpacity(0.04);
                                }
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed)) {
                                  return Colors.blue.withOpacity(0.12);
                                }
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          child: const Text('Add Channels',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
