//+------------------------------------------------------------------+
//|                                               delete_pending.mq4 |
//|                      Copyright � 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
#property show_confirm

//+------------------------------------------------------------------+
//| script "delete first pending order"                              |
//+------------------------------------------------------------------+
int start()
  {
   bool   result;
   int    cmd,total;
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
         if(cmd!=OP_BUY && cmd!=OP_SELL && OrderComment() == "hh")
           {
         
            //---- print selected order
            //OrderPrint();
            //---- delete first pending order
            result=OrderDelete(OrderTicket());
            if(result!=TRUE)
             Print("LastError = ", GetLastError());
            else
             i--;
            
           }
        }
      else { Print( "Error when order select ", GetLastError()); break; }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+