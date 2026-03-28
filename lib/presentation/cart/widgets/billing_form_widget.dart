import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/utils/keyboard_type_util.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/cart_provider.dart';
import 'package:stock_pilot/presentation/cart/widgets/customer_form_widget.dart';

class BillingFormWidget extends StatefulWidget {
  const BillingFormWidget({super.key});

  @override
  State<BillingFormWidget> createState() => _BillingFormWidgetState();
}

class _BillingFormWidgetState extends State<BillingFormWidget> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double fieldGap = (size.height * 0.025).clamp(10.0, 18.0);
    final provider = context.read<CartProvider>();
    return Form(
      key: provider.formKey,
      child: Column(
        children: [
          // Customer name
          CustomerFormWidget(
            prefixIcon: Icon(Icons.person, color: ColourStyles.primaryColor_2),
            labelText: "Customer Name",
            maxlength: 25,
            keyboard: KeyboardTypeUtil.getKeyboardType("name"),
            action: TextInputAction.next,
            validator: (value) => SelectValidatorUtil.validate(value, "name"),
            onSaved: (value) => provider.setCustomerName(value),
            onFieldSubmitted: (_) => FocusScope.of(
              context,
            ).requestFocus(provider.customerNumberFocus),
          ),
          SizedBox(height: fieldGap),
          //Customer phone number
          CustomerFormWidget(
            focus: provider.customerNumberFocus,
            prefixIcon: Icon(Icons.phone, color: ColourStyles.primaryColor_2),
            labelText: "Customer Phone Number",
            hintText: "+[CountryCode][Number]",
            maxlength: 15,
            keyboard: KeyboardTypeUtil.getKeyboardType("phone number"),
            action: TextInputAction.next,
            validator: (value) =>
                SelectValidatorUtil.validate(value, "phone number"),
            onSaved: (value) => provider.setCustomerNumber(value),
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: fieldGap),
          // Purchase date
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.calendar_today,
                color: ColourStyles.primaryColor_2,
              ),
              hintText: "Select Date",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: ColourStyles.primaryColor_2,
                  width: 1,
                ),
              ),
            ),
            // Open date picker on tap
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                final formatted = DateFormat(
                  'dd/MM/yyyy',
                ).format(pickedDate);
                _dateController.text = formatted;
              }
            },
            validator: (value) => SelectValidatorUtil.validate(value, "date"),
            onSaved: (value) {
              provider.setBillingDate(value);
            },
          ),
          SizedBox(height: fieldGap),
        ],
      ),
    );
  }
}
