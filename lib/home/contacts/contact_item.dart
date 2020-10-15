import 'package:flipper/util/app_colors.dart';
import 'package:flipper/util/text_helpers.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;
  final String searchKeyword;
  final Function onProfileTap;
  final Function onTap;

  ContactItem(
      {this.contact, this.searchKeyword, this.onProfileTap, this.onTap});

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
          child: IconButton(
              padding: const EdgeInsets.all(0.0),
              icon: const Icon(
                Icons.account_circle,
                size: 45.0,
              ),
              color: AppColors.lightGrey,
              onPressed: onProfileTap),
        ),
        title: searchKeyword == null || searchKeyword.isEmpty
            ? Text(
                contact.displayName == null ? '' : contact.displayName,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline5,
              )
            : TextHelpers.getHighlightedText(
                contact.displayName == null ? '' : contact.displayName,
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
