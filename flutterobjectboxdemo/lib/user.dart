import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  int id = 0;
  String name;
  String mobile;
  int age;

  User({required this.name, required this.mobile, required this.age});
}
