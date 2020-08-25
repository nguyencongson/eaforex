// fukinagashi

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- indicator parameters
extern int ExtDepth=30;
extern int ExtDeviation=5;
extern int ExtBackstep=3;
//---- indicator buffers
double ExtMapBuffer[];
double ExtMapBuffer2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2);
//---- drawing settings
   SetIndexStyle(0,DRAW_SECTION);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexEmptyValue(0,0.0);
   ArraySetAsSeries(ExtMapBuffer,true);
   ArraySetAsSeries(ExtMapBuffer2,true);
//---- indicator short name
   IndicatorShortName("ZigZag("+ExtDepth+","+ExtDeviation+","+ExtBackstep+")");
//---- initialization done
   return(0);
  }
  
int deinit() {
	ObjectDelete("Fibo");
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    shift, back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;

   for(shift=Bars-ExtDepth; shift>=0; shift--)
     {
      val=Low[Lowest(NULL,0,MODE_LOW,ExtDepth,shift)];
      if(val==lastlow) val=0.0;
      else 
        { 
         lastlow=val; 
         if((Low[shift]-val)>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=ExtMapBuffer[shift+back];
               if((res!=0)&&(res>val)) ExtMapBuffer[shift+back]=0.0; 
              }
           }
        } 
      ExtMapBuffer[shift]=val;
      //--- high
      val=High[Highest(NULL,0,MODE_HIGH,ExtDepth,shift)];
      if(val==lasthigh) val=0.0;
      else 
        {
         lasthigh=val;
         if((val-High[shift])>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=ExtMapBuffer2[shift+back];
               if((res!=0)&&(res<val)) ExtMapBuffer2[shift+back]=0.0; 
              } 
           }
        }
      ExtMapBuffer2[shift]=val;
     }

   // final cutting 
   lasthigh=-1; lasthighpos=-1;
   lastlow=-1;  lastlowpos=-1;

   for(shift=Bars-ExtDepth; shift>=0; shift--)
     {
      curlow=ExtMapBuffer[shift];
      curhigh=ExtMapBuffer2[shift];
      if((curlow==0)&&(curhigh==0)) continue;
      //---
      if(curhigh!=0)
        {
         if(lasthigh>0) 
           {
            if(lasthigh<curhigh) ExtMapBuffer2[lasthighpos]=0;
            else ExtMapBuffer2[shift]=0;
           }
         //---
         if(lasthigh<curhigh || lasthigh<0)
           {
            lasthigh=curhigh;
            lasthighpos=shift;
           }
         lastlow=-1;
        }
      //----
      if(curlow!=0)
        {
         if(lastlow>0)
           {
            if(lastlow>curlow) ExtMapBuffer[lastlowpos]=0;
            else ExtMapBuffer[shift]=0;
           }
         //---
         if((curlow<lastlow)||(lastlow<0))
           {
            lastlow=curlow;
            lastlowpos=shift;
           } 
         lasthigh=-1;
        }
     }
  
   for(shift=Bars-1; shift>=0; shift--)
     {
      if(shift>=Bars-ExtDepth) ExtMapBuffer[shift]=0.0;
      else
        {
         res=ExtMapBuffer2[shift];
         if(res!=0.0) ExtMapBuffer[shift]=res;
        }

     }
     
  	int i=0;
  	int LastZigZag, PreviousZigZag;
   
   /*
   for(int h=0; h<Bars && i<=2; h++)
   {
      if (ExtMapBuffer[h]!=0) {
         i++;
         if (i==1) { LastZigZag=h;
      	} else { PreviousZigZag=h; }
      } else if (ExtMapBuffer2[h]!=0) {
         i++;
         if (i==1) { LastZigZag=h;
      	} else { PreviousZigZag=h; }
       }
   }
   */
   
   int h=0;
   while ( ExtMapBuffer[h]==0 && ExtMapBuffer2[h]==0) {
   	h++;
   }
   
   LastZigZag=h;
   
   h++;
   while(ExtMapBuffer[h]==0 && ExtMapBuffer2[h]==0) {
   	h++;
   }
   
   PreviousZigZag=h;
   
//   ObjectCreate("Fibo", OBJ_FIBO, 0, Time[PreviousZigZag], ExtMapBuffer[LastZigZag], Time[LastZigZag], ExtMapBuffer[PreviousZigZag]);
//   Alert(lasthigh+"   "+lasthighpos);
    OnScreen("info2","ZigZag   Buy : "+DoubleToStr(lastlow,Digits)+"   Sell : "+DoubleToStr(lasthigh,Digits),11,3,400,90,clrPaleGreen);
          FileDelete(Symbol());
          int handle = FileOpen(Symbol(),FILE_WRITE|FILE_CSV);
          if (lastlow != -1) FileWrite(handle,"Buy");
          if (lasthigh != -1) FileWrite(handle,"Sell");
          FileClose(handle);
  }
  
void OnScreen(string name,string info, int fontsize2, int corner, int xx, int yy, color kleur)
{
    ObjectCreate(name,OBJ_LABEL, 0, 0, 0);
    ObjectSetText(name,info,fontsize2, "Arial",kleur);
    ObjectSet(name, OBJPROP_CORNER,corner);
    ObjectSet(name, OBJPROP_XDISTANCE,xx);
    ObjectSet(name, OBJPROP_YDISTANCE,yy);
}
   