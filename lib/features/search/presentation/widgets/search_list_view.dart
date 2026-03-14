import 'package:flutter/material.dart';

class SearchListView extends StatelessWidget {
  const SearchListView({
    super.key,
    required this.places,
    required this.icon,
    required this.onTap,
    this.onDelete,
  });
  final List places;
  final IconData icon;
  final Function(dynamic) onTap;
  final Function(dynamic)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return ListTile(
            leading: Icon(icon, color: Colors.grey),
            title: Text(
              place.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: (onDelete != null)
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => onDelete!(place),
                  )
                : null,
            onTap: () => onTap(place),
          );
        },
      ),
    );
  }
}
