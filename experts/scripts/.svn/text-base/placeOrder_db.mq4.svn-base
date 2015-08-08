//+------------------------------------------------------------------+
//|                                                        trade.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+b
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#include <stdlib.mqh>
#include <WinUser32.mqh>
//+------------------------------------------------------------------+
//| script "trading for all money"                                   |
//+------------------------------------------------------------------+
int start()
  {
  
   double distance = 0.10; // interval
   double cur = Ask;   // start price
   int number = 30;  // number of order per side
   double point_gap = 0.09;   // point gap between sell and buy price 
   double lot = 0.01;
//----
   if(MessageBox("Do you really want to create order for "+Symbol()+"by distance="+distance+", number="+number+" ?    ",
                 "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return(1);
//----
 
   double p,stop;
   
   for (int i =0; i< number; i++){
   //MessageBox("START "+i,"Script",MB_ICONQUESTION);
   p = cur+i*distance;
   stop = p+distance;
   int ticket=OrderSend(Symbol(),OP_BUYSTOP,lot, p,3,0,0,"hh",770102,0,CLR_NONE);
   if(ticket<1)
     {
      int error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      MessageBox("buystop: price="+p+", stop="+stop+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script",MB_ICONQUESTION);
      return;
     }

   //OrderPrint();
   
   p = cur-(i+1)*distance;
   stop = p-distance;
   int ticket2=OrderSend(Symbol(),OP_SELLSTOP,lot,p,3,0,0,"hh",770102,0,CLR_NONE);
   if(ticket2<1)
     {
      int error2=GetLastError();
      Print("Error = ",ErrorDescription(error2));
      MessageBox("sellstop: price="+p+", stop="+stop+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script",MB_ICONQUESTION);
      return;
     }

   //OrderPrint();
   }
   
   // lost order without takeprofit
   p = cur+(number+1)*distance;
    ticket=OrderSend(Symbol(),OP_BUYSTOP,lot, p,3,0,0,"hh",770102,0,CLR_NONE);
   if(ticket<1)
     {
     
      error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      MessageBox("price="+p+", stop="+0+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script",MB_ICONQUESTION);
      return;
     }
     
     p = cur-(number+2)*distance;
    ticket=OrderSend(Symbol(),OP_SELLSTOP,lot, p,3,0,0,"hh",770102,0,CLR_NONE);
      if(ticket<1)
     {
     
      error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      MessageBox("price="+p+", stop="+0+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script",MB_ICONQUESTION);
      return;
     }
   
   
   return(0);
  }
  

//+------------------------------------------------------------------+