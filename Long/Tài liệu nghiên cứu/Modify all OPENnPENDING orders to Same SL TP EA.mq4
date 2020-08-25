//+------------------------------------------------------------------+
//|                                               [EA]ModThemALL.mq4 |
//|                                 Copyright © 2009, Viking234.Com. |
//|                                         http://www.viking234.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Viking234.Com."
#property link      "http://www.viking234.com"

// http://www.forexfactory.com/showthread.php?p=2997450&posted=1#post2997450
// 4Shared file is WORKING VERSION!
// Distributed under GPL (http://www.gnu.org/licenses/gpl.txt)

extern int     TakeProfit        = 100;
extern int     StopLoss          = 100;
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
            if(TakeProfit==0) TP=0;
            else TP=OrderOpenPrice()+TakeProfit*Point;
            if(StopLoss==0) SL=0;
            else SL=OrderOpenPrice()-StopLoss*Point;
            if(OrderTakeProfit()!=TP||OrderStopLoss()!=SL)
               OrderModify(OrderTicket(),OrderOpenPrice(),SL,TP,0,CLR_NONE);
         } else if(OrderType()==OP_SELL||OrderType()==OP_SELLSTOP||OrderType()==OP_SELLLIMIT) {
            if(TakeProfit==0) TP=0;
            else TP=OrderOpenPrice()-TakeProfit*Point;
            if(StopLoss==0) SL=0;
            else SL=OrderOpenPrice()+StopLoss*Point;
            if(OrderTakeProfit()!=TP||OrderStopLoss()!=SL)
               OrderModify(OrderTicket(),OrderOpenPrice(),SL,TP,0,CLR_NONE);
         }
      }
   }   
//----
   return(0);
  }
//+------------------------------------------------------------------+