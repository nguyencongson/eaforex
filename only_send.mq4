//+------------------------------------------------------------------+
//|                                            only_send.mq4 |
//|                                           Son Nguyen Development |
//|                                             https://tech-fx.com/ |
//+------------------------------------------------------------------+
#property copyright "Son Nguyen Development"
#property link      "https://devtech-fx.com/"
#property version   "1.00"
input string title_1 = "Input Lots Entry Here"; // AREA INPUT
input double entry1 = 0.1; // Entry 1
input double entry2 = 0.3; // Entry 2
input double entry3 = 0.6; // Entry 3
input double entry4 = 1.2; // Entry 4
input double entry5 = 2.4; // Entry 5
input double entry6 = 4.8; // Entry 6
input string title_2 = "--------------------------"; // END AREA INPUT
input string title_3 = "Input Pip Order"; // Area input PIP distance Order this to order That
input int distance_order_2 = 20; 
input int distance_order_3 = 30;
input int distance_order_4 = 40;
input int distance_order_5 = 50;
input int distance_order_6 = 60;
input string title_4 = "Input Pip Profit and Loss"; // Area input PIP Profit and Loss
//input int distance_order_3 = 30;
 // Pip Profit
input int Max_Loss = 100; // Close all Order since the last order PIP
//input int distane_Open = 20; // Distance Order 2 from order 1
input string title_5 = "Area NOT INPUT HERE"; // Area NOT INPUT,Only For Developer
input int Number_Pre = 1;
input int Devation = 2;
input string title_6 = "Input Period for Indicator"; // Area input Period indicator RSI, BB, MA, Stoc ....
input int period_rsi = 14;
input string title_7 = "====== Input Pip Exit ========";
input int PipExit_1 = 10;
input int PipExit_2 = 20;
input double Profit_Pip = 20;
input int PipExit_4 = 30; 
input int PipExit_5 = 50; 
input int PipExit_6 = 70;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int Buy() {
   int res = NULL;
   string cmt = "Vao Lenh bang BUtton 144";
   res = OrderSend(Symbol(),OP_BUY,entry1,Ask,0,NULL,NULL,cmt,144,NULL,clrAzure);
   return res;
}

void Button_Creat (string Button_name, int xdis, int ydis, int xsize, int ysize, string text, string tenbt) {
   //string Button_name = "close_All";
   ObjectCreate(0,Button_name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,Button_name,OBJPROP_XDISTANCE,xdis);
   ObjectSetInteger(0,Button_name,OBJPROP_YDISTANCE,ydis);
   ObjectSetInteger(0,Button_name,OBJPROP_XSIZE,xsize);
   ObjectSetInteger(0,Button_name,OBJPROP_YSIZE,ysize);
   ObjectSetString(0,Button_name,OBJPROP_TEXT,tenbt);
   ObjectSetString(0,Button_name,OBJPROP_FONT,"Times New Roman");
   ObjectSetInteger(0,Button_name,OBJPROP_FONTSIZE,14);
   ObjectSetInteger(0,Button_name,OBJPROP_COLOR,Red);
   ObjectSetInteger(0,Button_name,OBJPROP_STATE,false);
}

