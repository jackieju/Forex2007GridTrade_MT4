//+------------------------------------------------------------------+
//|                                                       daemon.mq4 |
//|                       Copyright ?2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#include <stdlib.mqh>
#include <WinUser32.mqh>
 
int oldOrders[100];        // list of old orders
int newOrders[100];        // list of current orders
string Sym = "GBPJPYm";    // chart name
double lot = 0.01;         // lot for each order
double distance = 0.10;    // distance between order
//double point_gap = 0.09;   // point gap gbpjyp is 0.09
int magic_number = 770102; // magic number 
int direction = 0; // 0: no single-side, 1: up single-side, -1: down single-side
double SL = 1.0;  // stop loss
string summary;
int summary_status = 0;
int closedOrderNumber = 0;

void log(string s){
datetime tm = TimeCurrent();
string ts = TimeYear(tm)+"-"+TimeMonth(tm)+"-"+TimeDay(tm)+" "+TimeHour(tm)+":"+TimeMinute(tm)+":"+TimeSeconds(tm)+"\t"+s;
int handle = FileOpen("log"+TimeYear(tm)+""+TimeMonth(tm)+""+TimeDay(tm)+".txt", FILE_BIN|FILE_READ|FILE_WRITE);
FileSeek(handle, 0, SEEK_END);
FileWrite(handle, ts);
FileClose(handle);
}

int open_count =0; // number of open orders
int getOpenOrders(int &array[]){

   int    cmd,total;
   ArrayInitialize(array, 0);
   
// get order number
   total=OrdersTotal();
   //log("total: "+total);
   open_count =0; // number of open orders
   for(int i=0; i<total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
        cmd=OrderType();  
        //log("OrderTicket "+ OrderTicket()+ ":" +"OrderMagicNumber: " + OrderMagicNumber());       
        // if( (cmd==OP_BUY || cmd ==OP_SELL) && (OrderMagicNumber() == 770102) ) {
        string ss = OrderComment();
         if( (cmd==OP_BUY || cmd ==OP_SELL) && ss == "hh" ) {         
            array[open_count] = OrderTicket();
            //log("found open order " + OrderTicket());            
            
            // check current price and change the stop loss to open price 
          //  double op = OrderOpenPrice();
            //double b = Bid;
            //double a = Ask;
            //if ( ( (cmd == OP_BUY && b > op) || (cmd == OP_SELL && b < op) ) && OrderStopLoss() == 0 /*&& StringFind(ss, "notp") <0 */)
              // if (!OrderModify(OrderTicket(), 0, op, 0, 0)){
                //int error=GetLastError();
           //     if ( error != 0)
             //     log("Modify order " + OrderTicket() + " Error = "+ ErrorDescription(error) + ", price: "+op +", bid: " + b + "Ask: " + a);
          //     }
              // else
                //  log("Modify order " + OrderTicket() + " ok, price: "+op +", bid: " + b + "Ask: " + a);
            
            open_count++;
         }
      }/*else{
        Print( "Error when order select ", GetLastError()); 
        MessageBox("error: "+ErrorDescription(GetLastError()),NULL,IDOK);
        return (0); 
      }*/
   }
   //log("count="+count);
   return (open_count);
}



