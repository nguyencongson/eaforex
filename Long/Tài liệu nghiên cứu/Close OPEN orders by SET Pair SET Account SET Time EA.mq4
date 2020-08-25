//+------------------------------------------------------------------+
//|                                                  CloseOnTime.mq4 |
//|                                           Ким Игорь В. aka KimIV |
//|                                              http://www.kimiv.ru |
//|                                                                  |
//| Советник в нужное время закрывает все позиции.                   |
//+------------------------------------------------------------------+
#property copyright "Ким Игорь В. aka KimIV"
#property link      "http://www.kimiv.ru"

//---- input parameters
extern int   CloseHour     = 7;      // Time to close, hours
extern int   CloseMinute   = 0;      // Time to close, minutes
extern bool  UseCurrSymbol = False;  // Use one symbol only
extern bool  UseOneAccount = False;  // Use one account only
extern int   NumberAccount = 11111;  // Account number
extern int   Slippage      = 3;      // Slippage
extern color clCloseBuy    = Blue;   // Color of closing buy
extern color clCloseSell   = Red;    // Color of closing sell

void start() {
  double pBid, pAsk;

  if (UseOneAccount && AccountNumber()!=NumberAccount) {
    Comment("Working on the account: "+AccountNumber()+"is PROHIBITED!");
    return;
  } else Comment("");

  if (Hour()==CloseHour && Minute()>=CloseMinute) {
    for (int i=OrdersTotal()-1; i>=0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
        if (!UseCurrSymbol || OrderSymbol()==Symbol()) {
          if (OrderType()==OP_BUY) {
            pBid=MarketInfo(OrderSymbol(), MODE_BID);
            OrderClose(OrderTicket(), OrderLots(), pBid, Slippage, clCloseBuy);
          }
          if (OrderType()==OP_SELL) {
            pAsk=MarketInfo(OrderSymbol(), MODE_ASK);
            OrderClose(OrderTicket(), OrderLots(), pAsk, Slippage, clCloseSell);
          }
        }
      }
    }
  }
}
//+------------------------------------------------------------------+