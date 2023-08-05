import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/data/models/card_model.dart';
import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:check_and_fix/presentation/utils/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({
    super.key,
    required this.bnbType,
  });

  final BNBType bnbType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xfff6f6f6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _Title(bnbType: bnbType),
          const SizedBox(height: 40),
          const _ActionCardList(),
        ],
      ),
    );
  }
}

class _Title extends ConsumerWidget {
  const _Title({required this.bnbType});

  final BNBType bnbType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerMainRead = ref.read(providerMain.notifier);

    return Text(
      providerMainRead.getTitlePage(bnbType),
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: ConstantsColors.colorBlueGrey,
      ),
    );
  }
}

class _ActionCardList extends ConsumerWidget {
  const _ActionCardList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerMainRead = ref.read(providerMain.notifier);
    final providerMainWatch = ref.watch(providerMain);

    String title = providerMainRead
        .getTitlePage(providerMainRead.bnbList[providerMainWatch.currentTabIndex]);
    List<CardModel> cardModelList = providerMainRead.getCardModelList(title);

    return Expanded(
      child: ListView.separated(
        itemCount: cardModelList.length,
        itemBuilder: (BuildContext context, int i) => _CardItem(cardModelList[i]),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem(this.listMainModelItem);

  final CardModel listMainModelItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: ConstantsColors.colorIndigo,
            ),
            child: Icon(
              listMainModelItem.icon,
              color: ConstantsColors.colorWhite,
            ),
          ),
          title: Text(
            listMainModelItem.title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              listMainModelItem.subtitle!,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
