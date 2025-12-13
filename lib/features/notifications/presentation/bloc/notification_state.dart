part of 'notification_bloc.dart';

@immutable
sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

final class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

final class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

final class NotificationFailure extends NotificationState {
  final String error;
  const NotificationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

final class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;
  final String userId;
  final bool hasReachedMax;
  final int currentPage;

  const NotificationLoaded({
    required this.notifications,
    required this.userId,
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  NotificationLoaded copyWith({
    List<AppNotification>? notifications,
    String? userId,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      userId: userId ?? this.userId,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  List<Object?> get props => [notifications, userId, hasReachedMax, currentPage];
}

final class NotificationUnreadCount extends NotificationState {
  final int count;
  const NotificationUnreadCount(this.count);

  @override
  List<Object?> get props => [count];
}
