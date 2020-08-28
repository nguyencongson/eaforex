//+------------------------------------------------------------------+
//|                                                         long.mq4 |
//|                                                              son |
//|                                                   gdemyforex.com |
//+------------------------------------------------------------------+
#property copyright "son"
#property link      "gdemyforex.com"
#property version   "1.00"
input int Gap_trailing = 5;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int Order_Buy(int _Magic_Number, double _lots, double _StopLoss, double _TakeProfit, string _Comment ) {
   int _result = NULL;
   _result = OrderSend(Symbol(),OP_BUY,_lots,Ask,2,_StopLoss,_TakeProfit,_Comment,_Magic_Number,NULL,Green);
   return _result;
}

int Order_Sell(int _Magic_Number, double _lots, double _StopLoss, double _TakeProfit, string _Comment ) {
   int _result = NULL;
   _result = OrderSend(Symbol(),OP_SELL,_lots,Bid,2,_StopLoss,_TakeProfit,_Comment,_Magic_Number,NULL,Red);
   return _result;
}

int OnInit()
  {
//---
   string button_name = "Buy";
   ObjectCreate(0,button_name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,button_name,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,button_name,OBJPROP_YDISTANCE,200);
   ObjectSetInteger(0,button_name,OBJPROP_XSIZE,100);
   ObjectSetInteger(0,button_name,OBJPROP_YSIZE,50);
   ObjectSetInteger(0,button_name,OBJPROP_FONTSIZE,12);
   ObjectSetString(0,button_name,OBJPROP_FONT,"Times New Roman");
   ObjectSetString(0,button_name,OBJPROP_TEXT,"OrderBuy");
   ObjectSetInteger(0,button_name,OBJPROP_COLOR,Red);
   ObjectSetInteger(0,button_name,OBJPROP_BGCOLOR,clrLime);
    ObjectSetInteger(0,button_name,OBJPROP_STATE,false);
    
      string button_name_1 = "Sell";
   ObjectCreate(0,button_name_1,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,button_name_1,OBJPROP_XDISTANCE,200);
   ObjectSetInteger(0,button_name_1,OBJPROP_YDISTANCE,200);
   ObjectSetInteger(0,button_name_1,OBJPROP_XSIZE,100);
   ObjectSetInteger(0,button_name_1,OBJPROP_YSIZE,50);
   ObjectSetInteger(0,button_name_1,OBJPROP_FONTSIZE,12);
   ObjectSetString(0,button_name_1,OBJPROP_FONT,"Times New Roman");
   ObjectSetString(0,button_name_1,OBJPROP_TEXT,"Order Sell");
   ObjectSetInteger(0,button_name_1,OBJPROP_COLOR,Red);
   ObjectSetInteger(0,button_name_1,OBJPROP_BGCOLOR,clrLime);
    ObjectSetInteger(0,button_name_1,OBJPROP_STATE,false); 
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
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   if(sparam == "Buy")
     {
      Order_Buy(144,0.01,(Ask - (Gap_trailing*10*Point) ), NULL, "dEMO" );
      ObjectSetInteger(0,"Close_All_Order",OBJPROP_STATE,false);
      
     }
    if(sparam == "Sell")
      {
       Order_Sell(145,0.01,(Bid + (Gap_trailing*10*Point)), NULL,"Lenh Buyyy");
       ObjectSetInteger(0,"Sell",OBJPROP_STATE,false);
      }

  }
