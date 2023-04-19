import 'package:flutter/material.dart';
import '../modules/offers/filtered_offers_view.dart';
import 'filter_modal.dart';

class SearchAndFilter extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (query) {}, // Remove the onChanged handler
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilteredJobOffersPage(
                          filterConfig: {}, // Replace with your filter configuration
                          query: _searchController.text,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return FilterModal();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
