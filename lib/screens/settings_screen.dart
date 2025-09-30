import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: theme.brightness == Brightness.dark,
            onChanged: (val) {
              setState(() {
                isDarkMode = val;
              });
              // Use inherited widget or provider for real theme switching
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('CoinMarketCap App\nVersion 1.0.0'),
          ),
        ],
      ),
    );
  }
}
