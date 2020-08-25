//+------------------------------------------------------------------+
//|                                          SuperEuroUsdScalper.mq4 |                                                |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "SuperEuroUsdScalper"



//+------------------------------------------------------------------+
//| Imported functions description                                   |
//+------------------------------------------------------------------+
#import "wininet.dll"
int InternetOpenW(
                  string     sAgent,
                  int        lAccessType,
                  string     sProxyName="",
                  string     sProxyBypass="",
                  int     lFlags=0
                  );
int InternetOpenUrlW(
                     int     hInternetSession,
                     string     sUrl,
                     string     sHeaders="",
                     int     lHeadersLength=0,
                     int     lFlags=0,
                     int     lContext=0
                     );
int InternetReadFile(
                     int     hFile,
                     uchar     &sBuffer[],
                     int     lNumBytesToRead,
                     int     &lNumberOfBytesRead
                     );
int InternetCloseHandle(
                        int     hInet
                        );
#import

int hSession_IEType;
int hSession_Direct;
int Internet_Open_Type_Preconfig=0;
int Internet_Open_Type_Direct=1;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int hSession(bool Direct)
{
//---
  string InternetAgent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)";
  if(Direct)
    {
      if(hSession_Direct==0)
        {
         hSession_Direct=InternetOpenW(InternetAgent,Internet_Open_Type_Direct,"0","0",0);
        }

    return(hSession_Direct);
    }
  else
   {
      if(hSession_IEType==0)
        {
         hSession_IEType=InternetOpenW(InternetAgent,Internet_Open_Type_Preconfig,"0","0",0);
        }

    return(hSession_IEType);
   }
//---
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string httpGET(string strUrl)
{
//---
   int handler=hSession(false);
   int response= InternetOpenUrlW(handler,strUrl);
   if(response == 0)return("");

   uchar ch[100]; string toStr=""; int dwBytes,h=-1;
   while(InternetReadFile(response,ch,100,dwBytes))
     {
      if(dwBytes<=0) break; toStr=toStr+CharArrayToString(ch,0,dwBytes);
     }

   InternetCloseHandle(response);
   return(toStr);
//---
}





extern string Important2="Any TimeFrame";
extern string BestBroker="FBS Only";
extern string EA_Setting="------ EA Setting ------";
 int MaxSpreads_Points=100;
 int  Magic_Number=155556777;
int Magic;
 bool AutomaticCalculateMagic=true;

 bool Enabel_ECN_Broker=true;
 bool Enable_5Digit_Broker=true;
 bool KeepTrading=true;
 string Hidden_Pending_Setting="------ Hidden Pending Setting ------";
 int Hidden_Pending_Distane_Pips=5;
 bool Close_PendingIfNotInTrade=true;
 double Close_PendingAfterMinutes=0.15;

 string News_Settings="              ----- News Setting -----";
int Delay=2;
 bool Use_Important_NewsTrading=false;
 bool OpenAfterNews=true;
 int PlaceOrderAfter=1;
 int StopPlaceAfter=0;
 int PlaceOrderBeforNews=0;
 bool USDnews=true;
 bool EURnews=true;
 bool AUDnews=false;
 bool CADnews=false;
 bool JPYnews=false;
 bool GBPnews=false;
 bool NZDnews=false;
 bool CHFnews=false;
 bool CNYnews=false;
 bool IncludeHigh = true;
 bool IncludeMedium = false;
 bool IncludeLow = false;
 bool IncludeSpeaks = false;
 bool    DisplayNews       = true;
 int  NewsCorner=1;
 int YShift =20;
 int XShift=20;


 string Profit_Settings="              ----- Trarget Profit and Steps Setting -----";
extern double TotalProfit_Target=0.5;
extern double TotalProfit_Step_Target=0.5;
 int Keep_TradeOpen=0;

 string Lot_Settings="              ----- Lots size & Auto Lots Setting -----";
 double LotSize=1;
 double MaxLot=100;
 bool AutoLot=true;
 string AmountPerBaseLot = "50 = 0.01 lot for every $50 (Auto Lots Only)";
 double Amount_Per_baseLot = 100.0;
 int Slippage=9;