void Creat_Label (string _nameobj, int _xdis, int _ydis, int _fontsize, string _text) {
   //string Text_1 = "text1";
    ObjectCreate(0, _nameobj, OBJ_LABEL, 0, 0, 0);
    //ObjectSetString(0, Text_1, OBJPROP_BMPFILE, "\\Images\\1.bmp");
    ObjectSetInteger(0,_nameobj,OBJPROP_XDISTANCE,_xdis );
    ObjectSetInteger(0,_nameobj,OBJPROP_YDISTANCE,_ydis);
    ObjectSetString(0,_nameobj,OBJPROP_FONT,"Times New Roman");
    ObjectSetInteger(0,_nameobj,OBJPROP_FONTSIZE,_fontsize);
    ObjectSetString(0,_nameobj,OBJPROP_TEXT,_text);
    ObjectSetInteger(0,_nameobj,OBJPROP_COLOR,White);
}
int OnInit()
  {
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

int Ticket_main[1000] = {NULL};
int Ticket_main_145[1000] = {NULL};

 //  double distane_Open_Pip = distane_Open * 10 * Point;
   double Profit = Profit_Pip * 10 * Point; //So Pip muon cat lenh
   int RSI_0 = int(iRSI(Symbol(),PERIOD_CURRENT,period_rsi,PRICE_CLOSE,0));
   int RSI_1 = int(iRSI(Symbol(),PERIOD_CURRENT,period_rsi,PRICE_CLOSE,Number_Pre));
 //  double stoc_main = NormalizeDouble(iStochastic(Symbol(),PERIOD_CURRENT,5,3,3,MODE_SMA,0,MODE_MAIN,0),5);
 //  double stoc_singal = NormalizeDouble(iStochastic(Symbol(),PERIOD_CURRENT,5,3,3,MODE_SMA,0,MODE_SIGNAL,0),5);
   double Pip_entry_2 = distance_order_2 * 10 * Point; // Khoang cach Pip di vao lenh 2
   double Pip_entry_3 = distance_order_3 * 10 * Point; // Khoang cach Pip di vao lenh 3
   double Pip_entry_4 = distance_order_4 * 10 * Point; // Khoang cach Pip di vao lenh 4
   double Pip_entry_5 = distance_order_5 * 10 * Point; // Khoang cach Pip di vao lenh 5
   double Pip_entry_6 = distance_order_6 * 10 * Point; // Khoang cach Pip di vao lenh 6
   double Pip_exit_4 = PipExit_4 * 10 * Point;
   double Pip_exit_5 = PipExit_5 * 10 * Point;
   double Pip_exit_6 = PipExit_6 * 10 * Point;
   double Pip_exit_1 = PipExit_1 * 10 * Point;
   double Pip_exit_2 = PipExit_2 * 10 * Point;
   //double Pip_entry_3 = distance_order_3 * 10 * Point; // KHOẢNG CÁCH PIP ĐỂ VÀO LỆNH 3
  // double distance = distane_Open * 10 * Point;
   double DoLeChuan = Devation * 10 * Point; // Do Lech chuamn
   double Pip_Max_Loss = Max_Loss * 10 *Point; //Neu vuot qua so Pip nay thi se cat toan bo lenh
    //Creat_Label("PhongSuongToaiAnh",260,80,30,"Phong Suong Toai Anh");
    int Count_Ticket_Symbol = 0;
    int Count_Ticket_Symbol_145 = 0;
    // COMBO LENH TAI  25
    // gan lenh ticket number 144 vao bien ticket_main
    for(int ticket_m=0;ticket_m <= OrdersTotal();ticket_m++)
      {
         if(OrderSelect(ticket_m,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == 144)
                 {
                  Ticket_main[Count_Ticket_Symbol] = OrderTicket();
                  Count_Ticket_Symbol++;
                 }
              }
           }
      }
     
    // TỪ 151 - 158 LÀ VÀO l BUY ĐÂU TIÊN  
    // NEU GAP DUONG 25 THI NEU TAI DO CO LENH SELL THI THANH TOAN LENH
    if( (RSI_0 == 25 ) && (RSI_1 < RSI_0) )
      {
        if(Count_MagicNumber245() == 1)
          {
            if(Get_Profit(Ticket_main_145[0]) > 0 )
              {
               ClosesAllOrder_VIP_SELL();
              }
          }
        if(Count_MagicNumber144() == 0)
          {
           int res_1_b_25 = OrderSend(Symbol(),OP_BUY,entry1,Ask,2,NULL,NULL,"Vao Lenh Buy 1",144,NULL,Green);
          }
      }
      
      
    if( (RSI_0 == 70 )  && (RSI_1 < RSI_0) )
      {
       if(Count_MagicNumber245() == 0)
         {
          if(Count_MagicNumber144() == 0 )
            {
             int res_1_b_70 = OrderSend(Symbol(),OP_BUY,entry1,Ask,2,NULL,NULL,"Vao Lenh Buy 1",144,NULL,Green);
            }
         }
      }
    double Price_1  = Get_OpenPrice(Ticket_main[0]); // gia mo cua cua lenh #1 
    // DAT LENH THANH TOAN CHO BUY 1
  if(Price_1 > 0 )
    {
       if(Bid  >= (  Price_1 + Pip_exit_1) || Bid <= (Price_1 - Pip_Max_Loss))  //ok 
       {
          if(Count_MagicNumber144() == 1)
            {
             ClosesAllOrder_VIP144(); // bat dau thanh toan het 1 lenh
               RefreshRates();
            }
       }
    }
    
    // 
    if( Bid <= ( Price_1 - Pip_entry_2 )  )
      {
      if(Count_MagicNumber144() == 1)
            {
              int res_2 = OrderSend(Symbol(),OP_BUY,entry2,Ask,2,NULL,NULL," VAO LENH BUY #2 TAI ",144,NULL,Green);
            }
      } // KET THUC LỆNH THANH TOÁN LẦN 2
      
   double Price_2  = Get_OpenPrice(Ticket_main[1]); // LẤY GIÁ TRỊ CỦA LỆNH #2
