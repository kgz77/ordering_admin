import 'package:flutter/material.dart';

import 'package:foda_admin/constant/route_name.dart';

List<Menu> menus = const [
  Menu(
    title: 'Статистика',
    icon: Icons.analytics_outlined,
    route: overview,
    subRoutes: [],
  ),
  Menu(
    title: 'Клиенты',
    icon: Icons.group_outlined,
    route: customerPath,
    subRoutes: [],
  ),
  Menu(
    title: 'Заказы',
    icon: Icons.local_shipping,
    route: ordersPath,
    subRoutes: [],
  ),
  Menu(
    title: 'Добавить',
    icon: Icons.add_circle_outline,
    route: '',
    subRoutes: [
      Menu(
        title: 'Категория',
        icon: Icons.food_bank,
        route: createCategoryPath,
        subRoutes: [],
      ),
      Menu(
        title: 'Добавить еду',
        icon: Icons.create,
        route: createFoodPath,
        subRoutes: [],
      ),
    ],
  ),
  Menu(
    title: 'Меню',
    icon: Icons.restaurant_menu_outlined,
    route: foodsPath,
    subRoutes: [],
  ),
  // Menu(
  //   title: 'Transactions',
  //   icon: Icons.monetization_on_outlined,
  //   route: transactionPath,
  //   subRoutes: [],
  // ),
  // Menu(
  //   title: 'Feedbacks',
  //   icon: Icons.reviews_outlined,
  //   route: feedbackPath,
  //   subRoutes: [],
  // ),
];

@immutable
class Menu {
  final String title;
  final IconData icon;
  final String route;
  final List<Menu> subRoutes;

  const Menu({
    required this.title,
    required this.icon,
    this.route = overview,
    this.subRoutes = const [],
  });
}
