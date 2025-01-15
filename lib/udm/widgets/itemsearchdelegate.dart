import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemSearchDelegate extends SearchDelegate<Item?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }
    this.close(context, null);

    return Container();
    // ItemsListScreen(itemsList: Item.itemsList.where((element) => element.description == query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}

class _ItemSuggestionList extends StatelessWidget {
  const _ItemSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<Item>? suggestions;
  final String? query;
  final ValueChanged? onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16);
    return ListView.builder(
      itemCount: suggestions!.length,
      itemBuilder: (BuildContext context, int i) {
        final Item suggestion = suggestions![i];
        return ListTile(
          // leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          leading: Text(suggestion.item_code),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.description,
              style: textTheme,
            ),
          ),
          onTap: () {
            // onSelected(suggestion);
          },
        );
      },
    );
  }
}
