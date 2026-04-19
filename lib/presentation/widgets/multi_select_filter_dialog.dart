import 'package:flutter/material.dart';
import 'package:stock_pilot/core/interfaces/filter_provider_interface.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/searchbar_widget.dart';

class MultiSelectFilterDialog extends StatefulWidget {
  final FilterProviderInterface provider;
  final String title;
  final bool isCategory;

  const MultiSelectFilterDialog({
    super.key,
    required this.provider,
    required this.title,
    required this.isCategory,
  });

  @override
  State<MultiSelectFilterDialog> createState() => _MultiSelectFilterDialogState();
}

class _MultiSelectFilterDialogState extends State<MultiSelectFilterDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final items = widget.isCategory
        ? widget.provider.categoryList
        : widget.provider.brandsList;

    final filteredItems = items
        .where((item) => item.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Container(
      height: size.height * 0.8,
      decoration: const BoxDecoration(
        color: ColourStyles.primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ColourStyles.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: TextStyles.sectionTitle(context)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SearchbarWidget(
              controller: _searchController,
              hintText: "Search ${widget.title.toLowerCase()}...",
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onClear: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = "";
                });
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.provider,
              builder: (context, _) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final isSelected = widget.isCategory
                        ? widget.provider.tempCategories.contains(item)
                        : widget.provider.tempBrands.contains(item);

                    return CheckboxListTile(
                      title: Text(
                        item,
                        style: TextStyles.primaryText(context).copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      value: isSelected,
                      activeColor: ColourStyles.primaryColor_2,
                      checkColor: ColourStyles.primaryColor,
                      onChanged: (bool? value) {
                        if (widget.isCategory) {
                          widget.provider.toggleTempCategory(item);
                        } else {
                          widget.provider.toggleTempBrand(item);
                        }
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyles.dialogNextButton(context),
                child: const Text("Done"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
