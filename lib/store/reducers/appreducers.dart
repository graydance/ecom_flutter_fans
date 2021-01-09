import 'package:fans/models/models.dart';
import 'package:fans/store/reducers/auth_reducer.dart';
import 'package:fans/store/reducers/loadreducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    verifyEmail: verifyEmailReducer(state.verifyEmail, action),
    auth: authReducer(state.auth, action),
    interests: interestReducer(state.interests, action),
    isLoading: loadingReducer(state.isLoading, action),
    error: errorReducer(state.error, action),
  );
}
