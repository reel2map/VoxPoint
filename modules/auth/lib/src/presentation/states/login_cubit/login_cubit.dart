import 'package:auth/src/_src.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

part 'login_cubit.freezed.dart';
part 'login_cubit.g.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit({
    required this.loginUseCase,
    required this.checkBlockUseCase,
    required this.unBlockUseCase,
  }) : super(const LoginState());

  final LoginUseCase loginUseCase;

  final CheckBlockUseCase checkBlockUseCase;

  final UnBlockUseCase unBlockUseCase;

  final FormGroup form = FormGroup(<String, AbstractControl<dynamic>>{
    'login': FormControl<String>(
      value: 'demo',
      validators: <Validator<dynamic>>[Validators.required],
    ),
    'password': FormControl<String>(
      value: 'demo',
      validators: <Validator<dynamic>>[Validators.required],
    ),
  });

  Future<void> clear() async {
    emit(const LoginState());
  }

  void setError(String error) {
    emit(state.copyWith(error: error, status: FetchStatus.fetchingFailure));
  }

  void removeError() {
    emit(state.copyWith(error: null, status: FetchStatus.fetchingSuccess));
  }

  Future<void> checkAuth() async {
    final Duration duration = await checkBlockUseCase();

    emit(state.copyWith(blockTime: duration));

    emit(state.copyWith(stateStatus: StateStatus.ready));
  }

  Future<void> login() async {
    emit(state.copyWith(status: FetchStatus.fetchingInProgress));

    final result = await loginUseCase.call();

    result.fold((failure) => setError(failure.message), (success) {
      removeError();

      emit(state.copyWith(stateStatus: StateStatus.finish));
    });
  }

  Future<void> unBlock() async {
    await unBlockUseCase();
  }
}
