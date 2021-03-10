import 'package:customappbar/customappbar.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/views/tickets/tickets_viewmodel.dart';
import 'package:flipper_models/ticket.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;

class TicketsView extends StatelessWidget {
  const TicketsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => TicketsViewModel(),
      builder: (BuildContext context, TicketsViewModel model, Widget child) {
        return SafeArea(
          child: Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Add Customer to Sale',
              disableButton: true,
              showActionButton: false,
              onPressedCallback: () async {
                ProxyService.nav.pop();
              },
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Column(
                children: [
                  // TODO: implement search.
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
                        onChanged: (String name) async {
                          // model.setName(name: name);
                          // model.lock();
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Name, Email, Phone',
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
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Container(
                      width: double.infinity,
                      child: Button(
                        disableButton: false,
                        onPressedCallback: () {
                          ProxyService.nav.navigateTo(Routing.newTicket);
                        },
                        buttonName: 'New Ticket',
                      ),
                    ),
                  ),
                  // ignore: prefer_const_literals_to_create_immutables
                  Flexible(
                      child: ListView(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Column(
                        children: model.tickets.map((Ticket ticket) {
                          final date = DateTime.parse(ticket.createdAt);
                          return GestureDetector(
                            onTap: () {
                              model.saveToExistingTicket(ticketId: ticket.id);
                              ProxyService.nav.pop();
                            },
                            child: ListTile(
                              leading: Text(ticket.ticketName),
                              trailing: Text(timeago.format(date)),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ]))
                ],
              ),
            ),
          ),
        );
      },
      onModelReady: (TicketsViewModel model) {
        model.loadTickets();
      },
    );
  }
}
