//+------------------------------------------------------------------+
//|                                             Sonnnnnnnnnnnnnl.mq4 |
//|                                                  Coded by Son    |
//|                                       Copyright © 2020, G-Saram. |
//|                                           http://www.g-saram.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2020, G-Saram"
#property link      "http://www.g-saram.com"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 clrYellow
#property indicator_color3 Red
#property indicator_color4 White
//---- input parameters
extern int period = 42;
//----
double ma[];
double upper[], middle[], lower[];
enum Thietbi
  {
   Laptop = 1, // 15.5 in
   Desktop = 2 // 24 in
  };
input Thietbi Luachonthietbi =  Desktop;
int TicketGlobalmqh[100] = {NULL};
void Gan_Ticket_MQH() {
   int _Count = NULL;
   for(int _i=0; _i<= OrdersTotal(); _i++)
     {
      if(OrderSelect(_i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() )
           {
            TicketGlobalmqh[_Count] = OrderTicket();
            _Count++;
           }
        }
     }

}


void CreatObj_Label (string _nameobj, int _xdistance, int _ydistance, string _content) {
   string font = "Times New Roman";
   ObjectCreate(0,_nameobj,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,_nameobj,OBJPROP_XDISTANCE,_xdistance);
   ObjectSetInteger(0,_nameobj,OBJPROP_YDISTANCE,_ydistance);
   ObjectSetInteger(0,_nameobj,OBJPROP_XSIZE,100);
   ObjectSetInteger(0,_nameobj,OBJPROP_YSIZE,50);
   ObjectSetInteger(0,_nameobj,OBJPROP_COLOR,White);
   ObjectSetInteger(0,_nameobj,OBJPROP_FONTSIZE,10);
   ObjectSetString(0,_nameobj,OBJPROP_FONT,font);
   ObjectSetString(0,_nameobj,OBJPROP_TEXT,_content);
}
double TongLoiNhuan() {
   Gan_Ticket_MQH();
   double _Result = NULL;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(TicketGlobalmqh[i],SELECT_BY_TICKET,MODE_TRADES) )
        {
         _Result = _Result + (OrderProfit() + OrderSwap() + OrderCommission() );
        }
     }
   return _Result;
}
double TongLots() {
   Gan_Ticket_MQH();
   double _result = NULL;
   for(int i=0;i<= OrdersTotal();i++)
     {
      if(OrderSelect(TicketGlobalmqh[i],SELECT_BY_TICKET,MODE_TRADES)  )
        {
         _result = _result + OrderLots();
        }
     }
    return _result;
}
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, upper);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexShift(0, 0);
   SetIndexDrawBegin(0, 0);
//----
   SetIndexBuffer(1, middle);
   SetIndexStyle(1, DRAW_LINE, STYLE_DASHDOT);
   SetIndexShift(1, 0);
   SetIndexDrawBegin(1, 0);
//----
   SetIndexBuffer(2, lower);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexShift(2, 0);
   SetIndexDrawBegin(2, 0);
//---- name for DataWindow label
   SetIndexLabel(0, "SchanTren(" + period + ")");    
   SetIndexLabel(1, "Schangiua(" + period + ")"); 
   SetIndexLabel(2, "Schanduoi(" + period + ")"); 
   SetIndexLabel(3, "Schanngoai(" + period + ")"); 
   
//-- 
   SetIndexBuffer(3, ma);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexShift(3, 0);
   SetIndexDrawBegin(3, 0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() 
  {
     switch(Luachonthietbi)
      {
        case 1:
            CreatObj_Label("Label",800,35,"=== G-Saram ===");
             CreatObj_Label("Demo1",800,50,string("Don Bay La 1:"+string(AccountLeverage())));
            CreatObj_Label("Demo2",800,65,string("So Tien Quy Khach La: " +string(AccountBalance())) );
            CreatObj_Label("Demo3",800,80,string("Server Quy Khach La: " +string(AccountServer())) );
            CreatObj_Label("TicketNumber",800,95,string("Tong Loi n huan hien co: " +string( AccountProfit())) );
            CreatObj_Label("Total_Profit",800,110,string("Tong Loi Nhuan tren " + Symbol() + " la: " +string(TongLoiNhuan())) );
            CreatObj_Label("AccName",800,125,string("Ten Tai Khoan La: " +string(AccountName())) );
          break;
        case 2:
          CreatObj_Label("Label",1000,35,"==== Cong Ty TNHH G-Saram ====");
            CreatObj_Label("Demo1",1000,50,string("Don Bay La 1:"+string(AccountLeverage())));
            CreatObj_Label("Demo2",1000,65,string("So Tien Quy Khach La: " +string(AccountBalance())) );
            CreatObj_Label("Demo3",1000,80,string("Server Quy Khach La: " +string(AccountServer())) );
            CreatObj_Label("TicketNumber",1000,95,string("Tong Loi n huan hien co: " +string( AccountProfit())) );
            CreatObj_Label("Total_Profit",1000,110,string("Tong Loi Nhuan tren " + Symbol() + " la: " +string(TongLoiNhuan())) );
            CreatObj_Label("AccName",1000,125,string("Ten Tai Khoan La: " +string(AccountName())) );
            CreatObj_Label("AccLots",1000,140,string("Tong Lots : " +string(TongLots())) );
              //CreatObj_Label("InforMarket_Commision",1000,155,string("Lot Size la : " +string(MarketInfo(Symbol(),MODE_LOTSIZE))) );
           break;
        default:
          break;
   }
   int limit;
   double trungbinhcuanen;   
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
   limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+period;
//----
   for(int x = 0; x < limit; x++) 
     {
      middle[x] = iMA(NULL, 0, period, 0, MODE_SMA, PRICE_TYPICAL, x);
      trungbinhcuanen = findAvg(period, x);
      upper[x] = middle[x] + trungbinhcuanen;
      lower[x] = middle[x] - trungbinhcuanen;
        ma[x] = iMA(Symbol(),PERIOD_CURRENT,10,0,MODE_EMA,PRICE_CLOSE,x);
     }
  
   return(0);
  }
  

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+  
double findAvg(int period, int shift) 
  {
   double sum = 0;
   for(int x = shift; x < (shift + period); x++) 
     {     
       sum += High[x] - Low[x];
     }
   sum = sum / period;
   return(sum);
  }  
//+------------------------------------------------------------------+