// thanh toan lenh tu vi tri thu 2
      if(Price_2 > 0  )
         {
           if(Bid >= (Price_2 + Pip_exit_2) || Bid <=(Price_2 - Pip_Max_Loss) )  ///ok
             {
              if(Count_MagicNumber144() == 2)
                {
                  ClosesAllOrder_VIP144(); //  bat dau thanh toan het 2 lenh 
                  RefreshRates();
                }
             }       
         } // ket thuc thanh toan 2 lenh 
// 
   if(Bid <= (Price_2 - Pip_entry_3) )
     {
      if(RSI_1 <= RSI_0 )
        {
         if(Count_MagicNumber144() == 2)
           {
            int res_3 = OrderSend(Symbol(),OP_BUY,entry3,Ask,2,NULL,NULL,"vAO LENH BUY #3 TAI RSI , 144",144,NULL,Green); // VAO LENH THU 3
           }
        }
     } // KẾT THÚC LỆNH 3
 double Price_3 = Get_OpenPrice(Ticket_main[2]); // LAY GIA TRI CUA LENH BUY THU 3
 // THANH TOAN LENH 3
   if(Price_3 > 0)
     {
      if(Bid >= (Price_3 + Profit)   || Bid <= (Price_3 - Pip_Max_Loss)   )
        {
         if(Count_MagicNumber144() == 3 )
           {
            ClosesAllOrder_VIP144(); // Thoat tat ca cac lenh lan 3
            RefreshRates();
           }
        }
     } // KET THUC THANH TOAN LENH 3
     
   // BAT DAU VAO LENH 4 219 - 226 
   if(Bid <= (Price_3 - Pip_entry_4))
     {
      if(RSI_1 <= RSI_0)
        {
         if(Count_MagicNumber144() == 3)
           {
            int res_4 = OrderSend(Symbol(),OP_BUY,entry4,Ask,2,NULL,NULL,"vAO LENH BUY #4 TAI RSI  , 144",144,NULL,Green); // VAO LENH BUY THU 4
           }
        }
     }
  double Price_4 = Get_OpenPrice(Ticket_main[3]); // LAY GIA TRI CUA LENH BUY THU 4
  
  // THANH TOAN LẸNH 4 
  if(Price_4 > 0 && Pip_exit_4 > 0)
    {
     if(Bid >= (Price_4 + Pip_exit_4)  || Bid <= (Price_4 - Pip_Max_Loss)  )//ok
       {
        if(Count_MagicNumber144() == 4) // Thanh toan lenh thu 4
          {
           ClosesAllOrder_VIP144();
           RefreshRates();
          }
       }
    }        // KẾT THÚC LỆNH 4
 // BẮT ĐẦU VÀO LỆNH 5 241 - 248 
 if(Bid <= (Price_4 - Pip_entry_5) )
   {
    if(RSI_1 <= RSI_0 )
      {
       if(Count_MagicNumber144() == 4)
         {
          int res_5 = OrderSend(Symbol(),OP_BUY,entry5,Ask,2,NULL,NULL,"vAO LENH BUY #5 TAI RSI 25 , 144",144,NULL,Green);
         }
      }
   }
 double Price_5 = Get_OpenPrice(Ticket_main[4]); // LẤY GIÁ TRỊ CỦA LỆNH 5
  
  // THANH TOÁN Ở LỆNH 5
  if(Price_5 > 0 )
    {
     if(Bid >= (Price_5 + Pip_exit_5)   || Bid <= (Price_5 - Pip_Max_Loss)  )//ok
       {
         if(Count_MagicNumber144() == 5)
           {
            ClosesAllOrder_VIP144(); // thanh toan tai lenh 5
            RefreshRates();
           } 
       }
    } // KẾT THÚC LỆNH THANH TOÁN
  // BẮT ĐẦU VÀO LỆNH 6:  263  - 270
  if(Bid <= (Price_5 - Pip_entry_6 ))
    {
     if(RSI_1 <= RSI_0  )
       {
        if(Count_MagicNumber144() == 5)
          {
            int res_6 = OrderSend(Symbol(),OP_BUY,entry6,Ask,2,NULL,NULL,"vAO LENH BUY #6 TAI RSI 25 , 144",144,NULL,Green);
          }
       }
    } // keet thuc lenh 6 
  double Price_6 = Get_OpenPrice(Ticket_main[5]); // LẤY GIÁ TRỊ mo CỦA LỆNH 6  
  // thanh toan lenh 6
  if(Price_6 > 0)
    {
     if( Bid >= (Price_6 + Pip_exit_6)  || Bid <= (Price_6 - Pip_Max_Loss) )
       {
        if(Count_MagicNumber144() == 6)
          {
           ClosesAllOrder_VIP144(); // Thanh toan tai lenh 6
           RefreshRates();
          }
       }
    }
 //+------------------------------------------------------------------+
 //| TRUONG HOP VAO LENH SELL                                         |
 //+------------------------------------------------------------------+
      for(int ticket_n_s=0;ticket_n_s <= OrdersTotal();ticket_n_s++)
      {
         if(OrderSelect(ticket_n_s,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderSymbol() == Symbol())
              {
               if(OrderMagicNumber() == 245)
                 {
                  Ticket_main_145[Count_Ticket_Symbol_145] = OrderTicket();
                  Count_Ticket_Symbol_145++;
                 }
              }
           }
      }  
    // TỪ 318 LÀ VÀO LỆNH BUY ĐÂU TIÊN  
    if(RSI_0 == 75 && RSI_1 > RSI_0)
      {
       if(Count_MagicNumber144() == 1)
         {
            if(Get_Profit(Ticket_main[0] > 0 ) ) {
               ClosesAllOrder_VIP144();
               RefreshRates();
            }
         }
       if(Count_MagicNumber245() == 0)
         {
          int Res_1_S = OrderSend(Symbol(),OP_SELL,entry1,Bid,2,NULL,NULL," Vao lenh Sell khi gap duong 75",245,NULL,Red);
         }
      }
      
    if(RSI_0 == 30 && RSI_1 < RSI_0)
      {
       if( Count_MagicNumber245() == 0)
         {
          int Res_1_S_b = OrderSend(Symbol(),OP_SELL,entry1,Bid,2,NULL,NULL,"Vao lenh Sell khi gap duong 30",245,NULL,Red);
         }
      }
      
      Comment(Get_Profit(Ticket_main[0]));
    double Price_1_S  = Get_OpenPrice(Ticket_main_145[0]); // gia mo cua cua lenh #1 
    // DAT LENH THANH TOAN CHO BUY 1
  if(Price_1_S > 0 )
    {
       if(Ask  <= (  Price_1_S - Pip_exit_1) || Ask >= (Price_1_S + Pip_Max_Loss) ) //ok
       {
          if(Count_MagicNumber245() == 1)
            {
               ClosesAllOrder_VIP_SELL(); // thanh toan lenh sell 1
               RefreshRates();
            }
       }
    }
    
   if(Price_1_S > 0)
     {
       // 360 373
       if( Bid >= ( Price_1_S + Pip_entry_3 )  )
         {
          if(  RSI_1 >= RSI_0 )
            {
             if(Count_MagicNumber245() == 1)
               {
              
               int res2 = OrderSend(Symbol(),OP_SELL,entry2,Bid,2,NULL,NULL,"VAO LENH SELL 2 TAI RSI 75", 245, NULL,Red); // Vao Lenh 2 tai lenh SELL
               }
            }
         } // ket thuc thanh toan lenh 2
         
     }
   double Price_2_s  = Get_OpenPrice(Ticket_main_145[1]); // LẤY GIÁ TRỊ CỦA LỆNH #2
