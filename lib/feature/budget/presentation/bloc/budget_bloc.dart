import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/budget/domain/entites/category_saving_goal.dart';
import 'package:student_expense_analyzer/feature/budget/domain/entites/saving_goal.dart';
import 'package:student_expense_analyzer/feature/budget/domain/usecases/manage_cat_saving_goal.dart';
import '../../domain/usecases/manage_saving_goal.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetSavingGoalUseCase getSavingGoal;
  final SetSavingGoalUseCase setSavingGoal;
  final UpdateSavingGoalUseCase updateSavingGoalUseCase;
  final GetCategorySavingGoalsUseCase getCatGoals;
  final CreateCategoryGoalUseCase setCatGoal;
  final UpdateCategoryGoalUseCase updateCatGoal;

  BudgetBloc({
    required this.getSavingGoal,
    required this.setSavingGoal,
    required this.updateSavingGoalUseCase, required this.getCatGoals, required this.setCatGoal, required this.updateCatGoal,
  }) : super(BudgetInitial()) {
   
    on<FetchAllBudgets>((event, emit) async {
      emit(BudgetLoading());
      try {
        final results = await Future.wait([
          getSavingGoal(),
          getCatGoals(),
        ]);
        emit(BudgetLoaded(
          savingGoal: results[0] as SavingGoal,
          categoryGoals: results[1] as List<CategorySavingGoal>,
        ));
      } catch (e) {
        emit(BudgetError(e.toString()));
      }
    });

  
    on<UpdateCategoryGoal>((event, emit) async {
      final currentState = state;
      if (currentState is BudgetLoaded) {
        try {
          
          final updatedList = currentState.categoryGoals.map((g) {
            return g.id == event.id 
                ? CategorySavingGoal(
                    id: g.id, 
                    category: event.category, 
                    targetAmount: event.amount,
                    expensesAmount: g.expensesAmount,
                    remainingAmount: event.amount - g.expensesAmount,
                  ) 
                : g;
          }).toList();
          
          emit(BudgetLoaded(savingGoal: currentState.savingGoal, categoryGoals: updatedList));

          await updateCatGoal(event.id, event.category, event.amount);
          add(FetchAllBudgets()); 
        } catch (e) {
          emit(BudgetError(e.toString()));
          add(FetchAllBudgets()); 
        }
      }
    });

    on<SetCategoryGoal>((event, emit) async {
      try {
        await setCatGoal(event.category, event.amount);
        add(FetchAllBudgets());
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
      
      add(FetchAllBudgets());
    }
  }
});
  }
}
