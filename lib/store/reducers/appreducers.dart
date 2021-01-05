import 'package:fans/models/models.dart';
import 'package:fans/store/reducers/auth_reducer.dart';
import 'package:fans/store/reducers/cartreducer.dart';
import 'package:fans/store/reducers/hot_goods_reducer.dart';
import 'package:fans/store/reducers/hot_idols_reducer.dart';
import 'package:fans/store/reducers/hot_load_error_reducer.dart';
import 'package:fans/store/reducers/loadreducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    error: errorReducer(state.error, action),
    hotLoadError: hotLoadErrReducer(state.hotLoadError, action),
    hotIdols: hotIdolsReducer(state.hotIdols, action),
    hotGoods: hotGoodsReducer(state.hotGoods, action),
    cart: cartReducer(state.cart, action),
    isRegist: authReducer(state.isRegist, action),
    emailCheckError: clientValidEmailReducer(state.emailCheckError, action),
    email: setEmailReducer(state.email, action),
    passwordCheckError: validPasswordReducer(state.passwordCheckError, action),
  );
}