// thanh toan lenh tu vi tri thu 2
      if(Price_2_s > 0  )
         {
           if(Ask <= (Price_2_s - Pip_exit_2)  || Ask >= (Price_2_s + Pip_Max_Loss) )//ok
             {
              if(Count_MagicNumber245() == 2)
                {
                   ClosesAllOrder_VIP_SELL(); // Thoat lenh 
                  RefreshRates(); 
                }
             }       
         } // ket thuc thanh toan 2 lenh 
// VÀO LỆNH 3  198 - 208
   if(Price_2_s > 0)
     {
      if(Bid >= (Price_2_s + Pip_entry_3) )
        {
         if(RSI_1 >= RSI_0)
           {
            if(Count_MagicNumber245() == 2)
              {
              int res_3_S = OrderSend(Symbol(),OP_SELL,entry3,Bid,2,NULL,NULL,"vAO LENH BUY #3 TAI RSI 75 , 245",245,NULL,Red); // vao lenh 3 lenh sell
              }
           }
        } // KẾT THÚC LỆNH 3
     }
 double Price_3_s = Get_OpenPrice(Ticket_main_145[2]); // LẤY GIÁ TRỊ CỦA LỆNH 3
 // THANH TOAN LENH 3
   if(Price_3_s > 0)
     {
      if(Ask <= (Price_3_s - Profit)  || Ask >= (Price_3_s + Pip_Max_Loss) )//ok
        {
         if(Count_MagicNumber245() == 3)
           {
            ClosesAllOrder_VIP_SELL(); // thoat tat ca lenh 3
            RefreshRates();
           }
        }
     } // KET THUC THANH TOAN LENH 3
     
   // BAT DAU VAO LENH 4 219 - 226 
  if(Price_3_s > 0)
    {
      if(Bid >= (Price_3_s + Pip_entry_4)   )
        {
         if(RSI_1 >= RSI_0)
           {
             if(Count_MagicNumber245() == 3)
              {
               int res_4_s = OrderSend(Symbol(),OP_SELL,entry4,Bid,2,NULL,NULL,"vAO LENH SELL #4 TAI RSI 75 , 245",245,NULL,Red); // vao lenh sell lenh 4
              }   
           }
        }
    }
  double Price_4_s = Get_OpenPrice(Ticket_main_145[3]); // LẤY GIÁ TRỊ CỦA LỆNH 4
  
  // THANH TOAN LẸNH 4 
  if(Price_4_s > 0 )
    {
     if(Ask <= (Price_4_s -  Pip_exit_4) || Ask >= (Price_4_s + Pip_Max_Loss)  )//ok
       {
        if(Count_MagicNumber245() == 4)
          {
           ClosesAllOrder_VIP_SELL();
           RefreshRates();
          }
       }
    }        // KẾT THÚC LỆNH 4
 // BẮT ĐẦU VÀO LỆNH 5 241 - 248 
 if(Price_4_s > 0)
   {
    if(Bid >= (Price_4_s + Pip_entry_5))
      {
       if(RSI_1 >= RSI_0)
         {
          if(Count_MagicNumber245() == 4)
            {
             int res_5_s = OrderSend(Symbol(),OP_SELL,entry5,Bid,2,NULL,NULL,"vAO LENH BUY #5 TAI RSI 75 , 245",245,NULL,Red); // vao lenh sell thu 5 
            }
         }
      }
   }
 double Price_5_s = Get_OpenPrice(Ticket_main_145[4]); // lay gia tri mo lenh cua lenh 5
  
  // thanh toan lenh 5
  if(Price_5_s > 0 )
    {
     if(Ask <= (Price_5_s -Pip_exit_5) || Ask >= (Price_5_s + Pip_Max_Loss) ) //ok
       {
         if(Count_MagicNumber245() == 5)
           {
            ClosesAllOrder_VIP_SELL();
            RefreshRates();
           } 
       }
    } // ket thuc lenh thanh toan
  // BẮT ĐẦU VÀO LỆNH 6:  279  - 287
