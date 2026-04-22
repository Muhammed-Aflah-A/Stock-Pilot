import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/history/viewmodel/history_provider.dart';
import 'package:stock_pilot/presentation/widgets/activity_card_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';
import 'package:stock_pilot/presentation/widgets/sort_button_widget.dart';

class HistoryListPage extends StatefulWidget {
  const HistoryListPage({super.key});

  @override
  State<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<HistoryProvider>().searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      initialIndex: context.read<HistoryProvider>().currentTab.index,
      child: Scaffold(
        backgroundColor: ColourStyles.primaryColor,
        appBar: const AppBarWidget(
          showLeading: false,
          title: "History",
          centeredTitle: false,
          showAvatar: true,
        ),
        drawer: const AppDrawer(),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Consumer<HistoryProvider>(
                            builder: (context, provider, _) {
                              return SearchbarWidget(
                                controller: _searchController,
                                onChanged: (value) => provider.searchHistory(value),
                                onClear: () {
                                  _searchController.clear();
                                  provider.searchHistory("");
                                },
                                hintText: "search history",
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Consumer<HistoryProvider>(
                          builder: (context, provider, _) {
                            return SortButtonWidget<HistorySortOption>(
                              options: const {
                                HistorySortOption.latest: "Latest",
                                HistorySortOption.oldest: "Oldest",
                              },
                              currentValue: provider.currentSort,
                              defaultValue: HistorySortOption.latest,
                              onSelected: (option) => provider.sortHistory(option),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Consumer<HistoryProvider>(
                      builder: (context, provider, _) {
                        return TabBar(
                          onTap: (index) {
                            final tab = index == 0
                                ? HistoryTab.purchase
                                : index == 1
                                    ? HistoryTab.updates
                                    : HistoryTab.sales;
                            provider.setTab(tab);
                          },
                          labelColor: ColourStyles.primaryColor_2,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          unselectedLabelColor: ColourStyles.captionColor,
                          indicatorColor: ColourStyles.primaryColor_2,
                          indicatorWeight: 3,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: const [
                            Tab(text: "Purchase"),
                            Tab(text: "Updates"),
                            Tab(text: "Sales"),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    Expanded(
                      child: Consumer<HistoryProvider>(
                        builder: (context, provider, _) {
                          final activities = provider.filteredActivities;

                          if (provider.allActivities.isEmpty) {
                            return const EmptypageMessageWidget(
                              heading: "History is empty",
                              label: "Every activity will appear here",
                            );
                          }

                          if (activities.isEmpty) {
                            return const EmptypageMessageWidget(
                              icon: Icons.search_off_rounded,
                              heading: "No results found",
                              label: "Try a different product name or date",
                            );
                          }

                          return ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: activities.length,
                            itemBuilder: (context, index) {
                              final activity = activities[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.historyDetailsPage,
                                    arguments: activity,
                                  );
                                },
                                child: ActivityCardWidget(activity: activity),
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
          ),
        ),
      ),
    );
  }
}

