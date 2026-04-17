import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/form_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/image_adding_widget.dart';
import 'package:stock_pilot/presentation/widgets/next_button_widget.dart';

class ProductAddingPage1 extends StatelessWidget {
  const ProductAddingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductProvider>();

    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showLeading: true,
        title: "Basic Info",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
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
                    const SizedBox(height: 16),
                    const ImageAddingWidget(),
                    Selector<ProductProvider, bool>(
                      selector: (_, p) => p.hasImage,
                      builder: (_, hasImage, _) {
                        if (hasImage) return const SizedBox.shrink();
                        return const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Center(
                            child: Text(
                              "Please add at least one product image",
                              style: TextStyle(
                                color: ColourStyles.colorRed,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
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
                            onSaved: (value) =>
                                provider.productName = value!.trim(),
                            action: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(provider.productDescriptionFocus);
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Product Description",
                            style: TextStyles.sectionHeading(
                              context,
                            ).copyWith(color: ColourStyles.primaryColor_2),
                          ),
                          const SizedBox(height: 8),
                          FormWidget(
                            maxlength: 500,
                            maxlines: 5,
                            initialValue: provider.productDescription,
                            focus: provider.productDescriptionFocus,
                            keyboard: TextInputType.multiline,
                            validator: (value) => SelectValidatorUtil.validate(
                              value,
                              "product description",
                            ),
                            onSaved: (value) =>
                                provider.productDescription = value!.trim(),
                            action: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
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

