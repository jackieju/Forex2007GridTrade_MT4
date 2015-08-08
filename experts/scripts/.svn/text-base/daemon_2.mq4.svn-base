//+------------------------------------------------------------------+
//|                                                       daemon.mq4 |
//|                       Copyright ?2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#include <stdlib.mqh>
#include <WinUser32.mqh>
 
int oldOrders[100];
int newOrders[100];
string Sym = "GBPJPYm";
double lot = 0.01;
double distance = 0.10;
double point_gap = 0.09;
int magic_number = 770102;

void log(string s){
datetime tm = TimeCurrent();
string ts = TimeYear(tm)+"-"+TimeMonth(tm)+"-"+TimeDay(tm)+" "+TimeHour(tm)+":"+TimeMinute(tm)+":"+TimeSeconds(tm)+"\t"+s;
int handle = FileOpen("log.txt", FILE_BIN|FILE_READ|FILE_WRITE);
FileSeek(handle, 0, SEEK_END);
FileWrite(handle, ts);
FileClose(handle);
}
int getOpenOrders(int &array[]){

   int    cmd,total;
   ArrayInitialize(array, 0);
   
// get order number
   total=OrdersTotal();
   //log("total: "+total);
   int count =0; // number of open orders
   for(int i=0; i<total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
        cmd=OrderType();  
        //log("OrderTicket "+ OrderTicket()+ ":" +"OrderMagicNumber: " + OrderMagicNumber());       
        // if( (cmd==OP_BUY || cmd ==OP_SELL) && (OrderMagicNumber() == 770102) ) {
         if( (cmd==OP_BUY || cmd ==OP_SELL) && (OrderComment() == "hh") ) {
            array[count] = OrderTicket();
            //log("found open order " + OrderTicket());            
            count++;
         }
      }/*else{
        Print( "Error when order select ", GetLastError()); 
        MessageBox("error: "+ErrorDescription(GetLastError()),NULL,IDOK);
        return (0); 
      }*/
   }
   return (count);
}




//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
  log("starting...");
 // MessageBox(Symbol());
   int cmd,total;
   int newNumber = 0;
   
// get order number

   int oldNumber = getOpenOrders(oldOrders);
   MessageBox("number of open orders: "+ oldNumber,MB_OK);
//----
    
//----
   
//----
   while(true){
   newNumber =getOpenOrders(newOrders); // get current open orders
   //log("oldnumber:"+oldNumber+", newnumber:"+newNumber);
   if (newNumber > oldNumber){ // new order opened
      oldNumber = getOpenOrders(oldOrders); // refresh
      Sleep(100);
      continue;
   }
   //if (newNumber == oldNumber){
    //  Sleep(100);
     // continue;
   //}
   if (newNumber <= oldNumber){ // one order was closed
      // find closed Order
      for (int i = 0; i < oldNumber; i++){
         int sel_ret = 0;
        /* if (!OrderSelect(oldOrders[i], SELECT_BY_TICKET, MODE_TRADES))
         {
            sel_ret = 1;
         }
         else{
             if (newNumber < oldNumber)
               log("order "+oldOrders[i]+" is still living.");
             continue;  
         }
         log("order "+ oldOrders[i] + " was closed!");*/
         if (OrderSelect(oldOrders[i], SELECT_BY_TICKET, MODE_HISTORY) && OrderCloseTime() != 0)
          {
            sel_ret = 2;
            log("select order "+oldOrders[i]+" in history ok!");
           }
         else{
            //log("select order "+oldOrders[i]+" in history failed!");
            //break;
            continue;
         }
         log("order "+ oldOrders[i] + " was closed!");
         // found closed order
         double op = OrderOpenPrice();
         int type = OrderType();
         if (type == OP_BUY){
            op = op + distance;
            double stop = op-distance;
            log("stop="+op+"-"+distance);
            int ticket=OrderSend(Sym,OP_SELLSTOP, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
            if(ticket<1)
            {
             int error=GetLastError();
             log("SELL Error = "+ ErrorDescription(error) + ", price: "+op+", stop: "+stop+", BID="+Bid);
             //MessageBox("sellstop: price="+p+", stop="+stop+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script", MB_OK);
             break;
            }else log ("order "+ticket+" created ok at price "+op+" stop "+stop);
         }
         else if (type == OP_SELL){
            op = op-distance;
            stop = op+distance; 
           log("stop="+op+"+"+distance);
           ticket = 0;
           ticket=OrderSend(Sym,OP_BUYSTOP, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
           if (ticket<1)
            {
             error = 0;
             error=GetLastError();
             log("BUY Error = "+ErrorDescription(error) + ", price: "+op+", stop: "+stop+", ASK="+Ask);
             //MessageBox("sellstop: price="+p+", stop="+stop+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script", MB_OK);
             break;
            }else log ("order "+ticket+" created ok at price "+op+" stop "+stop + "ok.");
         }     
        
         break;

      }// for
      if (i >= oldNumber && oldNumber > newNumber)
         log("error: closed order cannot be found!");
      oldNumber = getOpenOrders(oldOrders); // refresh
      Sleep(100);      
      continue;
    }//if   
   }// while
   

//----
   return(0);
}
//+------------------------------------------------------------------+