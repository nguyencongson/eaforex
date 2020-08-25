//+------------------------------------------------------------------+
//|                                                    Matt_EA_2.mq4 |
//|                                         Developed by Coders Guru |
//|                                      Copyrighted for Matt C|
//|                                            http://www.xpworx.com |
//+------------------------------------------------------------------+

#property copyright "Matt C do not sell but you can share"
#property link      "http://www.xpworx.com"

string   ver  = "Modified: 28/11/06-07:15";

//---- Trades limits
extern   bool        CloseAtDayEnd  = false;
extern   double      distance       = 5;
extern   double      stoploss       = 50;
extern   double      takeprofit     = 100;
extern   double      lots           = 0.1;
extern   double      trailingStop   = 50; 
extern   int         slippage       = 5;
extern   int         hour_start     = 19;

//--- Global variables
int      MN1            = 20611160;
int      MN2            = 90611285;
int      MagicNumber    = 0;
string   ExpertComment  = "Matt_EA";

//+------------------------------------------------------------------
int init()
{
   if (CloseAtDayEnd) 
   {
      ExpertComment = "Matt_EA_CLOSE_ON";
      MagicNumber =  MN1;
   }
   else 
   {
      ExpertComment = "Matt_EA_CLOSE_OFF";
      MagicNumber =  MN2;
   }
   return(0);
}