void checkAndSendSummaryMail(){
   datetime tm = TimeCurrent();
   string ts;
   string msg;   
   bool send = false;
   
   int h = TimeHour(tm);
   if ((h >= 0 && h < 12 && (summary_status ==0 || summary_status==2)) || ( h >=12 && h <24 && summary_status <= 1 ))
      send = true;
  
   
   if (send){
      
      ts = TimeYear(tm)+"-"+TimeMonth(tm)+"-"+TimeDay(tm)+" "+TimeHour(tm)+":"+TimeMinute(tm)+":"+TimeSeconds(tm)+"\t";
      msg = "-----------------------------------------------\r\n"
            + "Summary on " + ts + ":\r\n"
            + closedOrderNumber + " order closed successfully\r\n"
            + open_count + " open orders, " + Sym + " Current Price " + Bid 
            + "Balance: " + AccountBalance( ) + ", Equity: " + AccountEquity( )  + ", Profit:" + AccountProfit() + ", Margin: " + AccountMargin () 
            + "\r\n-----------------------------------------------\r\n"
            + summary;
      SendMail("Forex Trade Summary", msg);
      
      summary = "";
      closedOrderNumber = 0;
      
      if (summary_status == 2)
         summary_status = 1;
      else if (summary_status ==0)
         summary_status = 1;
      else if (summary_status == 1)
         summary_status = 2;
      //if (summary_status == 0)
        // summary_status = 1;
      //else if (summary_status == 1)
        // summary_status = 0;
   
   }
   
   
   return;
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
   int sl = 0; // stop loss
   double tAsk;
   double tBid;
   int loop_count = 0;
// get order number
   string msg;
   
   
   Sym = Symbol();
   int oldNumber = getOpenOrders(oldOrders);
   MessageBox("Symbol is " + Sym + ", number of open orders: "+ oldNumber,MB_OK);
//----
    
//----
   
//----
   while(true){
   RefreshRates();
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
      double op1 = 0;
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
        
         closedOrderNumber ++;
         msg = "order "+ oldOrders[i] + " was closed(" + OrderOpenPrice() + "/" + OrderClosePrice() + ")";
         log(msg);
         summary = summary + msg+"\r\n";
         
         
         int ticket;
         int error;
         // found closed order
         double op = OrderOpenPrice();
         int type = OrderType();
         
         if (type == OP_BUY){
            if (direction > 0)
               sl = op + SL;
            else 
               sl = 0;
            double stop = op-(OrderClosePrice() - OrderOpenPrice());
            log("stop="+op+"-"+distance);
            RefreshRates();
            tBid = Bid;
            ticket = 0;
            if (tBid < op )
               ticket = OrderSend(Sym,OP_SELLLIMIT, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
            else
               ticket = OrderSend(Sym,OP_SELLSTOP, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
            if(ticket<1)
            {
               error=GetLastError();
               log("SELL Error = "+ ErrorDescription(error) + ", price: "+op+", stop: "+stop+", BID="+tBid);
               //MessageBox("sellstop: price="+p+", stop="+stop+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script", MB_OK);
               // place again
               if (tBid < op )
                  ticket = OrderSend(Sym,OP_SELLSTOP, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
               else 
                  ticket = OrderSend(Sym,OP_SELLLIMIT, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
               if(ticket<1)
               {
                   error=GetLastError();
                   log("SELL again Error = "+ ErrorDescription(error) + ", price: "+op+", stop: "+stop+", BID="+tBid);
                   SendMail("Forex trade alert", "SELL again Error = "+ ErrorDescription(error) + ", price: "+op+", stop: "+stop+", BID="+tBid);
                   break;
                }else 
               log ("order "+ticket+" created ok at price "+op+" stop "+stop);
            }else 
               log ("order "+ticket+" created ok at price "+op+" stop "+stop);
               
            if (direction > 0){
              ticket = 0;
              op1 = Ask+distance/2;
              stop = op1 + distance;
              tAsk = Ask;
              ticket=OrderSend(Sym,OP_BUYSTOP, lot, op1,3,0,stop,"aa",770102,0,CLR_NONE);
              if (ticket<1)
               {
                error = 0;
                error=GetLastError();
                log("BUY Error = "+ErrorDescription(error) + ", price: "+op1+", stop: "+stop+", ASK="+tAsk);
                //MessageBox("sellstop: price="+p+", stop="+stop+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script", MB_OK);
                break;
               }else 
                  log ("order "+ticket+" created ok at price "+op+" stop "+stop + "ok.");
           
           }
         }
         else if (type == OP_SELL){
           stop = op+OrderOpenPrice()-OrderClosePrice(); 
           log("stop="+op+"+"+distance);
           if ( direction < 0)
               sl = op - SL;
            else 
               sl = 0;
            
           ticket = 0;
            RefreshRates();
           tAsk = Ask;
           if (tAsk > op )
            ticket=OrderSend(Sym,OP_BUYLIMIT, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
           else
            ticket=OrderSend(Sym,OP_BUYSTOP, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
           if (ticket<1)
            {
             error = 0;
             error=GetLastError();
             log("BUY Error = "+ErrorDescription(error) + ", price: "+op+", stop: "+stop+", ASK="+tAsk);
             //MessageBox("sellstop: price="+p+", stop="+stop+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script", MB_OK);
             
              if (tAsk > op )
               ticket=OrderSend(Sym,OP_BUYSTOP, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
              else 
               ticket=OrderSend(Sym,OP_BUYLIMIT, lot, op,3,0,stop,"hh",770102,0,CLR_NONE);
               if (ticket<1)
               {
                error = 0;
                error=GetLastError();
                log("BUY again Error = "+ErrorDescription(error) + ", price: "+op+", stop: "+stop+", ASK="+tAsk);
                SendMail("Forex trade alert", "BUY again Error = "+ErrorDescription(error) + ", price: "+op+", stop: "+stop+", ASK="+tAsk);
                break;
               }else 
               log ("order "+ticket+" created ok at price "+op+" stop "+stop);
            }else 
               log ("order "+ticket+" created ok at price "+op+" stop "+stop + "ok.");
            
           if (direction < 0){
              ticket = 0;
              op1 = Bid-distance/2;
              stop = op1 - distance;
              tBid = Bid;
              ticket=OrderSend(Sym,OP_SELLSTOP, lot, op1,3,0,stop,"aa",770102,0,CLR_NONE);
              if (ticket<1)
               {
                error = 0;
                error=GetLastError();
                log("SELL Error = "+ErrorDescription(error) + ", price: "+op1+", stop: "+stop+", Bid="+tBid);
                //MessageBox("sellstop: price="+p+", stop="+stop+", i="+i+"\r\nerror:"+ErrorDescription(error),"Script", MB_OK);
                break;
               }else 
                  log ("order "+ticket+" created ok at price "+op+" stop "+stop + "ok.");
           
           }
         }     
        
         break;

      }// for
      if (i >= oldNumber && oldNumber > newNumber)
         log("error: closed order cannot be found!");
      oldNumber = getOpenOrders(oldOrders); // refresh
      
      // check if any order closed with s/l 0, place the order again
      
      Sleep(100);
      loop_count ++;
      if (loop_count > 36000) // check every hour
      {
         checkAndSendSummaryMail();      
         loop_count = 0;
      }
      continue;
    }//if   
   }// while
   

//----
   return(0);
}
//+------------------------------------------------------------------+