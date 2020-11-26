//+------------------------------------------------------------------+
//|                                                CloseAllOrder.mq4 |
//|                                                       Son Nguyen |
//|                                          http://technical-fx.com |
//+------------------------------------------------------------------+
#property copyright "Son Nguyen"
#property link      "http://technical-fx.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+

int Count_MagicNumber144 () {
   int result = NULL;
   for(int i=0;i<=OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol())
           {
            if(OrderMagicNumber() == 144)
              {
               result++;
              }
           }
        }
     }
     return result;
}


void ClosesAllOrder_VIP144()
  {
   RefreshRates();
   int _Res = NULL;
   int Ticket_Closeall[1000]; 
       for(int ticket_m=0;ticket_m <= OrdersTotal();ticket_m++)
      {
         if(OrderSelect(ticket_m,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == 144)
                 {
                  Ticket_Closeall[_Res] = OrderTicket();
                  _Res++;
                 }
              }
           }
      }
   double BidPrice = MarketInfo(Symbol(),MODE_BID);
   double AskPrice = MarketInfo(Symbol(),MODE_ASK);
   for(int j=_Res; j>=0; j--)
     {
      bool res = NULL;
      int _Type = NULL;
      if(OrderSelect(Ticket_Closeall[j],SELECT_BY_TICKET,MODE_TRADES))
        {
         // _Type = OrderType();
               if(OrderType() == OP_BUY)
                  {
                  res = OrderClose(OrderTicket(),OrderLots(),Bid,2,clrYellow);
                     RefreshRates();
                   }
               if(OrderType() == OP_SELL)
                 {
                  res = OrderClose(OrderTicket(),OrderLots(),Ask,2,clrYellow);
                  RefreshRates();
                 }
        }
     }
      if(Count_MagicNumber144() > 0 )
        {
         bool resLastOrder = NULL;
         int CCount = 0;
         int TicketOrderss = NULL;
         for(int ii=0;ii<= OrdersTotal();ii++)
           {
            if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber() == 144)
                 {
                  if(OrderSymbol() == Symbol())
                    {
                     TicketOrderss = OrderTicket();
                    }
                 }
               switch(OrderType())
                 {
                  case  0:
                    resLastOrder = OrderClose(TicketOrderss,OrderLots(),Bid,2,clrYellow);
                    break;
                  case 1:
                     resLastOrder = OrderClose(TicketOrderss,OrderLots(),Ask,2,clrYellow);
                     break;
                  default:
                    break;
                 }
              }
           }
            
        }
}

int Count_MagicNumber245 () {
   int result = NULL;
   for(int i=0;i<=OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol())
           {
            if(OrderMagicNumber() == 245)
              {
               result++;
              }
           }
        }
     }
     return result;
}
  

void ClosesAllOrder_VIP_SELL()
  {
   RefreshRates();
   int _Res = NULL;
   int Ticket_Closeall[1000]; 
       for(int ticket_m=0;ticket_m <= OrdersTotal();ticket_m++)
      {
         if(OrderSelect(ticket_m,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == 245)
                 {
                  Ticket_Closeall[_Res] = OrderTicket();
                  _Res++;
                 }
              }
           }
      }
   double BidPrice = MarketInfo(Symbol(),MODE_BID);
   double AskPrice = MarketInfo(Symbol(),MODE_ASK);
   for(int j=_Res; j>=0; j--)
     {
      bool res = NULL;
      int _Type = NULL;
      if(OrderSelect(Ticket_Closeall[j],SELECT_BY_TICKET,MODE_TRADES))
        {
         // _Type = OrderType();
               if(OrderType() == OP_BUY)
                  {
                  res = OrderClose(OrderTicket(),OrderLots(),Bid,2,clrYellow);
                     RefreshRates();
                   }
               if(OrderType() == OP_SELL)
                 {
                  res = OrderClose(OrderTicket(),OrderLots(),Ask,2,clrYellow);
                  RefreshRates();
                 }
        }
     }
      if(Count_MagicNumber245() > 0 )
        {
         bool resLastOrder = NULL;
         int CCount = 0;
         int TicketOrderss = NULL;
         for(int ii=0;ii<= OrdersTotal();ii++)
           {
            if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber() == 144)
                 {
                  if(OrderSymbol() == Symbol())
                    {
                     TicketOrderss = OrderTicket();
                    }
                 }
               switch(OrderType())
                 {
                  case  0:
                    resLastOrder = OrderClose(TicketOrderss,OrderLots(),Bid,2,clrYellow);
                    break;
                  case 1:
                     resLastOrder = OrderClose(TicketOrderss,OrderLots(),Ask,2,clrYellow);
                     break;
                  default:
                    break;
                 }
              }
           }
            
        }
}