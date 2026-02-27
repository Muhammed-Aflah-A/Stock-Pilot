import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class SortbuttonWidget<T> extends StatelessWidget {
  const SortbuttonWidget({
    super.key,
    required this.options,
    required this.currentValue,
    required this.onSelected,
    required this.defaultValue,
  });

  final Map<T, String> options;
  final T currentValue;
  final T defaultValue;
  final Function(T) onSelected;
  bool get _isActive => currentValue != defaultValue;

  void _showModal(BuildContext context) {
    T tempValue = currentValue;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
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
                              border: Border.all(
                                color: ColourStyles.shadowColor,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: options.entries.map((entry) {
                                final isSelected = tempValue == entry.key;
                                final isLast = entry.key == options.keys.last;
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () => setModalState(
                                        () => tempValue = entry.key,
                                      ),
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
                                                      ? ColourStyles
                                                            .primaryColor_2
                                                      : ColourStyles
                                                            .shadowColor,
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
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    onSelected(defaultValue);
                                    Navigator.pop(ctx);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.black87,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  child: const Text(
                                    'Clear Sort',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    onSelected(tempValue);
                                    Navigator.pop(ctx);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  child: const Text(
                                    'Apply Sort',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = (size.width * 0.12).clamp(40.0, 52.0);
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showModal(context),
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isActive ? Colors.black : Colors.transparent,
                  border: Border.all(
                    color: _isActive
                        ? Colors.black
                        : ColourStyles.primaryColor_2,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.sort,
                  size: (buttonSize * 0.45).clamp(18.0, 24.0),
                  color: _isActive ? Colors.white : ColourStyles.primaryColor_2,
                ),
              ),
              if (_isActive)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
