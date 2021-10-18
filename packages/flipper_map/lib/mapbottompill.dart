import 'package:flipper_map/subcategory.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class MapBottomPill extends StatelessWidget {
  SubCategory? subCategory;

  @override
  Widget build(BuildContext context) {
    // CategorySelectionService catSelection = Provider.of<CategorySelectionService>(context, listen: false);
    // this.subCategory = catSelection.selectedSubCategory;

    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset.zero)
            ]),
        child: Column(
          children: [
            Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipOval(
                          child: Image.asset('assets/imgages/.png',
                              width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        // Positioned(
                        //   bottom: -10,
                        //   right: -10,
                        //   child: CategoryIcon(
                        //     color: this.subCategory!.color,
                        //     iconName: this.subCategory!.icon,
                        //     size: 20,
                        //     padding: 5
                        //   ),
                        // )
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          const Text('Venta por Libra'),
                          const Text('2km de distancia',
                              style: TextStyle(color: Colors.black))
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.location_pin,
                      color: Colors.black,
                      size: 50,
                    )
                  ],
                )),
            Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/farmer.jpeg'),
                              fit: BoxFit.cover),
                          border: Border.all(color: Colors.black, width: 4)),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Jose Gonzalez',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Autopista Duarte\nCarretera Duarte Vieja #225')
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }
}
