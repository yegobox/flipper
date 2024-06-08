import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:google_fonts/google_fonts.dart';

class NewTicket extends StatefulWidget {
  const NewTicket({Key? key, required this.transaction, required this.onClose})
      : super(key: key);
  final ITransaction transaction;
  final VoidCallback onClose;

  @override
  NewTicketState createState() => NewTicketState();
}

class NewTicketState extends State<NewTicket>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _routerService = locator<RouterService>();
  final _formKey = GlobalKey<FormState>();
  final _swipeController = TextEditingController();
  final _noteController = TextEditingController();
  late bool _noteValue;
  late bool _ticketNameValue;

  @override
  void initState() {
    super.initState();
    _noteValue = false;
    _ticketNameValue = false;
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _swipeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) async {},
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close, color: Colors.black),
            ),
            title: Text(
              'New Ticket',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: _ticketNameValue && _noteValue
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          model.saveTicket(
                            ticketName: _swipeController.text,
                            transaction: widget.transaction,
                            ticketNote: _noteController.text,
                          );
                          _routerService.pop();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF01B8E4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _swipeController,
                    onChanged: (value) {
                      setState(() {
                        _ticketNameValue = value.isNotEmpty ? true : false;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "You need to enter ticket name or swipe";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabled: true,
                      hintText: "Ticket name (or Swipe)",
                      // prefixIcon: Icon(Icons.cash),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorMaxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _noteController,
                    onChanged: (value) {
                      setState(() {
                        _noteValue = value.isNotEmpty ? true : false;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "You need to enter the note";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabled: true,
                      hintText: "Add note",
                      prefixIcon: Icon(Icons.note),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorMaxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
