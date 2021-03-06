//+------------------------------------------------------------------+
//|                                                        longg.mq4 |
//|                                           Son Nguyen Development |
//|                                             https://g-saram.com/ |
//+------------------------------------------------------------------+
#property copyright "Son Nguyen Development"
#property link      "https://g-saram.com/"
#property version   "1.00"
#property strict
input double lots = 0.1;
input int cut_order = 5;
enum TrailingStop
  {
   On = True,
   Off = False
  };

input  TrailingStop CoTrailingStop = On;
input double LoiNhuanMongDoi = 10;


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
   double cut_oder_pip = cut_order * 10 * Point;
   double cut_order_pip_chia2 = (cut_order/2) * 10 * Point;
   double EMA10 = NormalizeDouble(iMA(Symbol(),PERIOD_CURRENT,10,0,MODE_EMA,PRICE_CLOSE,0),5);
   double EMA28 = NormalizeDouble(iMA(Symbol(),PERIOD_CURRENT,28,0,MODE_EMA,PRICE_CLOSE,0),5);
   double EMA10_Past = NormalizeDouble(iMA(Symbol(),PERIOD_CURRENT,10,0,MODE_EMA,PRICE_CLOSE,2),5);
   int Type_1 = NULL;
   int Type_2 = NULL;
   double MAX1 = NULL;
   double MAX2 = NULL;
   double Sub_Buy = NULL;
   double Sub_Sell = NULL;
   int Ticket_BUY = NULL;
   int Ticket_SELL = NULL;
   int Ticket[100] = {NULL};
   
   
   if(EMA10_Past < EMA10 && EMA10 == EMA28)
     {
      if(Count_MagicNumber_144() == 0)
        {
         OrderSend(Symbol(),OP_BUY,lots,Ask,0, (Ask - cut_order_pip_chia2), (Ask + cut_oder_pip), "Vao lenh Buy", 144, NULL,Green);
         
        }
     }
  // if(EMA10_Past > EMA10 && EMA10 == EMA28)
//     {
 //     if(Count_MagicNumber_144() == 0)
  //      {
 //        OrderSend(Symbol(),OP_SELL,0.1,Bid,0, (Bid + cut_oder_pip), (Bid - cut_oder_pip), "vao lenh SELL", 144, NULL, Red);
 //       }
 //    }
   for(int i=0;i<=OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() )
           {
            if(OrderMagicNumber() == 144)
              {
               Ticket_BUY = OrderTicket();
               continue;
              }
           }
        }
     }  
    
    
   if(OrderSelect(Ticket_BUY,SELECT_BY_TICKET,MODE_TRADES))
     {
      if(OrderSymbol() ==  Symbol() ) {
         MAX1 = OrderStopLoss();
         Type_1 = OrderType();
         }
     }
  
  if(CoTrailingStop == True)
    {
        switch(Type_1)
     {
      case  0:
          Sub_Buy = Ask  - cut_order_pip_chia2;
           if(Sub_Buy > MAX1)
             {
              bool Res_Modify = FALSE;
              Res_Modify = OrderModify(Ticket_BUY,Ask,Sub_Buy,OrderTakeProfit(),NULL,White);
              if(Res_Modify == TRUE)
                {
                 MAX1 = OrderStopLoss();
                }
             }
        break;
       case 1:
          Sub_Sell = Bid + cut_order_pip_chia2;
          if(Sub_Sell < MAX1)
            {
             bool Res_Modify = FALSE;
             Res_Modify = OrderModify(Ticket_BUY,Bid,Sub_Sell,OrderTakeProfit(),NULL,White);
             if(Res_Modify == TRUE)
               {
                MAX1 = OrderStopLoss();
               } else
                   {
                    Comment(GetLastError());
                   }
            }
          break;
      default:
        break;
     }
  }   
   //+------------------------------------------------------------------+
   //|VAO LENH 244|
   //+------------------------------------------------------------------+
     
 //  if(EMA10_Past < EMA10 && EMA10 == EMA28)
 //    {
 //     if(Count_MagicNumber_244() == 0)
