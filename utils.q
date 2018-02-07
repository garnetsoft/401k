/
  logging utils 
  level - level to log (DEBUG|ERROR|WARN|INFO)
  return nothing 
\

.log.log:{[level;str]
  -1 (string .z.Z)," : ", (string level), " ", str; / log a string to stdout for level  
  };

 // log level
 .log.error:.log.log[`ERROR;];
 .log.info:.log.log[`INFO;];
 .log.warn:.log.log[`WARN;];
 .log.debug:.log.log[`DEBUG;];


empty:{[t]
  @[`.;t;0#]; / delete and keep sym 
  }

get_param:{[p]
  :first(.Q.opt .z.x)p /using .Q.opt, return value of given param key
  }

frmt_handle:{[h]
  hsym `$h / convert string to q handle
  }