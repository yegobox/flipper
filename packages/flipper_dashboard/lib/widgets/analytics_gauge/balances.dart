import 'package:flutter/material.dart';

class Balances extends StatefulWidget {
  const Balances({super.key});

  @override
  State<Balances> createState() => _BalancesState();
}

class _BalancesState extends State<Balances>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          Positioned(
            left: 61,
            top: 10.37,
            child: Text(
              '3,355 RWF',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6200000047683716),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 30,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            left: 291,
            top: 10.37,
            child: Text(
              '50 RWF',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.4099999964237213),
                fontSize: 20,
                decoration: TextDecoration.none,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 30,
              ),
            ),
          ),
          const Positioned(
            left: 61,
            top: 40.37,
            child: Text(
              'Gross profit',
              style: TextStyle(
                color: Color(0xFF98C2FE),
                fontSize: 20,
                fontFamily: 'Poppins',
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w600,
                height: 30,
              ),
            ),
          ),
          const Positioned(
            left: 285,
            top: 40.37,
            child: Text(
              'Expenses',
              style: TextStyle(
                color: Color(0xFF98C2FE),
                fontSize: 20,
                fontFamily: 'Poppins',
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w600,
                height: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
