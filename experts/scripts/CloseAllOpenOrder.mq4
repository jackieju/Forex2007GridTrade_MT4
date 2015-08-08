//+------------------------------------------------------------------+
//|                                               delete_pending.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
#property show_confirm
#include <WinUser32.mqh>
#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| script "delete first pending order"                              |
//+------------------------------------------------------------------+
int start()
  {
   bool   result;
   int    cmd,total;
   
   if(MessageBox("Do you really want to delete all open order of "+Symbol(),
                 "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return(1);
//----
   total=OrdersTotal();
   MessageBox("total="+total);
//----
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
       
         cmd=OrderType();
       
         //MessageBox("OrderMagicNumber()="+OrderMagicNumber()+"type="+cmd);
         //---- pending orders only are considered
         //if(cmd!=OP_BUY && cmd!=OP_SELL && OrderMagicNumber()==770102)
         if((cmd==OP_BUY || cmd==OP_SELL) && OrderComment() == "hh")
           {
       
            //---- print selected order
            //OrderPrint();
            //---- delete first pending order
            if (cmd == OP_SELL)
                result=OrderClose(OrderTicket(), OrderLots(), Ask, 3, CLR_NONE);
            else if (cmd == OP_BUY)
                result=OrderClose(OrderTicket(), OrderLots(), Bid, 3, CLR_NONE);
            if(result!=TRUE)
             MessageBox("LastError = "+ErrorDescription(GetLastError()));
            else
            {
             i--;
             total--;
             }
            
           }
        }
      else {
       MessageBox( "Error when order select "+ErrorDescription(GetLastError())); 
       break;
      }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+