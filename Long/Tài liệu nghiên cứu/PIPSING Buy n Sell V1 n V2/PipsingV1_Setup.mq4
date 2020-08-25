//+------------------------------------------------------------------+
//|                                             Pipsing_Setup_V1.mq4 |
//|                                             Copyright © 2008, AP |
//|                                                   ekr-ap@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, AP"
#property link      "ekr-ap@mail.ru"
#property show_inputs
//----
#include <WinUser32.mqh>

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

extern double  Lot=0.1;
extern int     Slippage=3;
extern int     Repetitions=1;
extern int     Buy_tp=500;
extern int     Buy_sl=35;
extern int     Sell_tp=500;
extern int     Sell_sl=35;
extern double  Blank_buy=0;
extern double  Blank_sell=0;



int start()
  { string r="error from"; string ex;
      
    
  if(GlobalVariableSet("Lot_P",Lot)==0)                   r=r+"1 ";
  if(GlobalVariableSet("Slippage_P",Slippage)==0)         r=r+"2 ";
  if(GlobalVariableSet("Repetitions_P",Repetitions)==0)   r=r+"3 ";
  if(GlobalVariableSet("Buy_tp_P",Buy_tp)==0)             r=r+"4 ";
  if(GlobalVariableSet("Buy_sl_P",Buy_sl)==0)             r=r+"5 ";
  if(GlobalVariableSet("Sell_tp_P",Sell_tp)==0)           r=r+"6 ";
  if(GlobalVariableSet("Sell_sl_P",Sell_sl)==0)           r=r+"7 ";
 
  if(GlobalVariableSet("Blank_buy_P",Blank_buy)==0)       r=r+"8 ";
  if(GlobalVariableSet("Blank_sell_P",Blank_sell)==0)     r=r+"9 ";
 
  if(StringLen(r)>10) {MessageBox(r,"",MB_OK|MB_ICONERROR); }
  else
  {

   ex="PiPsing= "+DoubleToStr(Lot,1)+" "+DoubleToStr(Slippage,0)+"  "+DoubleToStr(Repetitions,0)+
   "  "+DoubleToStr(Buy_tp,0)+"  "+DoubleToStr(Buy_sl,0)+
   "  "+DoubleToStr(Sell_tp,0)+"  "+DoubleToStr(Sell_sl,0)+
   "  "+DoubleToStr(Blank_buy,0)+"  "+DoubleToStr(Blank_sell,0);
 
   int i=WindowBarsPerChart()/2;
   if(ObjectFind("PipsOwn")==-1) 
                           {ObjectCreate("PipsOwn",OBJ_TEXT,0,iTime(NULL,0,i),High[i]+40*Point);
                            ObjectSetText("PipsOwn", ex  , 9,"",White);
                           } 
   else 
       {
       ObjectSetText("PipsOwn", ex  , 9,"",White);
         if    (  iBarShift ( NULL,0,ObjectGet ( "PipsOwn",OBJPROP_TIME1),FALSE )>WindowBarsPerChart())
         ObjectSet("PipsOwn",OBJPROP_TIME1,iTime(NULL,0,i));  //если за край экрана
       }
   }
   return(0);
  }
//+------------------------------------------------------------------+