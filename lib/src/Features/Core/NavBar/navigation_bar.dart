import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Constants/colors.dart';
import '../../../Controller/theme_controller.dart';
import '../../Authentication/Controllers/nav_bar_controller.dart';
import '../../Authentication/Models/user_model.dart';
import '../Category/views/category_screen.dart';
import '../ChamadosPage/Controller/user_controller.dart';
import '../ChamadosPage/Screen/chamados_screen.dart';
import '../Mapa/maps.dart';
import '../Profile/profile_screen.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  final List<GetPage> _pages = [
    GetPage(name: '/reporting', page: () => const ChamadosScreen()),
    GetPage(name: '/maps', page: () => const MapScreen()),
    GetPage(name: '/category', page: () => const CategoryScreen()),
    GetPage(name: '/user/Settings', page: () => const ProfileScreen()),

  ];

  final controller = Get.put(NavBarController());
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return StreamBuilder<UserModel?>(
      stream: userController.userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        bool isAdmin = user?.isAdmin ?? false;

        final List<GetPage> filteredPages = _pages.where((page) {
          if (page.name == "/category" && !isAdmin) {
            return false; // Remover a página de categoria se o usuário nao for admin
          }
          return true; // Manter todas as outras páginas
        }).toList();

        return StreamBuilder<bool>(
          stream: themeController.isDarkMode.stream,
          initialData: themeController.isDarkMode.value,
          builder: (context, snapshot) {
            final isDark = snapshot.data ?? false;
            return GetBuilder<NavBarController>(
              builder: (context) {
                int selectedIndex = controller.tabIndex.clamp(
                  0,
                  filteredPages.length - 1,
                );
                return Scaffold(
                  body: IndexedStack(
                    index: controller.tabIndex,
                    children: filteredPages.map((page) => page.page()).toList(),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: isDark ? darkNavBar : whiteNavBar,
                    selectedItemColor: isDark ? whiteColor : blackColor,
                    unselectedItemColor: isDark ? white60 : greyShade600,
                    currentIndex: controller.tabIndex,
                    onTap: (index) {
                      setState(() {
                        controller.tabIndex = index;
                      });
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.view_list_rounded,
                          color: isDark ? whiteColor : blackColor,
                        ),
                        label: selectedIndex == 0 ? "Chamados" : "",
                        backgroundColor: isDark ? darkNavBar : whiteBgNavBar,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.map_sharp,
                          color: isDark ? whiteColor : blackColor,
                        ),
                        label: selectedIndex == 1 ? "Maps" : "",
                        backgroundColor: isDark ? darkNavBar : whiteBgNavBar,
                      ),
                      if (isAdmin)
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.sell_sharp,
                            color: isDark ? whiteColor : blackColor,
                          ),
                          label: selectedIndex == 2 ? "Categorias" : "",
                          backgroundColor: isDark ? darkNavBar : whiteBgNavBar,
                        ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.person_sharp,
                          color: isDark ? whiteColor : blackColor,
                        ),
                        label: isAdmin
                            ? selectedIndex == 3
                                ? "Perfil"
                                : ""
                            : selectedIndex == 2
                                ? "Perfil"
                                : "",
                        backgroundColor: isDark ? darkNavBar : whiteBgNavBar,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
