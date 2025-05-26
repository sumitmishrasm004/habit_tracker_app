class DropDownModel {
  List<Category>? category;

  DropDownModel({this.category});

  DropDownModel.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  bool? isOpened;
  String? title;
  List<Subcategories>? subcategories;

  Category({this.isOpened, this.title, this.subcategories});

  Category.fromJson(Map<String, dynamic> json) {
    isOpened = json['isOpened'];
    title = json['title'];
    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(new Subcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isOpened'] = this.isOpened;
    data['title'] = this.title;
    if (this.subcategories != null) {
      data['subcategories'] =
          this.subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategories {
  bool? isOpened;
  String? title;
  List<Items>? items;

  Subcategories({this.isOpened, this.title, this.items});

  Subcategories.fromJson(Map<String, dynamic> json) {
    isOpened = json['isOpened'];
    title = json['title'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isOpened'] = this.isOpened;
    data['title'] = this.title;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  bool? isOpened;
  String? title;

  Items({this.isOpened, this.title});

  Items.fromJson(Map<String, dynamic> json) {
    isOpened = json['isOpened'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isOpened'] = this.isOpened;
    data['title'] = this.title;
    return data;
  }
}
