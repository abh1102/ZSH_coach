import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanadu_coach/feature/profile/data/model/coach_session_hours.dart';
import 'package:zanadu_coach/feature/profile/data/model/payout_transaction_model.dart';
import 'package:zanadu_coach/feature/profile/data/repository/profile_repository.dart';

part 'payout_state.dart';

class PayoutCubit extends Cubit<PayoutState> {
  PayoutCubit() : super(PayoutInitialState()) {
    getPayOutData();
  }

  final ProfileRepository _repository = ProfileRepository();

  Future<void> getPayOutData() async {
    emit(PayoutLoadingState());
    try {
      CoachSessionHours hours = await _repository.getCoachSession();

      List<PayoutTransactionModel> transactions =
          await _repository.getPayoutTransaction();

      emit(PayoutLoadedState(transactions, hours));
    } catch (e) {
      emit(PayoutErrorState(e.toString()));
    }
  }
}