if(Price_5_s > 0)
  {
     if(Bid >= (Price_5_s + Pip_entry_6 ))
       {
        if(RSI_1 >= RSI_0)
          {
           if(Count_MagicNumber245() == 5)
             {
              int res_6_s = OrderSend(Symbol(),OP_SELL,entry6,Bid,2,NULL,NULL,"vAO LENH BUY #6 TAI RSI 75 , 245",245,NULL,Red); // vao lenh sell tai lenh 6
             }
          }
       } // keet thuc lenh 6 
  }
  double Price_6_s = Get_OpenPrice(Ticket_main_145[5]); // LẤY GIÁ TRỊ mo CỦA LỆNH 6  
  // thanh toan lenh 6
  if(Price_6_s > 0)
    {
     if( Ask <= (Price_6_s - Pip_exit_6)  || Ask >= (Price_6_s) )//ok
       {
        if(Count_MagicNumber245() == 6)
          {
             ClosesAllOrder_VIP_SELL();
           RefreshRates();
          }
       }
    }
 
 

 }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   if(sparam == "close_All" )
     {
      ClosesAllOrder();
      ObjectSetInteger(0,"close_All",OBJPROP_STATE,false);
     }
      if(sparam == "Buy_Button")
     {
      Buy();
      ObjectSetInteger(0,"Buy_Button",OBJPROP_STATE,false);
     }
   if(sparam == "XoaLenh")
     {
      ClosesAllOrder_VIP144();
      ObjectSetInteger(0,"XoaLenh",OBJPROP_STATE,false);
     }
  }
