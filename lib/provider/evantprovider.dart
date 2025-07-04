import 'package:flutter/material.dart';
import 'event_model.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [
    Event(title: 'Tech Meetup', date: DateTime(2025, 7, 15), location: 'Kochi', category: 'Tech'),
    Event(title: 'Football Match', date: DateTime(2025, 7, 20), location: 'Malappuram', category: 'Sports'),
    Event(title: 'Cultural Night', date: DateTime(2025, 7, 30), location: 'Calicut', category: 'Culture'),
    Event(title: 'Music Fest', date: DateTime(2025, 8, 5), location: 'Thrissur', category: 'Music'),
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'Date'; // or 'Name'

  List<Event> get filteredEvents {
    List<Event> filtered = _events.where((event) {
      final matchesCategory = _selectedCategory == 'All' || event.category == _selectedCategory;
      final matchesSearch = event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (_sortBy == 'Date') {
      filtered.sort((a, b) => a.date.compareTo(b.date));
    } else {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    }

    return filtered;
  }

  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSortBy() {
    _sortBy = _sortBy == 'Date' ? 'Name' : 'Date';
    notifyListeners();
  }

  String get sortBy => _sortBy;
}

