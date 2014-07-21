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
 # 	print x
 #	print "\n"
  #end

  g=["S-> S + T ","S-> T ","T-> T * F ","T-> F ","F-> ( S ) ","F-> id "]
  gram_sym=["S","T","F","id","+","*","(",")","$","epsilon"]
  term_sym=["id","+","*","(",")","$","epsilon"]
  non_term_sym=["S","T","F"]
  #z=items(g,gram_sym)
  #puts z.length
  #for x in z
   #print x
   #print "\n"
  #end
  #print followof("S",term_sym,non_term_sym,g)
  table(g,term_sym,non_term_sym,gram_sym)
end
