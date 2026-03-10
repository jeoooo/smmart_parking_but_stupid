import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Brand Header — SM SmartParking gradient bar
// Implements PreferredSizeWidget so it can be used as Scaffold.appBar.
// ---------------------------------------------------------------------------

class BrandHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool compact;

  const BrandHeader({super.key, this.compact = false});

  @override
  Size get preferredSize =>
      Size.fromHeight(compact ? kToolbarHeight : 110.0);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        height: preferredSize.height + topPadding,
        padding: EdgeInsets.fromLTRB(16, topPadding + 14, 16, 14),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Logo + title — always centered
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/logos/app/SM_2022.svg',
                  width: compact ? 28 : 36,
                  height: compact ? 28 : 36,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SmartParking',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 18 : 22,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'HenrySans',
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (!compact)
                      Text(
                        BranchManager.current.name,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'HenrySans',
                        ),
                      ),
                  ],
                ),
              ],
            ),

            // Back button — only when there is a route to pop to
            if (compact && Navigator.canPop(context))
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(LucideIcons.arrowLeft,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Previews
// ---------------------------------------------------------------------------

@Preview(name: 'BrandHeader · Full')
Widget previewFull() => const BrandHeader();

@Preview(name: 'BrandHeader · Compact')
Widget previewCompact() => const BrandHeader(compact: true);
