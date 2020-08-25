//+------------------------------------------------------------------+
//|                                          NewOrderWithMagicNo.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "none"
#property link      "none"


#property show_inputs

/*
Order Types:
OP_BUY 0 Buying position. 
OP_SELL 1 Selling position. 


*/

extern string Order_Type = "sell";
extern double Lots = 0.1;
extern int magic = 33333;

int m, d, y;


//=============== FUNCTION init
int init()
  {

  }
//== end function

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
  int ticket;
  if(Order_Type == "Buy" || Order_Type == "buy")
   {
    ticket = OrderSend(Symbol(),OP_BUY, Lots, Ask, 2, NULL, NULL, NULL, magic, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
       }
     else Print("Error opening BUY order : ",GetLastError());  
    }
  
  else if(Order_Type == "Sell" || Order_Type == "sell")
   {
    ticket = OrderSend(Symbol(),OP_SELL, Lots, Bid, 2, NULL, NULL, NULL, magic, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }

   
   
   return(0);
  }
  




//+------------------------------------------------------------------+