import 'package:flutter/material.dart';

class CustomTabs extends StatefulWidget {
  const CustomTabs({Key? key}) : super(key: key);

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  int _selectedPage = 0;
  late PageController _pageController;
  void changePage(int page) {
    setState(() {
      _selectedPage = page;
      _pageController.animateToPage(page,
          duration: const Duration(microseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey,
            width: 400,
            // padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: FittedBox(
              fit: BoxFit.contain,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TabButton(
                  text: "First Tab",
                  pageNumber: 0,
                  selectedPage: _selectedPage,
                  onPressed: () {
                    changePage(0);
                  },
                ),
                TabButton(
                  text: "Second Tab",
                  pageNumber: 1,
                  selectedPage: _selectedPage,
                  onPressed: () {
                    changePage(1);
                  },
                ),
              ]),
            ),
          ),
          Flexible(
            child: PageView(
              controller: _pageController,
              children: const [
                Text("Page One"),
                Text("Page Two"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String? text;
  final int? selectedPage;
  final int? pageNumber;
  final Function onPressed;

  const TabButton(
      {Key? key,
      this.text,
      this.selectedPage,
      this.pageNumber,
      required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
            color:
                selectedPage == pageNumber ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(4.0)),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Text(
          text ?? "Tab Button",
          style: TextStyle(
            color: selectedPage == pageNumber ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }
}
