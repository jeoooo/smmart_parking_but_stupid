import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Brand Header — SM SmartParking gradient bar
// ---------------------------------------------------------------------------

class BrandHeader extends StatelessWidget {
  final bool compact;

  const BrandHeader({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.fromLTRB(24, compact ? 16 : 48, 24, compact ? 16 : 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Stack(
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
                // Back button — left side, only when there's a screen to pop to
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
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Previews
// ---------------------------------------------------------------------------

@Preview(name: 'BrandHeader \u00B7 Full')
Widget previewFull() => const BrandHeader();

@Preview(name: 'BrandHeader \u00B7 Compact')
Widget previewCompact() => const BrandHeader(compact: true);