//+------------------------------------------------------------------+

//get open_oderprice 
double Get_OpenPrice (int Ticket) {
   double res = NULL;
   if(OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      res = OrderOpenPrice();
     }
   return res;
}

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

int Count_MagicNumber145 () {
   int result = NULL;
   for(int i=0;i<=OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol())
           {
            if(OrderMagicNumber() == 145)
              {
               result++;
              }
           }
        }
     }
     return result;
}
double Get_Profit (int _Ticket) {
   double res = NULL;
  if(OrderSelect(_Ticket,SELECT_BY_POS,MODE_TRADES))
    {
     res = OrderProfit() + OrderCommission() + OrderSwap();
    }
    
 return res;
}

double Total_Profit () {
   double res = NULL;
   int Ticket[100] = {NULL};
   int CountTicket = 0;
   for(int i=0;i<=OrdersTotal() ;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol())
           {
            if(OrderMagicNumber() == 144)
              {
               Ticket[CountTicket] = OrderTicket();
               CountTicket++;
              }
           }
        }
     }
     
   for(int j=0;j<=CountTicket;j++)
     {
      res = res + Get_Profit(Ticket[j]);
     }
   return NormalizeDouble(res,3);
}
void ClosesAllOrder()
  {
   RefreshRates();
   int _Res = NULL;
   for(int i=0; i<= OrdersTotal() +1 ; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol())
           {
            if(OrderMagicNumber() == 144)
              {
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
      if(OrderSelect(j,SELECT_BY_POS,MODE_TRADES))
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