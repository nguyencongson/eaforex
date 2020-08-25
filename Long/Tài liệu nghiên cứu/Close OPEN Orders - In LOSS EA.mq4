//+------------------------------------------------------------------+
//|                                            close-all-orders.mq4  |
//|                                  Copyright © 2005, Matias Romeo. |
//|                                       Custom Metatrader Systems. |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2005, Matias Romeo."
#property link      "mailto:matiasDOTromeoATgmail.com"
//Some Modifications, Functional/Visual By ForexSaint4u@gmail.com

extern int LT = -20; // Maximum Loss target in Dollars/Euro or whichever Currency you have in your account
extern string Loss_Target= "Enter LT above To limit the loss to that Amount in per -OPEN trade ";
extern string Use1= "To Limit losses in Losing Trades";
extern string Use2= "Kinda StopLoss to,OPEN Trades in Profit.In this case LT has to be a Positive Integer";

int start()
{
  int total = OrdersTotal();
  for(int i=total-1;i>=0;i--)
  {
    OrderSelect(i, SELECT_BY_POS);
    int type   = OrderType();

    bool result = false;
    
    switch(type)
    {
      //Close opened long positions
      case OP_BUY       : if ( OrderProfit() <= LT) result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
                          break;
      
      //Close opened short positions
      case OP_SELL      : if ( OrderProfit() <= LT) result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
                          
    }
    
    if(result == false)
    {
      //Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
      Sleep(0);
    }  
  }
  
  return(0);
}