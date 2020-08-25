//+---------------------------------------------------------------------------+ 
//| ����������� Sell Percent.mq4  Scriptor �� CodeBase MQL-4.com              |
//| ������ ��������� ������� SELL �������� � ������� �� ����������� ��������� |
//|                                 Aleksandr Pak, Alma-Ata, 03.2008          |
//+---------------------------------------------------------------------------+
/*��� ������� ������� ���������� � ������ ������� �������� �������. 
����� ����������� � ����� experts/scripts, ���������������.

������� �������������� ��������� �������, �������� � ������ �� ������.
��� ������ �������� ������ ��� ��������, ����� ��������� ������ � �������� �����.
������ ������ ����� � ������ ������� ������� ���� ���������� ������ � ���� ��.

��� ������� ������� ���������, ����� ������ ������, 
���������  ������� ������� ������������ ������������ ����.
����� ����� ��������� ������� ������� (��������! �.�. ������ -�� �������� ������ � ��� ����, 
������� ���� ������� ��� ����������))))

������ PipsingV1_Buy ��������� �������� Buy c ��������� �����������: 
���, �������, ����� �������, ����������, ��������.
������ PipsingV1_Sell, ����������, ������ ��� � ������ ��������� � Buy.

���� ������ ��������� � ��������� �����, �� �� ������ ���������� ��� ������� ��������������� �����, 
������� �������� �� ��������� ������. ����� ������ ���������� �����.
�����,�������� ����� ���������� � ������ ���������, ����� ��������� ���� ��������� �� ������.

�������� ������ ������� �������� � ���������� �������� Pipsing_Setup_V1, 
� �������� � ���������� ���������� ���������. ���� �� ���� ������ � ������� 4-� ����, 
�� ���������� ���������� ��������,, ����� ��������� "Parametrs??", 
��� �������� ��� ����� ��������� ������ PipsingV1_Setup. ����� ���������� ���������.

� �������� ���������� ������������: 
������ ����, ���������������, ����� ������� �������� ����� ��� �������, ���������� ���, �������� ����, 
����������  ����, �������� ����,����� ���, ����� ���� - ���� ����� ������� ���� - ������ �������.

������� ����� ���, � ����� ���� ����� ������������ ��� ����������� �������. 

��������, ������ �� ���������� ������/���������� �� ������� ������.
��� ����� � ���� �� �������������� ����������� ����� �������� ��� ������������ �������� ������.
�������� ���� ������ � ���������� ���������� ���: GlobalVariableSet("Blank_sell_P", signal); 
GlobalVariableSet("Blank_buy_P", signal2);
���� ����� ����� ���� �� ����� ��������, ��������� ���� - ��������.

����������� �������� ��������� �������� ��������� ��� ������������ �������� � ��������� ������ PiPsing. 
���� ������ �� ������������ ����� ������ �������. ����������� �� 100 ����� �� ������ ���� �����. 
����� ������������� � ������� �����, ����� delet.

��������� ������ ����� ����� �������� Close  �� ����������� �������� MT-4

*/
#property copyright "mandorr@gmail.com" //������ �� �������� Sell Percent.mq4
#property copyright "ekr-ap@mail.ru"
//#property show_inputs
//----
#include <WinUser32.mqh>


int deinit()
{

 ObjectDelete("PipsWork");
}


