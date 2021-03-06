/query yahoo financials and produce a table of trading info for a list of stocks during the last few days

httpGet:{[host;location] (`$":http://",host)"GET ",location," HTTP/1.0\r\nHost:",host,"\r\n\r\n"};
httpsGet:{[host;location] (`$":https://",host)"GET ",location," HTTPS/1.0\r\nHost:",host,"\r\n\r\n"};

/ q)b:httpGet[ "ichart.finance.yahoo.com"; "/table.csv?s=MSFT" ]  
/ q)b:httpGet[ "finance.yahoo.com"; "/quote/GE/history?p=GE"]

yahoo:{[ndays;stocks] 
 / ensure that stocks is a list (it might be a single symbol) and then get rid of duplicates, if any
 stocks: distinct stocks,();  
 enddate: .z.d; / .z.d gives current date
 startdate: enddate-ndays;
 / parameter string for HTTP request
 params: "&d=" , (string -1+`mm$enddate) / end month 
    , "&e=" , (string `dd$enddate) / end day 
    , "&f=" , (string `year$enddate) / end year
    , "&g=d&a=" , (string -1+`mm$startdate) / start month
    , "&b=" , (string `dd$startdate) / start day
    , "&c=" , (string `year$startdate) / start year
    , "&ignore=.csv";
 tbl:(); / initialize results table
 i:0;
 do[count stocks; /iterate over all the stocks
     stock: stocks[i];
     / send HTTP request for this stock; we get back a string
     / txt: `:http://ichart.finance.yahoo.com "GET /table.csv?s=" , (string stock) , params , " http/1.0\r\nhost:ichart.finance.yahoo.com\r\n\r\n";
     / https://finance.yahoo.com/quote/GE/history?p=GE
     txt:httpGet["finance.yahoo.com", "/quote/",(string stock),"/history?p=",(string stock)];

     show "xxxx txt: ",string txt;

     pattern: "Date,Open"; / pattern to search for in the result string
     startindex: txt ss pattern; / the function ss finds the positions of a pattern in a string
    txt: startindex _ txt; / drop everything before the pattern (HHTP headers, etc)
	stocktable: ("DEEEEI ";enlist",")0:txt; / parse the string and create a table from it
    stocktable: update Sym:stock from stocktable; / add a column with name of stock
    tbl,: stocktable; / append the table for this stock to tbl
    i+:1
  ];
 tbl: select from tbl where not null Volume; / get rid of rows with nulls
 `Date`Sym xasc tbl} / order by date and stock

/ ha:httpGet["en.wikipedia.org"; "/wiki/List_of_S%26P_500_companies"]

/ https://en.wikipedia.org/wiki/List_of_S%26P_500_companies#Recent_changes_to_the_list_of_S&P_500_Components

/ he:httpsGet["en.wikipedia.org"; "/wiki/List_of_S%26P_500_companies#Recent_changes_to_the_list_of_S&P_500_Components"];