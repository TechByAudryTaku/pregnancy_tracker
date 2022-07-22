import 'package:flutter/material.dart';
import 'package:pregnancytrackerapp/common/theme_helper.dart';
import 'package:pregnancytrackerapp/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:simple_moment/simple_moment.dart';

import 'profile_page.dart';

class AccountSetupPage extends StatefulWidget {
  const AccountSetupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountSetupPageState();
  }
}

class _AccountSetupPageState extends State<AccountSetupPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _lastPeriodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const SizedBox(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "City/Village", "Enter your city/village"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: ThemeHelper().textInputDecoration(
                                "Phone number", "Enter your phone number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (val!.isEmpty &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextField(
                            controller: _birthdayController,
                            //editing controller of this TextField
                            decoration: ThemeHelper().textInputDecoration(
                                "Birthday", "Enter your birthday"),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                // format date
                                String formattedDate = DateFormat('dd MMM yyyy')
                                    .format(pickedDate);

                                setState(() {
                                  // set output date to TextField value.
                                  _birthdayController.text = formattedDate;
                                });
                              } else {}
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextField(
                            controller: _lastPeriodController,
                            //editing controller of this TextField
                            decoration: ThemeHelper().textInputDecoration(
                                "Last period",
                                "Enter the first day of your last menstrual period (LMP)"),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                // format date
                                String formattedDate = DateFormat('dd MMM yyyy')
                                    .format(pickedDate);

                                // convert date to moment object
                                Moment rawDate =
                                    Moment.parse(pickedDate.toString());

                                setState(() {
                                  // set output date to TextField value.
                                  _lastPeriodController.text = formattedDate;
                                  // add 280 days or 40 weeks to the first day of the person's last
                                  //period then assign the result to _dueDateController
                                  _dueDateController.text = rawDate
                                      .add(days: 280)
                                      .format("dd MMM yyyy");
                                  print("Weeks: " +
                                      rawDate.add(days: 280).format("w"));
                                });
                              } else {}
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _dueDateController,
                            //editing controller of this TextField
                            decoration:
                                ThemeHelper().textInputDecoration("Due date"),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      Moment.parse(_lastPeriodController.text)
                                          .date,
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                String formattedDate = DateFormat('dd MMM yyyy')
                                    .format(pickedDate);
                                setState(() {
                                  _dueDateController.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          "Congratulations!",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Text(
                          "You're 3 Weeks pregnant",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfilePage()),
                                    (Route<dynamic> route) => false);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