string name1="buyline";
string name2="sellline";
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
datetime TradeTime;
double TradeProfit,ProfitForClose,ProfitForSeries;
double ActStep;
int N=0;
datetime StartTime;
string smbs[];


int init()
  {
    if(Enable_5Digit_Broker)
    {
      Hidden_Pending_Distane_Pips*=10;
      Slippage*=10;
    }
   
    StartTime=TimeCurrent()-5;
    Read();
    if(AutomaticCalculateMagic) Magic=GetMagicNumber();
    else Magic=Magic_Number;
 
   if(ObjectFind(name1)!=-1)ObjectDelete(name1);
   if(ObjectFind(name2)!=-1)ObjectDelete(name2);
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
   if(ObjectFind(name1)!=-1)ObjectDelete(name1);
   if(ObjectFind(name2)!=-1)ObjectDelete(name2);
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
datetime StartTrade,EndTrade;
double Upper,Lower;
bool makeSet=false;
bool GoNextTrade=true,SetProfit=false;
int start()
  {
    
     {
    
     }
    if(Use_Important_NewsTrading&&GoNextTrade)
    {
      int minut;
      if(OpenAfterNews)
      {
         minut=iCustom(NULL, 0, "FFCal_04", IncludeHigh, IncludeMedium, IncludeLow, IncludeSpeaks, true,
         USDnews,EURnews,GBPnews,NZDnews,JPYnews,AUDnews,CHFnews,CADnews,CNYnews,DisplayNews,NewsCorner,YShift,XShift,1, 0);
         if(minut>=PlaceOrderAfter&&minut<=StopPlaceAfter&&!makeSet)
         {Print("make set");
           Upper=Ask+Hidden_Pending_Distane_Pips*Point;
           Lower=Bid-Hidden_Pending_Distane_Pips*Point;
           DrawLine(name1,Upper);
           DrawLine(name2,Lower);
           TradeTime=TimeCurrent();
           makeSet=true;
         }
      }
      else
      {
        minut=iCustom(NULL, 0, "FFCal_04", IncludeHigh, IncludeMedium, IncludeLow, IncludeSpeaks, true,
        USDnews,EURnews,GBPnews,NZDnews,JPYnews,AUDnews,CHFnews,CADnews,CNYnews,DisplayNews,NewsCorner,YShift,XShift,1, 1);
        if(minut<=PlaceOrderBeforNews&&!makeSet)
        {Print("make set");
           Upper=Ask+Hidden_Pending_Distane_Pips*Point;
           Lower=Bid-Hidden_Pending_Distane_Pips*Point;
           DrawLine(name1,Upper);
           DrawLine(name2,Lower);
           TradeTime=TimeCurrent();
           makeSet=true;
        }
           
      }
    }
    else
    {
         if(!makeSet)
         {Print("make set");
           Upper=Ask+Hidden_Pending_Distane_Pips*Point;
           Lower=Bid-Hidden_Pending_Distane_Pips*Point;
           DrawLine(name1,Upper);
           DrawLine(name2,Lower);
           TradeTime=TimeCurrent();
           makeSet=true;
         }
    }
      if(makeSet)
      {
        int TradeOpen=openposThis();
        int TradesAfterOpen=openAfter();
        int OpenActTrades=openpos();
        if(TradeOpen==0&&TradesAfterOpen==0)
        {
          if(NormalizeDouble(Ask-Bid,Digits)<NormalizeDouble(MaxSpreads_Points*Point,Digits))
          if(Ask>=Upper)OpenBuy();
          if(Bid<=Lower)OpenSell();
        }
        if(TradeOpen==1&&TradesAfterOpen==0)
        {
          CheckReverse();
        }
        if(Close_PendingIfNotInTrade)
        {
          if(TimeCurrent()>=TradeTime+Close_PendingAfterMinutes*60)
          {
            if(OpenActTrades==0)
            {Print("1");
              if(ObjectFind(name1)!=-1)ObjectDelete(name1);
              if(ObjectFind(name2)!=-1)ObjectDelete(name2);
              makeSet=false;
              if(TradesAfterOpen>0)
              {
                if(KeepTrading)GoNextTrade=true;
                else GoNextTrade=false;
              }
            }
          }
        }
        
        
        if(OpenActTrades==0)
        {
          if(TradesAfterOpen>0)
          {Print("2");
            if(ObjectFind(name1)!=-1)ObjectDelete(name1);
            if(ObjectFind(name2)!=-1)ObjectDelete(name2);
            makeSet=false;
            if(KeepTrading)GoNextTrade=true;
            else GoNextTrade=false;
          }
        }
        else
        {
          double Multi=GetMulti();
          if(LastTrade())
          {
           double Pr=GetProfit();
           if(!SetProfit)
           {
             TradeProfit=TotalProfit_Target*Multi;
             ProfitForSeries=TradeProfit;
             ActStep=TotalProfit_Step_Target*Multi;
             SetProfit=true;
           }
           if(Pr>TradeProfit)
           {
             TradeProfit=Pr;
             Print("trade profit  ",TradeProfit);
             if(N>0)ProfitForClose=TradeProfit-ActStep;
           }
           if(N==0&&TradeProfit-ProfitForSeries>=ActStep)
           {
             ProfitForClose=TradeProfit-ActStep;
             Print("profit for close  ",ProfitForClose);
             Print("add step ");
             N++;
           }
           if(N>0&&Pr<=ProfitForClose)
           {
             CloseAll();
             Print("close with profit",ProfitForClose);
             N=0;
             SetProfit=false;
           }
          }
        }
      }

   return(0);
  }
//+------------------------------------------------------------------+

void DrawLine(string name,double price)
{
    string linename=name;
     if(ObjectFind(linename)!=-1)
     {
       ObjectMove(linename,0,Time[0],price);
     }
     else
     {
       ObjectCreate(linename,OBJ_HLINE,0,0,price);
       ObjectSet(linename,OBJPROP_COLOR,Blue);
       ObjectSet(linename,OBJPROP_STYLE,0);
       ObjectSet(linename,OBJPROP_WIDTH,1);
       ObjectSet(linename,OBJPROP_BACK,true);
     }
     return;
}
void CloseAll()
{
  while(openpos()>0)
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
   if(OrderSymbol()==Symbol()&&OrderType()<=OP_SELL&&OrderMagicNumber()==Magic)
   {
     if(OrderType()==OP_BUY)OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,0);
     if(OrderType()==OP_SELL)OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,0);
   }
   return;
}
int GetMulti()
{
  int multi=NormalizeDouble(GetLot()/MarketInfo(Symbol(),MODE_MINLOT),0);
  return(multi);
}
int openAfter()
{
   int j=0;
   for(int i=0;i<OrdersHistoryTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
   if(OrderSymbol()==Symbol()&&OrderType()<=OP_SELL)
   if(OrderMagicNumber()==Magic&&OrderOpenTime()>=TradeTime)
     j++;
   return(j);
}
void CheckReverse()
{
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
   if(OrderSymbol()==Symbol()&&OrderType()<=OP_SELL&&OrderMagicNumber()==Magic)
   {
     if(OrderType()==OP_BUY)
     {
       if(Bid<=Lower)
       {
         if(OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,0))
         {
           return;
         }
       }
     }
     if(OrderType()==OP_SELL)
     {
       if(Ask>=Upper)
       {
         if(OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,0))
         {
           return;
         }
       }
     }
   }
   return;
}
int openpos()
{
   int j=0;
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
   if(OrderSymbol()==Symbol()&&OrderType()<=OP_SELL)
   if(OrderMagicNumber()==Magic)
     j++;
   return(j);
}

