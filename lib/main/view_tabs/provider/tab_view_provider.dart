import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:calendy_x_project/main/view_tabs/enum/tab_view_model.dart';

final tabViewProvider = StateProvider((_) => ViewTab.group);

final tabViewCommentProvider = StateProvider((_) => ViewTabComment.comment);
