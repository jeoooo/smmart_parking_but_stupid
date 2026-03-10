import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SM logo — white silhouette on gradient background
                SvgPicture.asset(
                  'assets/logos/SM_2022.svg',
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
                        // Black for the product name hero text
                        fontSize: compact ? 18 : 22,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'HenrySans',
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (!compact)
                      Text(
                        'SM City Davao',
                        style: TextStyle(
                          // Regular weight for the subtitle
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
