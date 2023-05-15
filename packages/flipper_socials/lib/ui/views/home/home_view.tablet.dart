import 'package:flipper_socials/ui/common/app_colors.dart';
import 'package:flipper_socials/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeViewTablet extends ViewModelWidget<HomeViewModel> {
  const HomeViewTablet({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                verticalSpaceLarge,
                Column(
                  children: const [
                    Text(
                      'Hello, TABLET UI!',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    verticalSpaceMedium,
                    MaterialButton(
                      color: Colors.black,
                      onPressed: null,
                      child: Text(
                        "hello",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    MaterialButton(
                      color: kcDarkGreyColor,
                      child: Text(
                        'Show Dialog',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: null,
                    ),
                    MaterialButton(
                      color: kcDarkGreyColor,
                      child: Text(
                        'Show Bottom Sheet',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: null,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
