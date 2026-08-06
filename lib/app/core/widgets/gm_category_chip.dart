import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../responsive/responsive_helper.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Category Chip Widget (Responsive & Themed)
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: R.isMobile ? 60 : 70,
            height: R.isMobile ? 60 : 70,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.primaryColor
                  : theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: category.iconUrl != null && category.iconUrl!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: CachedNetworkImage(
                      imageUrl: category.iconUrl!,
                      fit: BoxFit.contain,
                      color: isSelected ? Colors.white : theme.primaryColor,
                      errorWidget: (context, url, error) => Icon(
                        Icons.category_outlined,
                        color: isSelected ? Colors.white : theme.primaryColor,
                      ),
                    ),
                  )
                : Icon(
                    Icons.category_outlined,
                    color: isSelected ? Colors.white : theme.primaryColor,
                    size: R.isMobile ? 26 : 30,
                  ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: R.isMobile ? 70 : 80,
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: R.sp(12),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? theme.primaryColor : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