int openposThis()
{
   int j=0;
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
   if(OrderSymbol()==Symbol()&&OrderType()<=OP_SELL)
   if(OrderMagicNumber()==Magic&&OrderOpenTime()>=TradeTime)
     j++;
   return(j);
}
void OpenBuy()
{
    int Ticket=0;
    int error;
    bool doo=true;
    while(doo)
    {
     RefreshRates();
     Ticket=OrderSend(Symbol(),OP_BUY,GetLot(),NormalizeDouble(Ask,Digits),Slippage,0,0,"",Magic,Blue);
     Sleep(200);
     if(Ticket>0)doo=false;
     else
     {
       error=GetLastError();
       if(error==129||error==138)
       {
         Sleep(200);
         RefreshRates();
       }
       else
       doo=false;
     }
    }
  if(Ticket>0)
  {
  }
  else Print(GetLastError());
  return;
}
void OpenSell()
{
  int Ticket=0;
  int error;
  bool doo=true;
    
    while(doo)
    {
      RefreshRates();
      Ticket=OrderSend(Symbol(),OP_SELL,GetLot(),NormalizeDouble(Bid,Digits),Slippage,0,0,"",Magic,Red);
      Sleep(200);
      if(Ticket>0) doo=false;
      else
      {
        error=GetLastError();
        if(error==129||error==138)
        {
          Sleep(200);
          RefreshRates();
        }
        else doo=false;
      }
    }
  if(Ticket>0)
  {

  }
  else Print(GetLastError());
  return;
}
double GetLot()
{
  double lot,koef;
  if(!AutoLot)
   lot=LotSize;
  else
  lot=MathFloor(AccountEquity()/Amount_Per_baseLot)*MarketInfo( Symbol(),MODE_MINLOT);
   if(lot<MarketInfo(Symbol(),MODE_MINLOT))lot=MarketInfo(Symbol(),MODE_MINLOT);
   if(lot>MarketInfo(Symbol(),MODE_MAXLOT))lot=MarketInfo(Symbol(),MODE_MAXLOT);
   if(lot>MaxLot)lot=MaxLot;
     if(MarketInfo(Symbol(),MODE_MINLOT)==0.1)lot=NormalizeDouble(lot,1);
     if(MarketInfo(Symbol(),MODE_MINLOT)==0.01)lot=NormalizeDouble(lot,2);
  return(lot);
}
bool LastTrade()
{
  datetime ot=0;
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
   if(OrderSymbol()==Symbol()&&OrderMagicNumber()==Magic&&OrderType()<=OP_SELL)
   if(OrderOpenTime()>ot&&OrderOpenTime()>StartTime)ot=OrderOpenTime();
   if(ot!=0)
   {
     if(TimeCurrent()-ot>Keep_TradeOpen)
     return(true);
     else return(false);
   }
}

double  GetProfit()
{
 double prof=0;
 for(int i=0;i<OrdersTotal();i++)
 if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
 if(OrderSymbol()==Symbol()&&OrderMagicNumber()==Magic&&OrderType()<=OP_SELL)
  prof=prof+OrderProfit()+OrderSwap()+OrderCommission();
  return(prof);
}
int GetMagicNumber()
{
  int mag=0;
  int n=ArraySize(smbs);
    for(int i=0;i<n;i++)
    {
      if(smbs[i]==Symbol())mag=Magic_Number+i;
    }
  return(mag);
}
void Read()
{
int hFile = FileOpenHistory("symbols.raw", FILE_BIN|FILE_READ); if(hFile<0) return(-1);  // ��������� symbols.raw
int nSmb=FileSize(hFile)/1936; // ���������� ���������� ��������, ������������������ � �����
ArrayResize(smbs, nSmb);
for(int i=0; i<nSmb; i++) { smbs[i] = FileReadString(hFile, 12); FileSeek(hFile, 1924, SEEK_CUR); }  // ������ ��� �������
}