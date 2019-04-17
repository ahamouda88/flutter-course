import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/products_model.dart';
import '../scoped_models/users_model.dart';

class MainModel extends Model with ProductsModel, UsersModel {}
