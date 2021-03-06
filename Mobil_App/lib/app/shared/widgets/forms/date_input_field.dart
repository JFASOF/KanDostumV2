import 'package:flutter/material.dart';
import 'package:kandostum2/app/shared/helpers/date_helper.dart';

class DateInputField extends StatelessWidget {
  final String label;
  final bool busy;
  final TextInputType textInputType;
  final Function(String) onSaved;
  final Function(String) validator;
  final TextEditingController controller;

  const DateInputField({
    Key key,
    this.label,
    this.onSaved,
    this.busy = false,
    this.textInputType = TextInputType.text,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              enabled: !busy,
              controller: controller,
              keyboardType: textInputType,
              validator: validator,
              onSaved: onSaved,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                filled: true,
              ),
            ),
          ),
          Container(
            width: 80.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: !busy ? Theme.of(context).accentColor : Theme.of(context).dividerColor,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: IconButton(
              icon: Icon(
                Icons.date_range,
                color: !busy ? Colors.white : Colors.black38,
              ),
              onPressed: !busy
                  ? () {
                      _openDatePicker(context);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Future _openDatePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: controller.text.isEmpty
          ? DateTime.now()
          : DateHelper.parse(controller.text),
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
    );

    if (date != null) {
      controller.text = DateHelper.format(date);
    }
  }
}
