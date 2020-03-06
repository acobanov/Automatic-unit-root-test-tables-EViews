subroutine pp(string %final_name,string %output,string %var_names)
'************************************************************************************************************************************
' Philips-Perron (PP) unit root tests TABLE
'*************************************************************************************************************************************

' Author:  Ante Cobanov (ante.cobanov@yahoo.com)
' GitHub: acobanov

'*************************************************************************************************************************************

' INPUT:
   '%final_name  -> Eviews table output name
   '%output           -> File name (saved to disk)
   '%var_names -> Variable's names

' OUTPUT:
   ' Eviews table objects and corresponding files saved to disk

'*************************************************************************************************************************************
		%tests= "pp"
		%models= "const trend none"
		%difs= "0 1 2"
		
		
		!vars=@wcount(%var_names)
		!tests=@wcount(%tests)
		!models=@wcount(%models)
		!difs=@wcount(%difs)
		!cols=!tests*!models*!difs
		
		matrix(!vars,!cols) results
		table(!vars+3,!cols+1) {%final_name}
		
		!kk=0
		for %test {%tests}
			for %model {%models}
				for %dif {%difs}
					!kk=!kk+1
					{%final_name}(1,!kk+1)=%test
					{%final_name}(2,!kk+1)=%model
					{%final_name}(3,!kk+1)=%dif
				next
			next
		next
		
		
		table(!vars,!cols) aa
		!rr=0
		for %var_name {%var_names}
			!rr=!rr+1
			!ss=0
 			for %test {%tests}
				for %model {%models}
					for %dif {%difs}
						!ss=!ss+1
						%name1=%var_name+"_"+%test+"_"+%model+"_"+%dif
						freeze({%name1}) {%var_name}.uroot({%test},{%model},dif={%dif})
						!critical_1=@val({%name1}(8,4))
						!critical_5=@val({%name1}(9,4))
						!critical_10=@val({%name1}(10,4))
						!test_statistic=@val({%name1}(7,4))
						aa(!rr,!ss)=!test_statistic
						aa.setformat(!rr,!ss,!rr,!ss) f(.3)
						if ((!critical_1*!test_statistic)>0) then
							if (@abs(!test_statistic)>@abs(!critical_1)) then
								aa(!rr,!ss)=aa(!rr,!ss)+"*" 
							endif
						endif
						if ((!critical_5*!test_statistic)>0) then
							if (@abs(!test_statistic)>@abs(!critical_5)) then
								aa(!rr,!ss)=aa(!rr,!ss)+"*" 
							endif
						endif
						if ((!critical_10*!test_statistic)>0) then
							if (@abs(!test_statistic)>@abs(!critical_10)) then
								aa(!rr,!ss)=aa(!rr,!ss)+"*" 
							endif
						endif
		
					next
				next
			next
		next
		
		tabplace({%final_name},aa, 4,2,1,1,!vars,!cols)
		'{%final_name}.setformat(4,2,!vars+3,!cols+1) f(.3)
		{%final_name}.setwidth(@all) 14
		{%final_name}.setheight(@all) 1
		{%final_name}.setlines(a3:j3) +b
		{%final_name}.setlines(a1:a15) +r
		
		!rr=3
		'{%final_name}.setwidth(1) 12
		for %var_name {%var_names}
			!rr=!rr+1
			{%final_name}(!rr,1)=%var_name
		next
		
		{%final_name}.setjust(4,2,!vars+3,!cols+1) left
		'{%final_name}.setindent(4,2,!vars+3,!cols+1) 7
		{%final_name}.setindent(@all) 7
		{%final_name}.save(t=emf) {%output}
		delete aa
endsub


