'*********************************************************************************************************************************
'   Toolbox to automate unit root test tables
'   Unit root tests included: Augmented Dickey - Fuller, Philips-Perron, Kwiatkowski - Philips - Schmidt - Shin
'   All (available) options included: none, constant, trend  + level, 1st difference, 2nd difference

'*************************************************************************************************************************************

' Author:  Ante Cobanov (ante.cobanov@yahoo.com)
' GitHub: acobanov

'*************************************************************************************************************************************

' MAIN CODE' 

'************************************************************************************************************************************
%path="...\G4"
cd %path

' include  functions
include "...\functions\\adf"
include "...\functions\kpss"
include "...\functions\pp"

'define sample and frequency
%start_date="1997m01"
%end_date="2019m12"
%fr="m"

wfcreate(wf=analiza) {%fr} {%start_date} {%end_date}
%sheet_names=@tablenames("...\data\data.xls")
%var_names= "series1 series2 series3"

for %s {%sheet_names}
		pagecreate(page={%s})  {%fr} {%start_date} {%end_date}
		read(b2,s={%s}) ...\data\data.xls {%var_names}
		%tab_adf="adf_"+"sheet_"+%s
		%tab_pp="pp_"+"sheet_"+%s
		%tab_kpss="kpps_"+"sheet_"+%s
        ' Augmented Dickey - Fuller unit root tests table
		call adf(%tab_adf,%tab_adf,%var_names)
           ' Philips-Perron unit root tests table
		call pp(%tab_pp,%tab_pp,%var_names)
           ' Kwiatkowski - Philips - Schmidt - Shin unit root test table
		call kpss(%tab_kpss,%tab_kpss,%var_names)
next

' Copy all unit root tables to final page
%final="tables"
pagecreate(page={%final})  {%fr} {%start_date} {%end_date}

for %s  {%sheet_names}
		%tab_adf="adf_"+"sheet_"+%s
		%tab_pp="pp_"+"sheet_"+%s
		%tab_kpss="kpps_"+"sheet_"+%s
          copy {%s}\{%tab_adf}  {%final}\{%tab_adf}
          copy {%s}\{%tab_pp} {%final}\{%tab_pp}
           copy {%s}\{%tab_kpss} {%final}\{%tab_kpps}
next
   





