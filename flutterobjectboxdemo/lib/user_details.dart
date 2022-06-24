import 'package:flutter/material.dart';
import 'package:flutterobjectboxdemo/objectbox.g.dart';
import 'package:flutterobjectboxdemo/objectbox_store_box_helper.dart';
import 'package:flutterobjectboxdemo/user.dart';
import 'package:objectbox/objectbox.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  bool _showBottomSheet = false;
  Store? _store;
  Box<User>? userBox;
  late List<User> _users = [];
  User? currentUser;
  openObjectBox() {
    OpenStoreAndBoxHelper().openObjectBoxStore().then((store) async {
      _store = store;
      userBox = await OpenStoreAndBoxHelper().openUserBox(_store!);
      refreshUsers();
    });
  }

  refreshUsers() async {
    setState(() {
      _users = userBox!.getAll();
    });
  }

  void deleteUser(User user) {
    bool isRemoved = userBox!.remove(user.id);
    if (isRemoved) {
      _users.remove(user);
      setState(() {
        _users = _users;
      });
    }
  }

  void updateUser(User user) {
    userBox!.put(user);
    int index = _users.indexWhere((u) => u.id == user.id);
    if (index > -1) {
      // _users.removeAt(index);
      _users.insert(index, user);
      setState(() {
        _users = _users;
      });
    }
  }

  void openBottomSheet() {
    setState(() {
      _showBottomSheet = !_showBottomSheet;
      if (!_showBottomSheet) {
        refreshUsers();
      } else {
        currentUser = User(name: "", mobile: "", age: 0);
      }
    });
  }

  void editUser(User user) {
    setState(() {
      _showBottomSheet = true;
      currentUser = user;
    });
  }

  @override
  void initState() {
    openObjectBox();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    OpenStoreAndBoxHelper().closeStore(_store!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users Details"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text("Id"),
                  ),
                  DataColumn(
                    label: Text("Name"),
                  ),
                  DataColumn(
                    label: Text("Mobile"),
                  ),
                  DataColumn(
                    label: Text("Age"),
                  ),
                  DataColumn(
                    label: Text(""),
                  ),
                ],
                rows: _users
                    .map((user) => buildDataRow(
                        user, () => deleteUser(user), () => editUser(user)))
                    .toList()),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBottomSheet();
        },
        child: Center(
          child: !_showBottomSheet
              ? const Icon(Icons.add)
              : const Icon(Icons.close),
        ),
      ),
      bottomSheet: _showBottomSheet
          ? BottomSheet(
              onClosing: () {},
              builder: (context) {
                return _bottomSheet(context, _store!, currentUser!);
              })
          : null,
    );
  }
}

Container _bottomSheet(BuildContext context, Store store, User user) {
  final TextEditingController nameController =
      TextEditingController.fromValue(TextEditingValue(text: user.name));
  ;
  final TextEditingController mobileController =
      TextEditingController.fromValue(TextEditingValue(text: user.mobile));
  ;
  final TextEditingController ageController = TextEditingController.fromValue(
      TextEditingValue(text: user.age > 0 ? user.age.toString() : ""));
  ;
  return Container(
    padding: const EdgeInsets.all(20.0),
    height: 350,
    color: Colors.black12,
    child: Form(
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              label: Text("Enter name"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: mobileController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              label: Text("Enter mobile number"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: ageController,
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
                  await OpenStoreAndBoxHelper().openUserBox(store);
              user.name = nameController.text;
              user.mobile = mobileController.text;
              user.age = int.parse(ageController.text);
              userBox.put(user);
              nameController.clear();
              mobileController.clear();
              ageController.clear();
            },
            child: Text(user.id == 0 ? "Add User" : "Edit User"),
          ),
        ],
      ),
    ),
  );
}

DataRow buildDataRow(
    User user, void Function()? deleteUser, void Function()? updateUser) {
  return DataRow(cells: [
    DataCell(Text(user.id.toString())),
    DataCell(Text(user.name)),
    DataCell(Text(user.mobile)),
    DataCell(Text(user.age.toString())),
    DataCell(Row(
      children: [
        IconButton(
          onPressed: updateUser,
          icon: const Icon(Icons.edit),
          color: Colors.green,
          tooltip: "Edit User",
        ),
        IconButton(
          onPressed: deleteUser,
          icon: const Icon(Icons.delete_forever),
          color: Colors.red,
          tooltip: "Delete User",
        )
      ],
    ))
  ]);
}
