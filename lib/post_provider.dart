import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:request_api/post_model.dart';

const typeList = 10;
const typeGrid = 20;

final viewTypeProvider = StateProvider.autoDispose<int>((ref) => typeList);

class PostNotifier extends ChangeNotifier {
  final limit = 10;
  List<Post> postList = [];
  int page = 0;
  bool isLoading = false;
  String? errorMessage;

  PostNotifier() {
    loadData();
  }

  static final provider =
      ChangeNotifierProvider.autoDispose<PostNotifier>((ref) => PostNotifier());

  void loadData() async {
    log("loadData  $page $limit");
    isLoading = true;
    notifyListeners();

    if (page == 10) {
      errorMessage = "load list finished";
      notifyListeners();
    } else {
      // Simulate fetching data from an API
      await Future.delayed(const Duration(milliseconds: 500));

      // Generate new items
      List<Post> newItems = List.generate(limit, (i) {
        final index = (i + (page * limit)) + 1;
        return Post(
            id: index.toDouble(),
            title: "post $index",
            description: "descripstion $index");
      });

      postList.addAll(newItems);
      page++;

      isLoading = false;
      notifyListeners();
    }
  }
}
