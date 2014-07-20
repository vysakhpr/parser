require_relative "parser/version"
require_relative "parser/functions"

module Parser
  g=["S-> L = R ", "S-> R ", "L-> * R ", "L-> id ", "R-> L " ];
  for x in items(g)
  	print x
  	print "\n"
  end
end