void OnTick()
  {
//---
   int Ticket_1 = NULL, Ticket_2 = NULL, Ticket_3 = NULL;
   int Ticket2 = NULL;
   int Array_Ticket[] = {NULL};
   int Type_1 = NULL, Type_2 = NULL, Type_3 = NULL;
   double EMA_10 = NormalizeDouble(iMA(Symbol(),PERIOD_CURRENT,10,0,MODE_EMA,PRICE_CLOSE,0),5);
   double EMA_28 = NormalizeDouble(iMA(Symbol(),PERIOD_CURRENT,28,0,MODE_EMA,PRICE_CLOSE,0),5);
   double EMA_60 = NormalizeDouble(iMA(Symbol(),PERIOD_CURRENT,60,0,MODE_EMA,PRICE_CLOSE,0),5);
   double Subtract_1 = NULL, Subtract_2 = NULL, Subtract_3 = NULL;
   double Max_1 = NULL, Max_2 = NULL, Max_3 = NULL;
   double Gap_trailing_Pip = Gap_trailing * 10 * Point;
   bool Modify_1 = NULL, Modify_2 = NULL, Modify_3 = NULL;
  //Singal BUY
   if(EMA_10 == EMA_28 && Average_EMA(10,1) <= EMA_10 )
     {
      if(Count_Magic_Number_144() == 10)
        {
         Ticket_1 = Order_Buy(144,0.01,(Ask - Gap_trailing_Pip ),NULL,"Buy 10&28");
        }
     }
      if(EMA_10 == EMA_28 && Average_EMA(10,3) >= EMA_10)
     {
       if(Count_Magic_Number_144() == 10)
         {
          Ticket_1 = Order_Sell(144,0.01,(Bid + Gap_trailing_Pip),NULL,"Sell 10&28");
         }
     }  
 
   if(EMA_10 == EMA_60 && Average_EMA(10,5) <= EMA_10)
     {
      if(Count_Magic_Number_145() == 0)
        {
         Ticket2 = Order_Buy(145,0.01,(Ask - Gap_trailing_Pip ),NULL,"Buy 10&60");
        }
     }
     if(EMA_10 == EMA_60 && Average_EMA(10,3) >= EMA_10)
     {
      if(Count_Magic_Number_145() == 0)
        {
         Ticket2 = Order_Sell(145,0.01,(Bid + Gap_trailing_Pip),NULL,"Sell 10&60");
        }
     }  
   
   if(EMA_28 == EMA_60 && Average_EMA(28,1) <= EMA_28)
     {
      if(Count_Magic_Number_146() == 10)
        {
         Ticket_3 = Order_Buy(146,0.01,(Ask - Gap_trailing_Pip ),NULL,"Buy 28&60");
        }
     
     }
       if(EMA_28 == EMA_60 && Average_EMA(28,3) >= EMA_28)
     {
      if(Count_Magic_Number_146() == 10)
        {
         Ticket_3 = Order_Sell(146,0.01,(Bid + Gap_trailing_Pip),NULL,"Sell 28&60");
        }
     }  
  for(int i=0;i<=OrdersTotal();i++)
    {
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
       {
        if(OrderMagicNumber() == 145)
          {
           Type_2 = OrderTicket();
          }
       }
    }
   //--- trailing stop
   if(Count_Magic_Number_144() == 1)
     {
      switch(Order_Type(Ticket_144()))
        {
         case  0:
           Subtract_1 = NormalizeDouble((Bid - Gap_trailing_Pip),5);
           Max_1 = Get_Stoploss(Ticket_144());
           break;
         default:
           break;
        }
     }
   if(Count_Magic_Number_144() == 1)
     {
      switch(Order_Type(Ticket_144()))
        {
         case  0: // BUY
           Subtract_1 = NormalizeDouble((Bid - Gap_trailing_Pip),5);
           Max_1 = Get_Stoploss(Ticket_144());
           if(Subtract_1 >= Max_1)
             {
              Modify_1 = OrderModify(Ticket_144(),OrderOpenPrice(),Subtract_1,NULL,NULL,White);
              if(Modify_1 == true)
                {
                 Max_1 = Get_Stoploss(Ticket_144());
                }
             }
           case 1: // SEELL 144
            Subtract_1 = NormalizeDouble((Ask + Gap_trailing_Pip) , 5);
            Max_1 = Get_Stoploss(Ticket_144());
            if(Subtract_1 <= Max_1 )
              {
               Modify_1 = OrderModify(Ticket_144(),OrderOpenPrice(),Subtract_1,NULL,NULL,White);
               if(Modify_1 == true)
                 {
                  Max_1 = Get_Stoploss(Ticket_144());
                 }
               }
              
              break;
           break;
         default:
           break;
        }
     }

   if(Count_Magic_Number_145() == 1)
     {
      switch(Order_Type(Ticket_145() ) )
        {
         case  0: // Buy
           Subtract_2 = NormalizeDouble( (Bid - Gap_trailing_Pip),5) ;
           Max_2 = Get_Stoploss(Ticket_145() );
           if(Subtract_2  >= Max_2)
             {
              Modify_2 = OrderModify(Ticket_145() ,OrderOpenPrice(),Subtract_2,NULL,NULL,White);
              if(Modify_2 == true)
                {
                 Max_2 = Get_Stoploss(Ticket_145() );
                }
             }
           break;
         case 1:
            Subtract_2 = Ask + Gap_trailing_Pip;
            Max_2 = Order_StopLoss(Ticket_145() );
            if(Subtract_2 <= Max_2)
              {
               Modify_2 = OrderModify(Ticket_145() ,OrderOpenPrice(),Subtract_2,NULL,NULL,White);
               if(Modify_2 == true)
                 {
                  Max_2 = Order_StopLoss(Ticket_145() );
                 }
              }
            break;
         default:
           break;
        } 
     }
     if(Count_Magic_Number_146() == 1)
       {
        switch(Order_Type(Ticket_146()))
          {
           case  0: // BUY
           Subtract_3 = Bid - Gap_trailing_Pip;
           Max_3 = Get_Stoploss(Ticket_146());
           if(Subtract_3 >= Max_3)
             {
              Modify_3 = OrderModify(Ticket_146(),OrderOpenPrice(),Subtract_3,NULL,NULL,White);
              if(Modify_3 == true)
                {
                 Max_3 = Get_Stoploss(Ticket_146());
                }
             }
             
             break;
           case 1: // SELL
           Subtract_3 = Ask + Gap_trailing_Pip;
           Max_3 = Get_Stoploss(Ticket_146());
           if(Subtract_3 <= Max_3)
             {
              Modify_3 = OrderModify(Ticket_146(),OrderOpenPrice(),Subtract_3,NULL,NULL,White);
              if(Modify_3 == true)
                {
                 Max_3 = Get_Stoploss(Ticket_146());
                }
             }
              
              break;
           default:
             break;
          }
       }
    
   
   Comment(Ticket_144() +"\n "+ Ticket_146() + "\n" +Count_Magic_Number_145() +" |\n "+ Get_Stoploss(Ticket_145() ) +" | "+NormalizeDouble( (Bid - Gap_trailing_Pip),5) +" | "+ Ticket_145()  );
   
  }
