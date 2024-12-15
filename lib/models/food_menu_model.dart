// To parse this JSON data, do
//
//     final foodMenuModel = foodMenuModelFromJson(jsonString);

import 'dart:convert';

FoodMenuModel foodMenuModelFromJson(String str) => FoodMenuModel.fromJson(json.decode(str));

String foodMenuModelToJson(FoodMenuModel data) => json.encode(data.toJson());

class FoodMenuModel {
    List<Category>? categories;

    FoodMenuModel({
        this.categories,
    });

    factory FoodMenuModel.fromJson(Map<String, dynamic> json) => FoodMenuModel(
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    };
}

class Category {
    int? id;
    String? name;
    List<Dish>? dishes;

    Category({
        this.id,
        this.name,
        this.dishes,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        dishes: json["dishes"] == null ? [] : List<Dish>.from(json["dishes"]!.map((x) => Dish.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dishes": dishes == null ? [] : List<dynamic>.from(dishes!.map((x) => x.toJson())),
    };
}

class Dish {
    int? id;
    String? name;
    String? price;
    String? currency;
    int? calories;
    String? description;
    List<Addon>? addons;
    String? imageUrl;
    bool? customizationsAvailable;

    Dish({
        this.id,
        this.name,
        this.price,
        this.currency,
        this.calories,
        this.description,
        this.addons,
        this.imageUrl,
        this.customizationsAvailable,
    });

    factory Dish.fromJson(Map<String, dynamic> json) => Dish(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        currency: json["currency"],
        calories: json["calories"],
        description: json["description"],
        addons: json["addons"] == null ? [] : List<Addon>.from(json["addons"]!.map((x) => Addon.fromJson(x))),
        imageUrl: json["image_url"],
        customizationsAvailable: json["customizations_available"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "currency": currency,
        "calories": calories,
        "description": description,
        "addons": addons == null ? [] : List<dynamic>.from(addons!.map((x) => x.toJson())),
        "image_url": imageUrl,
        "customizations_available": customizationsAvailable,
    };
}

class Addon {
    int? id;
    String? name;
    String? price;

    Addon({
        this.id,
        this.name,
        this.price,
    });

    factory Addon.fromJson(Map<String, dynamic> json) => Addon(
        id: json["id"],
        name: json["name"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
    };
}
