Struct SConfig 
(
	ask_even_if_bmps_are_equal 		= false,
	ask_user_when_file_op_fails 	= true,
	binary_compare_of_non_img 		= false,
	ask_even_if_binary_are_equal 	= false,
	process_medit_only_content 		= false,
	collect_img_ies 				= true,
	collect_hdri_images 			= true,
	collect_vray_meshes 			= true,
	dont_collect_shaders			= true,
	make_backups 					= true,
	incremental_backups				= true,
	load_files_when_fix_links		= false,
	search_texture_instances		= false,
	process_xref_structure 			= true,
	clear_medit_before_proceed 		= true,
	unused_summary_only				= true,
	if_image_has_alpha				= 1,
	tga_premultiply_alpha			= true,
	jpeg_compression 				= 100,  
	use_nconvert					= true,
	img_ies_root 	 				= "", --without last '\'
	hdri_root	 	 				= "", --without last '\'
	vrmesh_root 	 				= "", --without last '\'
	
	function ToStringArray = 
	(
		local vals = #()
		append vals ("ask_even_if_bmps_are_equal = " + ask_even_if_bmps_are_equal  	as string  )
		append vals ("ask_user_when_file_op_fails = " + ask_user_when_file_op_fails 	as string  )
		append vals ("binary_compare_of_non_img = " + binary_compare_of_non_img   	as string  )
		append vals ("ask_even_if_binary_are_equal = " + ask_even_if_binary_are_equal	as string  )
		append vals ("process_medit_only_content = " + process_medit_only_content  	as string  )
		append vals ("collect_img_ies = " + collect_img_ies              	as string  )
		append vals ("collect_hdri_images = " + collect_hdri_images         	as string  )
		append vals ("collect_vray_meshes = " + collect_vray_meshes         	as string  )
		append vals ("dont_collect_shaders = " + dont_collect_shaders         	as string  )
		append vals ("make_backups = " + make_backups                	as string  )
		append vals ("incremental_backups = " + incremental_backups                	as string  )
		append vals ("load_files_when_fix_links = " + load_files_when_fix_links                	as string  )
		append vals ("search_texture_instances = " + load_files_when_fix_links                	as string  )
		append vals ("process_xref_structure = " + process_xref_structure      	as string  )
		append vals ("clear_medit_before_proceed = " + clear_medit_before_proceed  	as string  )
		append vals ("unused_summary_only = " + unused_summary_only  	as string  )
		append vals ("if_image_has_alpha = " + if_image_has_alpha  	as string  )
		append vals ("tga_premultiply_alpha = " + tga_premultiply_alpha  	as string  )
		append vals ("jpeg_compression = " + jpeg_compression 				as string  )
		append vals ("nconvert = " + use_nconvert 				as string  )
		append vals ("img_ies_root = " + img_ies_root                	 		   )
		append vals ("hdri_root = " + hdri_root                	 		   )
		append vals ("vrmesh_root = " + vrmesh_root                	 		   )
		vals	
	),
	
	function ClearToDefaults =
	(
		ask_even_if_bmps_are_equal 		= false
		ask_user_when_file_op_fails 	= true
		binary_compare_of_non_img 		= false
		ask_even_if_binary_are_equal 	= false
		process_medit_only_content 		= false
		collect_img_ies 				= true
		collect_hdri_images 			= true
		collect_vray_meshes 			= true
		dont_collect_shaders 			= true
		make_backups 					= true
		incremental_backups 			= true
		load_files_when_fix_links 		= false
		search_texture_instances		= false
		process_xref_structure 			= true
		clear_medit_before_proceed 		= true
		unused_summary_only 			= true
		if_image_has_alpha 				= 1
		tga_premultiply_alpha 			= true
		jpeg_compression 				= 100  
		use_nconvert 					= true  
		img_ies_root 					= ""
		hdri_root 						= ""
		vrmesh_root 					= ""
	),
	
	function SaveAll =
	(
		fileProperties.addProperty #custom "to_ask_even_if_bmps_are_equal" 		ask_even_if_bmps_are_equal 	
		fileProperties.addProperty #custom "to_ask_user_when_file_op_fails" 	ask_user_when_file_op_fails 
		fileProperties.addProperty #custom "to_binary_compare_of_non_img" 		binary_compare_of_non_img 	
		fileProperties.addProperty #custom "to_ask_even_if_binary_are_equal" 	ask_even_if_binary_are_equal
		fileProperties.addProperty #custom "to_process_medit_only_content" 		process_medit_only_content 	
		fileProperties.addProperty #custom "to_collect_img_ies" 				collect_img_ies 				
		fileProperties.addProperty #custom "to_collect_hdri_images" 			collect_hdri_images 		
		fileProperties.addProperty #custom "to_collect_vray_meshes" 			collect_vray_meshes 		
		fileProperties.addProperty #custom "to_dont_collect_shaders" 			dont_collect_shaders 		
		fileProperties.addProperty #custom "to_make_backups" 					make_backups 				
		fileProperties.addProperty #custom "to_incremental_backups" 			incremental_backups 				
		fileProperties.addProperty #custom "to_load_files_when_fix_links" 		load_files_when_fix_links 				
		fileProperties.addProperty #custom "to_search_texture_instances" 		search_texture_instances 				
		fileProperties.addProperty #custom "to_process_xref_structure" 			process_xref_structure 		
		fileProperties.addProperty #custom "to_clear_medit_before_proceed" 		clear_medit_before_proceed 	
		fileProperties.addProperty #custom "to_unused_summary_only" 			unused_summary_only 	
		fileProperties.addProperty #custom "to_if_image_has_alpha" 				if_image_has_alpha 			
		fileProperties.addProperty #custom "to_tga_premultiply_alpha" 			tga_premultiply_alpha			
		fileProperties.addProperty #custom "to_jpeg_compression" 				jpeg_compression 			
		fileProperties.addProperty #custom "to_use_nconvert" 					use_nconvert 			
		fileProperties.addProperty #custom "to_img_ies_root" 					img_ies_root 				
		fileProperties.addProperty #custom "to_hdri_root" 						hdri_root 				
		fileProperties.addProperty #custom "to_vrmesh_root" 					vrmesh_root 				
	),                                  
	
	function GetAll =
	(
		ask_even_if_bmps_are_equal 		= ut_main.main_wnd.chk1.checked 
		ask_user_when_file_op_fails 	= ut_main.main_wnd.chk22.checked   
		binary_compare_of_non_img 		= ut_main.main_wnd.chk9.checked 
		ask_even_if_binary_are_equal 	= ut_main.main_wnd.chk8.checked 
		process_medit_only_content 		= ut_main.main_wnd.chk121.checked   
		collect_img_ies 				= ut_main.main_wnd.chk11.checked 
		collect_hdri_images 			= ut_main.main_wnd.chk14.checked 
		collect_vray_meshes 			= ut_main.main_wnd.chk10.checked 
		dont_collect_shaders 			= ut_main.main_wnd.chk25.checked 
		make_backups 					= ut_main.main_wnd.chk13.checked 
		incremental_backups				= ut_main.main_wnd.chk28.checked 
		load_files_when_fix_links		= ut_main.main_wnd.chk26.checked 
		search_texture_instances		= ut_main.main_wnd.chk27.checked 
		process_xref_structure 			= ut_main.main_wnd.chk16.checked 
		clear_medit_before_proceed 		= ut_main.main_wnd.chk77.checked 
		unused_summary_only 			= ut_main.main_wnd.chk12.checked 
		if_image_has_alpha 				= ut_main.convert_dlg.rdo1.state  
		tga_premultiply_alpha 			= ut_main.convert_dlg.chk27.checked 
		jpeg_compression 				= ut_main.convert_dlg.spn1.value as integer
		if jpeg_compression == undefined do
			jpeg_compression = 100
		if jpeg_compression	< 50 do
			jpeg_compression = 50
		if jpeg_compression	> 100 do
			jpeg_compression = 100
		use_nconvert 					= ut_main.convert_dlg.chk2.checked 
		ut_main.convert_dlg.spn1.value = jpeg_compression as float
		if doesFileExist ut_main.main_wnd.edt4.text do
			img_ies_root = lowercase ut_main.main_wnd.edt4.text
		if doesFileExist ut_main.main_wnd.cust6.text do
			hdri_root = lowercase ut_main.main_wnd.cust6.text
		if doesFileExist ut_main.main_wnd.cust7.text do
			vrmesh_root = lowercase ut_main.main_wnd.cust7.text
	),	
	
	function SetAll =
	(
		ut_main.main_wnd.chk1.checked 		= ask_even_if_bmps_are_equal 	
		ut_main.main_wnd.chk22.checked		= ask_user_when_file_op_fails    
		ut_main.main_wnd.chk9.checked 		= binary_compare_of_non_img 	
		ut_main.main_wnd.chk8.checked 		= ask_even_if_binary_are_equal
		ut_main.main_wnd.chk121.checked 	= process_medit_only_content 	   
		ut_main.main_wnd.chk11.checked		= collect_img_ies 				 
		ut_main.main_wnd.chk14.checked		= collect_hdri_images 		 
		ut_main.main_wnd.chk10.checked		= collect_vray_meshes 		 
		ut_main.main_wnd.chk25.checked		= dont_collect_shaders 		 
		ut_main.main_wnd.chk13.checked		= make_backups 				 
		ut_main.main_wnd.chk28.checked		= incremental_backups 				 
		ut_main.main_wnd.chk26.checked		= load_files_when_fix_links			 
		ut_main.main_wnd.chk27.checked		= search_texture_instances			 
		ut_main.main_wnd.chk16.checked		= process_xref_structure 		 
		ut_main.main_wnd.chk77.checked		= clear_medit_before_proceed
		ut_main.main_wnd.chk12.checked		= unused_summary_only
		ut_main.convert_dlg.rdo1.state		= if_image_has_alpha
		ut_main.convert_dlg.chk27.checked	= tga_premultiply_alpha 	 
		ut_main.convert_dlg.spn1.value 		= jpeg_compression as float 
		ut_main.convert_dlg.chk2.checked 	= use_nconvert
		ut_main.main_wnd.edt4.text 			= img_ies_root
		ut_main.main_wnd.cust6.text 		= hdri_root
		ut_main.main_wnd.cust7.text 		= vrmesh_root
	),	

	function SaveConfigToIni fname sec_name =
	(
		delIniSetting fname sec_name
		setINISetting fname sec_name "to_ask_even_if_bmps_are_equal" 	(ask_even_if_bmps_are_equal 	as string )
		setINISetting fname sec_name "to_ask_user_when_file_op_fails" 	(ask_user_when_file_op_fails 	as string )
		setINISetting fname sec_name "to_binary_compare_of_non_img" 	(binary_compare_of_non_img 		as string )	
		setINISetting fname sec_name "to_ask_even_if_binary_are_equal" 	(ask_even_if_binary_are_equal 	as string )
		setINISetting fname sec_name "to_process_medit_only_content" 	(process_medit_only_content 	as string )
		setINISetting fname sec_name "to_collect_img_ies" 				(collect_img_ies 	 			as string )			
		setINISetting fname sec_name "to_collect_hdri_images" 			(collect_hdri_images 	 		as string )	
		setINISetting fname sec_name "to_collect_vray_meshes" 			(collect_vray_meshes 		 	as string )
		setINISetting fname sec_name "to_dont_collect_shaders" 			(dont_collect_shaders 		 	as string )
		setINISetting fname sec_name "to_make_backups" 					(make_backups 				 	as string )
		setINISetting fname sec_name "to_incremental_backups" 			(incremental_backups		 	as string )
		setINISetting fname sec_name "to_load_files_when_fix_links"		(load_files_when_fix_links	 	as string )
		setINISetting fname sec_name "to_search_texture_instances"		(search_texture_instances	 	as string )
		setINISetting fname sec_name "to_process_xref_structure" 		(process_xref_structure 		as string )
		setINISetting fname sec_name "to_clear_medit_before_proceed" 	(clear_medit_before_proceed 	as string )
		setINISetting fname sec_name "to_unused_summary_only" 			(unused_summary_only 			as string )
		setINISetting fname sec_name "to_if_image_has_alpha" 			(if_image_has_alpha 			as string )
		setINISetting fname sec_name "to_tga_premultiply_alpha" 		(tga_premultiply_alpha 			as string )
		setINISetting fname sec_name "to_jpeg_compression" 				(jpeg_compression 			 	as string )
		setINISetting fname sec_name "to_use_nconvert" 					(use_nconvert 			 		as string )
		setINISetting fname sec_name "to_img_ies_root" 					 img_ies_root 				  
		setINISetting fname sec_name "to_hdri_root" 					 hdri_root 				  
		setINISetting fname sec_name "to_vrmesh_root" 					 vrmesh_root 				  
	),
	
	function LoadConfigFromIni fname sec_name =
	(
		local names_array = getINISetting fname sec_name
		local retval = false
		if names_array.count > 0 then
		(
			if (finditem names_array "to_ask_even_if_bmps_are_equal" 	) != 0 do ask_even_if_bmps_are_equal 	= (getINISetting fname sec_name	"to_ask_even_if_bmps_are_equal" 	 ) as BooleanClass
			if (finditem names_array "to_ask_user_when_file_op_fails" 	) != 0 do ask_user_when_file_op_fails  	= (getINISetting fname sec_name	"to_ask_user_when_file_op_fails" 	 ) as BooleanClass
			if (finditem names_array "to_binary_compare_of_non_img" 	) != 0 do binary_compare_of_non_img 	= (getINISetting fname sec_name	"to_binary_compare_of_non_img" 	 	 ) as BooleanClass
			if (finditem names_array "to_ask_even_if_binary_are_equal" 	) != 0 do ask_even_if_binary_are_equal  = (getINISetting fname sec_name	"to_ask_even_if_binary_are_equal" 	 ) as BooleanClass
			if (finditem names_array "to_process_medit_only_content" 	) != 0 do process_medit_only_content 	= (getINISetting fname sec_name	"to_process_medit_only_content" 	 ) as BooleanClass
			if (finditem names_array "to_collect_img_ies" 				) != 0 do collect_img_ies 	 			= (getINISetting fname sec_name	"to_collect_img_ies" 				 ) as BooleanClass
			if (finditem names_array "to_collect_hdri_images" 			) != 0 do collect_hdri_images 	 		= (getINISetting fname sec_name	"to_collect_hdri_images" 			 ) as BooleanClass
			if (finditem names_array "to_collect_vray_meshes" 			) != 0 do collect_vray_meshes 		  	= (getINISetting fname sec_name	"to_collect_vray_meshes" 			 ) as BooleanClass
			if (finditem names_array "to_dont_collect_shaders" 			) != 0 do dont_collect_shaders 		  	= (getINISetting fname sec_name	"to_dont_collect_shaders" 			 ) as BooleanClass
			if (finditem names_array "to_incremental_backups" 			) != 0 do incremental_backups		  	= (getINISetting fname sec_name	"to_incremental_backups" 			 ) as BooleanClass
			if (finditem names_array "to_load_files_when_fix_links"		) != 0 do load_files_when_fix_links	  	= (getINISetting fname sec_name	"to_load_files_when_fix_links"		 ) as BooleanClass
			if (finditem names_array "to_search_texture_instances"		) != 0 do search_texture_instances	  	= (getINISetting fname sec_name	"to_search_texture_instances"		 ) as BooleanClass
			if (finditem names_array "to_process_xref_structure" 		) != 0 do process_xref_structure 	  	= (getINISetting fname sec_name	"to_process_xref_structure" 		 ) as BooleanClass
			if (finditem names_array "to_clear_medit_before_proceed" 	) != 0 do clear_medit_before_proceed  	= (getINISetting fname sec_name	"to_clear_medit_before_proceed" 	 ) as BooleanClass
			if (finditem names_array "to_unused_summary_only" 			) != 0 do unused_summary_only  			= (getINISetting fname sec_name	"to_unused_summary_only" 	 		 ) as BooleanClass
			if (finditem names_array "to_if_image_has_alpha" 			) != 0 do if_image_has_alpha  			= (getINISetting fname sec_name	"to_if_image_has_alpha" 	 	 	 ) as Integer
			if (finditem names_array "to_tga_premultiply_alpha" 		) != 0 do tga_premultiply_alpha  		= (getINISetting fname sec_name	"to_tga_premultiply_alpha" 	 	 	 ) as BooleanClass
			if (finditem names_array "to_jpeg_compression" 				) != 0 do jpeg_compression 			  	= (getINISetting fname sec_name	"to_jpeg_compression" 				 ) as Integer
			if (finditem names_array "to_use_nconvert" 					) != 0 do use_nconvert 			  		= (getINISetting fname sec_name	"to_use_nconvert" 				 	 ) as BooleanClass
			if (finditem names_array "to_img_ies_root" 					) != 0 do img_ies_root 				  	= lowercase (getINISetting fname sec_name	"to_img_ies_root" 		 )
			if (finditem names_array "to_hdri_root" 					) != 0 do hdri_root 				  	= lowercase (getINISetting fname sec_name	"to_hdri_root" 			 )
			if (finditem names_array "to_vrmesh_root" 					) != 0 do vrmesh_root 				  	= lowercase (getINISetting fname sec_name	"to_vrmesh_root" 		 )
			retval = true
		)
		retval
	),
	
	function GetCriticalSaveName =
	(
		((symbolicPaths.getPathValue "$plugcfg") + "\\TOCollectoREX_cac.ini")
	),
	
	function GetDefaultsFileName =
	(
		((symbolicPaths.getPathValue "$plugcfg") + "\\TOCollectoREX_defaults.ini")
	),
	
	function GetCriticalSecName =
	(
		("Tertium Organum CollectoREX Continue After Crash Data")
	),
	
	function GetDefaultsSecName =
	(
		("Tertium Organum CollectoREX Defaults Data")
	),
	
	function CriticalSave files_array operation =
	(
		local fname = GetCriticalSaveName ()
		local sec_name = GetCriticalSecName()
		SaveConfigToIni fname sec_name 
		setINISetting fname sec_name "operation" (operation	as string)
		for i = 1 to files_array.count do
		(
			setINISetting fname sec_name ("file_name_" + i as string) files_array[i]
		)
	),
	
	function HasDefaults =
	(
		local retval = false
		local names_array = getINISetting (GetDefaultsFileName()) (GetDefaultsSecName())
		if names_array.count > 0 then
			retval = true
		retval
	),
	
	function WasCrash =
	(
		local retval = false
		local names_array = getINISetting (GetCriticalSaveName()) (GetCriticalSecName())
		if names_array.count > 0 then
			retval = true
		retval
	),
	
	function CriticalLoad &files_array &operation =
	(
		local retval = false
		ClearToDefaults()
		files_array = #()
		local fname = GetCriticalSaveName ()
		local sec_name = GetCriticalSecName()
		local names_array = getINISetting fname sec_name
		if names_array.count > 0 then
		(
			LoadConfigFromIni fname sec_name
			if (finditem names_array "operation" ) != 0 do operation = (getINISetting fname sec_name "operation" ) as Integer
			for v in names_array do
				if matchpattern v pattern:"file_name_*" do
					append files_array (getINISetting fname sec_name v)
			retval = true	
		)
		retval
	),
	
	function KillCacData =
	(
		local fname = GetCriticalSaveName()
		deleteFile fname 
	),
	
	function SaveDefaults = 
	(
		SaveConfigToIni (GetDefaultsFileName()) (GetDefaultsSecName())
	),
	
	function LoadDefaults = 
	(
		if not ( LoadConfigFromIni (GetDefaultsFileName()) (GetDefaultsSecName()) ) do
			SaveDefaults()
	),
	
	function ClearDefaults = 
	(
		ClearToDefaults()
		SaveDefaults()
	),
	
	function LoadAll =
	(
		ClearToDefaults ()
		local n = 0
		n = fileProperties.findProperty #custom "to_ask_even_if_bmps_are_equal" 	; if n != 0 then ask_even_if_bmps_are_equal 	= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_ask_user_when_file_op_fails" 	; if n != 0 then ask_user_when_file_op_fails  	= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_binary_compare_of_non_img" 		; if n != 0 then binary_compare_of_non_img 		= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_ask_even_if_binary_are_equal"	; if n != 0 then ask_even_if_binary_are_equal 	= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_process_medit_only_content" 	; if n != 0 then process_medit_only_content 	= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_collect_img_ies" 				; if n != 0 then collect_img_ies 				= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_collect_hdri_images" 			; if n != 0 then collect_hdri_images 		 	= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_collect_vray_meshes" 			; if n != 0 then collect_vray_meshes 		 	= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_dont_collect_shaders" 			; if n != 0 then dont_collect_shaders 		 	= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_make_backups" 					; if n != 0 then make_backups 					= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_incremental_backups" 			; if n != 0 then incremental_backups			= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_load_files_when_fix_links"		; if n != 0 then load_files_when_fix_links		= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_search_texture_instances"		; if n != 0 then search_texture_instances		= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_process_xref_structure" 		; if n != 0 then process_xref_structure 		= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_clear_medit_before_proceed" 	; if n != 0 then clear_medit_before_proceed 	= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_unused_summary_only" 			; if n != 0 then unused_summary_only 			= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_ask_if_image_has_alpha" 		; if n != 0 then ask_if_image_has_alpha			= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_tga_premultiply_alpha" 			; if n != 0 then tga_premultiply_alpha			= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_jpeg_compression" 				; if n != 0 then jpeg_compression 				= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_use_nconvert" 					; if n != 0 then use_nconvert 					= fileProperties.getPropertyValue #custom n 
		n = fileProperties.findProperty #custom "to_img_ies_root" 					; if n != 0 then img_ies_root 					= lowercase ( fileProperties.getPropertyValue #custom n )
		n = fileProperties.findProperty #custom "to_hdri_root" 						; if n != 0 then hdri_root 						= lowercase ( fileProperties.getPropertyValue #custom n )
		n = fileProperties.findProperty #custom "to_vrmesh_root" 					; if n != 0 then vrmesh_root 					= lowercase ( fileProperties.getPropertyValue #custom n )
		if n == 0 then
			LoadDefaults()
	)
)