//        {
//         OrderSend(Symbol(),OP_BUY,lots*2,Ask,0, (Ask - cut_oder_pip), (Ask + cut_oder_pip), "Vao lenh Buy 2 44 ", 244, NULL,Green);
 //        
//        }
    if(EMA10_Past > EMA10 && EMA10 == EMA28)
     {
      if(Count_MagicNumber_244() == 0)
        {
         OrderSend(Symbol(),OP_SELL,lots,Bid,0, (Bid + cut_order_pip_chia2), (Bid - cut_oder_pip), "vao lenh SELL 244", 244, NULL, Red);
        }
     }
   for(int j=0;j<=OrdersTotal();j++)
     {
      if(OrderSelect(j,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() )
           {
            if(OrderMagicNumber() == 244)
              {
               Ticket_SELL= OrderTicket();
               continue;
              }
           }
        }
     }  
    
    
   if(OrderSelect(Ticket_SELL,SELECT_BY_TICKET,MODE_TRADES))
     {
      if(OrderSymbol() ==  Symbol() ) {
         MAX2 = OrderStopLoss();
         Type_2 = OrderType();
         }
     }
  
  if(CoTrailingStop == True)
    {
        switch(Type_2)
     {
     
       case 1:
          Sub_Sell = Bid + cut_order_pip_chia2;
          if(Sub_Sell < MAX2)
            {
             bool Res_Modify = FALSE;
             Res_Modify = OrderModify(Ticket_SELL,Bid,Sub_Sell,OrderTakeProfit(),NULL,White);
             if(Res_Modify == TRUE)
               {
                MAX2 = OrderStopLoss();
               } else
                   {
                    Comment(GetLastError());
                   }
            }
          break;
      default:
        break;
     }
    }
   if(TongProfit() >= LoiNhuanMongDoi )
     {
      ClosesAllOrder();
     }
  Comment(Ticket[0] + "\n"+ EMA28 );
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
//--- function tong loi nhuan
double TongProfit () {
   double res = 0;
   for(int i=0; i<= OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
            res +=(OrderProfit() + OrderSwap() + OrderCommission());
        }
     }
    return res;
}  
//+------------------------------------------------------------------+
int Count_MagicNumber_144 () {
   int _result = NULL;
   for(int i=0;i<= OrdersTotal() ;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() )
           {
            if(OrderMagicNumber() ==  144)
              {
               _result++;
              }
           }
        }
     }
     return _result;
}

int Count_MagicNumber_244 () {
   int _result = NULL;
   for(int i=0;i<= OrdersTotal() ;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() )
           {
            if(OrderMagicNumber() ==  244)
              {
               _result++;
              }
           }
        }
     }
     return _result;
}
//+------------------------------------------------------------------+
//|HÀM ĐÓNG TẤT CẢ LỆNH |
//+------------------------------------------------------------------+
void ClosesAllOrder()
  {
   RefreshRates();
   int _Res = NULL;
   for(int i=0; i<= OrdersTotal() ; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol() == Symbol())
           {
            _Res++;
           }
        }
     }
   double BidPrice = MarketInfo(Symbol(),MODE_BID);
   double AskPrice = MarketInfo(Symbol(),MODE_ASK);
   for(int j=_Res; j>=0; j--)
     {
      bool res = NULL;
      int _Type = NULL;
      if(OrderSelect(j,SELECT_BY_POS,MODE_TRADES))
        {
         // OrderType() = _Type;
         if(OrderType() == OP_BUY)
           {
            res = OrderClose(OrderTicket(),OrderLots(),BidPrice,0,clrYellow);
           }
         if(OrderType() == OP_SELL)
           {
            res = OrderClose(OrderTicket(),OrderLots(),AskPrice,0,clrYellow);
           }


        }
     }

  }
//+------------------------------------------------------------------+