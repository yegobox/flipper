import 'package:customappbar/customappbar.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper_models/view_models/tickets_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NewTicket extends StatelessWidget {
  const NewTicket({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, TicketsViewModel model, Widget child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () async {
                  await model.saveNewTicket();
                  ProxyService.nav.pop();
                },
                title: 'New Ticket',
                rightActionButtonName: 'Save',
                disableButton: model.isLocked,
                showActionButton: true,
                onPressedCallback: () async {
                  model.saveNewTicket();
                  ProxyService.nav.pop();
                },
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.black),
                        // validator: Validators.isValid,
                        onChanged: (String ticketName) async {
                          model.setTicketName(ticketName: ticketName);
                          model.lock();
                        },
                        decoration: InputDecoration(
                          hintText: 'Ticket Name',
                          fillColor: Theme.of(context)
                              .copyWith(canvasColor: Colors.white)
                              .canvasColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor('#D0D7E3')),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.black),
                        onChanged: (String note) async {
                          model.setNote(note: note);
                        },
                        decoration: InputDecoration(
                          hintText: 'Add Note',
                          fillColor: Theme.of(context)
                              .copyWith(canvasColor: Colors.white)
                              .canvasColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor('#D0D7E3')),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => TicketsViewModel(),
        onModelReady: (TicketsViewModel model) {
          //TODO: get current
        });
  }
}
