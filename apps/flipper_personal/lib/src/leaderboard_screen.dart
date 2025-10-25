import 'package:flutter/material.dart';
import 'package:flipper_personal/src/personal_home_screen.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: FlipperPalette.primaryGreen,
        elevation: 0,
      ),
      backgroundColor: FlipperPalette.backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLeaderboardItem(context, 1, 'Alice', 2500, isCurrentUser: true),
          const SizedBox(height: 12),
          _buildLeaderboardItem(context, 2, 'Bob', 2300),
          const SizedBox(height: 12),
          _buildLeaderboardItem(context, 3, 'Charlie', 2100),
          const SizedBox(height: 12),
          _buildLeaderboardItem(context, 4, 'David', 1900),
          const SizedBox(height: 12),
          _buildLeaderboardItem(context, 5, 'Eve', 1700),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(
    BuildContext context,
    int rank,
    String name,
    int xp, {
    bool isCurrentUser = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? FlipperPalette.lightGreen
            : FlipperPalette.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: isCurrentUser
            ? Border.all(color: FlipperPalette.primaryGreen, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: FlipperPalette.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: FlipperPalette.primaryGreen,
            child: Text(name[0], style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: FlipperPalette.textPrimary,
              ),
            ),
          ),
          Text(
            '${xp}XP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: FlipperPalette.xpGold,
            ),
          ),
        ],
      ),
    );
  }
}
