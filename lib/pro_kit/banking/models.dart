import 'package:cheetah_driver/pro_kit/banking/utils.dart';

class BankingShareInfoModel {
  String icon = "";

  BankingShareInfoModel(this.icon);
}
List<BankingShareInfoModel> bankingInfoList() {
  List<BankingShareInfoModel> list = List<BankingShareInfoModel>();

  var list1 = BankingShareInfoModel(Banking_ic_Skype);
  list.add(list1);

  var list2 = BankingShareInfoModel(Banking_ic_Inst);
  list.add(list2);

  var list3 = BankingShareInfoModel(Banking_ic_WhatsApp);
  list.add(list3);

  var list4 = BankingShareInfoModel(Banking_ic_messenger);
  list.add(list4);

  var list5 = BankingShareInfoModel(Banking_ic_facebook);
  list.add(list5);

  return list;
}
