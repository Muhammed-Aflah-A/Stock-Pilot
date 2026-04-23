import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/models/cart_model.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/cart_provider.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';

class CartListTileWidget extends StatefulWidget {
  final CartItems item;

  const CartListTileWidget({super.key, required this.item});

  @override
  State<CartListTileWidget> createState() => _CartListTileWidgetState();
}

class _CartListTileWidgetState extends State<CartListTileWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.item.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant CartListTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.quantity != widget.item.quantity) {
      if (controller.text != widget.item.quantity.toString()) {
        controller.text = widget.item.quantity.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CartProvider>();
    final quantity = context.select<CartProvider, int>((p) {
      final found = p.cartItems.firstWhere(
        (e) => e.product.productName == widget.item.product.productName,
        orElse: () => widget.item,
      );
      return found.quantity;
    });

    final product = widget.item.product;
    final stock = int.tryParse(product.itemCount ?? '0') ?? 0;
    final isMaxReached = quantity >= stock;
    final isInvalid = quantity <= 0 || quantity > stock;
    return Card(
      color: ColourStyles.primaryColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 90,
                    height: 70,
                    color: ColourStyles.primaryColor_2,
                    child: product.productImages.isNotEmpty
                        ? Image(
                            image: ImageUtil.getProductImage(
                              product.productImages.first,
                            ),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.inventory_2_rounded),
                          )
                        : const Icon(Icons.inventory_2_rounded),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.productName ?? "",
                              style: TextStyles.titleText(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              product.category ?? "",
                              style: TextStyles.activityCardLabel(context),
                            ),
                            Text(
                              product.brand ?? "",
                              style: TextStyles.activityCardText(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        NumberFormatterUtil.formatCurrency(
                          double.tryParse(product.salesRate ?? '0') ?? 0,
                        ),
                        style: TextStyles.productPriceText(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 105,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            if (quantity == 1) {
                              showDialog(
                                context: context,
                                builder: (_) => ActionConfirmationWidget(
                                  title: "Remove Item",
                                  actionText: "Remove",
                                  actionColor: ColourStyles.colorRed,
                                  displayName:
                                      widget.item.product.productName ?? "",
                                  onConfirm: () async {
                                    await provider.removeItem(widget.item);
                                    return true;
                                  },
                                ),
                              );
                            } else {
                              await provider.decreaseQty(widget.item);
                            }
                          },
                          icon: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 48,
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 2,
                            ),
                            errorText: isInvalid ? "Invalid" : null,
                            errorStyle: const TextStyle(fontSize: 0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: ColourStyles.primaryColor_2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: ColourStyles.primaryColor_2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: ColourStyles.colorRed,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: ColourStyles.colorRed,
                              ),
                            ),
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                          keyboardType: TextInputType.number,
                          onChanged: (value) async {
                            if (value.trim().isEmpty) {
                              await provider.setQuantity(
                                widget.item,
                                0,
                              );
                              return;
                            }
                            final newQty = int.tryParse(value);
                            if (newQty == null) return;
                            await provider.setQuantity(widget.item, newQty);
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: isMaxReached
                              ? null
                              : () async {
                                  final success = await provider.increaseQty(
                                    widget.item,
                                  );
                                  if (!context.mounted) return;
                                  if (!success) {
                                    SnackbarUtil.showSnackBar(
                                      context,
                                      "Maximum stock reached",
                                      true,
                                    );
                                  }
                                },
                          icon: const Icon(Icons.add, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => ActionConfirmationWidget(
                            title: "Remove Item",
                            displayName: widget.item.product.productName ?? "",
                            actionText: "Remove",
                            actionColor: ColourStyles.colorRed,
                            onConfirm: () async {
                              await provider.removeItem(widget.item);
                              return true;
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "Remove",
                        style: TextStyle(
                          color: ColourStyles.colorRed,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
