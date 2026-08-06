import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Custom Themed AppBar Widget
// ════════════════════════════════════════════════════════════════════════════

class GMAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const GMAppBar({
    required this.title,
    this.showBack = true,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      automaticallyImplyLeading: showBack,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
