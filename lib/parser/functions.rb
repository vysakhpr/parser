def closure(i,g)
	j=i
	f=0
	begin
		f=0
		for k in j.find_all{|item| item =~ /^[A-Z]+->[ ][\W0-9a-zA-Z ]*[.][ ][A-Z]+[ ]?[a-zA-Z0-9\W ]*$/}
			l=k[/[.][ ][A-Z]*[ ]/]
			l.delete!(". ")
			for m in g.find_all{|item| item =~ /#{l}->/}
				n=m[/->[ ][\W0-9A-Za-z ]+/]
				n.gsub!(/->/, '')
				n=l+"-> ."+n+" "
				unless j.include?(n)
					j<<n
					f=1
				end
			end
		end 
	end while(f==1)
	return j	
end

def got(i,x,g)
   	l=[ ]
   	for k in i.find_all{|item| item =~ /^[A-Z]+->[ ][\W0-9a-zA-Z ]*[.] [#{x}][ ][\Wa-zA-Z ]*$/}
		a=k[/^[A-Z]+->[ ][\WA-Za-z ]*[.]/]
		a=a.gsub(".","")
		b=k[/[.] [#{x}][ ][\Wa-zA-Z ]*$/]
		b=b.gsub(". ","")
 		b.delete!("#{x}")
 		a=a+x+" ."+b
 		a=a.gsub(/[\s]+$/," ")
 		l<<a
	end		
    return closure(l,g)
end

def items(g)
	c=[closure(["SS-> . S "],g)]
	gram_sym=[ "S","L","R","=","*" ]
	begin
		f=0
		for i in c
			for x in gram_sym
				h=got(i,x,g)
				unless h.empty?
					unless c.include?(h)
						c<<h
						f=1
					end	
				end
			end
		end
	end while(f==1)
	return c
end