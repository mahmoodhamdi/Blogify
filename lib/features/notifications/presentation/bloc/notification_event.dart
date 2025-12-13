part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

final class NotificationFetch extends NotificationEvent {
  final String userId;

  NotificationFetch({required this.userId});
}

final class NotificationFetchMore extends NotificationEvent {}

final class NotificationMarkRead extends NotificationEvent {
  final String notificationId;

  NotificationMarkRead({required this.notificationId});
}

final class NotificationMarkAllRead extends NotificationEvent {
  final String userId;

  NotificationMarkAllRead({required this.userId});
}

final class NotificationFetchUnreadCount extends NotificationEvent {
  final String userId;

  NotificationFetchUnreadCount({required this.userId});
}
