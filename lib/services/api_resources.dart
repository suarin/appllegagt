import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiResources {
  //General Services
  //Create account
  static const String registrationUri = 'customer/register';

  //Login
  static const String loginUri = 'customer/login';

  //Web pin change
  static const String webPinChangeUri = 'customer/webpin';

  //Password change
  static const String passwordChangeUri = 'customer/password';

  //Recover Access
  static const String customerAccessUri = 'customer/recovery_access';

  //Visa request
  static const String visaRequestUri = 'card/visarequest';

  //Visa Balance
  static const String visaBalanceUri = 'plastic_card/balance';

  //Visa Cards
  static const String visaCardsUri = 'plastic_card/cards';

  //Card/BGP Transactions
  static const String cardTransactionsUri = 'card/tranreport';

  //Virtual Card Balance
  static const String virtualCardBalanceUri = 'virtual_card/balance';

  //Virtual Cards
  static const String virtualCardsUri = 'virtual_card/cards';

  //Bills
  static const String billsUri = 'customer/billpay_request';

  //Pay Bill
  static const String payBillUri = 'customer/billpay_confirm';

  //Add Accounts USA
  static const String addAccounts = 'Card/GpsAddAccounts';

  //Add Account GT
  static const String addAccountsYPayMe = 'Card/YpmAddAccounts';

  //Transfers
  //Card Transfer: This method is used to transfer funds from one account/card to another account/card.
  static const String cardTransferUri = 'card/transfer';

  //Visa Transfer: This method is used to transfer money from customer’s account to the Pre-Paid Visa GPS PAY Card.
  static const String visaLoadUri = 'Card/visaload';

  //Bank Accounts
  static const String bankAccountsUri = 'card/bankaccounts';

  //Bank Transfer
  static const String bankTransferUri = 'card/banktransfer';

  //International Transfer
  static const String cardTansferInt = 'card/TransferInt';

  //International Transfer
  static const String cooitzaTansfer = 'plastic_card/cooitzaPay';

  //Get GBP Account for transfers USA
  static const String bgpAccountsUri = 'card/bgpaccounts';

  //Get GBP Account for transfers USA
  static const String ypmAccountsUri = 'card/ypmAccounts';

  //Recharge
  //Deposit Zelle: This method is used to load the customer account/card from domestic bank account
  static const String loadBkUri = 'Card/Loadbk';

  //Zelle transfer information request
  static const String reqZelleInfoUri = 'card/reqZelleInfo';

  //Merchant with voucher
  static const String cardLoadVoucherUri = 'merchant/card_loadvoucher';

  //Merchant with QR
  static const String cardLoadCashUri = 'merchant/card_loadcash';

  //Paysafe
  static const String loadPaySafeUri = 'card/loadpaysafe';

  //PaySafeDepositRequest
  static const String loadPaySafeDepositUri = 'card/reqPaySafe';

  //Purchase
  //Qr Purchase
  static const String qrPayUri = 'card/qrpay';

  //Virtual Card Transactions
  static const String virtualCardTransactionsUri = 'virtual_card/trans';

  //Visa Card Transactions
  static const String visaCardTransactionsUri = 'plastic_card/trans';
}
