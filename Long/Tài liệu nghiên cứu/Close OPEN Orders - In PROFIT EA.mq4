//+------------------------------------------------------------------+
//|                                            close-all-orders.mq4  |
//|                                  Copyright © 2005, Matias Romeo. |
//|                                       Custom Metatrader Systems. |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2005, Matias Romeo."
#property link      "mailto:matiasDOTromeoATgmail.com"
//Some Modifications, Functional/Visual By ForexSaint4u@gmail.com

extern int PT = 40; // Maximum Profit target in Dollars/Euro or whichever Currency you have in your account
extern string Profit_Target= "Enter PT above To Book the Profit to that Amount in per -OPEN trade ";
extern string Use= "To Book Profits in Open Winning Trades";
extern string Use2= "Kinda TakeProfit to,OPEN Trades in Loss.In this case PT has to be a Negative Integer";

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
      case OP_BUY       : if ( OrderProfit() >= PT) result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
                          break;
      
      //Close opened short positions
      case OP_SELL      : if ( OrderProfit() >= PT) result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
                          
    }
    
    if(result == false)
    {
      //Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
      Sleep(0);
    }  
  }
  
  return(0);
}