part of 'payout_cubit.dart';

abstract class PayoutState {}

class PayoutInitialState extends PayoutState {}

class PayoutLoadingState extends PayoutState {}



class PayoutLoadedState extends PayoutState {
  final CoachSessionHours coachSessionHours;
  final List<PayoutTransactionModel> payoutTransactions;

  PayoutLoadedState(this.payoutTransactions, this.coachSessionHours);
}

// Add this to Payout_state.dart



class PayoutErrorState extends PayoutState {
  final String error;
  PayoutErrorState(this.error);
}
