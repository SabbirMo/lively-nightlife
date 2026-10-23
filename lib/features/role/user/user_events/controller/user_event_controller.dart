import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';
import '../model/user_event_model.dart';
import '../model/user_ticket_model.dart';
import '../model/user_lineup_model.dart';

class UserEventController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxInt selectedTab = 0.obs; // 0: All, 1: Tonight, 2: This Week, 3: Weekend
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final RxList<UserEventModel> eventsList = <UserEventModel>[].obs;
  final RxList<UserEventModel> filteredEvents = <UserEventModel>[].obs;

  // Pagination & Loading States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasNextPage = true.obs;
  String? _nextUrl;
  int _currentPage = 1;
  final ScrollController scrollController = ScrollController();

  // Selected Ticket Quantities for Booking (TicketID -> Quantity)
  final RxMap<String, int> selectedQuantities = <String, int>{}.obs;
  final RxInt totalPaid = 0.obs;
  final RxString selectedTicketId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    fetchEvents();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    ever(selectedTab, (_) => filterEvents());
    ever(searchQuery, (_) => filterEvents());
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          loadMoreEvents();
        }
      }
    });
  }

  Future<void> fetchEvents({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _nextUrl = null;
      hasNextPage.value = true;
    } else {
      if (eventsList.isEmpty) {
        isLoading.value = true;
      }
      _currentPage = 1;
      _nextUrl = null;
      hasNextPage.value = true;
    }

    try {
      final response = await _apiService.get(
        ApiEndpoints.events,
        queryParameters: {'page': 1},
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          _nextUrl = data['next']?.toString();
          hasNextPage.value = _nextUrl != null && _nextUrl!.isNotEmpty;

          final rawResults = data['results'];
          if (rawResults is List) {
            final List<UserEventModel> loaded = [];
            for (int i = 0; i < rawResults.length; i++) {
              final item = rawResults[i];
              if (item is Map<String, dynamic>) {
                loaded.add(UserEventModel.fromJson(item, isHot: i == 0));
              }
            }
            eventsList.assignAll(loaded);
            filterEvents();
          }
        } else if (data is List) {
          final List<UserEventModel> loaded = [];
          for (int i = 0; i < data.length; i++) {
            final item = data[i];
            if (item is Map<String, dynamic>) {
              loaded.add(UserEventModel.fromJson(item, isHot: i == 0));
            }
          }
          eventsList.assignAll(loaded);
          filterEvents();
        }
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
      if (eventsList.isEmpty) {
        _loadMockEvents();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreEvents() async {
    if (isLoadingMore.value || !hasNextPage.value) return;

    isLoadingMore.value = true;
    _currentPage++;

    try {
      String requestPath = ApiEndpoints.events;
      Map<String, dynamic>? queryParams = {'page': _currentPage};

      if (_nextUrl != null && _nextUrl!.isNotEmpty) {
        try {
          final uri = Uri.parse(_nextUrl!);
          requestPath = uri.path;
          queryParams =
              uri.queryParameters.isNotEmpty ? uri.queryParameters : null;
        } catch (_) {
          requestPath = ApiEndpoints.events;
          queryParams = {'page': _currentPage};
        }
      }

      final response = await _apiService.get(
        requestPath,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          _nextUrl = data['next']?.toString();
          hasNextPage.value = _nextUrl != null && _nextUrl!.isNotEmpty;

          final rawResults = data['results'];
          if (rawResults is List) {
            final List<UserEventModel> loaded = [];
            for (final item in rawResults) {
              if (item is Map<String, dynamic>) {
                loaded.add(UserEventModel.fromJson(item));
              }
            }
            eventsList.addAll(loaded);
            filterEvents();
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading more events: $e');
      _currentPage--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void filterEvents() {
    final query = searchQuery.value.trim().toLowerCase();
    List<UserEventModel> temp = eventsList;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Filter by Tab
    if (selectedTab.value == 1) {
      // Tonight: events today or matching today's date
      temp = temp.where((e) {
        if (e.startTime != null) {
          final start = e.startTime!.toLocal();
          final startDate = DateTime(start.year, start.month, start.day);
          return startDate == today;
        }
        final todayStr =
            '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
        return e.date == todayStr;
      }).toList();
    } else if (selectedTab.value == 2) {
      // This Week: events happening within next 7 days
      final endOfWeek = today.add(const Duration(days: 7));
      temp = temp.where((e) {
        if (e.startTime != null) {
          final start = e.startTime!.toLocal();
          final startDate = DateTime(start.year, start.month, start.day);
          return !startDate.isBefore(today) && !startDate.isAfter(endOfWeek);
        }
        return true;
      }).toList();
    } else if (selectedTab.value == 3) {
      // Weekend: Friday, Saturday, or Sunday
      temp = temp.where((e) {
        if (e.startTime != null) {
          final weekday = e.startTime!.toLocal().weekday;
          return weekday == DateTime.friday ||
              weekday == DateTime.saturday ||
              weekday == DateTime.sunday;
        }
        return e.isHot;
      }).toList();
    }

    if (query.isNotEmpty) {
      temp = temp.where((e) {
        final matchName = e.name.toLowerCase().contains(query);
        final matchLocation = e.location.toLowerCase().contains(query);
        final matchVenue = e.venueName.toLowerCase().contains(query);
        final matchCategory =
            e.categories.any((c) => c.toLowerCase().contains(query));
        final matchTags = e.tags.any((t) => t.toLowerCase().contains(query));
        return matchName ||
            matchLocation ||
            matchVenue ||
            matchCategory ||
            matchTags;
      }).toList();
    }

    filteredEvents.assignAll(temp);
  }

  void toggleRsvp(UserEventModel event) {
    event.isRsvped.toggle();
    final idx = eventsList.indexWhere((e) => e.id == event.id);
    if (idx != -1) {
      eventsList[idx] = event;
      filterEvents();
    }
  }

  void initializeBooking(UserEventModel event) {
    selectedQuantities.clear();
    for (var ticket in event.tickets) {
      selectedQuantities[ticket.id] = 0;
    }
    // Set first category to 1 default
    if (event.tickets.isNotEmpty) {
      selectedTicketId.value = event.tickets.first.id;
      selectedQuantities[event.tickets.first.id] = 1;
    }
    calculateTotal(event);
  }

  void selectTicket(UserEventModel event, String ticketId) {
    selectedTicketId.value = ticketId;
    selectedQuantities.keys.toList().forEach((key) {
      selectedQuantities[key] = (key == ticketId) ? 1 : 0;
    });
    calculateTotal(event);
  }

  void adjustQuantity(UserEventModel event, String ticketId, int change) {
    final current = selectedQuantities[ticketId] ?? 0;
    final ticket = event.tickets.firstWhere((t) => t.id == ticketId);

    int next = current + change;
    if (next < 1) next = 1;
    if (next > ticket.available) next = ticket.available;

    selectedQuantities[ticketId] = next;
    calculateTotal(event);
  }

  void calculateTotal(UserEventModel event) {
    int total = 0;
    selectedQuantities.forEach((tid, quantity) {
      final ticket = event.tickets.firstWhere((t) => t.id == tid);
      total += ticket.price * quantity;
    });
    totalPaid.value = total;
  }

  int getSelectedQuantityCount() {
    int count = 0;
    selectedQuantities.forEach((_, q) => count += q);
    return count;
  }

  void _loadMockEvents() {
    eventsList.assignAll([
      UserEventModel(
        id: '1',
        name: 'ULTRA x Omnia: Martin Garrix Live',
        location: 'Omnia Nightclub, Las Vegas',
        date: '2026-06-14',
        time: '10:30 PM',
        duration: '10:30 PM - 4:00 AM',
        image: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
        price: 75,
        categories: ['EDM', 'Synthwave'],
        tags: ['edm', 'rave', 'neon', 'cyberpunk', 'djset'],
        goingCount: '2,890',
        interestedCount: '8,450',
        isHot: true,
        isRsvped: false,
        description:
            'The biggest EDM event of the summer. Martin Garrix takes over Omnia for an exclusive 4-hour live set. Limited tickets available — this WILL sell out.',
        tickets: const [
          UserTicketModel(
            id: 't1',
            name: 'General Admission',
            price: 75,
            available: 45,
            total: 500,
          ),
          UserTicketModel(
            id: 't2',
            name: 'VIP Package',
            price: 250,
            available: 12,
            total: 100,
          ),
          UserTicketModel(
            id: 't3',
            name: 'Table Minimum',
            price: 2000,
            available: 3,
            total: 20,
          ),
        ],
        lineup: const [
          UserLineupModel(
            name: 'Martin Garrix',
            role: 'Headliner',
            image:
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
          ),
          UserLineupModel(
            name: 'DJ Snake',
            role: 'Special Guest',
            image:
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
          ),
          UserLineupModel(
            name: 'Alesso',
            role: 'Opening Act',
            image:
                'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6',
          ),
        ],
      ),
      UserEventModel(
        id: '2',
        name: 'Coachella Valley Music and Arts Festival',
        location: 'Empire Polo Club, Indio',
        date: '2026-06-27',
        time: '2:00 PM',
        duration: '2:00 PM - 12:00 AM',
        image: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
        price: 499,
        categories: ['Festival', 'Rock', 'Pop', 'Indie'],
        tags: ['festival', 'rock', 'pop', 'indie', 'livemusic'],
        goingCount: '125,000',
        interestedCount: '340,000',
        isHot: false,
        isRsvped: false,
        description:
            'Experience the ultimate music and arts festival in Indio. Featuring standard Coachella configurations, visuals, and premium setups.',
        tickets: const [
          UserTicketModel(
            id: 't4',
            name: 'General Admission Pass',
            price: 499,
            available: 150,
            total: 10000,
          ),
          UserTicketModel(
            id: 't5',
            name: 'VIP Pass',
            price: 1069,
            available: 45,
            total: 2000,
          ),
        ],
        lineup: const [
          UserLineupModel(
            name: 'Lana Del Rey',
            role: 'Headliner',
            image:
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
          ),
          UserLineupModel(
            name: 'Tyler, The Creator',
            role: 'Headliner',
            image:
                'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6',
          ),
        ],
      ),
    ]);
    filterEvents();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
