//+------------------------------------------------------------------+
//|                                              Sell with SL and TP |
//|                               Copyright © 2008, smjones          |
//|                                               sjcoinc            |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, smjones"
#property link      "sjcoinc2000@yahoo.com"



//#property show_inputs

extern double Lots = 1;
extern bool   UseMoneyMgmt = true;
extern double RiskPercent = 2;
extern bool   UseStop = true;
extern bool   UseTakeProfit = true;
extern double StopLoss = 200;
extern double TakeProfit = 400;
extern string Note="0 in Entry field means Market Order Sell";
extern double Entry = 0.0000;

string Input = " Sell Price ";




//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
  double Risk = RiskPercent / 100;
  if (UseMoneyMgmt)
    Lots = NormalizeDouble( AccountBalance()*Risk/StopLoss/(MarketInfo(Symbol(), MODE_TICKVALUE)),2); 
  int Mode = OP_SELLSTOP;
  if (Bid < Entry && Entry > 0) Mode = OP_SELLLIMIT; 
  if (Entry == 0)  {Entry = Bid; Mode = OP_SELL;}
  double  SLS = Entry+StopLoss*Point, TPS = Entry - TakeProfit * Point;
  if (UseStop == false) SLS = 0;
  if (UseTakeProfit == false) TPS = 0;
  if(Lots > 0)
   OrderSend(Symbol(),Mode, Lots, Entry, 2, SLS, TPS, "Sell Script",0, NULL, Red);
            
   return(0);
  }
//+------------------------------------------------------------------+