//+---------------------------------------------------------------------------+ 
//| Использован, изменен Sell Percent.mq4  Scriptor из CodeBase MQL-4.com     |
//|                                 Aleksandr Pak, Alma-Ata, 03.2008          |
//+---------------------------------------------------------------------------+



#property copyright "ekr-ap@mail.ru"
#property copyright "mandorr@gmail.com" //ссылка на исходный Sell Percent.mq4
#include <WinUser32.mqh>

double y_pipsown;
int deinit()
{

 ObjectDelete("PipsWork");
}


void start()
{  int i,j,k,Slipp,Pop,Buy_tp,Buy_sl,Sell_tp,Sell_sl,Blank_buy,Blank_sell,err,crach,twoslash=1;
  double Lot,loss,profit;
  int ticket;
  
  string s,r="Parametrs??",p,x,ex;
  
  if (!IsCondition()) return;
  
  
 
 ObjectCreate("PipsWork",OBJ_TEXT,0,iTime(NULL,0,10),High[10]);
 ObjectSetText("PipsWork", "!!!", 60,"",Red);
 WindowRedraw();
 
  if(GlobalVariableCheck("P_Lot")==FALSE)           r=r+"1";
  if(GlobalVariableCheck("P_Slippage")==FALSE)      r=r+"2";
  if(GlobalVariableCheck("P_Repetitions")==FALSE)   r=r+"3";
  if(GlobalVariableCheck("P_Buy_tp")==FALSE)        r=r+"4";
  if(GlobalVariableCheck("P_Buy_sl")==FALSE)        r=r+"5";
  if(GlobalVariableCheck("P_Sell_tp")==FALSE)       r=r+"6";
  if(GlobalVariableCheck("P_Sell_sl")==FALSE)       r=r+"7";
  if(GlobalVariableCheck("P_Blank_buy")==FALSE)     r=r+"8";
  if(GlobalVariableCheck("P_Blank_sell")==FALSE)    r=r+"9";
  if(GlobalVariableCheck("P_Two_slash")==FALSE)    r=r+"10";
 
  if(StringLen(r)>11) {MessageBox(r,"",MB_OK|MB_ICONERROR);  return;}
 
 
 Lot       =GlobalVariableGet("P_Lot");
 Slipp     =GlobalVariableGet("P_Slippage");
 Pop       =GlobalVariableGet("P_Repetitions");
 Buy_tp    =GlobalVariableGet("P_Buy_tp");
 Buy_sl    =GlobalVariableGet("P_Buy_sl");
 Sell_tp   =GlobalVariableGet("P_Sell_tp");
 Sell_sl   =GlobalVariableGet("P_Sell_sl");
 Blank_buy =GlobalVariableGet("P_Blank_buy");
 Blank_sell=GlobalVariableGet("P_Blank_sell");
 twoslash  =GlobalVariableGet("P_Two_slash");
     
   ex="PiPsing= "+DoubleToStr(Lot,1)+" "+DoubleToStr(Slipp,0)+"  "+DoubleToStr(Pop,0)+
   "  "+DoubleToStr(Buy_tp,0)+"  "+DoubleToStr(Buy_sl,0)+
   "  "+DoubleToStr(Sell_tp,0)+"  "+DoubleToStr(Sell_sl,0)+
   "  "+DoubleToStr(Blank_buy,0)+"  "+DoubleToStr(Blank_sell,0)+"  "+DoubleToStr(twoslash,0);
   
   i=0.3*WindowBarsPerChart();  //place for text
   y_pipsown=0.95*(WindowPriceMax(0)-WindowPriceMin(0))+WindowPriceMin(0);
   if(ObjectFind("PipsOwn2")==-1) 
                           {ObjectCreate("PipsOwn2",OBJ_TEXT,0,iTime(NULL,0,i), y_pipsown);
                           //ObjectCreate("PipsOwn2",OBJ_TEXT,0,iTime(NULL,0,i),High[i]+40*Point);
   
                           ObjectSetText("PipsOwn2", ex  , 9,"",White);
                           } else 
                           {ObjectSetText("PipsOwn2", ex  , 9,"",White);
         if    (  iBarShift ( NULL,0,ObjectGet ( "PipsOwn2",OBJPROP_TIME1),FALSE )>0.5*WindowBarsPerChart())
               ObjectSet("PipsOwn2",OBJPROP_TIME1,iTime(NULL,0,i));  //если за край экрана
                           }
   if (AccountLots(Lot)<=0)
   { 
      string title="Ошибка";
      string msg="Нет свободных средств     ";
      MessageBox(msg,title,MB_OK|MB_ICONERROR);
      return;
   }
  
  if(Blank_buy==0)
  {if (twoslash==1)
         {
            ticket = send_order(0,ticket,Lot,Slipp,Pop,0,0); //send empty
            if(ticket>0) 
               {//Sleep(1000); //Если брокер не дает быстро изменять, снять //, подобрать задержку
                  send_order(1,ticket,Lot,Slipp,Pop,Buy_tp,Buy_sl); //modify
               }
         }
         else send_order(0,ticket,Lot,Slipp,Pop,Buy_tp,Buy_sl); //send +tp/sl
   }
   ObjectDelete("PipsWork");
}
//....................................................

