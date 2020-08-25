//+------------------------------------------------------------------+
//|                                             [EA]Go2SamePoint.mq4 |
//|                                 Copyright © 2009, Viking234.Com. |
//|                                         http://www.viking234.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Viking234.Com."
#property link      "http://www.viking234.com"

// http://www.forexfactory.com/showthread.php?p=2997450
// 4Shared file is WORKING VERSION!
// Distributed under GPL (http://www.gnu.org/licenses/gpl.txt)
// Donation? Very Welcome > www.viking234.com side bar. =)

extern double    Buy_TP=141.20;
extern double    Buy_SL=140.00;
extern double    Sell_TP=140.00;
extern double    Sell_SL=141.20;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   int HowDeepIsYourLove = OrdersTotal();
   double TP,SL;
   for(int z=0;z<HowDeepIsYourLove;z++) {
      if(OrderSelect(z,SELECT_BY_POS,MODE_TRADES)) {
         if(OrderType()==OP_BUY||OrderType()==OP_BUYSTOP||OrderType()==OP_BUYLIMIT) {
            TP=NormalizeDouble(Buy_TP,Digits);
            SL=NormalizeDouble(Buy_SL,Digits);
            if(OrderTakeProfit()!=TP||OrderStopLoss()!=SL) {
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),SL,TP,0,CLR_NONE))
                  Print("Something happened in BuyHood =), error#"+GetLastError());
            }
         } else if(OrderType()==OP_SELL||OrderType()==OP_SELLSTOP||OrderType()==OP_SELLLIMIT) {
            TP=NormalizeDouble(Sell_TP,Digits);
            SL=NormalizeDouble(Sell_SL,Digits);
            if(OrderTakeProfit()!=TP||OrderStopLoss()!=SL) {
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),SL,TP,0,CLR_NONE))
                  Print("Something happened in SellHood =), error#"+GetLastError());
            }
         }
      }
   }   
//----
   return(0);
  }
//+------------------------------------------------------------------+