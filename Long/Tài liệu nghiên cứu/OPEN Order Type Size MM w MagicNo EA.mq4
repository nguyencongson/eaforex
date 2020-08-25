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
extern string Order_Type = "";
extern double Lots               = 0.01;
extern double MaximumRisk        = 20;
extern int    MagicNumber = 22;
extern double MaxLots = 50;
extern double DisMmIfLotsUnder = 0.02;
extern double lotincreasewhenlosing     = 0;

int m, d, y;
//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+
double LotsOptimized()
  {
   double lot=Lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//---- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/5000.0,10);
//---- calcuulate number of losses orders without a break
   if(lotincreasewhenlosing>0)
     {
      for(int i=orders-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL) continue;
         if(OrderMagicNumber() != MagicNumber) continue;
         //----
         if(OrderProfit()>0) break;
         if(OrderProfit()<0) losses++;
        }
      if(losses>2) lot=NormalizeDouble(lot+lot+losses/lotincreasewhenlosing,1);
     }
//---- return lot size
   if(lot<DisMmIfLotsUnder) lot=Lots;
   if(lot> MaxLots) lot=MaxLots;
   return(lot);
  }


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
    ticket = OrderSend(Symbol(),OP_BUY, LotsOptimized(), Ask, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
       }
     else Print("Error opening BUY order : ",GetLastError());  
    }
  
  else if(Order_Type == "s" || Order_Type == "s")
   {
    ticket = OrderSend(Symbol(),OP_SELL, LotsOptimized(), Bid, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    else if(Order_Type == "bs" || Order_Type == "bs")
   {
    ticket = OrderSend(Symbol(),OP_BUYSTOP, LotsOptimized(), setPrice, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    else if(Order_Type == "ss" || Order_Type == "ss")
   {
    ticket = OrderSend(Symbol(),OP_SELLSTOP, LotsOptimized(), setPrice, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    else if(Order_Type == "bl" || Order_Type == "bl")
   {
    ticket = OrderSend(Symbol(),OP_BUYLIMIT, LotsOptimized(), setPrice, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    else if(Order_Type == "sl" || Order_Type == "sl")
   {
    ticket = OrderSend(Symbol(),OP_SELLLIMIT, LotsOptimized(), setPrice, 2, NULL, NULL, NULL, MagicNumber, 0, CLR_NONE);
    if(ticket>0)
       {
        if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
       }
     else Print("Error opening SELL order : ",GetLastError());  
    }
    
    
   
   return(0);
  }
  




//+------------------------------------------------------------------+