import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../responsive/responsive_helper.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Category Chip Widget (Responsive & LayoutBuilder safe)
// ════════════════════════════════════════════════════════════════════════════

class GMCategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback? onTap;

  const GMCategoryChip({
    required this.category,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxH = constraints.maxHeight.isInfinite ? 90.0 : constraints.maxHeight;
          final iconBoxSize = (maxH * 0.62).clamp(38.0, 60.0);

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.primaryColor
                      : theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: category.iconUrl != null && category.iconUrl!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: CachedNetworkImage(
                          imageUrl: category.iconUrl!,
                          fit: BoxFit.contain,
                          color: isSelected ? Colors.white : theme.primaryColor,
                          errorWidget: (context, url, error) => Icon(
                            Icons.category_outlined,
                            color: isSelected ? Colors.white : theme.primaryColor,
                            size: iconBoxSize * 0.45,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.category_outlined,
                        color: isSelected ? Colors.white : theme.primaryColor,
                        size: iconBoxSize * 0.45,
                      ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: R.sp(11),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? theme.primaryColor : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
