import 'package:built_value/built_value.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper_models/branch.dart';
import 'package:redux/redux.dart';

part 'home_app_bar_viewmodel.g.dart';

abstract class HomeAppBarViewModel
    implements Built<HomeAppBarViewModel, HomeAppBarViewModelBuilder> {
  HomeAppBarViewModel._();

  // ignore: sort_unnamed_constructors_first
  factory HomeAppBarViewModel(
          [void Function(HomeAppBarViewModelBuilder) updates]) =
      _$HomeAppBarViewModel;

  bool get hasUpdatedChannelsInGroup;

  String get title;

  bool get memberOfChannel;

  bool get isEvent;

  String get eventDate;

  static Function(Store<AppState>) fromStore(context) {
    return (Store<AppState> store) {
//      final channels = getSelectedChannel(store.state);
//      final groupId = store.state.selectedGroupId;
//      final channels = store.state.groups[groupId].channels.values.toList();
//      final hasGroupUpdates =
//          channels.any((c) => (c != channels) && c.hasUpdates);

//      final isMemberOfChannel =
//          channels.users.any((u) => u.id == store.state.user.uid);

      return HomeAppBarViewModel((vm) {
//        return vm
//          ..title = channels.name
//          ..memberOfChannel = isMemberOfChannel
//          ..hasUpdatedChannelsInGroup = hasGroupUpdates
//          ..isEvent = channels.type == ChannelType.EVENT
//          ..eventDate = _formatDate(context, channels);
      });
    };
  }

  static String _formatDate(context, Branch branch) {}
}
