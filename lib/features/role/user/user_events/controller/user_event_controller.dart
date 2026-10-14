import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/user_event_model.dart';
import '../model/user_ticket_model.dart';
import '../model/user_lineup_model.dart';

class UserEventController extends GetxController {
  final RxInt selectedTab = 0.obs; // 0: All, 1: Tonight, 2: This Week, 3: Weekend
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final RxList<UserEventModel> eventsList = <UserEventModel>[].obs;
  final RxList<UserEventModel> filteredEvents = <UserEventModel>[].obs;

  // Selected Ticket Quantities for Booking (TicketID -> Quantity)
  final RxMap<String, int> selectedQuantities = <String, int>{}.obs;
  final RxInt totalPaid = 0.obs;
  final RxString selectedTicketId = ''.obs;

  @override
  void onInit() {
    _loadMockEvents();
    filterEvents();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    ever(selectedTab, (_) => filterEvents());
    ever(searchQuery, (_) => filterEvents());
    super.onInit();
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void filterEvents() {
    final query = searchQuery.value.toLowerCase();
    List<UserEventModel> temp = eventsList;

    // Filter by Tab (Simulated date categorizations)
    if (selectedTab.value == 1) {
      temp = temp.where((e) => e.date == '2026-06-22' || e.isHot).toList(); // Tonight mock
    } else if (selectedTab.value == 2) {
      temp = temp.where((e) => e.date.contains('2026-06-22') || e.date.contains('2026-06-23')).toList();
    } else if (selectedTab.value == 3) {
      temp = temp.where((e) => e.isHot).toList();
    }

    if (query.isNotEmpty) {
      temp = temp.where((e) => e.name.toLowerCase().contains(query) || e.location.toLowerCase().contains(query)).toList();
    }

    filteredEvents.assignAll(temp);
  }

  void toggleRsvp(UserEventModel event) {
    event.isRsvped.toggle();
    // Update count mock representation
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
        goingCount: '2,890',
        interestedCount: '8,450',
        isHot: true,
        isRsvped: false,
        description: 'The biggest EDM event of the summer. Martin Garrix takes over Omnia for an exclusive 4-hour live set. Limited tickets available — this WILL sell out.',
        tickets: const [
          UserTicketModel(id: 't1', name: 'General Admission', price: 75, available: 45, total: 500),
          UserTicketModel(id: 't2', name: 'VIP Package', price: 250, available: 12, total: 100),
          UserTicketModel(id: 't3', name: 'Table Minimum', price: 2000, available: 3, total: 20),
        ],
        lineup: const [
          UserLineupModel(name: 'Martin Garrix', role: 'Headliner', image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d'),
          UserLineupModel(name: 'DJ Snake', role: 'Special Guest', image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e'),
          UserLineupModel(name: 'Alesso', role: 'Opening Act', image: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6'),
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
        goingCount: '125,000',
        interestedCount: '340,000',
        isHot: false,
        isRsvped: false,
        description: 'Experience the ultimate music and arts festival in Indio. Featuring standard Coachella configurations, visuals, and premium setups.',
        tickets: const [
          UserTicketModel(id: 't4', name: 'General Admission Pass', price: 499, available: 150, total: 10000),
          UserTicketModel(id: 't5', name: 'VIP Pass', price: 1069, available: 45, total: 2000),
        ],
        lineup: const [
          UserLineupModel(name: 'Lana Del Rey', role: 'Headliner', image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'),
          UserLineupModel(name: 'Tyler, The Creator', role: 'Headliner', image: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6'),
        ],
      ),
    ]);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
