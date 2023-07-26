import 'package:flutter/material.dart';
import 'package:check_and_fix/core/constants/constants_colors.dart';
import 'package:check_and_fix/data/models/list_main_model.dart';
import 'package:check_and_fix/presentation/providers/provider_main.dart';
import 'package:check_and_fix/presentation/utils/services.dart';
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
          const _ListActions(),
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

class _ListActions extends ConsumerWidget {
  const _ListActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerMainRead = ref.read(providerMain.notifier);

    List<ListMainModel> listMainModelList =
        providerMainRead.getListMainModelList();

    return Expanded(
      child: ListView.separated(
        itemCount: listMainModelList.length,
        itemBuilder: (BuildContext context, int index) {
          ListMainModel listMainModelItem = listMainModelList[index];

          return _ActionItem(listMainModelItem: listMainModelItem);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 20);
        },
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.listMainModelItem});

  final ListMainModel listMainModelItem;

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
