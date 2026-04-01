import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      // APP BAR
      appBar: const AppBarWidget(
        showLeading: false,
        title: "Revenue",
        centeredTitle: false,
        showAvatar: true,
      ),
      // DRAWER
      drawer: const AppDrawer(),
    );
  }
}