int deinit() 
{
   return(0);
}
int start() 
{
      
   int cnt,total,long_ticket,short_ticket;
   int hour_end = hour_start -1;

   total  = OrdersTotal();
   if((total < 1 || isNewSymbol(Symbol())) && Hour()==hour_start)
   {
      short_ticket=OpenPendingOrder(OP_SELLSTOP,lots,distance,slippage,stoploss,takeprofit,ExpertComment+"_SELLSTOP",MagicNumber,0);
      if(short_ticket>0)
      {
        if(OrderSelect(short_ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("Pending " + GetOrderType(OrderType()) + " order opened : ",OrderOpenPrice());
      }
      else
      { 
         Print("Error opening Pending " + GetOrderType(OrderType()) + " order : ",GetLastError());
      }      
      
      long_ticket=OpenPendingOrder(OP_BUYSTOP,lots,distance,slippage,stoploss,takeprofit,ExpertComment+"_BUYSTOP",MagicNumber,0);
      if(long_ticket>0)
      {
         if(OrderSelect(long_ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("Pending " + GetOrderType(OrderType()) + " order opened : ",OrderOpenPrice());
      }
      else
      { 
         Print("Error opening Pending " + GetOrderType(OrderType()) + " order : ",GetLastError());
      } 
   }
   
   if(CloseAtDayEnd && Hour()==hour_end)
   {
      CloseDeleteAll();
   }
   
   for(cnt=0;cnt<total;cnt++) 
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      
      if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
      {
         if(OrderType()==OP_BUY)   //<-- Long position is opened
         {
            CloseOposite(OP_SELLSTOP);
            if(Bid-OrderOpenPrice()>Point*trailingStop)
            {
               if(OrderStopLoss()<Bid-Point*trailingStop)
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*trailingStop,OrderTakeProfit(),0,Green);
               }
            }
         }
            
         if(OrderType()==OP_SELL) //<-- Go to short position
         {
            CloseOposite(OP_BUYSTOP);
            if((OrderOpenPrice()-Ask)>(Point*trailingStop))
            {
               if((OrderStopLoss()>(Ask+Point*trailingStop)) || (OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*trailingStop,OrderTakeProfit(),0,Red);
               }
            }
         }
      }
   }

   return(0);
}

int OpenPendingOrder(int pType=OP_BUYLIMIT,double pLots=1,double pLevel=5,int sp=0, double sl=0,double tp=0,string pComment="",int pMagic=123,datetime pExpiration=0,color pColor=Yellow)
{
  switch (pType)
  {
      case OP_BUYLIMIT:
         Alert("BUYLIMIT - Ask:",Ask," Bid:",Bid," Open price:",Ask-(pLevel*Point)," StopLoss:",(Ask-pLevel*Point)-sl*Point);
         return(OrderSend(Symbol(),OP_BUYLIMIT,pLots,Ask-(pLevel*Point),sp,(Ask-pLevel*Point)-sl*Point,(Ask-pLevel*Point)+tp*Point,pComment,pMagic,pExpiration,pColor));    
         break;
      case OP_BUYSTOP:
         Alert("BUYSTOP - Ask:",Ask," Bid:",Bid," Open price:",Ask+(pLevel*Point)," StopLoss:",(Ask+pLevel*Point)-sl*Point);
         return(OrderSend(Symbol(),OP_BUYSTOP,pLots,Ask+(pLevel*Point),sp,(Ask+pLevel*Point)-sl*Point,(Ask+pLevel*Point)+tp*Point,pComment,pMagic,pExpiration,pColor));     
         break;
      case OP_SELLLIMIT:
         Alert("SELLLIMIT - Ask:",Ask," Bid:",Bid," Open price:",Bid+(pLevel*Point)," StopLoss:",(Bid+pLevel*Point)+sl*Point);
         return(OrderSend(Symbol(),OP_SELLLIMIT,pLots,Bid+(pLevel*Point),sp,(Bid+pLevel*Point)+sl*Point,(Bid+pLevel*Point)-tp*Point,pComment,pMagic,pExpiration,pColor));    
         break;
      case OP_SELLSTOP:
         Alert("SELLSTOP - Ask:",Ask," Bid:",Bid," Open price:",Bid-(pLevel*Point)," StopLoss:",(Bid-pLevel*Point)+sl*Point);
         return(OrderSend(Symbol(),OP_SELLSTOP,pLots,Bid-(pLevel*Point),sp,(Bid-pLevel*Point)+sl*Point,(Bid-pLevel*Point)-tp*Point,pComment,pMagic,pExpiration,pColor));    
         break;
  } 
}

string GetOrderType( int type)
{
   if(type == OP_BUY) return ("Buying position");
   if(type == OP_SELL) return ("Selling position");
   if(type == OP_BUYLIMIT) return ("Buy Limit pending position");
   if(type == OP_BUYSTOP) return ("Buy Stop pending position");
   if(type == OP_SELLLIMIT) return ("Sell Limit pending position");
   if(type == OP_SELLSTOP) return ("Sell Stop pending position");
}
bool isNewSymbol(string current_symbol)
  {
   //loop through all the opened order and compare the symbols
   int total  = OrdersTotal();
   for(int cnt = 0 ; cnt < total ; cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      string selected_symbol = OrderSymbol();
      if (current_symbol == selected_symbol && OrderMagicNumber()==MagicNumber)
      return (False);
    }
    return (True);
}

void CloseOposite(int type)
{
   int cnt,total;
   total = OrdersTotal();
   for(cnt=0;cnt<total;cnt++) 
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderType()==type && OrderMagicNumber() == MagicNumber) 
      {  
         OrderDelete(OrderTicket());
      }
   }
}

void CloseDeleteAll()
{
      int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if (OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
         {
            if(OrderType()==OP_BUY)
               OrderClose(OrderTicket(),OrderLots(),Bid,slippage,Violet);
            if(OrderType()==OP_SELL)   
               OrderClose(OrderTicket(),OrderLots(),Ask,slippage,Violet);
            if(OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT)
               OrderDelete(OrderTicket());
         }
      }
}

/*void mPrint(string msg1 = "" , string msg2 = "" , string msg3 = "" , string msg4 = "" , string msg5 = "", string msg6 = "", string msg7 = "", string msg8 = "")
{
   if(IsTesting()) return(0);
   string temp = "";
   if (msg1 != "") temp = temp + ":" + msg1;
   if (msg2 != "") temp = temp + ":" + msg2;
   if (msg3 != "") temp = temp + ":" + msg3;
   if (msg4 != "") temp = temp + ":" + msg4;
   if (msg5 != "") temp = temp + ":" + msg5;
   if (msg6 != "") temp = temp + ":" + msg6;
   if (msg7 != "") temp = temp + ":" + msg7;
   if (msg8 != "") temp = temp + ":" + msg8;
   Print(temp);
}*/






