import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

import 'package:flipper_models/realm_model_export.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Tenant?>(
              future: ProxyService.realm
                  .getTenantBYUserId(userId: ProxyService.box.getUserId()!),
              builder: (context, snapshot) {
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        // Add your business logo here
                        child: Icon(
                          Icons.business,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        snapshot.data?.name ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        snapshot.data?.email ??
                            snapshot.data?.phoneNumber ??
                            "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          FutureBuilder<List<Business>>(
            future: ProxyService.local
                .businesses(userId: ProxyService.box.getUserId()!),
            builder: (context, businessSnapshot) {
              if (businessSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (businessSnapshot.hasError) {
                return Text(
                    'Error loading businesses: ${businessSnapshot.error}');
              }

              final List<Business> businesses = businessSnapshot.data ?? [];
              return SizedBox.shrink();
              // FIXME: uncomment this code.
              // return FutureBuilder<List<Branch>>(
              //   future: ProxyService.local
              //       .branches(businessId: businesses.first.serverId),
              //   builder: (context, branchSnapshot) {
              //     if (branchSnapshot.connectionState ==
              //         ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     }

              //     if (branchSnapshot.hasError) {
              //       return Text(
              //           'Error loading branches: ${branchSnapshot.error}');
              //     }

              //     final List<Branch> branches = branchSnapshot.data ?? [];

              //     // Extract business names and filter out null values
              //     final List<String> businessNames = businesses
              //         .map((business) => business.name ?? '')
              //         .toList();

              //     // Extract branch names and filter out null values
              //     final List<String> branchNames =
              //         branches.map((branch) => branch.name ?? '').toList();

              //     return BusinessTile(
              //       businessName: businessNames.isNotEmpty
              //           ? businessNames.first
              //           : 'Default Business',
              //       branches: branchNames.isNotEmpty
              //           ? branchNames
              //           : ['Default Branch'],
              //     );
              //   },
              // );
            },
          )
        ],
      ),
    );
  }
}

class BusinessTile extends StatefulWidget {
  final String businessName;
  final List<String> branches;

  const BusinessTile({
    required this.businessName,
    required this.branches,
    Key? key,
  }) : super(key: key);

  @override
  _BusinessTileState createState() => _BusinessTileState();
}

class _BusinessTileState extends State<BusinessTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.businessName),
      leading: Icon(Icons.business),
      onExpansionChanged: (expanded) {},
      tilePadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      children: widget.branches
          .map((branch) => ListTile(
                title: Text(branch),
                onTap: () {
                  Navigator.pop(context);
                  // Handle branch selection as needed
                },
              ))
          .toList(),
    );
  }
}