int send_order(int sm, int ticket, double Lot, int Slipp, int Pop,int _tp, int _sl)
//sm=0 - send tp/sl, sm=1  send tp=0,sl=0  sm=2 modify
{int err,k,crach;
 double loss,profit;
 bool result=TRUE;
err=1; k=0;
         
         while(err!=0||k>=Pop)
         { k+=1; RefreshRates(); 
                  if (_sl>0) loss  =Ask-_sl  *Point; else loss=0;
                  if (_tp>0) profit=Ask+_tp*Point; else profit=0;
                 if(sm==0) ticket=OrderSend(Symbol(),OP_BUY,Lot,Ask,Slipp,loss,profit,NULL,0,0,CLR_NONE);                       
                 else      result=OrderModify(ticket,0,loss,profit,0,CLR_NONE);                
         err=ShowError(Pop,k);
         if(err==0&&result==TRUE) break; else { Sleep(1000); }
         if(k>=Pop) break;
            //повтор только при 4 6 135 136 137 138 146 
            switch(err)
            {  
            case 6: crach=0;  //нет связи
            case 135: crach=0;//Цена изменилась
            case 136: crach=0;//Нет цен
            case 137: crach=0;//Брокер занят
            case 138: crach=0;//Новые цены
            case 145: crach=0;//Слишком близко к рынку
            case 146: crach=0;//Подсистема торговли занята
            default : crach=1;
            } 
            if(crach==1)break;  //new repeat is crazy  
        }
   if(err>1) ticket=-ticket;
 return (ticket);

}

double AccountLots(double Lot)
{
   double freemargin=AccountFreeMargin(); if (freemargin<=0) return (0);
   double lotmargin=0;
   string symbol=Symbol();
   string market=MarketType(symbol);
   if (market=="Forex"  ) lotmargin=LotMarginForex  (symbol);
   if (market=="Metalls") lotmargin=LotMarginCFD    (symbol);
   if (market=="CFD"    ) lotmargin=LotMarginCFD    (symbol);
   if (market=="Futures") lotmargin=LotMarginFutures(symbol);
   if (market=="") return (0);
   
   
  if(Lot*lotmargin>freemargin) return (-1); else   return (1);
   }

