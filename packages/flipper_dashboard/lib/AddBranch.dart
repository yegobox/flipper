import 'package:flutter/material.dart';

class Branch {
  String name;
  String location;

  Branch({required this.name, required this.location});
}


class AddBranch extends StatefulWidget {
  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  final List<Branch> _branches = [
    Branch(name: 'Branch 1', location: 'Location 1'),
    Branch(name: 'Branch 2', location: 'Location 2'),
  ];

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  void _addBranch() {
    final name = _nameController.text;
    final location = _locationController.text;

    if (name.isNotEmpty && location.isNotEmpty) {
      setState(() {
        _branches.add(Branch(name: name, location: location));
        _nameController.clear();
        _locationController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branch Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to top
          children: [
            Container(
              width: 300, // Adjust width as needed
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Branch',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _addBranch,
                    child: Text('Add Branch'),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16), // Add some space between form and list
            Expanded(
              child: ListView.builder(
                itemCount: _branches.length,
                itemBuilder: (context, index) {
                  final branch = _branches[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Icon(Icons.location_pin, color: Colors.blue),
                      title: Text(
                        branch.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(branch.location),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
