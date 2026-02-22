// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stock_pilot/core/theme/colours_styles.dart';
// import 'package:stock_pilot/core/theme/text_styles.dart';
// import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

// class SortbuttonWidget extends StatelessWidget {
//   const SortbuttonWidget({super.key});

//   final Map<SortOption, String> _options = const {
//     SortOption.priceHighToLow: 'Price : High to Low',
//     SortOption.priceLowToHigh: 'Price : Low to High',
//     SortOption.alphabeticalAZ: 'Alphabetical ( A – Z )',
//     SortOption.alphabeticalZA: 'Alphabetical ( Z – A )',
//   };

//   void _showModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (ctx) {
//         return Consumer<ProductProvider>(
//           builder: (context, provider, child) {
//             return Container(
//               color: ColourStyles.shadowColor,
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Material(
//                     color: ColourStyles.primaryColor,
//                     borderRadius: BorderRadius.circular(20),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 20,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: GestureDetector(
//                                   onTap: () => Navigator.pop(ctx),
//                                   child: const Icon(Icons.close, size: 22),
//                                 ),
//                               ),
//                               Text(
//                                 'Sort Options',
//                                 style: TextStyles.cardHeading(context),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: ColourStyles.shadowColor,
//                               ),
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             child: Column(
//                               children: _options.entries.map((entry) {
//                                 final isSelected =
//                                     provider.currentSort == entry.key;
//                                 final isLast = entry.key == _options.keys.last;

//                                 return Column(
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         provider.sortProducts(entry.key);
//                                         Navigator.pop(ctx);
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 16,
//                                           vertical: 18,
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 entry.value,
//                                                 style: TextStyles.primaryText(
//                                                   context,
//                                                 ),
//                                               ),
//                                             ),
//                                             Container(
//                                               width: 24,
//                                               height: 24,
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 border: Border.all(
//                                                   color: isSelected
//                                                       ? ColourStyles
//                                                             .primaryColor_2
//                                                       : ColourStyles
//                                                             .shadowColor,
//                                                   width: isSelected ? 2 : 1.5,
//                                                 ),
//                                               ),
//                                               child: isSelected
//                                                   ? const Center(
//                                                       child: CircleAvatar(
//                                                         radius: 6,
//                                                         backgroundColor:
//                                                             ColourStyles
//                                                                 .primaryColor_2,
//                                                       ),
//                                                     )
//                                                   : null,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     if (!isLast)
//                                       const Divider(
//                                         height: 1,
//                                         thickness: 1,
//                                         color: ColourStyles.shadowColor,
//                                       ),
//                                   ],
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 48,
//       height: 48,
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () => _showModal(context),
//           borderRadius: BorderRadius.circular(10),
//           child: Container(
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: ColourStyles.primaryColor_2,
//                 width: 1.5,
//               ),
//             ),
//             child: const Icon(
//               Icons.sort,
//               size: 22,
//               color: ColourStyles.primaryColor_2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class SortbuttonWidget<T> extends StatelessWidget {
  const SortbuttonWidget({
    super.key,
    required this.options,
    required this.currentValue,
    required this.onSelected,
  });

  final Map<T, String> options;
  final T currentValue;
  final Function(T) onSelected;

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          color: ColourStyles.shadowColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: ColourStyles.primaryColor,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: const Icon(Icons.close, size: 22),
                            ),
                          ),
                          Text(
                            'Sort Options',
                            style: TextStyles.cardHeading(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: ColourStyles.shadowColor),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: options.entries.map((entry) {
                            final isSelected = currentValue == entry.key;
                            final isLast = entry.key == options.keys.last;
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    onSelected(entry.key);
                                    Navigator.pop(ctx);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            entry.value,
                                            style: TextStyles.primaryText(
                                              context,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? ColourStyles.primaryColor_2
                                                  : ColourStyles.shadowColor,
                                              width: isSelected ? 2 : 1.5,
                                            ),
                                          ),
                                          child: isSelected
                                              ? const Center(
                                                  child: CircleAvatar(
                                                    radius: 6,
                                                    backgroundColor:
                                                        ColourStyles
                                                            .primaryColor_2,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!isLast)
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: ColourStyles.shadowColor,
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showModal(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColourStyles.primaryColor_2,
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.sort,
              size: 22,
              color: ColourStyles.primaryColor_2,
            ),
          ),
        ),
      ),
    );
  }
}
