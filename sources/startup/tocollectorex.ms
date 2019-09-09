macroScript TOCollectoREX category:"Tertium Organum" tooltip:"Tertium Organum CollectoREX"  icon:#("tocollectorex",1)
(
	on ischecked return try(execute "ut_main.isopen")catch(off)
	on execute do 
	(
		fileIn "collectorEx/launcher.ms"
	)
)