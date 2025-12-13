import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/common/widgets/loader.dart';
import 'package:blogify/features/notifications/domain/entities/notification.dart';
import 'package:blogify/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:blogify/features/notifications/presentation/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const NotificationsPage(),
      );

  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchNotifications() {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<NotificationBloc>().add(NotificationFetch(userId: userId));
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NotificationBloc>().add(NotificationFetchMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _markAllAsRead() {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<NotificationBloc>().add(NotificationMarkAllRead(userId: userId));
  }

  void _onNotificationTap(AppNotification notification) {
    // Mark as read
    if (!notification.isRead) {
      context
          .read<NotificationBloc>()
          .add(NotificationMarkRead(notificationId: notification.id));
    }

    // Navigate to the relevant content
    if (notification.blogId != null) {
      // Navigate to blog viewer - we need to fetch the blog first
      // For now, just show a snackbar indicating navigation would happen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening blog...'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded &&
                  state.notifications.any((n) => !n.isRead)) {
                return TextButton(
                  onPressed: _markAllAsRead,
                  child: const Text('Mark all read'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Loader();
          }

          if (state is NotificationFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load notifications',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchNotifications,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: () async {
                _fetchNotifications();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.notifications.length
                    : state.notifications.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.notifications.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final notification = state.notifications[index];
                  return NotificationCard(
                    notification: notification,
                    onTap: () => _onNotificationTap(notification),
                    onMarkRead: notification.isRead
                        ? null
                        : () {
                            context.read<NotificationBloc>().add(
                                  NotificationMarkRead(
                                    notificationId: notification.id,
                                  ),
                                );
                          },
                  );
                },
              ),
            );
          }

          return _buildEmptyState(context);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'When someone likes or comments on your blogs,\nyou\'ll see it here.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
