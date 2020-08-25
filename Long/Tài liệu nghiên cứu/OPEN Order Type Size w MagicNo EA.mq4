//+------------------------------------------------------------------+
//|                                                 ChannelTrade.mq4 |
//|                               Copyright © 2006, Taylor Stockwell |
//|                                               stockwet@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Taylor Stockwell"
#property link      "stockwet@yahoo.com"


#property show_inputs

/*
Order Types:
OP_BUY 0 Buying position. 
OP_SELL 1 Selling position. 


*/

extern string use_setprice_for_pending_orders = "";
extern double setPrice = 238.66;
extern string type_initials_sell = "s ss sl";
extern string type_initials_buy = "b bs bl";
extern string Order_Type = "b";
extern double Lots               = 0.01;
extern int    MagicNumber = 22;


int m, d, y;
//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+



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
  if(Order_Type == "b" || Order_Type == "b")
   {
    ticket = OrderSend(Symbol(),OP_BUY, Lots, Ask, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
       }
     else Print("Error opening BUY order : ",GetLastError());  
    }
  
  else if(Order_Type == "s" || Order_Type == "s")
   {
    ticket = OrderSend(Symbol(),OP_SELL, Lots, Bid, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    else if(Order_Type == "bs" || Order_Type == "bs")
   {
    ticket = OrderSend(Symbol(),OP_BUYSTOP, Lots, setPrice, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    else if(Order_Type == "ss" || Order_Type == "ss")
   {
    ticket = OrderSend(Symbol(),OP_SELLSTOP, Lots, setPrice, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    else if(Order_Type == "bl" || Order_Type == "bl")
   {
    ticket = OrderSend(Symbol(),OP_BUYLIMIT, Lots, setPrice, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    else if(Order_Type == "selllimit" || Order_Type == "selllimit")
   {
    ticket = OrderSend(Symbol(),OP_SELLLIMIT, Lots, setPrice, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    
   
   return(0);
  }
  




//+------------------------------------------------------------------+