--/*
if (ut_main == undefined) then 
(
	local ext = "ms"
	--local ext = "mse"
	
	filein ("collectorex\\utils." + ext)
	filein ("collectorex\\main." + ext)
	filein ("collectorex\\file_ops." + ext)
	filein ("collectorex\\find_files." + ext) 
	filein ("collectorex\\convjpg." + ext) 
	filein ("collectorex\\macro_ops_utils." + ext) 
	filein ("collectorex\\macro_ops." + ext) 
	filein ("collectorex\\log." + ext) 
	filein ("collectorex\\unused_dlg." + ext) 
	filein ("collectorex\\main_ops." + ext) 

	filein ("collectorex\\utils." + ext)
	filein ("collectorex\\main." + ext)
	filein ("collectorex\\file_ops." + ext)
	filein ("collectorex\\find_files." + ext) 
	filein ("collectorex\\convjpg." + ext) 
	filein ("collectorex\\macro_ops_utils." + ext) 
	filein ("collectorex\\macro_ops." + ext) 
	filein ("collectorex\\log." + ext) 
	filein ("collectorex\\unused_dlg." + ext) 
	filein ("collectorex\\main_ops." + ext)  

	updateToolbarButtons()	
)	

if ut_main.isopen then 
(
	removerollout ut_main.main_wnd
	removerollout ut_main.convert_dlg
	removerollout ut_main.about_dlg
)
else 
(
	addRollout ut_main.main_wnd
	addRollout ut_main.convert_dlg	rolledUp:true	
	addRollout ut_main.about_dlg 	rolledUp:true
)
--*/
/*
filein "collectorex\\utils.ms"
filein "collectorex\\main.ms"
filein "collectorex\\file_ops.ms"
filein "collectorex\\find_files.ms" 
filein "collectorex\\convjpg.ms" 
filein "collectorex\\macro_ops_utils.ms" 
filein "collectorex\\macro_ops.ms" 
filein "collectorex\\log.ms" 
filein "collectorex\\unused_dlg.ms" 
filein "collectorex\\main_ops.ms" 

filein "collectorex\\utils.ms"
filein "collectorex\\main.ms"
filein "collectorex\\file_ops.ms"
filein "collectorex\\find_files.ms" 
filein "collectorex\\convjpg.ms" 
filein "collectorex\\macro_ops_utils.ms" 
filein "collectorex\\macro_ops.ms" 
filein "collectorex\\log.ms" 
filein "collectorex\\unused_dlg.ms" 
filein "collectorex\\main_ops.ms" 

try
(
	removerollout ut_main.main_wnd
	removerollout ut_main.about_dlg
	removerollout ut_main.convert_dlg
)
catch ()

addRollout ut_main.main_wnd
addRollout ut_main.convert_dlg	rolledUp:true
addRollout ut_main.about_dlg rolledUp:true
--*/