void start()
{  int i,j,k,Slipp,Pop,Buy_tp,Buy_sl,Sell_tp,Sell_sl,Blank_buy,Blank_sell,err;
  double Lot,loss,profit;
  
  string s,r="Parametrs??",p,x,ex;
  
  if (!IsCondition()) return;
  
  i=WindowBarsPerChart()-100;  //place for text
 
 ObjectCreate("PipsWork",OBJ_TEXT,0,iTime(NULL,0,10),High[10]);
 ObjectSetText("PipsWork", "!!!", 60,"",Red);
 WindowRedraw();
 
  if(GlobalVariableCheck("Lot_P")==FALSE)           r=r+"1";
  if(GlobalVariableCheck("Slippage_P")==FALSE)      r=r+"2";
  if(GlobalVariableCheck("Repetitions_P")==FALSE)   r=r+"3";
  if(GlobalVariableCheck("Buy_tp_P")==FALSE)        r=r+"4";
  if(GlobalVariableCheck("Buy_sl_P")==FALSE)        r=r+"5";
  if(GlobalVariableCheck("Sell_tp_P")==FALSE)       r=r+"6";
  if(GlobalVariableCheck("Sell_sl_P")==FALSE)       r=r+"7";
  if(GlobalVariableCheck("Blank_buy_P")==FALSE)     r=r+"8";
  if(GlobalVariableCheck("Blank_sell_P")==FALSE)    r=r+"9";
 
  if(StringLen(r)>11) {MessageBox(r,"",MB_OK|MB_ICONERROR);  return;}
 
 
 Lot       =GlobalVariableGet("Lot_P");
 Slipp     =GlobalVariableGet("Slippage_P");
 Pop       =GlobalVariableGet("Repetitions_P");
 Buy_tp    =GlobalVariableGet("Buy_tp_P");
 Buy_sl    =GlobalVariableGet("Buy_sl_P");
 Sell_tp   =GlobalVariableGet("Sell_tp_P");
 Sell_sl   =GlobalVariableGet("Sell_sl_P");
 Blank_buy =GlobalVariableGet("Blank_buy_P");
 Blank_sell=GlobalVariableGet("Blank_sell_P");
     
   ex="PiPsing= "+DoubleToStr(Lot,1)+" "+DoubleToStr(Slipp,0)+"  "+DoubleToStr(Pop,0)+
   "  "+DoubleToStr(Buy_tp,0)+"  "+DoubleToStr(Buy_sl,0)+
   "  "+DoubleToStr(Sell_tp,0)+"  "+DoubleToStr(Sell_sl,0)+
   "  "+DoubleToStr(Blank_buy,0)+"  "+DoubleToStr(Blank_sell,0);
   
   
   
   if(ObjectFind("PipsOwn")==-1) 
                           {ObjectCreate("PipsOwn",OBJ_TEXT,0,iTime(NULL,0,i),High[i]+40*Point);
   
                           ObjectSetText("PipsOwn", ex  , 9,"",White);
                           } else 
                           {ObjectSetText("PipsOwn", ex  , 9,"",White);
         if    (  iBarShift ( NULL,0,ObjectGet ( "PipsOwn",OBJPROP_TIME1),FALSE )>WindowBarsPerChart())
               ObjectSet("PipsOwn",OBJPROP_TIME1,iTime(NULL,0,i));  //���� �� ���� ������
                           }
   if (AccountLots(Lot)<=0)
   { 
      string title="������";
      string msg="��� ��������� �������     ";
      MessageBox(msg,title,MB_OK|MB_ICONERROR);
      return;
   }
  
  if(Blank_sell==0)
  {err=1; k=0;
  while(err!=0||k>=Pop)
  { k+=1; 
  if (Sell_sl>0) loss  =Bid+Sell_sl  *Point;
  if (Sell_tp>0) profit=Bid-Sell_tp*Point;
  
   OrderSend(Symbol(),OP_SELL,Lot,Bid,Slipp,loss,profit,NULL,0,0,CLR_NONE);
   err=ShowError();
   if(err==0) break; else { Sleep(1000); RefreshRates(); }
   if(k>=Pop) break;
  
   }
   }
   ObjectDelete("PipsWork");
}
//....................................................

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
   string �urrency=AccountCurrency();
   double rate_�urrency=1; if (base!=�urrency) rate_�urrency=MarketInfo(base+�urrency,MODE_BID);
   result=rate_�urrency*result;
   return (result);
}
double LotMarginCFD (string symbol)
{
   double bid_symbol=MarketInfo(symbol,MODE_BID);
   double lotsize=MarketInfo(symbol,MODE_LOTSIZE);
   double leverage=10;
   double result=0; if (leverage>0) result=lotsize*bid_symbol/leverage;
   string �urrency=AccountCurrency();
   double rate_�urrency=1; if (�urrency!="USD") rate_�urrency=MarketInfo(�urrency+"USD",MODE_BID);
   result=rate_�urrency*result;
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
   string �urrency=AccountCurrency();
   double rate_�urrency=1; if (�urrency!="USD") rate_�urrency=MarketInfo(�urrency+"USD",MODE_BID);
   result=rate_�urrency*result;
   return (result);
}
bool IsCondition()
{
   bool result=true;
   string field="     ";
   string msg;
   string title="������"; if (AccountNumber()>0)title=AccountNumber()+": "+title;
   if (!IsConnected())
   {
      msg=msg+"����� � �������� �����������"+field;
      result=false;
   }
   if (!IsTradeAllowed())
   {
      if (!result) msg=msg+"\n";
      msg=msg+"�������� ���������"+field;
      result=false;
   }
   if (!result) MessageBox(msg,title,MB_OK|MB_ICONERROR);
   return (result);
}
int ShowError()
{
   string description;
   int err=GetLastError();
   switch (err)
   {
      case   0: return;
      case   1: description="��� ������, �� ��������� ����������"; break;
      case   2: description="����� ������"; break;
      case   3: description="������������ ���������"; break;
      case   4: description="�������� ������ �����"; break;
      case   5: description="������ ������ ����������� ���������"; break;
      case   6: description="��� ����� � �������� ��������"; break;
      case   7: description="������������ ����"; break;
      case   8: description="������� ������ �������"; break;
      case   9: description="������������ �������� ���������� ���������������� �������"; break;
      case  64: description="���� ������������"; break;
      case  65: description="������������ ����� �����"; break;
      case 128: description="����� ���� �������� ���������� ������"; break;
      case 129: description="������������ ����"; break;
      case 130: description="������������ �����"; break;
      case 131: description="������������ �����"; break;
      case 132: description="����� ������"; break;
      case 133: description="�������� ���������"; break;
      case 134: description="������������ ����� ��� ���������� ��������"; break;
      case 135: description="���� ����������"; break;
      case 136: description="��� ���"; break;
      case 137: description="������ �����"; break;
      case 138: description="����� ����"; break;
      case 139: description="����� ������������ � ��� ��������������"; break;
      case 140: description="��������� ������ �������"; break;
      case 141: description="������� ����� ��������"; break;
      case 145: description="����������� ���������, ��� ��� ����� ������� ������ � �����"; break;
      case 146: description="���������� �������� ������"; break;
      case 147: description="������������� ���� ��������� ������ ��������� ��������"; break;
      default : description="����������� ������"; break;
   }
   string field="     ";
   string msg="������ #"+err+" "+description+field;
   string title="������"; if (AccountNumber()>0)title=AccountNumber()+": "+title;
   MessageBox(msg,title,MB_OK|MB_ICONERROR);
   
   
   return (err);
}
// End