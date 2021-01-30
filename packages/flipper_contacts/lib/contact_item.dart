import 'package:flipper_models/fcontact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';

import './text_helpers.dart';

class ContactItem extends StatelessWidget {
  const ContactItem(
      {this.contact, this.searchKeyword, this.onProfileTap, this.onTap});

  final FContact contact;
  final String searchKeyword;
  final Function onProfileTap;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).copyWith(canvasColor: Colors.white).canvasColor,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
        leading: SizedBox(
          width: 45.0,
          height: 45.0,
          child: TextDrawable(
            text: contact.name,
            isTappable: true,
            onTap: null,
            boxShape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: searchKeyword == null || searchKeyword.isEmpty
            ? Text(
                contact.name,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline5,
              )
            : TextHelpers.getHighlightedText(
                contact.name,
                searchKeyword,
                Theme.of(context).textTheme.headline5,
                Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.blue),
              ),
        onTap: onTap,
      ),
    );
  }
}
