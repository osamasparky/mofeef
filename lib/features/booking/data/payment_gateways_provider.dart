import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class PaymentGatewayItem {
  final String id;
  final String name;
  final String nameAr;
  final String desc;
  final String descAr;
  final bool isOffline;
  final String iconType;

  const PaymentGatewayItem({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.desc,
    required this.descAr,
    this.isOffline = false,
    required this.iconType,
  });
}

final paymentGatewaysProvider = FutureProvider<List<PaymentGatewayItem>>((ref) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get(ApiEndpoints.gateways);
    final data = response.data;
    final List<PaymentGatewayItem> list = [];

    if (data is Map<String, dynamic>) {
      if (data.containsKey('moyasar') || data['status'] == 1) {
        list.add(
          const PaymentGatewayItem(
            id: 'moyasar_apple_pay',
            name: 'Apple Pay (via Moyasar)',
            nameAr: 'Apple Pay (عبر بوابة ميسر)',
            desc: 'Instant & secure Apple Pay checkout',
            descAr: 'دفع فوري وآمن بضغطة واحدة عبر Apple Pay',
            iconType: 'apple_pay',
          ),
        );
        list.add(
          const PaymentGatewayItem(
            id: 'moyasar_mada',
            name: 'Mada Debit Card (via Moyasar)',
            nameAr: 'بطاقة مدى البنكية (بوابة ميسر)',
            desc: 'Saudi national payment network',
            descAr: 'الدفع المباشر عبر بطاقة مدى السعودية',
            iconType: 'mada',
          ),
        );
        list.add(
          const PaymentGatewayItem(
            id: 'moyasar_card',
            name: 'Credit Card (Visa / MasterCard)',
            nameAr: 'البطاقات الائتمانية (Visa / MasterCard)',
            desc: 'Secure credit card transaction',
            descAr: 'معالجة مشفرة وآمنة لبطاقات فيزا وماستركارد',
            iconType: 'card',
          ),
        );
        list.add(
          const PaymentGatewayItem(
            id: 'moyasar_stc',
            name: 'STC Pay (via Moyasar)',
            nameAr: 'STC Pay (عبر بوابة ميسر)',
            desc: 'Direct mobile wallet payment',
            descAr: 'الدفع السريع عبر محفظة STC Pay',
            iconType: 'stc_pay',
          ),
        );
      }

      if (data.containsKey('offline')) {
        list.add(
          const PaymentGatewayItem(
            id: 'offline',
            name: 'Offline / Pay on Arrival',
            nameAr: 'الدفع عند الوصول / تحويل بنكي',
            desc: 'Pay at the venue or direct bank transfer',
            descAr: 'الدفع نقداً أو بالشبكة عند نقطة الالتقاء أو تحويل بنكي',
            isOffline: true,
            iconType: 'offline',
          ),
        );
      }
    }

    if (list.isEmpty) {
      list.addAll(_defaultGateways);
    }
    return list;
  } catch (_) {
    return _defaultGateways;
  }
});

const _defaultGateways = [
  PaymentGatewayItem(
    id: 'moyasar_apple_pay',
    name: 'Apple Pay (via Moyasar)',
    nameAr: 'Apple Pay (بوابة ميسر المعتمدة)',
    desc: 'Instant Apple Pay payment',
    descAr: 'دفع فوري وآمن عبر Apple Pay معتمد من ساما',
    iconType: 'apple_pay',
  ),
  PaymentGatewayItem(
    id: 'moyasar_mada',
    name: 'Mada Debit Card (via Moyasar)',
    nameAr: 'بطاقة مدى البنكية (بوابة ميسر)',
    desc: 'Saudi national payment network',
    descAr: 'الدفع عبر الشبكة السعودية للمدفوعات (مدى)',
    iconType: 'mada',
  ),
  PaymentGatewayItem(
    id: 'moyasar_card',
    name: 'Credit Card (Visa / MasterCard)',
    nameAr: 'بطاقات Visa / MasterCard (بوابة ميسر)',
    desc: 'Secure credit card transaction',
    descAr: 'بوابة دفع ميسر المشفرة للبطاقات العالمية',
    iconType: 'card',
  ),
  PaymentGatewayItem(
    id: 'wallet',
    name: 'Modeefe Wallet Balance',
    nameAr: 'رصيد محفظة مُضيف (١,٢٥٠ ر.س)',
    desc: 'Pay directly from your in-app balance',
    descAr: 'خصم مباشر وفوري من رصيد محفظتك المتاح',
    iconType: 'wallet',
  ),
  PaymentGatewayItem(
    id: 'offline',
    name: 'Pay on Arrival',
    nameAr: 'الدفع عند الوصول / تحويل بنكي',
    desc: 'Pay at the venue or transfer',
    descAr: 'الدفع عند نقطة بدء المسار أو الفعالية',
    isOffline: true,
    iconType: 'offline',
  ),
];
