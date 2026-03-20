import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../../../data/datasource/category_remote_datasource.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../domain/entities/categories/categories_overview.dart';
import '../../../domain/entities/categories/category.dart';
import '../../../domain/repositories/category_repository.dart';
import '../../../domain/usecases/categories/create_category_usecase.dart';
import '../../../domain/usecases/categories/delete_category_usecase.dart';
import '../../../domain/usecases/categories/get_categories_usecase.dart';
import '../../../domain/usecases/categories/update_category_usecase.dart';

part 'category_providers.g.dart';

final categoryRemoteDatasourceProvider = Provider<CategoryRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryRemoteDatasource(dio);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(datasource: ref.watch(categoryRemoteDatasourceProvider));
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  return GetCategoriesUseCase(ref.watch(categoryRepositoryProvider));
});

final createCategoryUseCaseProvider = Provider<CreateCategoryUseCase>((ref) {
  return CreateCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

final updateCategoryUseCaseProvider = Provider<UpdateCategoryUseCase>((ref) {
  return UpdateCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

final deleteCategoryUseCaseProvider = Provider<DeleteCategoryUseCase>((ref) {
  return DeleteCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

@riverpod
class CategoriesOverviewController extends _$CategoriesOverviewController {
  @override
  FutureOr<CategoriesOverview> build() {
    final useCase = ref.read(getCategoriesUseCaseProvider);
    return useCase();
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(getCategoriesUseCaseProvider)());
  }
}

@riverpod
class CategoryMutationController extends _$CategoryMutationController {
  @override
  FutureOr<void> build() {}

  Future<bool> createCategory({
    required String name,
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(createCategoryUseCaseProvider)(
        name: name,
        type: type,
        budget: budget,
        icon: icon,
        color: color,
      );
      ref.invalidate(categoriesOverviewControllerProvider);
    });
    return !state.hasError;
  }

  Future<bool> updateCategory({
    required int id,
    required String name,
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(updateCategoryUseCaseProvider)(
        id: id,
        name: name,
        type: type,
        budget: budget,
        icon: icon,
        color: color,
      );
      ref.invalidate(categoriesOverviewControllerProvider);
    });
    return !state.hasError;
  }

  Future<bool> deleteCategory(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(deleteCategoryUseCaseProvider)(id);
      ref.invalidate(categoriesOverviewControllerProvider);
    });
    return !state.hasError;
  }

  String? get errorMessage => state.maybeWhen(
    error: (error, _) => error.toString().replaceFirst('Exception: ', ''),
    orElse: () => null,
  );
}
