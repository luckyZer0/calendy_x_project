// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';



// class MobileGroupView extends ConsumerWidget {
//   const MobileGroupView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDarkMode = ref.watch(themeModeProvider);
//     final groups = ref.watch(allGroupProvider);
//     return RefreshIndicator(
//       onRefresh: () {
//         ref.invalidate(userGroupsProvider);
//         return Future.delayed(const Duration(seconds: 1));
//       },
//       child: groups.when(
//         data: (groups) {
//           if (groups.isEmpty) {
//             return const EmptyContentWithTextAnimationView(
//                 text: Strings.youHaveNoGroups);
//           } else {
//             return GroupCardView(groups: groups);
//           }
//         },
//         error: (error, stackTrace) => const ErrorAnimation(),
//         loading: () => LoadingAnimation(isDarkMode: isDarkMode),
//       ),
//     );
//   }
// }
