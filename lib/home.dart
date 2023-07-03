import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:request_api/post_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = _calculateCrossAxisCount(context);
    return Scaffold(
      appBar: _appbar(context),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer(builder: (context, ref, _) {
          final postListState = ref.watch(PostNotifier.provider);
          if (postListState.isLoading && postListState.page <= 0) {
            return const Center(child: CircularProgressIndicator());
          }
          if (postListState.errorMessage != null && postListState.page <= 0) {
            return Center(
                child: Text(postListState.errorMessage.toString(),
                    style: Theme.of(context).textTheme.labelMedium));
          }
          return NotificationListener(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !postListState.isLoading &&
                  postListState.errorMessage == null) {
                ref.read(PostNotifier.provider.notifier).loadData();
                return false;
              }
              return true;
            },
            child: Consumer(builder: (context, ref, _) {
              final type = ref.watch(viewTypeProvider);
              return type == typeList
                  ? _buildList(postListState)
                  : _buildGrid(postListState, crossAxisCount);
            }),
          );
        }),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width <= 420
        ? 2
        : width <= 580
            ? 3
            : width <= 720
                ? 4
                : 5;
    return crossAxisCount;
  }

  _buildGrid(PostNotifier postListState, int crossAxisCount) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 16 / 6),
      itemCount: postListState.postList.length,
      itemBuilder: (context, index) {
        final post = postListState.postList[index];
        return ColoredBox(
          color: Colors.white,
          child: ListTile(
            title:
                Text(post.title, style: Theme.of(context).textTheme.titleSmall),
            subtitle:
                Text(post.title, style: Theme.of(context).textTheme.bodySmall),
          ),
        );
      },
    );
  }

  _buildList(PostNotifier postListState) {
    return ListView.separated(
      itemCount: postListState.postList.length + 1,
      itemBuilder: (context, index) {
        if (index < postListState.postList.length) {
          // Build your item widget here
          final post = postListState.postList[index];
          return ColoredBox(
            color: Colors.white,
            child: ListTile(
              title: Text(post.title,
                  style: Theme.of(context).textTheme.titleSmall),
              subtitle: Text(post.title,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          );
        } else {
          // Show loading widget at the bottom
          return Visibility(
            visible:
                postListState.isLoading && postListState.errorMessage == null,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  _appbar(BuildContext context) {
    return AppBar(
      title: Text("Latihan Infinite Scrollview",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white)),
      actions: [
        Consumer(builder: (context, ref, _) {
          final type = ref.watch(viewTypeProvider);
          return IconButton(
              onPressed: () {
                ref.invalidate(PostNotifier.provider);
                ref
                    .read(viewTypeProvider.notifier)
                    .update((state) => state == typeGrid ? typeList : typeGrid);
              },
              icon: type == typeGrid
                  ? const Icon(
                      Icons.grid_on_rounded,
                      color: Colors.white,
                    )
                  : const Icon(Icons.grid_off_rounded, color: Colors.white));
        })
      ],
    );
  }
}
