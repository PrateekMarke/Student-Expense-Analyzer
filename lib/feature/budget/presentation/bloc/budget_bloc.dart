import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/budget/domain/entites/saving_goal.dart';
import '../../domain/usecases/manage_saving_goal.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetSavingGoalUseCase getSavingGoal;
  final SetSavingGoalUseCase setSavingGoal;
  final UpdateSavingGoalUseCase updateSavingGoalUseCase;

  BudgetBloc({
    required this.getSavingGoal,
    required this.setSavingGoal,
    required this.updateSavingGoalUseCase,
  }) : super(BudgetInitial()) {
    on<FetchSavingGoal>((event, emit) async {
      emit(BudgetLoading());
      try {
        final goal = await getSavingGoal();
        emit(BudgetLoaded(savingGoal: goal));
      } catch (e) {
        emit(BudgetError(e.toString()));
      }
    });

    on<SetSavingGoal>((event, emit) async {
      try {
        final goal = await setSavingGoal(event.amount);
        emit(BudgetLoaded(savingGoal: goal));
      } catch (e) {
        emit(BudgetError(e.toString()));
      }
    });
  on<UpdateSavingGoal>((event, emit) async {
  final currentState = state;
  if (currentState is BudgetLoaded) {
    try {
      final oldGoal = currentState.savingGoal;

      
      final predictedGoal = SavingGoal(
        id: oldGoal.id,
        targetAmount: event.amount, 
        remainingAmount: event.amount - oldGoal.expensesAmount, 
        expensesAmount: oldGoal.expensesAmount,
        createdAt: oldGoal.createdAt,
      );
      emit(BudgetLoaded(savingGoal: predictedGoal));

     
      await updateSavingGoalUseCase(oldGoal.id, event.amount);

     
      final freshGoal = await getSavingGoal();
      emit(BudgetLoaded(savingGoal: freshGoal));
      
    } catch (e) {
      emit(BudgetError("Update failed: ${e.toString()}"));
      
      add(FetchSavingGoal());
    }
  }
});
  }
}