string MarketType (string symbol)
{
   int len=StringLen(symbol);
   string base;
   if (StringSubstr(symbol,0,1)=="_") return ("Indexes");
   if (StringSubstr(symbol,0,1)=="#")
   {
      base=StringSubstr(symbol,len-1,1);
      if (base=="0") return ("Futures");
      if (base=="1") return ("Futures");
      if (base=="2") return ("Futures");
      if (base=="3") return ("Futures");
      if (base=="4") return ("Futures");
      if (base=="5") return ("Futures");
      if (base=="6") return ("Futures");
      if (base=="7") return ("Futures");
      if (base=="8") return ("Futures");
      if (base=="9") return ("Futures");
      return ("CFD");
   }
   else
   {
      if (symbol=="GOLD"  ) return ("Metalls");
      if (symbol=="SILVER") return ("Metalls");
      if (len==6)
      {
         base=StringSubstr(symbol,0,3);
         if (base=="AUD") return ("Forex");
         if (base=="CAD") return ("Forex");
         if (base=="CHF") return ("Forex");
         if (base=="EUR") return ("Forex");
         if (base=="GBP") return ("Forex");
         if (base=="LFX") return ("Forex");
         if (base=="NZD") return ("Forex");
         if (base=="SGD") return ("Forex");
         if (base=="USD") return ("Forex");
      }
   }
   return ("");
}
double LotMarginForex (string symbol)
{
   double lotsize=MarketInfo(symbol,MODE_LOTSIZE);
   double leverage=AccountLeverage();
   double result=0; if (leverage>0) result=lotsize/leverage;
   string base=StringSubstr(symbol,0,3);
   string сurrency=AccountCurrency();
   double rate_сurrency=1; if (base!=сurrency) rate_сurrency=MarketInfo(base+сurrency,MODE_BID);
   result=rate_сurrency*result;
   return (result);
}
double LotMarginCFD (string symbol)
{
   double bid_symbol=MarketInfo(symbol,MODE_BID);
   double lotsize=MarketInfo(symbol,MODE_LOTSIZE);
   double leverage=10;
   double result=0; if (leverage>0) result=lotsize*bid_symbol/leverage;
   string сurrency=AccountCurrency();
   double rate_сurrency=1; if (сurrency!="USD") rate_сurrency=MarketInfo(сurrency+"USD",MODE_BID);
   result=rate_сurrency*result;
   return (result);
}
double LotMarginFutures (string symbol)
{
   int len=StringLen(symbol);
   double result=0;
   string base=StringSubstr(symbol,0,len-2);
   if (base=="#ENQ" ) result=3750;
   if (base=="#EP"  ) result=3938;
   if (base=="#SLV" ) result=5063;
   if (base=="#GOLD") result=2363;
   if (base=="#CL"  ) result=4725;
   if (base=="#NG"  ) result=8100;
   if (base=="#W"   ) result= 608;
   if (base=="#S"   ) result=1148;
   if (base=="#C"   ) result= 473;
   string сurrency=AccountCurrency();
   double rate_сurrency=1; if (сurrency!="USD") rate_сurrency=MarketInfo(сurrency+"USD",MODE_BID);
   result=rate_сurrency*result;
   return (result);
}
bool IsCondition()
{
   bool result=true;
   string field="     ";
   string msg;
   string title="Ошибка"; if (AccountNumber()>0)title=AccountNumber()+": "+title;
   if (!IsConnected())
   {
      msg=msg+"Связь с сервером отсутствует"+field;
      result=false;
   }
   if (!IsTradeAllowed())
   {
      if (!result) msg=msg+"\n";
      msg=msg+"Торговля запрещена"+field;
      result=false;
   }
   if (!result) MessageBox(msg,title,MB_OK|MB_ICONERROR);
   return (result);
}
int ShowError(int Pop, int k)
{
   string description;
   int err=GetLastError(),crach; //3 129 130 131 134 139 140 
   switch (err)            //повтор только при 4, 6, 135, 136 137 138 146 
   {
      case   0: return;
      case   1: description="Нет ошибки, но результат неизвестен"; break;
      case   2: description="Общая ошибка"; break;
      case   3: description="Неправильные параметры"; break;
      case   4: description="Торговый сервер занят"; break;
      case   5: description="Старая версия клиентского терминала"; break;
      case   6: description="Нет связи с торговым сервером"; break;
      case   7: description="Недостаточно прав"; break;
      case   8: description="Слишком частые запросы"; break;
      case   9: description="Недопустимая операция нарушающая функционирование сервера"; break;
      case  64: description="Счет заблокирован"; break;
      case  65: description="Неправильный номер счета"; break;
      case 128: description="Истек срок ожидания совершения сделки"; break;
      case 129: description="Неправильная цена"; break;
      case 130: description="Неправильные стопы"; break;
      case 131: description="Неправильный объем"; break;
      case 132: description="Рынок закрыт"; break;
      case 133: description="Торговля запрещена"; break;
      case 134: description="Недостаточно денег для совершения операции"; break;
      case 135: description="Цена изменилась"; break;
      case 136: description="Нет цен"; break;
      case 137: description="Брокер занят"; break;
      case 138: description="Новые цены"; break;
      case 139: description="Ордер заблокирован и уже обрабатывается"; break;
      case 140: description="Разрешена только покупка"; break;
      case 141: description="Слишком много запросов"; break;
      case 145: description="Модификация запрещена, так как ордер слишком близок к рынку"; break;
      case 146: description="Подсистема торговли занята"; break;
      case 147: description="Использование даты истечения ордера запрещено брокером"; break;
      default : description="Неизвестная ошибка"; break;
   }
   
   
   
   switch(err)
   {   case 4: crach=0;
      case 6: crach=0;
      case 135: crach=0;
      case 136: crach=0;
      case 137: crach=0;
      case 138: crach=0;
      case 146: crach=0;
      default : crach=1;
    }
  
  string field="     ";
   string msg="Ошибка #"+err+" "+description+field;
   string title="Ошибка"; if (AccountNumber()>0)title=AccountNumber()+": "+title;
   if(crach==1)   MessageBox(msg,title,MB_OK|MB_ICONERROR);
     if(Pop-1==k) MessageBox(msg,title,MB_OK|MB_ICONERROR);
   
   return (err);
}
// End