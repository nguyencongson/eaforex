//+------------------------------------------------------------------+
//|                                              Buy  with SL and TP |
//|                               Copyright © 2008, smjones          |
//|                                               sjcoinc            |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, smjones"
#property link      "sjcoinc2000@yahoo.com"


#property show_inputs

extern int    NumberOfOrders = 1;
extern bool   UseActualSlTp = true;
extern double StopLossPrice = 0.0000;
extern double TakeProfitPrice = 0.0000;
extern string Note="0 in Entry field means Market Order Buy";
extern double Entry = 0.0000;
extern bool   MicroOrdersAllowed = true;
extern bool   MiniOrdersAllowed = true;

extern bool   UseMoneyMgmt = true;
extern double RiskPercent = 1;
extern double Lots = 1;
extern double StopLoss = 0;
extern double TakeProfit = 0;

extern string Comments = "Buy Script";



//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  { 
  double Risk = RiskPercent / 100;
  int OrdersizeAllowed = 0;
  int Mode = OP_BUYSTOP;
  if (Ask > Entry && Entry > 0) Mode = OP_BUYLIMIT; 
  if (Entry == 0)  {Entry = Ask; Mode = OP_BUY;}
  double SLB = Entry - StopLoss*Point, TPB = Entry + TakeProfit*Point;

  if (UseActualSlTp)
      {
         StopLoss = (Entry-StopLossPrice)/Point;
         SLB = StopLossPrice;
         TPB = TakeProfitPrice;    
      }
  if (MiniOrdersAllowed) OrdersizeAllowed=1;
  if (MicroOrdersAllowed) OrdersizeAllowed=2;        
  if (UseMoneyMgmt)  
      Lots = NormalizeDouble( AccountBalance()*Risk/StopLoss/(MarketInfo(Symbol(), MODE_TICKVALUE)),OrdersizeAllowed);       

  if ((Lots < 0.01&&MicroOrdersAllowed) || (Lots < 0.1&&MiniOrdersAllowed&&MicroOrdersAllowed==false))
      {
         Comment("YOUR LOTS SIZE IS TOO SMALL TO PLACE!");
      } 

  if(Lots > 0)
  for (int i=0;i<NumberOfOrders;i++)
      {
         OrderSend(Symbol(),Mode, Lots, Entry, 2,SLB , TPB, Comments, 0, NULL, LimeGreen);
      }

           
   return(0);
  }
//+------------------------------------------------------------------+