require_relative "can_functions"
def firstof(x,term_sym, non_term_sym,g)
	f=[ ]
	if term_sym.include?(x)
		f=[x]
	elsif non_term_sym.include?(x)
		for k in g.find_all{|item| item =~ /^#{x}->/}
			n=nil
			l=k[/->[\Wa-zA-Z0-9 ]+/]
			l.delete!("->")
			l=l.split(" ")
			for m in l
				unless firstof(m, term_sym, non_term_sym, g).include?("")
					n=m
					break;
				end
			end
		    if !(n.nil?)
				p=firstof(n, term_sym, non_term_sym, g) 
				for q in p
					unless f.include?(q)
						f<<q
					end
				end
			else
			    f<<"" if !(f.include?(""))
			end
		end
	end
	return f
end

def followof(x, term_sym, non_term_sym, g)
	f=[ ]
	y=x
	if y=="S"
		f<<"$" if !(f.include?("$"))
	end
   	x=x.split("").join("[")
   	x=x.insert(0,"[")
   	x=x.scan(/./).each_slice(2).map(&:join).join("]")
   	x=x.insert(x.length,"]")
   	for k in g.find_all{|item| item =~ /^[A-Z]+->[ ][\W0-9a-zA-Z ]*#{x} [\Wa-zA-Z0-9]+[ ][\Wa-zA-Z0-9 ]*$/}
   		l=k.gsub(/^[A-Z]+->[ ]/,"")
   		l=l[/#{x}[ ][^\s]+[ ]/]
   		l=l.gsub("#{y}", "")
   		l=l.gsub(/^[\s]+/,"")
   		l=l.gsub(/[\s]+$/,"")
   		a=k[/^[A-Z]+->/]
   		a=a.gsub("->","")
   		#unless a==y
	   		n=firstof(l, term_sym, non_term_sym, g)
   			for m in n	
   				unless m=="epsilon"
   					f<<m if !(f.include?(m))
   				end
   			end
   			if n.include?("epsilon")
	   			for b in followof(a,term_sym,non_term_sym,g)
   					f<<b if !(f.include?(b))
   				end
   			end
   		#end 
   	end
   	for k in g.find_all{|item| item =~ /^[A-Z]+->[ ][\Wa-zA-Z0-9]* #{x} $/}
   		a=k[/^[A-Z]+->/]
   		a=a.gsub("->","")	
   		unless a==y
   			for b in followof(a,term_sym,non_term_sym,g)
   				f<<b if !(f.include?(b))
   			end
   		end
   	end
return f
end



def table(g, table_action_sym, table_goto_sym, gram_sym, start_sym)
	c=items(g,gram_sym, start_sym)
	$action=Array.new(c.length){Array.new(table_action_sym.length)}
	$goto_table=Array.new(c.length){Array.new(table_goto_sym.length)}
	for i in (0...c.length)
		for k in c[i].find_all{|item| item =~ /^[A-Z]+->[ ][\W0-9a-zA-Z ]*[.] [^\sA-Z]+ [\Wa-zA-Z0-9 ]*$/}
			a=k[/[.] [^\sA-Z]+[ ]/]
			a=a.gsub(". ","")
			a=a.gsub(" ","")
			d=got(c[i],a,g)
			j=c.index(d)
			if table_action_sym.index(a).nil?
				puts "unknown identifier"
				return
			end
			unless j.nil?
				$action[i][table_action_sym.index(a)]="s#{j}"
			end
		end

		for k in c[i].find_all{|item| item =~ /^[A-Z]+->[ ][\W0-9a-zA-Z ]*[.][ ]$/}
			#puts k
			l=k.gsub(". ","")
			a=k[/^[A-Z]+->/]
			a=a.gsub("->","")
			#unless a == "SS"
				j=g.index(l)
				#puts j
				for m in followof(a, table_action_sym, table_goto_sym,g)
					unless table_action_sym.index(m).nil?
						$action[i][table_action_sym.index(m)]="r#{j+1}"
					end
				end
			#end
		end	

		if c[i].include?("SS-> #{start_sym} . ")
			$action[i][table_action_sym.index("$")]="ac"
		end

		for k in table_goto_sym
			d=got(c[i],k,g)
			j=c.index(d)
			unless j.nil?
				$goto_table[i][table_goto_sym.index(k)]=j
			end
		end
	end

	for i in (0...c.length)
		for j in (0...table_action_sym.length)
			print $action[i][j]
			print "\t"
		end

		for j in (0...table_goto_sym.length)
			print $goto_table[i][j]
			print "\t"
		end
		print("\n")
	end

	print "\n\n\n"

end

def parse(word,term_sym,non_term_sym,g)
	word=word+"$"
	words=word.split(/[\s]/)
	len=words.length
	j=0
	st=[0]
	l=0
    while true
    	a=words[j]
		s=st[l]
		unless s.nil?
		d=$action[s.to_i][term_sym.index(a)]
		end
		#for z in (0..l)
		#	print st[z]
		#end
		#print "\t\t"
		#print d
		#print "\t\t\n"
		if d =~ /^[s]/
			b=d.gsub(/^[s]/,"")
			l=l+1
			st[l]=b.to_i
			j=j+1
		elsif d =~ /^[r]/
			b=d.gsub(/^[r]/,"")
			b=b.to_i
			x=g[b-1]
			c=x[/^[A-Z]+->/]
			y=x[/->[\Wa-zA-Z0-9 ]+$/]
			y=y.gsub("->","")
			c=c.gsub("->","")
			y=y.split(" ")			
			for i in (0...y.length)
				l=l-1
			end
			t=st[l]
			l=l+1
			st[l]=$goto_table[t.to_i][non_term_sym.index(c)]
			puts x
		elsif d=="ac"
			puts "ACCEPTED"
			break
		else	
			puts "ERROR"
			break	
		end
	end
end

