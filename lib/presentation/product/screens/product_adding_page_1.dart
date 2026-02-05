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
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    final provider = context.watch<ProductProvider>();
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: currentWidth * 0.04,
                      vertical: currentHeight * 0.015,
                    ),
                    child: IntrinsicHeight(
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
                          SizedBox(height: currentHeight * 0.015),
                          const ImageAddingWidget(),
                          if (!provider.hasImage)
                            Padding(
                              padding: EdgeInsets.only(
                                top: currentHeight * 0.01,
                              ),
                              child: Center(
                                child: Text(
                                  "Please add at least one product image",
                                  style: TextStyle(
                                    color: ColourStyles.colorRed,
                                    fontSize: currentWidth * 0.035,
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: currentHeight * 0.02),
                          Form(
                            key: provider.firstFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Product Name",
                                  style: TextStyles.sectionHeading(context)
                                      .copyWith(
                                        color: ColourStyles.primaryColor_2,
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.01),
                                FormWidget(
                                  maxlength: 25,
                                  initialValue: provider.productName,
                                  keyboard: TextInputType.name,
                                  validator: (value) =>
                                      SelectValidatorUtil.validate(
                                        value,
                                        "product name",
                                      ),
                                  onSaved: (newValue) {
                                    provider.productName = newValue!.trim();
                                  },
                                  action: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context).requestFocus(
                                      provider.productDescriptionFocus,
                                    );
                                  },
                                ),
                                SizedBox(height: currentHeight * 0.02),
                                Text(
                                  "Product Description",
                                  style: TextStyles.sectionHeading(context)
                                      .copyWith(
                                        color: ColourStyles.primaryColor_2,
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.01),
                                FormWidget(
                                  maxlength: 500,
                                  maxline: currentHeight < 700 ? 4 : 6,
                                  initialValue: provider.productDescription,
                                  focus: provider.productDescriptionFocus,
                                  keyboard: TextInputType.multiline,
                                  validator: (value) =>
                                      SelectValidatorUtil.validate(
                                        value,
                                        "product description",
                                      ),
                                  onSaved: (newValue) {
                                    provider.productDescription = newValue!
                                        .trim();
                                  },
                                  action: TextInputAction.done,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(height: currentHeight * 0.04),
                          Center(
                            child: NextbuttonWidget(
                              onPressed: () {
                                final formValid = provider
                                    .firstFormKey
                                    .currentState!
                                    .validate();
                                if (!provider.hasImage || !formValid) {
                                  SnackbarUtil.showSnackBar(
                                    context,
                                    "images and details must be correct",
                                    true,
                                  );
                                  return;
                                }
                                if (formValid) {
                                  provider.firstFormKey.currentState!.save();
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.productAddingPage2,
                                    arguments: {
                                      'product': widget.product,
                                      'productIndex': widget.productIndex,
                                    },
                                  );
                                }
                              },
                              text: "Next",
                            ),
                          ),
                          SizedBox(height: currentHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
