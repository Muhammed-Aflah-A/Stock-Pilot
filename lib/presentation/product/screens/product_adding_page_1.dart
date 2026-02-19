import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/form_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/image_adding_widget.dart';
import 'package:stock_pilot/presentation/widgets/nextbutton_widget.dart';

class ProductAddingPage1 extends StatefulWidget {
  final ProductModel? product;
  final int? productIndex;

  const ProductAddingPage1({super.key, this.product, this.productIndex});

  @override
  State<ProductAddingPage1> createState() => _ProductAddingState();
}

class _ProductAddingState extends State<ProductAddingPage1> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 40.0);
    final verticalPadding = (size.height * 0.02).clamp(12.0, 24.0);
    final spacing = (size.height * 0.02).clamp(12.0, 24.0);
    final provider = context.read<ProductProvider>();
    final isEditing = widget.product != null;
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        showleading: true,
        title: isEditing ? "Edit Basic Info" : "Basic Info",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Product Image",
                        style: TextStyles.sectionHeading(
                          context,
                        ).copyWith(color: ColourStyles.primaryColor_2),
                      ),
                    ),
                    SizedBox(height: spacing),
                    const ImageAddingWidget(),
                    Selector<ProductProvider, bool>(
                      selector: (_, p) => p.hasImage,
                      builder: (context, hasImage, _) {
                        if (hasImage) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Center(
                            child: Text(
                              "Please add at least one product image",
                              style: const TextStyle(
                                color: ColourStyles.colorRed,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: spacing),
                    Form(
                      key: provider.firstFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product Name",
                            style: TextStyles.sectionHeading(
                              context,
                            ).copyWith(color: ColourStyles.primaryColor_2),
                          ),
                          const SizedBox(height: 8),
                          FormWidget(
                            maxlength: 25,
                            initialValue: provider.productName,
                            keyboard: TextInputType.name,
                            validator: (value) => SelectValidatorUtil.validate(
                              value,
                              "product name",
                            ),
                            onSaved: (newValue) {
                              provider.productName = newValue!.trim();
                            },
                            action: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(provider.productDescriptionFocus);
                            },
                          ),
                          SizedBox(height: spacing),
                          Text(
                            "Product Description",
                            style: TextStyles.sectionHeading(
                              context,
                            ).copyWith(color: ColourStyles.primaryColor_2),
                          ),
                          const SizedBox(height: 8),
                          FormWidget(
                            maxlength: 500,
                            maxline: size.height < 700 ? 4 : 6,
                            initialValue: provider.productDescription,
                            focus: provider.productDescriptionFocus,
                            keyboard: TextInputType.multiline,
                            validator: (value) => SelectValidatorUtil.validate(
                              value,
                              "product description",
                            ),
                            onSaved: (newValue) {
                              provider.productDescription = newValue!.trim();
                            },
                            action: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing * 2),
                    Center(
                      child: NextbuttonWidget(
                        text: "Next",
                        onPressed: () {
                          final formValid = provider.firstFormKey.currentState!
                              .validate();
                          if (!provider.hasImage || !formValid) {
                            SnackbarUtil.showSnackBar(
                              context,
                              "Images and details must be correct",
                              true,
                            );
                            return;
                          }
                          provider.firstFormKey.currentState!.save();
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productAddingPage2,
                            arguments: {
                              'product': widget.product,
                              'productIndex': widget.productIndex,
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