//+------------------------------------------------------------------+
int Ticket_145() {
   int _result = NULL;
   for(int i=0;i<= OrdersTotal() ;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber() == 145)
           {
            _result = OrderTicket();
           }
        }
     }
     return _result;
   
}

int Ticket_144 () {
   int _result = NULL;
   for(int i=0;i<=OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber() == 144)
           {
            _result = OrderTicket();
           }
        }
     }
     return _result;
}

int Ticket_146() {
   int _result = NULL;
   for(int i=0;i<=OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber() == 146)
           {
            _result = OrderTicket();
           }
        }
     }  
     return _result;
}
int Order_Ticket_Number (int _number) { 
   int _result = NULL;
   if(OrderSelect(_number,SELECT_BY_POS,MODE_TRADES))
     {
      _result = OrderTicket();
     }
   return _result;
}
double Order_Open_Price (int _ticket) {
   double _result = NULL;
   if(OrderSelect(_ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      _result  = OrderOpenPrice();
     }
   return _result;
}
int Order_Type (int _ticket) {
   int _result = NULL;
   if(OrderSelect(_ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      _result = OrderType();
     }
   return _result;
}
double Order_StopLoss (int _Ticket) {
   double _result = NULL;
   if(OrderSelect(_Ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      _result = OrderStopLoss();
     }
   return _result;

}
double Get_Stoploss (int _Ticket) {
   double _result = NULL;
   if(OrderSelect(_Ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      _result = OrderStopLoss();
     }
     return _result;
}
double Average_EMA (int Period_MA, int _Bao_nhieu_So) {
   double _result = NULL;
   double Array_Of_EMA[10];
   double  _Sum = NULL;
   for(int j=1;j<=_Bao_nhieu_So;j++)
     {
      Array_Of_EMA[j] = iMA(Symbol(),PERIOD_CURRENT,Period_MA,0,MODE_EMA,PRICE_CLOSE,j);
     }
   for(int i=0;i<= _Bao_nhieu_So; i++)
     {
      _Sum = _Sum + Array_Of_EMA[i];
     }
   return NormalizeDouble(_Sum/_Bao_nhieu_So,5);
   
}

int Count_Magic_Number_144 () {
   int _result = NULL;
   for(int i=0;i<=OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber() == 144)
           {
            _result++;
           }
        }
        
     }
     return _result;
}
int Count_Magic_Number_145 () {
   int _result = NULL;
   for(int i=0;i<=OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber() == 145)
           {
            _result++;
           }
        }
        
     }
     return _result;
}
int Count_Magic_Number_146 () {
   int _result = NULL;
   for(int i=0;i<=OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber() == 146)
           {
            _result++;
           }
        }
        
     }
     return _result;
     }