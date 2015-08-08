//+------------------------------------------------------------------+
//|                                                        trade.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#include <stdlib.mqh>
#include <WinUser32.mqh>
//+------------------------------------------------------------------+
//| script "trading for all money"                                   |
//+------------------------------------------------------------------+
int start()
  {
//----
//   if(MessageBox("Do you really want to BUY 1.00 "+Symbol()+" at ASK price?    ",
 //                "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return(1);
//----
   int ticket=OrderSend(Symbol(),OP_BUY,1,Ask,3,Ask-0.0010,Ask+0.0030,"expert comment",255,0,CLR_NONE);
   if(ticket<1)
     {
      int error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      return;
     }
//----
   OrderPrint();
   return(0);
  }
//+------------------------------------------------------------------+