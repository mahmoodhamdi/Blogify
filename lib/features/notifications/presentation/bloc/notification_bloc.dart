import 'package:blogify/features/notifications/domain/entities/notification.dart';
import 'package:blogify/features/notifications/domain/usecases/get_notifications.dart';
import 'package:blogify/features/notifications/domain/usecases/get_unread_count.dart';
import 'package:blogify/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:blogify/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications _getNotifications;
  final MarkNotificationRead _markNotificationRead;
  final MarkAllNotificationsRead _markAllNotificationsRead;
  final GetUnreadCount _getUnreadCount;

  NotificationBloc({
    required GetNotifications getNotifications,
    required MarkNotificationRead markNotificationRead,
    required MarkAllNotificationsRead markAllNotificationsRead,
    required GetUnreadCount getUnreadCount,
  })  : _getNotifications = getNotifications,
        _markNotificationRead = markNotificationRead,
        _markAllNotificationsRead = markAllNotificationsRead,
        _getUnreadCount = getUnreadCount,
        super(const NotificationInitial()) {
    on<NotificationFetch>(_onFetch);
    on<NotificationFetchMore>(_onFetchMore);
    on<NotificationMarkRead>(_onMarkRead);
    on<NotificationMarkAllRead>(_onMarkAllRead);
    on<NotificationFetchUnreadCount>(_onFetchUnreadCount);
  }

  static const int _notificationsPerPage = 20;

  void _onFetch(
    NotificationFetch event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    final res = await _getNotifications(
      GetNotificationsParams(
        userId: event.userId,
        page: 0,
        limit: _notificationsPerPage,
      ),
    );

    res.fold(
      (l) => emit(NotificationFailure(l.message)),
      (notifications) => emit(NotificationLoaded(
        notifications: notifications,
        userId: event.userId,
        hasReachedMax: notifications.length < _notificationsPerPage,
        currentPage: 0,
      )),
    );
  }

  void _onFetchMore(
    NotificationFetchMore event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is NotificationLoaded && !currentState.hasReachedMax) {
      final nextPage = currentState.currentPage + 1;

      final res = await _getNotifications(
        GetNotificationsParams(
          userId: currentState.userId,
          page: nextPage,
          limit: _notificationsPerPage,
        ),
      );

      res.fold(
        (l) => emit(NotificationFailure(l.message)),
        (newNotifications) {
          if (newNotifications.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(NotificationLoaded(
              notifications: [...currentState.notifications, ...newNotifications],
              userId: currentState.userId,
              hasReachedMax: newNotifications.length < _notificationsPerPage,
              currentPage: nextPage,
            ));
          }
        },
      );
    }
  }

  void _onMarkRead(
    NotificationMarkRead event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;

    final res = await _markNotificationRead(
      MarkNotificationReadParams(notificationId: event.notificationId),
    );

    res.fold(
      (l) => emit(NotificationFailure(l.message)),
      (_) {
        if (currentState is NotificationLoaded) {
          final updatedNotifications = currentState.notifications
              .map((n) => n.id == event.notificationId
                  ? n.copyWith(isRead: true)
                  : n)
              .toList();
          emit(currentState.copyWith(notifications: updatedNotifications));
        }
      },
    );
  }

  void _onMarkAllRead(
    NotificationMarkAllRead event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;

    final res = await _markAllNotificationsRead(
      MarkAllNotificationsReadParams(userId: event.userId),
    );

    res.fold(
      (l) => emit(NotificationFailure(l.message)),
      (_) {
        if (currentState is NotificationLoaded) {
          final updatedNotifications = currentState.notifications
              .map((n) => n.copyWith(isRead: true))
              .toList();
          emit(currentState.copyWith(notifications: updatedNotifications));
        }
      },
    );
  }

  void _onFetchUnreadCount(
    NotificationFetchUnreadCount event,
    Emitter<NotificationState> emit,
  ) async {
    final res = await _getUnreadCount(
      GetUnreadCountParams(userId: event.userId),
    );

    res.fold(
      (l) => null, // Silently fail for count
      (count) => emit(NotificationUnreadCount(count)),
    );
  }
}
