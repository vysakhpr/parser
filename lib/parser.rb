require_relative "parser/version"
require_relative "parser/can_functions"
require_relative "parser/pars_table"

module Parser
  #g=[ "S-> T SS ", "SS-> + T SS ", "SS-> epsilon ", "T-> F TT ", "TT-> * F TT ", "TT-> epsilon ", "F-> ( S ) ", "F-> id "]
  #gram_sym=[ "S","SS","T","TT","F","+","*","id","(",")"]
  #term_sym=[ "id","+","*","(",")","$","epsilon"]
  #non_term_sym=["S","T","F","SS", "TT"]
  #print followof("SS",term_sym,non_term_sym,g)

  #g=[ "S-> L = R ","S-> R ","L-> * R ","L-> id ","R-> L "]
  #gram_sym=["S","L","R","=","*","id"]
  #for x in items(g,gram_sym)
  #print x
  #print "\n"
  #end

  g=["S-> DATATYPE FNAME { STMTS } ",
     "STMTS-> STMT ; STMTS ",
     "STMTS-> STMT ; ",
     "STMT-> DATATYPE IDS ",
     "STMT-> id = EXPR ",
     "EXPR-> EXPR + TERM ","EXPR-> TERM ","TERM-> TERM * FACTOR ","TERM-> FACTOR ","FACTOR-> ( EXPR ) ","FACTOR-> id ", 
     "IDS-> id , IDS ",
     "IDS-> id ",
     "DATATYPE-> int ",
     "DATATYPE-> void ",
     "DATATYPE-> char ",
     "FNAME-> NAME ( ) ",
      "NAME-> main "]
  gram_sym=["S","DATATYPE","EXPR","TERM","FACTOR", "FNAME","NAME","STMT", "IDS" ,"STMTS","id","int","char","void","main","+","*","=","{","}","(",")",";",",","$","epsilon"]
  term_sym=["id","int","void","char","main","+","*","=","{","}","(",")",";",",","$","epsilon"]
  non_term_sym=["S","DATATYPE","EXPR","TERM","FACTOR" ,"FNAME","NAME","STMT","IDS","STMTS"]
  start_sym="S"
  

  

  #g=["S-> S + T ","S-> T ","T-> T * F ","T-> F ","F-> ( S ) ","F-> id "]
  #gram_sym=["S","T","F","id","+","*","(",")","$","epsilon"]
  #term_sym=["id","+","*","(",")","$","epsilon"]
  #non_term_sym=["S","T","F"]
  #start_sym="S"
  #c=[closure(["SS-> . #{start_sym} "],g)]
  #puts c
  #z=items(g,gram_sym,start_sym)
  #puts z.length
  #for x in z
  #print x
  #print "\n"
  #end
  #print followof("S",term_sym,non_term_sym,g)
  table(g,term_sym,non_term_sym,gram_sym, start_sym)
  puts "Enter the input"
  z=gets.chomp
  parse(z,term_sym,non_term_sym,g)
end
