// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:sendbird_chat_sdk/src/internal/main/chat/chat.dart';
import 'package:sendbird_chat_sdk/src/internal/main/logger/sendbird_logger.dart';
import 'package:sendbird_chat_sdk/src/internal/network/http/http_client/request/user/list/banned_user_list_request.dart';
import 'package:sendbird_chat_sdk/src/internal/network/http/http_client/response/responses.dart';
import 'package:sendbird_chat_sdk/src/public/core/user/restricted_user.dart';
import 'package:sendbird_chat_sdk/src/public/main/chat/sendbird_chat.dart';
import 'package:sendbird_chat_sdk/src/public/main/define/enums.dart';
import 'package:sendbird_chat_sdk/src/public/main/define/exceptions.dart';
import 'package:sendbird_chat_sdk/src/public/main/query/base_query.dart';

/// A class representing query to retrieve lists related to banned [User].
class BannedUserListQuery extends BaseQuery {
  /// The [ChannelType] of the channel you want to get banned users from.
  ChannelType channelType;

  /// The channel url of the channel you want to get banned users from.
  String channelUrl;

  BannedUserListQuery({
    required this.channelType,
    required this.channelUrl,
    Chat? chat,
  }) : super(chat: chat ?? SendbirdChat().chat);

  /// Gets the list of next items.
  @override
  Future<List<RestrictedUser>> next() async {
    sbLog.i(StackTrace.current);

    if (isLoading) throw QueryInProgressException();
    if (!hasNext) return [];

    isLoading = true;

    final req = BannedUserListRequest(
      chat,
      limit: limit,
      channelType: channelType,
      channelUrl: channelUrl,
      token: token,
    );

    final res =
        await chat.apiClient.send<UserListQueryResponse<RestrictedUser>>(req);
    isLoading = false;
    token = res.next;
    hasNext = res.next != '';
    return res.users;
  }
}
