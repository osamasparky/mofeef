class BookingPersonItem {
  final String name;
  final double price;
  final int quantity;

  const BookingPersonItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;
}

class BookingExtraItem {
  final String name;
  final double price;

  const BookingExtraItem({
    required this.name,
    required this.price,
  });
}

class BookingDraft {
  final String title;
  final String? imageUrl;
  final String? location;
  final DateTime date;
  final String serviceType;
  final int serviceId;
  final List<BookingPersonItem> personItems;
  final List<BookingExtraItem> extraItems;
  final double unitPrice;
  final double totalAmount;

  const BookingDraft({
    required this.title,
    this.imageUrl,
    this.location,
    required this.date,
    required this.serviceType,
    required this.serviceId,
    this.personItems = const [],
    this.extraItems = const [],
    this.unitPrice = 0.0,
    required this.totalAmount,
  });

  int get totalGuests {
    if (personItems.isEmpty) return 1;
    return personItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    if (personItems.isNotEmpty || extraItems.isNotEmpty) {
      final pTotal = personItems.fold(0.0, (sum, item) => sum + item.total);
      final eTotal = extraItems.fold(0.0, (sum, item) => sum + item.price);
      return pTotal + eTotal;
    }
    return totalAmount;
  }
}
