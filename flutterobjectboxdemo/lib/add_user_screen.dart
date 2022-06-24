import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterobjectboxdemo/objectbox.g.dart';
import 'package:flutterobjectboxdemo/objectbox_store_box_helper.dart';
import 'package:flutterobjectboxdemo/user.dart';

class AddUserScreen extends StatefulWidget {
  final Store? store;
  const AddUserScreen({Key? key, required this.store}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(widget.store);
    return Container(
      padding: const EdgeInsets.all(20.0),
      height: 350,
      color: Colors.black12,
      child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                label: Text("Enter name"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                label: Text("Enter mobile number"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text("Enter age"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(300, 50)),
              onPressed: () async {
                Box<User> userBox =
                    await OpenStoreAndBoxHelper().openUserBox(widget.store!);
                userBox.put(User(
                    name: _nameController.text,
                    mobile: _mobileController.text,
                    age: int.parse(_ageController.text)));
              },
              child: const Text("Add User"),
            ),
          ],
        ),
      ),
    );
  }
}
