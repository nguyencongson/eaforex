//+------------------------------------------------------------------+
//|                       [EA]2Become1-JustLikeTheSpiceGirlsSong.mq4 |
//|                                 Copyright © 2009, Viking234.Com. |
//|                                         http://www.viking234.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Viking234.Com."
#property link      "http://www.viking234.com"

// http://www.forexfactory.com/showthread.php?p=2997450&posted=1#post2997450
// 4Shared file is WORKING VERSION!
// Distributed under GPL (http://www.gnu.org/licenses/gpl.txt)
// Donation? Very Welcome > www.viking234.com side bar. =)

extern string  Pair_0         = "USDCHF";
extern double  Pair_0_Lots    = 1.0;
extern int     Pair_0_TP      = 0;
extern int     Pair_0_SL      = 0;
extern int     Pair_0_OrdType = 0;
               /*
               0 Buying position (default for else then 0 and 1). 
               1 Selling position. 
               */
extern string  Pair_1         = "GBPUSD";
extern double  Pair_1_Lots    = 0.5;
extern int     Pair_1_TP      = 0;
extern int     Pair_1_SL      = 0;
extern int     Pair_1_OrdType = 1;
               /*
               0 Buying position (default for else then 0 and 1). 
               1 Selling position. 
               */
extern string  OrdType        = "0=Buying position. 1=Selling position.";
extern int     Slippage       = 5;
extern int     MagicNumbers   = 234;
bool KillEmAll=false;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if(KillEmAll==true) {
      Comment("\n\nJust 2 Become 1 DONE!");
      return(0);
   }
   int kabbi=OrdersTotal(),sittong=0,dhuwe=0,karcis;
   double argena=0,TP=0,SL=0;
   for(int a=0;a<kabbi;a++) {
      if(OrderSelect(a,SELECT_BY_POS,MODE_TRADES)) {
         if(OrderMagicNumber()!=MagicNumbers) continue;
         if(OrderSymbol()==Pair_0) sittong++;
         else if(OrderSymbol()==Pair_1) dhuwe++;
      }
   }
   
   if(sittong==0) {
      if(Pair_0_OrdType>2) Pair_0_OrdType=0;
      if(Pair_0_OrdType==OP_BUY) {
         argena=MarketInfo(Pair_0,MODE_ASK);
         if(Pair_0_SL==0) SL=0; else SL=argena-Pair_0_SL*MarketInfo(Pair_0,MODE_POINT);
         if(Pair_0_TP==0) TP=0; else TP=argena+Pair_0_TP*MarketInfo(Pair_0,MODE_POINT);
      } else {
         argena=MarketInfo(Pair_0,MODE_BID);
         if(Pair_0_SL==0) SL=0; else SL=argena+Pair_0_SL*MarketInfo(Pair_0,MODE_POINT);
         if(Pair_0_TP==0) TP=0; else TP=argena-Pair_0_TP*MarketInfo(Pair_0,MODE_POINT);
      }
      karcis=OrderSend(Pair_0,Pair_0_OrdType,Pair_0_Lots,argena,Slippage,SL,TP,"Viking234.Com",MagicNumbers,0,Yellow);
      if(karcis<0) {
         Print("Something wrong with this order on "+Pair_0+" error#"+GetLastError());
         return(0);
      }
   }
   
   if(dhuwe==0) {
      if(Pair_1_OrdType>1) Pair_1_OrdType=0;
      if(Pair_1_OrdType==OP_BUY) {
         argena=MarketInfo(Pair_1,MODE_ASK);
         if(Pair_1_SL==0) SL=0; else SL=argena-Pair_1_SL*MarketInfo(Pair_1,MODE_POINT);
         if(Pair_1_TP==0) TP=0; else TP=argena+Pair_1_TP*MarketInfo(Pair_1,MODE_POINT);
      } else {
         argena=MarketInfo(Pair_1,MODE_BID);
         if(Pair_1_SL==0) SL=0; else SL=argena+Pair_1_SL*MarketInfo(Pair_1,MODE_POINT);
         if(Pair_1_TP==0) TP=0; else TP=argena-Pair_1_TP*MarketInfo(Pair_1,MODE_POINT);
      }
      karcis=OrderSend(Pair_1,Pair_1_OrdType,Pair_1_Lots,argena,Slippage,SL,TP,"Viking234.Com",MagicNumbers,0,Yellow);
      if(karcis<0) {
         Print("Something wrong with this order on "+Pair_1+" error#"+GetLastError());
         return(0);
      }
   }
   
   if(sittong>0&&dhuwe>0) KillEmAll=true;
//----
   return(0);
  }
//+------------------------------------------------------------------+