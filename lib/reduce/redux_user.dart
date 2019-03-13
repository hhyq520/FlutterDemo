import 'package:flutter_stander/model/login_user.dart';
import 'package:redux/redux.dart';
class UpdateUseraction{
  final User user;
  UpdateUseraction(this.user);
}
User _updateUser(User user,action){
  user=action.user;
  return user;
}
final combineUserReducer =combineReducers<User>([TypedReducer<User,UpdateUseraction>(_updateUser),]);