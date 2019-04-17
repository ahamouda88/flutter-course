import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/connected_products_model.dart';

class MainModel extends Model
    with ConnectedProductsModel, ProductsModel, UsersModel {}
