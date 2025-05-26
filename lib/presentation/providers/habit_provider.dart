import 'package:hooks_riverpod/hooks_riverpod.dart';

class DropDownModel {
  List categoryList;

  DropDownModel({
    this.categoryList = const <CategoryModel>[],
  });
}

class CategoryModel {
  bool isOpened;
  String title;
  List<SubCategory> subcategories;

  CategoryModel({
    this.isOpened = false,
    required this.subcategories,
    this.title = "Thoughts",
  });
}

class SubCategory {
  bool isOpened;
  String subTitle;
  List<String> items;

  SubCategory({
    this.isOpened = false,
    this.subTitle = "Health",
    this.items = const ['Drink Water', 'Eat Fruits'],
  });
}

final dropDownProvider =
    NotifierProvider<DropDownNotifier, DropDownModel>(DropDownNotifier.new);

class DropDownNotifier extends Notifier<DropDownModel> {
  @override
  DropDownModel build() => DropDownModel(categoryList: []);

  // Create a common function to update the properties
  void updateCategoryList(List newCategoryList) {
    final currentCategoryList = newCategoryList ?? state.categoryList;
    state = DropDownModel(categoryList: currentCategoryList);
  }
}

final categoryProvider =
    NotifierProvider<CategoryNotifier, CategoryModel>(CategoryNotifier.new);

class CategoryNotifier extends Notifier<CategoryModel> {
  @override
  CategoryModel build() => CategoryModel(subcategories: []);

  // Create a common function to update the properties
  void updateCategory({
    bool? newIsOpened,
    String? newTitle,
    List<SubCategory>? newSubcategories,
  }) {
    final currentIsOpened = newIsOpened ?? state.isOpened;
    final currentTitle = newTitle ?? state.title;
    final currentSubcategories = newSubcategories ?? state.subcategories;

    state = CategoryModel(
      isOpened: currentIsOpened,
      title: currentTitle,
      subcategories: currentSubcategories,
    );
  }
}

final subCategoryProvider =
    NotifierProvider<SubCategoryNotifier, SubCategory>(SubCategoryNotifier.new);

class SubCategoryNotifier extends Notifier<SubCategory> {
  @override
  SubCategory build() => SubCategory();

  // Create a common function to update the properties
  void updateSubCategory({
    bool? newIsOpened,
    String? newSubTitle,
    List<String>? newItems,
  }) {
    final currentIsOpened = newIsOpened ?? state.isOpened;
    final currentSubTitle = newSubTitle ?? state.subTitle;
    final currentItems = newItems ?? state.items;

    state = SubCategory(
      isOpened: currentIsOpened,
      subTitle: currentSubTitle,
      items: currentItems,
    );
  }
}

Map map = {
  'status': false,
  'category': [
    {
      'isOpened': false,
      'title': 'Thought',
      'subcategories': [
        {
          'isOpened': false,
          'title': 'Health',
          'items': [
            {'isOpened': false, 'title': 'Drink Water', 'items': [
              {
          'isOpened': false,
          'title': '5 litre',
          'items': [
            {'isOpened': false, 'title': 'Per day'
            },
          ]
        },
            ],
            },
          ]
        },
      ]
    }
  ],
};
