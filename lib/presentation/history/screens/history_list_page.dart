import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/presentation/history/viewmodel/history_provider.dart';
import 'package:stock_pilot/presentation/widgets/activity_card_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_drawer_widget.dart';
import 'package:stock_pilot/presentation/widgets/emptypage_message_widget.dart';
import 'package:stock_pilot/presentation/widgets/filter_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';
import 'package:stock_pilot/presentation/widgets/sort_button_widget.dart';

class HistoryListPage extends StatefulWidget {
  const HistoryListPage({super.key});

  @override
  State<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      // APP BAR
      appBar: const AppBarWidget(
        showLeading: false,
        title: "History",
        centeredTitle: false,
        showAvatar: true,
      ),
      // DRAWER
      drawer: const AppDrawer(),
      body: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
            // SEARCH & FILTER BAR
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
                    return FilterButtonWidget(provider: provider);
                  },
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
            // HISTORY LIST
            Expanded(
              child: Consumer<HistoryProvider>(
                builder: (context, provider, _) {
                  final activities = provider.filteredActivities;

                  // If the database is entirely empty
                  if (provider.allActivities.isEmpty) {
                    return const EmptypageMessageWidget(
                      heading: "History is empty",
                      label: "Every activity will appear here",
                    );
                  }

                  // If search or filter returns no results
                  if (activities.isEmpty) {
                    return const EmptypageMessageWidget(
                      icon: Icons.search_off_rounded,
                      heading: "No results found",
                      label: "Try a different product name or date",
                    );
                  }

                  return ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return ActivityCardWidget(activity: activities[index]);
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