utility ut_main ""
(

	local script_version = "1.0"
	--following vars fill up with recursive_object_lookup
	--previously globals
	local file_owners = #()	-- objects, having images or string props which are seem to be file link
	local file_owners_props = #() -- props of these objects
	local file_owners_paths = #() -- names stacks for finding objects
	local obj_searched = #() -- all objects, being examined on object of having file links
	local total_files_used = #()
	local name_stack = #()

	local config = SConfig()	
	local files_remained = #()
	local interrupted_op = 0
	local cac_result = 0
	local xreftree_result = 0
	local operation_types = #("Collect resources", "Find unused files", "Missing files identify", "JPEG convert", "Relink to resources roots", "Find unused files summary", "Resolve links to existing", "Relink to another disc") 
	local log_postfixes =   #("_collect", 		   "_unused", 			"_missing", 			  "_jpegconv", 	  "_relink",                   "_unused_summary"          , "_resolve",                                    "_redisc") 
	local isopen =	off
	
	local shader_exts = #(".cgfx", ".mi", ".psh", ".vsh", ".fx", ".fxh", ".axml", ".msl")
	
	local show_unused_dlg_every_file = false
	
	--kinda enum EOperationName
	local EON_Collect 	= 1 -- modifies scene, copy files
	local EON_Unused 	= 2 -- readonly, kills/moves files
	local EON_Missing 	= 3 -- readonly, only if "kill" checked - modifies scene
	local EON_Convert 	= 4 -- modifies scene, adds files
	local EON_Relink 	= 5 -- modifies scene
	local EON_UnusedGroup = 6 -- unused files summary
	local EON_Resolve = 7 -- unused files summary
	local EON_Redisc 	= 8 -- change all paths beginning on one drive to another
	
	rollout continue_after_crash_wnd "Continue after crash" width:507 height:462
	(
		local allow_exit = false
		button btn12 "Continue" pos:[450,440] width:50 height:18
		dotNetControl list "System.Windows.Forms.TextBox" pos:[3,34] width:501 height:399
		button btn34 "Abort operation" pos:[368,440] width:79 height:18
		label lbl2 "Operation was interrupted by crash of 3dsmax application. You can choose to continue last operation." pos:[3,2] width:495 height:15
		label lbl3 "Stored parameters see below." pos:[3,17] width:497 height:15
		label lbl6 "Interrupted operation:" pos:[4,442] width:106 height:15
		label lbl7 "" pos:[106,442] width:209 height:15
		button btn5 "Cancel" pos:[319,440] width:46 height:18
		on continue_after_crash_wnd open do
		(
			allow_exit = false
			list.Multiline = true
			list.WordWrap = true
			list.ReadOnly = true
			list.ScrollBars = (dotNetClass "System.Windows.Forms.ScrollBars").Both
			local txt = ""
			local params = config.ToStringArray()
			for i = 1 to params.count do
				txt += params[i] + "\r\n"
			txt += "Files scheduled:\r\n"
			for i = 1 to files_remained.count do
			(
				if i != files_remained.count then
					txt += files_remained[i] + "\r\n"
				else
					txt += files_remained[i]
			)
			list.text = txt
			if interrupted_op > 0 and interrupted_op <= operation_types.count then
				lbl7.caption = operation_types[interrupted_op]
			else
				lbl7.caption = operation_types[1] --unknown, so will be Collect
		)
		on continue_after_crash_wnd okToClose do
			allow_exit
		on btn12 pressed do
		(
			if queryBox "Attention!!!\rDo you really want to CONTINUE interrupted operation?\rIt may take much time, especially if it is 'Collect resources'." then
			(
				cac_result = 1
				allow_exit = true
				DestroyDialog continue_after_crash_wnd
			)
		)
		on btn34 pressed do
		(
			if queryBox "Attention!!!\rDo you really want to ABORT interrupted operation and clear all it's data?\rIf aborted some actions may be incomplete." then
			(
				cac_result = 0
				allow_exit = true
				DestroyDialog continue_after_crash_wnd
			)
		)
		on btn5 pressed do
		(
			cac_result = 2
			allow_exit = true
			DestroyDialog continue_after_crash_wnd
		)
	)
	rollout show_xref_tree_wnd "XRef link tree" width:556 height:269
	(
		local allow_exit = false
		button btn12 "Continue" pos:[490,245] width:61 height:18
		dotNetControl list "System.Windows.Forms.TextBox" pos:[4,17] width:549 height:222
		button btn34 "Continue without XRef tree" pos:[349,245] width:138 height:18
		label lbl2 "This scene have XRef links tree. If you choose to continue all those files will be processed:" pos:[5,2] width:495 height:15
		label lbl6 "Current operation:" pos:[4,246] width:85 height:15
		label lbl7 "" pos:[91,246] width:171 height:15
		button btn7 "Abort operation" pos:[265,245] width:81 height:18
		on show_xref_tree_wnd open do
		(
			allow_exit = false
			list.Multiline = true
			list.WordWrap = true
			list.ReadOnly = true
			list.ScrollBars = (dotNetClass "System.Windows.Forms.ScrollBars").Both
			local txt = ""
			for i = 1 to files_remained.count do
			(
				if i != files_remained.count then
					txt += files_remained[i] + "\r\n"
				else
					txt += files_remained[i]
			)
			list.text = txt
			if interrupted_op > 0 and interrupted_op <= operation_types.count then
				lbl7.caption = operation_types[interrupted_op]
			else
				lbl7.caption = operation_types[1] --unknown, so will be Collect
		)
		on show_xref_tree_wnd okToClose do
			allow_exit
		on btn12 pressed do
		(
			if queryBox "Attention!!!\rDo you really want to CONTINUE operation?\rIt may take much time, especially if it is 'Collect resources'." then
			(
				xreftree_result = 1
				allow_exit = true
				DestroyDialog show_xref_tree_wnd
			)
		)
		on btn34 pressed do
		(
			if queryBox "Attention!!!\rDo you really want to process only current file?\rX-ref'ed files will not be affected." then
			(
				xreftree_result = 2
				allow_exit = true
				DestroyDialog show_xref_tree_wnd
			)
		)
		on btn7 pressed do
		(
			if queryBox "Attention!!!\rDo you really want to ABORT full operation?" then
			(
				xreftree_result = 0
				allow_exit = true
				DestroyDialog show_xref_tree_wnd
			)
		)
	)
	
	rollout convert_dlg "Convert to JPEG/TGA" width:164 height:155
	(
		button btn2 "Convert" pos:[17,111] width:125 height:18
		radiobuttons rdo1 "" pos:[23,20] width:120 height:32 labels:#("ask", "-> JPG ", "skip", "-> TGA ") default:1 columns:2
		checkbox chk27 "premultiplied alpha in TGA" pos:[8,67] width:147 height:16 enabled:true checked:true
		GroupBox grp68 "If image has alpha" pos:[3,3] width:155 height:54
		spinner spn1 "JPEG quality" pos:[17,87] width:133 height:16 range:[50,100,100] type:#integer scale:1 
		checkbox chk2 "use NConvert\xAE if exists" pos:[8,134] width:151 height:16 enabled:true checked:true
		on convert_dlg open do
		(
			config.loadAll()
			config.setAll()
			--CheckButtonsEnability() in onopen of about dialog - it loads last
			try ( callbacks.removescripts #filePostOpen ) catch ()
			callbacks.addScript	#filePostOpen "ut_main.config.loadAll(); ut_main.config.setAll(); ut_main.CheckButtonsEnability(); ut_main.config.getAll(); ut_main.config.saveAll() " 	
		)
		on btn2 pressed do
		(
			ProcessOperation EON_Convert
		)
		on rdo1 changed v do
		(
			config.GetAll()
			config.saveAll()
		)
		on chk27 changed v do
		(
			config.GetAll()
			config.saveAll()
		)
		on spn1 changed v do
		(
			config.GetAll()
			config.saveAll()
		)
		on chk2 changed v do
		(
			config.GetAll()
			config.saveAll()
		)
	)
	
	rollout about_dlg "Help & config" width:164 height:155
	(
		label lbl9 "Tertium Organum ® 2008-2019" pos:[18,137] width:123 height:16
		button btn31 "About" pos:[17,93] width:125 height:18 enabled:true
		GroupBox grp7 "Config" pos:[8,3] width:144 height:85
		button btn12 "Save config as defaults" pos:[17,20] width:125 height:18
		button btn13 "Load config from defaults" pos:[17,42] width:125 height:18
		button btn14 "Clear defaults" pos:[17,64] width:125 height:18 enabled:true
		--button btn5 "License search/request" pos:[17,115] width:125 height:18
		on about_dlg open do
		(
			ut_main.CheckButtonsEnability()		
		)
		on btn31 pressed do
		(
			local fname = (symbolicPaths.getPathValue "$scripts") + "\\collectorex\\about.html"
			ShellLaunch fname ""
		)
		on btn12 pressed do
		(
			if queryBox "Do you want to save current config as defaults? Defaults data (if exists) will be lost." then
			(
				config.GetAll()
				config.saveAll()
				config.SaveDefaults()
			)
		)
		on btn13 pressed do
		(
			if queryBox "Do you want to replace current config with defaults? Current config will be lost." then
			(
				config.LoadDefaults()
				config.setAll()
				ut_main.CheckButtonsEnability()				
			)
		)
		on btn14 pressed do
		(
			if queryBox "Do you want to clear config defaults? Defaults data (if exists) will be lost." then
				config.ClearDefaults()
		)
		on btn5 pressed  do
		(
			if not (ut_utility.FindAndLoadLicenseFile()) then
			(
				ut_main.main_wnd.title  = "TO CollectoREX DEMO"
				createdialog ut_utility.dlg width:269 height:136
			)
			else
			(
				ut_main.main_wnd.title  = "TO CollectoREX"
				MessageBox "License has been founded and successfully installed!\rThank you for purchasing!" caption:"License search/request"
			)	
			ut_main.CheckButtonsEnability()
		)
	)

	rollout main_wnd "TO CollectoREX" width:160 height:719
	(
		button btn12 "Collect resources" pos:[17,554] width:125 height:18
		button btn14 "Unused" pos:[17,577] width:45 height:18
		checkbox chk1 "ask even if bmps are equal" pos:[6,20] width:147 height:16
		button btn15 "Missing files identify" pos:[17,673] width:100 height:18 enabled:true
		checkbox chk22 "ask user when file op fails" pos:[6,131] width:147 height:16 checked:true
		checkbox chk8 "ask even if binary are equal" pos:[6,55] width:150 height:16
		checkbox chk9 "non-img full compare (slow!)" pos:[6,38] width:148 height:16 checked:false
		checkbox chk10 "VRay meshes" pos:[15,516] width:98 height:16 checked:true
		checkbox chk11 "Images && ph.webs" pos:[15,484] width:130 height:16 enabled:true checked:true
		checkbox chk13 "make back-ups" pos:[6,96] width:147 height:16 enabled:true checked:true
		checkbox chk14 "HDR images" pos:[15,500] width:91 height:16 checked:true
		GroupBox grp1 "Affect:" pos:[3,469] width:154 height:66
		checkbox chk16 "process XRef structure" pos:[6,203] width:148 height:16 checked:true
		button btn141 "Relink to roots" pos:[17,600] width:82 height:18
		button btn101 "Re-disc" pos:[17,622] width:45 height:18
		dropDownList ddl1 "" pos:[64,621] width:31 height:21 items:#("c", "d", "e", "f", "g", "h", "i", "j", "k")
		dropDownList ddl2 "" pos:[116,621] width:32 height:21 items:#("c", "d", "e", "f", "g", "h", "i", "j", "k")
		label lbl13 "->" pos:[100,625] width:16 height:11
		button btn151 "Continue op after crash" pos:[17,695] width:125 height:18 enabled:false
		button btn16 "..." pos:[135,289] width:19 height:16
		checkbox chk77 "clear medit before proceed" pos:[6,221] width:150 height:16 checked:true
		checkbox chk121 "process medit-only content" pos:[6,185] width:150 height:16 enabled:true
		dotNetControl edt4 "System.Windows.Forms.TextBox" pos:[6,307] width:148 height:38 
 
 
		GroupBox grp7 "Files with same names" pos:[3,4] width:154 height:74
		GroupBox grp8 "Security" pos:[3,80] width:154 height:88
		GroupBox grp9 "Content" pos:[3,170] width:154 height:106
		label lbl6 "Images && ph.web root " pos:[6,290] width:108 height:14
		button btn29 "..." pos:[136,348] width:17 height:16
		dotNetControl cust6 "System.Windows.Forms.TextBox" pos:[6,366] width:148 height:38
		label lbl7 "HDRI root " pos:[6,349] width:100 height:14
		button btn30 "..." pos:[135,407] width:18 height:16
		dotNetControl cust7 "System.Windows.Forms.TextBox" pos:[6,425] width:148 height:38
		label lbl8 "VRay meshes root " pos:[6,408] width:100 height:14
		GroupBox grp28 "Resource roots related" pos:[3,537] width:154 height:110
		checkbox chk12 "summary only" pos:[66,579] width:84 height:15 checked:true
		button btn10 "Resolve links to existing" pos:[17,652] width:125 height:18
		checkbox chk25 "ignore shaders" pos:[6,239] width:150 height:16 checked:true
		GroupBox grp11 "Collect roots" pos:[3,276] width:154 height:193
		checkbox chk26 "reload while fix links (slow!)" pos:[6,149] width:147 height:16 checked:false
		checkbox chk27 "scan all tex instances also" pos:[6,257] width:150 height:16 checked:false
		checkbox chk28 "incremental back-ups" pos:[12,113] width:124 height:16 enabled:true checked:true
		checkbutton ckb1 "kill" pos:[120,674] width:22 height:18
		on main_wnd open do
		(
			isOpen = on
			ckb1.checked = false;
			edt4.Multiline = true
			edt4.WordWrap = false
			edt4.ReadOnly = true
			edt4.ScrollBars = (dotNetClass "System.Windows.Forms.ScrollBars").Horizontal
			cust6.Multiline = true
			cust6.WordWrap = false
			cust6.ReadOnly = true
			cust6.ScrollBars = (dotNetClass "System.Windows.Forms.ScrollBars").Horizontal
			cust7.Multiline = true
			cust7.WordWrap = false
			cust7.ReadOnly = true
			cust7.ScrollBars = (dotNetClass "System.Windows.Forms.ScrollBars").Horizontal
			--converter rollout loads after it so init there
			--ut_utility.Init() --FREEE
			/*if not (ut_utility.FindAndLoadLicenseFile()) then
			(
				ut_main.main_wnd.title  = "TO CollectoREX DEMO"
				createdialog ut_utility.dlg width:269 height:136
			)
			else
			(
				ut_main.main_wnd.title  = "TO CollectoREX"
			)*/
			
			ut_main.main_wnd.title  = "TO CollectoREX"
		)
		on main_wnd close do
		(
			try ( callbacks.removescripts #filePostOpen ) catch ()
			isOpen = off
		)
		on btn12 pressed do
		(
			ProcessOperation EON_Collect
		)
		on btn14 pressed do
		(
			ProcessOperation EON_Unused
		)
		on chk1 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
		on btn15 pressed do
		(
			ProcessOperation EON_Missing
		)
		on chk22 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
		on chk8 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
		on chk9 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
		on chk10 changed state do
		(
			ut_main.CheckButtonsEnability()
			config.GetAll()
			config.saveAll()
		)
		on chk11 changed state do
		(
			ut_main.CheckButtonsEnability()
			config.GetAll()
			config.saveAll()
		)
		on chk13 changed state do
		(
			ut_main.CheckButtonsEnability()
			config.GetAll()
			config.saveAll()
		)
		on chk14 changed state do
		(
			ut_main.CheckButtonsEnability()
			config.GetAll()
			config.saveAll()
		)
		on chk16 changed state do
		(
			ut_main.CheckButtonsEnability()
			config.GetAll()
			config.saveAll()
		)
		on btn141 pressed do
		(
			ProcessOperation EON_Relink
		)
		
		on btn101 pressed do
		(
			ProcessOperation EON_Redisc
		)
		
		on btn151 pressed do
		(
			--continue after crash
			local was_crash = config.CriticalLoad &files_remained &interrupted_op
			if was_crash do
			(
				local img_ies_ok = true
				local hdri_ok = true
				local vrmesh_ok = true
				if config.img_ies_root == "" or not (doesfileexist config.img_ies_root) then
					img_ies_ok = false
				if config.hdri_root == "" or not (doesfileexist config.hdri_root) then
					hdri_ok = false
				if config.vrmesh_root == "" or not (doesfileexist config.vrmesh_root) then
					vrmesh_ok = false
				if not img_ies_ok and not hdri_ok and not vrmesh_ok then
				(
					messagebox ( "All resources roots are invalid. Try to edit\r" + config.GetCriticalSaveName() + "\rIf you delete it 'Continue after crash' becomes unavailable.")  title:"Error" 
				)
				else
				(
					CreateDialog continue_after_crash_wnd width:507 height:462 modal:true
					if cac_result == 1 then
						ContinueAfterCrash interrupted_op
					if cac_result == 0 then 
					(
						config.KillCacData ()
						ut_main.CheckButtonsEnability()
					)
				)
			)
		)
		on btn16 pressed do
		(
			local prev_param = config.img_ies_root
			if prev_param == "" do
				prev_param = maxfilepath
			if not (doesfileexist prev_param) do
				prev_param = maxfilepath
			local v = getSavePath caption:"Select images and ph.webs root folder" initialDir:prev_param
			if v != undefined and doesfileexist v then
			(
				edt4.text = lowercase v
				chk11.checked = true
				cust6.text = lowercase v
				chk14.checked = true
				cust7.text = lowercase v
				chk10.checked = true
				config.GetAll()
				ut_main.CheckButtonsEnability ()
				config.GetAll()
				config.saveAll()
			)
		)
		on chk77 changed state do
		(
			ut_main.CheckButtonsEnability ()
			config.GetAll()
			config.saveAll()
		)
		on chk121 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
		on btn29 pressed do
		(
			local prev_param = config.hdri_root
			if prev_param == "" do
				prev_param = maxfilepath
			if not (doesfileexist prev_param) do
				prev_param = maxfilepath
			local v = getSavePath caption:"Select HDRI root folder" initialDir:prev_param
			if v != undefined and doesfileexist v then
			(
				cust6.text = lowercase v
				chk14.checked = true
				config.GetAll()
				ut_main.CheckButtonsEnability()
				config.GetAll()
				config.saveAll()
			)
		)
		on btn30 pressed do
		(
			local prev_param = config.vrmesh_root
			if prev_param == "" do
				prev_param = maxfilepath
			if not (doesfileexist prev_param) do
				prev_param = maxfilepath
			local v = getSavePath caption:"Select VRay meshes root folder" initialDir:prev_param
			if v != undefined and doesfileexist v then
			(
				cust7.text = lowercase  v
				chk10.checked = true
				config.GetAll()
				ut_main.CheckButtonsEnability ()
				config.GetAll()
				config.saveAll()
			)
		)
		on chk12 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
		on btn10 pressed do
		(
			ProcessOperation EON_Resolve
		)
		on chk25 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
		on chk26 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
		on chk27 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
		on chk28 changed state do
		(
			config.GetAll()
			config.saveAll()
		)
	)
	
	function CheckButtonsEnability =
	(
		local img_ies_ok = false
		local hdri_ok = false
		local vrmesh_ok = false
		
		if config.img_ies_root != "" and doesfileexist config.img_ies_root do
			img_ies_ok = true
		if config.hdri_root != "" and doesfileexist config.hdri_root do
			hdri_ok = true
		if config.vrmesh_root != "" and doesfileexist config.vrmesh_root do
			vrmesh_ok = true
		
		if not img_ies_ok do
			main_wnd.edt4.text = ""
		if not hdri_ok do
			main_wnd.cust6.text = ""
		if not vrmesh_ok do
			main_wnd.cust7.text = ""
		
		main_wnd.chk11.enabled = img_ies_ok
		if not img_ies_ok do
			main_wnd.chk11.checked = false
		main_wnd.chk14.enabled = hdri_ok
		if not hdri_ok do
			main_wnd.chk14.checked = false
		main_wnd.chk10.enabled = vrmesh_ok
		if not vrmesh_ok do
			main_wnd.chk10.checked = false

		if main_wnd.chk77.checked then
		(
			main_wnd.chk121.checked = false
			main_wnd.chk121.enabled = false
		)
		else
			main_wnd.chk121.enabled = true
		
		main_wnd.btn12.enabled =  (main_wnd.chk11.checked or main_wnd.chk14.checked or main_wnd.chk10.checked)
		main_wnd.btn14.enabled =  (main_wnd.chk11.checked or main_wnd.chk14.checked or main_wnd.chk10.checked)
		main_wnd.btn141.enabled = (main_wnd.chk11.checked or main_wnd.chk14.checked or main_wnd.chk10.checked)
		main_wnd.chk12.enabled =  (main_wnd.chk11.checked or main_wnd.chk14.checked or main_wnd.chk10.checked) and main_wnd.chk16.checked
		
		main_wnd.chk28.enabled = main_wnd.chk13.checked
		
		main_wnd.btn151.enabled = config.WasCrash()
		
		--about_dlg.btn5.enabled = not (ut_utility.IsLicenseOk())
	)
)