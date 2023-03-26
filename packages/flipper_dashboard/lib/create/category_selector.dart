import 'package:flipper_models/isar_models.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({Key? key, required this.categories})
      : super(key: key);
  final List<Category> categories;

  Widget categorySelector(
      {required List<Category> categories, required BuildContext context}) {
    late Text text;
    if (categories.isEmpty) {
      return Text(
        'Select Category',
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
      );
    }
    for (Category category in categories) {
      if (category.focused) {
        text = Text(
          category.name,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.black),
        );
        return text;
      } else {
        text = Text('Select Category',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400));
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push(Routes.categories, extra: categories);
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.3),
              leading: Text(
                'Category',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Wrap(
                children: <Widget>[
                  categorySelector(categories: categories, context: context),
                  Theme(
                    data: ThemeData(
                      iconTheme: const IconThemeData(
                        color: Colors.black,
                      ),
                    ),
                    child: const Icon(FluentIcons.arrow_forward_20_regular),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
