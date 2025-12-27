import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/assets/app_images.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/drawer_provider.dart';
import 'package:stock_pilot/presentation/profile/viewmodel/profile_page_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final dashboardProvider = context.watch<DashboardProvider>();
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: AppBar(
        backgroundColor: ColourStyles.primaryColor,
        toolbarHeight: 100,
        title: Text("Dashboard", style: TextStyles.heading_2),
        actions: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Consumer<ProfilePageProvider>(
              builder: (context, provider, child) {
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: ColourStyles.primaryColor_2,
                  backgroundImage:
                      (provider.user?.profileImage != null &&
                          File(provider.user!.profileImage!).existsSync())
                      ? FileImage(File(provider.user!.profileImage!))
                      : AssetImage(AppImages.profilePicture),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: ColourStyles.primaryColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: ColourStyles.primaryColor),
              accountName: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "${provider.user?.fullName}",
                    style: TextStyles.primaryText,
                  );
                },
              ),
              accountEmail: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "${provider.user?.gmail}",
                    style: TextStyles.primaryText,
                  );
                },
              ),
              currentAccountPicture: Consumer<ProfilePageProvider>(
                builder: (context, provider, child) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: ColourStyles.primaryColor_2,
                    backgroundImage:
                        (provider.user?.profileImage != null &&
                            File(provider.user!.profileImage!).existsSync())
                        ? FileImage(File(provider.user!.profileImage!))
                        : AssetImage(AppImages.profilePicture),
                  );
                },
              ),
            ),
            Expanded(
              child: Consumer<DrawerProvider>(
                builder: (context, provider, child) {
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: h * 0.01),
                    itemCount: provider.drawerItems.length,
                    itemBuilder: (context, index) {
                      final item = provider.drawerItems[index];
                      return ListTile(
                        selected: provider.selectedIndex == index,
                        selectedTileColor: ColourStyles.baseBackgroundColor,
                        tileColor: ColourStyles.primaryColor,
                        leading: Image.asset(item.icon!, height: 35, width: 35),
                        title: Text(
                          item.title!,
                          style: TextStyles.primaryText_2,
                        ),
                        onTap: () {
                          provider.selectedDrawerItem(index);
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "${item.navigation}");
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(h * 0.010),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1.7,
                ),
                itemCount: dashboardProvider.dashboardCards.length,
                itemBuilder: (context, index) {
                  final item = dashboardProvider.dashboardCards[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: ColourStyles.cardborderColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: ColourStyles.primaryColor_3,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(item.title!, style: TextStyles.primaryText_2),
                          SizedBox(height: h * 0.008),
                          Text(item.value!, style: item.valueStyle),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: h * 0.02),
              Text("Recent Activity", style: TextStyles.primaryText_4),
              SizedBox(height: h * 0.02),
              Expanded(
                child: Consumer<DashboardProvider>(
                  builder: (context, provider, _) {
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: h * 0.01),
                      itemCount: provider.dashboardActivity.length,
                      itemBuilder: (context, index) {
                        final activity = provider.dashboardActivity[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: ColourStyles.cardborderColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: ColourStyles.primaryColor_3,
                          child: Padding(
                            padding: EdgeInsets.all(h * 0.016),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      activity.image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: w * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity.title!,
                                        style: TextStyles.primaryText_2,
                                      ),
                                      Text(
                                        activity.product!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        activity.category!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${activity.unit}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: activity.isPositive!
                                            ? ColourStyles.colorGreen
                                            : ColourStyles.colorRed,
                                      ),
                                    ),
                                    Text(
                                      activity.label!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}