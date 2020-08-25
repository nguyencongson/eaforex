//+------------------------------------------------------------------+
//|                                             Pipsing_Setup_V1.mq4 |
//|                                             Copyright � 2008, AP |
//|                         Aleksandr Pak, Alma-Ata   ekr-ap@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2008, AP"
#property link      "ekr-ap@mail.ru"
#property show_inputs
//----
#include <WinUser32.mqh>

//�������� �� ���� �������� ��� ������������� ������ ��������.
//������ 2 => �� ����������� "stace" �������� ������. 
//������� ������ �� ����� � ���� ����
//1. ������� ���� Two_Slash=0 - ������� ������� ������.
//2. ������� Two_Slash=1 - ������� � ��� �����:
// - ������� ����� � tp/sl=0, ����� ����������� +tp +sl
//����� ���������� ��������� � ��������� �������, - ���������, ������ t ��������, 
//�������� ����� ���������� ����������, ����� ���� � ���� ����� => ������/���������� ����������
//�����������: �������� ���������� Setup ������ ������� � ������, ����������� => ���������/���������


extern double  Lot=0.1;
extern int     Slippage=3;
extern int     Repetitions=1;
extern int     Buy_tp=10;
extern int     Buy_sl=40;
extern int     Sell_tp=10;
extern int     Sell_sl=40;
extern double  Blank_buy=0;
extern double  Blank_sell=0;
extern double  Two_slash=0;



int start()
  { string r="error from"; string ex; double y_pipsown; int i;
     
  if(GlobalVariableSet("P_Lot",Lot)==0)                   r=r+"1 ";
  if(GlobalVariableSet("P_Slippage",Slippage)==0)         r=r+"2 ";
  if(GlobalVariableSet("P_Repetitions",Repetitions)==0)   r=r+"3 ";
  if(GlobalVariableSet("P_Buy_tp",Buy_tp)==0)             r=r+"4 ";
  if(GlobalVariableSet("P_Buy_sl",Buy_sl)==0)             r=r+"5 ";
  if(GlobalVariableSet("P_Sell_tp",Sell_tp)==0)           r=r+"6 ";
  if(GlobalVariableSet("P_Sell_sl",Sell_sl)==0)           r=r+"7 ";
  if(GlobalVariableSet("P_Blank_buy",Blank_buy)==0)       r=r+"8 ";
  if(GlobalVariableSet("P_Blank_sell",Blank_sell)==0)     r=r+"9 ";
  if(GlobalVariableSet("P_Two_slash",Two_slash)==0)       r=r+"10 ";
 
  if(StringLen(r)>10) {MessageBox(r,"",MB_OK|MB_ICONERROR); }
  else
  {

   ex="PiPsing= "+DoubleToStr(Lot,1)+" "+DoubleToStr(Slippage,0)+"  "+DoubleToStr(Repetitions,0)+
   "  "+DoubleToStr(Buy_tp,0)+"  "+DoubleToStr(Buy_sl,0)+
   "  "+DoubleToStr(Sell_tp,0)+"  "+DoubleToStr(Sell_sl,0)+
   "  "+DoubleToStr(Blank_buy,0)+"  "+DoubleToStr(Blank_sell,0)+"  "+DoubleToStr(Two_slash,0);
 
   i=0.3*WindowBarsPerChart();  //place for text
   y_pipsown=0.95*(WindowPriceMax(0)-WindowPriceMin(0))+WindowPriceMin(0);
   if(ObjectFind("PipsOwn2")==-1) 
                           {ObjectCreate("PipsOwn2",OBJ_TEXT,0,iTime(NULL,0,i),y_pipsown);
                            ObjectSetText("PipsOwn2", ex  , 9,"",White);
                           } 
   else 
       {
       ObjectSetText("PipsOwn2", ex  , 9,"",White);
         if    (  iBarShift ( NULL,0,ObjectGet ( "PipsOwn2",OBJPROP_TIME1),FALSE )>0.5*WindowBarsPerChart())
         ObjectSet("PipsOwn2",OBJPROP_TIME1,iTime(NULL,0,i));  //���� �� ���� ������
       }
   }
   WindowRedraw();
   return(0);
  }
//+------------------------------------------------------------------+