import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabselected = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Container(
          color: Colors.white, // Set your desired background color here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 17.81,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(19.0),
                child: SizedBox(
                    height: 17.81,
                    child: Text(
                      "Notifications",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          height: 0.31,
                          fontSize: 21,
                          color: const Color(0xff000000)),
                    )),
              ),
              Divider(color: const Color(0xff000000).withOpacity(0.25)),
              Padding(
                padding: const EdgeInsets.fromLTRB(19.0, 2.5, 19.0, 2.5),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      7.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 2.5, 2.5, 2.5),
                    child: TabBar(
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          7.0,
                        ),
                        color: const Color(0xffFFFFFF),
                      ),
                      labelColor: Colors.black,
                      // labelStyle: tabLabelStyle,
                      // unselectedLabelColor: Colors.black,
                      // indicatorColor: Colors.black,
                      tabs: const [
                        // first tab [you can add an icon using the icon property]
                        SizedBox(
                          height: 41,
                          width: double.infinity,
                          child: Tab(
                            text: 'Account',
                          ),
                        ),

                        // second tab [you can add an icon using the icon property]
                        SizedBox(
                          height: 41,
                          width: double.infinity,
                          child: Tab(
                            text: 'What\'s new',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // tab bar view here
              Flexible(
                fit: FlexFit.tight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(19.0, 67.5, 19.0, 0.0),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 91.0,
                            width: 390.0,
                            child: Card(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 11.0,
                                          height: 11.0,
                                          decoration: const BoxDecoration(
                                            color: Color(0xff006AFE),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            22.0, 0.0, 110.96, 0),
                                        child: Text("Take your first payment"),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                      "Learn how to take your first payment."),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Center(
                      child: Text(
                        'two',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
