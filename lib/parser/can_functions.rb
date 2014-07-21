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
				n=n.gsub(/[\s]+$/," ")
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
   	y=x
   	x=x.split("").join("[")
   	x=x.insert(0,"[")
   	x=x.scan(/./).each_slice(2).map(&:join).join("]")
   	x=x.insert(x.length,"]")
   	for k in i.find_all{|item| item =~ /^[A-Z]+->[ ][\W0-9a-zA-Z ]*[.] #{x} [\Wa-zA-Z0-9 ]*$/}
		a=k[/^[A-Z]+->[ ][\WA-Za-z ]*[.]/]
		a=a.gsub(".","")
		b=k[/[.] #{x} [\Wa-zA-Z ]*$/]
		b=b.gsub(". ","")
 		b=b.gsub("#{y}","")
 		a=a+y+" ."+b
 		a=a.gsub(/[\s]+$/," ")
 		l<<a
	end		
    return closure(l,g)
end

def items(g,gram_sym)
	c=[closure(["SS-> . S "],g)]
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