
--add_all: if false - do not add "no_parameter"'s values: for jpgconvert
function add_files num array_old exts add_all: true = 
(
	if num <= ut_main.file_owners_props.count do
	(
		for i = 1 to ut_main.file_owners_props[num].count do
		(
			local add = true
			-- if img excl and exts.empty =>  impossible!; img incl and exts.empty => all allowed
			if exts.count > 0 do 
			(
				local ext = getFilenameType ut_main.file_owners_props[num][i].param_value
				if ut_main.config.collect_img_ies then
				(
					if (finditem exts ext) != 0 do --exclude if images included (if found in filter -> don't add)
						add = false
				)	
				else
				(
					if (finditem exts ext) == 0 do --include if images excluded (if not found in filter -> don't add)
						add = false
				)
			)
			if ut_main.config.dont_collect_shaders then
				if (finditem ut_main.shader_exts ext) != 0 then
					add = false
			if not add_all and ut_main.file_owners_props[num][i].param_name == "no_parameter" do
				add = false
			if add do
			(	
				local v = ut_main.file_owners_props[num][i].param_value		
				if v != "" and (findItem array_old v) == 0 do 
					append array_old v
			)
		)
	)
)

function add_only_img_files num array_old = 
(
	local filter_exts = #(".tif", ".tiff", ".psd", ".png", ".tga", ".bmp")

	if num <= ut_main.file_owners_props.count do
	(
		for i = 1 to ut_main.file_owners_props[num].count do
		(
			local add = true
			local ext = getFilenameType ut_main.file_owners_props[num][i].param_value
			if (finditem filter_exts ext) == 0 do 
				add = false
			if (not add) and (finditem ut_main.shader_exts ext) != 0 then
				add = false
			if (not add) and ut_main.file_owners_props[num][i].param_name == "no_parameter" do
				add = false
			if add do
			(	
				local v = ut_main.file_owners_props[num][i].param_value		
				if v != "" and (findItem array_old v) == 0 do 
					append array_old v
			)
		)
	)
)

function resolveRealNames array_old array_new =
(
	local res = true
	local progress_count = array_old.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Resolving filenames"

	for i = 1 to array_old.count do
	(
		n = mapPaths.getFullFilePath array_old[i]
		if doesFileExist n then
			append array_new (lowercase n)
		else
			append array_new "missing"		
		if not (progressUpdate (progress_curval += progress_increment) ) do
		(
			res = false
			progressEnd ()
			exit 
		)
	)
	progressEnd ()
	progressUpdate 0
	res
)

function compareFN v1 v2 =
(
	stricmp v1 v2
)

function addFilesAccordingToFilter array_old add_all:true = 
(
	local ext_filter = #()
	if ut_main.config.collect_img_ies then
	(
		if ut_main.config.collect_hdri_images == false do
		(
			append ext_filter ".hdri"
			append ext_filter ".hdr"
		)
		if ut_main.config.collect_vray_meshes == false do
		(
			append ext_filter ".vrmesh"
		)
	)
	else
	(
		if ut_main.config.collect_hdri_images == true do
		(
			append ext_filter ".hdri"
			append ext_filter ".hdr"
		)
		if ut_main.config.collect_vray_meshes == true do
		(
			append ext_filter ".vrmesh"
		)
	)
	local res = true
	local progress_count = ut_main.file_owners.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Getting filenames"
	
	for i = 1 to ut_main.file_owners.count do
	(
		add_files i array_old ext_filter add_all: add_all	
		if not (progressUpdate (progress_curval += progress_increment) ) do
		(
			res = false
			progressEnd ()
			exit 
		)
	)
	qsort array_old compareFN 
	progressEnd ()
	progressUpdate 0
	res
)

function addImageFilesForConvert array_old = 
(
	local res = true
	local progress_count = ut_main.file_owners.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Getting filenames"
	
	for i = 1 to ut_main.file_owners.count do
	(
		add_only_img_files i array_old 
		if not (progressUpdate (progress_curval += progress_increment) ) do
		(
			res = false
			progressEnd ()
			exit 
		)
	)
	qsort array_old compareFN 
	progressEnd ()
	progressUpdate 0
	res
)

function printResolvedFilesMap array_old array_new =
(
	if array_old.count == array_new.count then
	(
		format "\n*************Resolved File Names*************\n"
		format "**Stored Path -> Resolved path**\n"
		for i = 1 to array_old.count do
		(
			format "% -> %\n" array_old[i] array_new[i]
		)
		format "*********************************************\n\n"
	)	
)

function printConvertedFilesMap array_old array_new =
(
	if array_old.count == array_new.count then
	(
		format "\n*************Converted File Names*************\n"
		format "**Stored Path -> Resolved path**\n"
		for i = 1 to array_old.count do
		(
			if array_old[i] != "missing" and array_new[i] != "missing" then
				format "% -> %\n" array_old[i] array_new[i]
		)
		format "*********************************************\n\n"
	)	
)

function check_and_log_missing_files old_arr new_arr =
(
	for i = 1 to ut_main.file_owners.count do
	(
		for j = 1 to ut_main.file_owners_props[i].count do 
		(
			if ut_main.file_owners_props[i][j].param_value != "" do
			(
				n = findItem old_arr ut_main.file_owners_props[i][j].param_value
				if n != 0 then
				(
					if new_arr[n] == "missing" then 
					(
						p_name = ""
						if ut_main.file_owners_props[i][j].param_index == 0 then
							p_name = ut_main.file_owners_props[i][j].param_name as string
						else
							p_name = (ut_main.file_owners_props[i][j].param_name as string) + "[" + (ut_main.file_owners_props[i][j].param_index as string) + "]"
						format "WARNING: File is missing!\n Full tree for parameter '%' = '%':\n%\n" p_name ut_main.file_owners_props[i][j].param_value (get_full_obj_tree i)
					)
				)
			)
		)
	)
)

function collect_files collection  =
(
	ut_utility.arg_collect_files_collection = collection
	local enc_ok = false
	local res = false
	local func = ut_utility.GetCollectFunc()
	if func != "" do
	(
		try
		(
			res = execute func
			enc_ok = true
		)
		catch
		(
			enc_ok = false
		)
	)
	ut_utility.arg_collect_files_collection = undefined
	if not enc_ok do
	(
		res = collect_files_ collection
	)
	res
)

-- array with new names (not processed yet), abs path of collected folder
-- if vraymesh - using its root; if hdri - using its root; else using img_ies root
-- in this func can not be files forbidden
function collect_files_ collection =
(
	Messagebox "***This is only DEMO version, so script will copy not every file, but some***\n" caption:"DEMO warning"
	local progress_count = collection.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Files processing"
	
	local res = true
	local demo_num = random 3 6
	for i = 1 to collection.count do
	(
		if ( (mod i demo_num) as integer) == 0 then
		(
			local abs_path = ""
			local ext = getfilenameType collection[i]
			if ext == ".vrmesh" then
				abs_path = ut_main.config.vrmesh_root + "\\"
			else
			(
				if ext == ".hdri" or ext == ".hdr" then
					abs_path = ut_main.config.hdri_root + "\\"
				else
					abs_path = ut_main.config.img_ies_root + "\\"
			)
			if abs_path != "" do
				res = collect_file collection i abs_path
		)
		else
			format "DEMO LIMITATION: not collecting: '%'\n" collection[i]
		if not (progressUpdate (progress_curval += progress_increment) ) or not res do
		(
			res = false
			progressEnd ()
			exit 
		)
	)	
	
	progressEnd ()
	progressUpdate 0	
	res
)

function fix_objects_links old_arr new_arr  =
(
	ut_utility.arg_fix_objects_links_old_arr = old_arr
	ut_utility.arg_fix_objects_links_new_arr = new_arr
	local enc_ok = false
	local res = false
	local func = ut_utility.GetFixFunc()
	if func != "" do
	(
		try
		(
			res = execute func
			enc_ok = true
		)
		catch
		(
			enc_ok = false
		)
	)
	ut_utility.arg_fix_objects_links_old_arr = undefined
	ut_utility.arg_fix_objects_links_new_arr = undefined
	if not enc_ok do
	(
		res = fix_objects_links_ old_arr new_arr 
	)
	res
)

function fix_objects_links_ old_arr new_arr  =
(
	Messagebox "***This is only DEMO version, so script will not fix any file links***\n" caption:"DEMO warning"
	local progress_count = ut_main.file_owners.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Fixing file links"
	
	local res = true
	for i = 1 to ut_main.file_owners.count do
	(
		fix_object_links_ i old_arr new_arr 
		if not (progressUpdate (progress_curval += progress_increment) ) do
		(
			res = false
			progressEnd ()
			exit 
		)
	)	
	
	progressEnd ()
	progressUpdate 0
	res
)

function fix_object_links_ i old_arr new_arr  =
(					
	local full_obj_tree = ""
	local was_prop_processed = false
	for j = 1 to ut_main.file_owners_props[i].count do
	(
		local bim = undefined
		local param = undefined
		local e_text = ""
		local e_text1 = ""
		
		if full_obj_tree == "" do 
			full_obj_tree = get_full_obj_tree i
		local n = findItem old_arr ut_main.file_owners_props[i][j].param_value
		if n != 0 then
		(
			if new_arr[n] != "missing" and new_arr[n] != old_arr[n] then 
			(
				local p_name = ""
				if ut_main.file_owners_props[i][j].param_index == 0 then
					p_name = ut_main.file_owners_props[i][j].param_name as string
				else
					p_name = (ut_main.file_owners_props[i][j].param_name as string) + "[" + (ut_main.file_owners_props[i][j].param_index as string) + "]"
				format ">>>Object changed:\n%\tParameter '%': '%' -> '%'\n" full_obj_tree p_name ut_main.file_owners_props[i][j].param_value new_arr[n]

				was_prop_processed = true
				if  ut_main.file_owners_props[i][j].param_name == "no_parameter" then
				(
					format "NOTE: This link can not be fixed as it is additional virtual paramater. It related to file somehow connected to object except via object property, for example using image file list (IFL)\n"
				)
				else
				(
					format "NOTE: This link can be fixed but in DEMO version it is unavailable\n"
				)
			)
		)						
	)
	if was_prop_processed do
		format "\n\n"
)

function _fix_object_links i old_arr new_arr func =
(
	ut_utility.arg_fix_objects_links_old_arr = old_arr
	ut_utility.arg_fix_objects_links_new_arr = new_arr
	ut_utility.arg_fix_object_links_i = i
	local enc_ok = false
	local res = false
	if func != "" do
	(
		try
		(
			res = execute func
			enc_ok = true
		)
		catch
		(
			enc_ok = false
		)
	)
	ut_utility.arg_fix_objects_links_old_arr = undefined
	ut_utility.arg_fix_objects_links_new_arr = undefined
	ut_utility.arg_fix_object_links_i = 0	
	if not enc_ok do
	(
		format "Error: enc_ok == false! "
		res = fix_object_links_ i old_arr new_arr 
	)
	res
)

--joins all files from selected folders to array
function get_existing_file_names_according_to_filter arr =
(
	local paths = #()
	if ut_main.config.collect_img_ies and ut_main.config.img_ies_root != "" and doesfileexist ut_main.config.img_ies_root do
		append paths ut_main.config.img_ies_root
	if ut_main.config.collect_hdri_images and ut_main.config.hdri_root != "" and doesfileexist ut_main.config.hdri_root do
		if (finditem paths ut_main.config.hdri_root) == 0 do
			append paths ut_main.config.hdri_root
	if ut_main.config.collect_vray_meshes and ut_main.config.vrmesh_root != "" and doesfileexist ut_main.config.vrmesh_root do
		if (finditem paths ut_main.config.vrmesh_root) == 0 do
			append paths ut_main.config.vrmesh_root
	for p in paths do
		join arr (for f in (getFiles (p + "\\*.*")) collect lowercase f)
)

function get_unused_only_files found_files scene_files unused_files =
(
	local res = true
	local progress_count = found_files.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Search unused files"

	for i = 1 to found_files.count do
	(
		if (finditem scene_files found_files[i]) == 0 do
			append unused_files found_files[i]
		if not (progressUpdate (progress_curval += progress_increment) ) do
		(
			res = false
			progressEnd ()
			exit 
		)
	)
	progressEnd ()
	progressUpdate 0
	res
)

function relink_files array_old array_new =
(
	local res = true
	local progress_count = array_old.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Trying to relink"

	for i = 1 to array_old.count do
	(
		local collect_path = ""
		local ext = getFilenameType array_old[i]	
		if ext == ".vrmesh" then
			collect_path = ut_main.config.vrmesh_root
		else
		(
			if ext == ".hdri" or ext == ".hdr" then				
				collect_path = ut_main.config.hdri_root
			else
				collect_path = ut_main.config.img_ies_root
		)
		if collect_path != "" do 
		(
			local new_name = collect_path + "\\" + (filenameFromPath array_old[i])	
			if doesFileExist new_name then
				append array_new new_name
			else
				append array_new "missing"		
		)
		if not (progressUpdate (progress_curval += progress_increment) ) do
		(
			res = false
			progressEnd ()
			exit 
		)
		
	)
	progressEnd ()
	progressUpdate 0
	res
)

function redisc_files array_old array_new =
(
	local res = true
	local progress_count = array_old.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Trying to redisc"
	
	local d1 = ut_main.main_wnd.ddl1.items[ut_main.main_wnd.ddl1.selection]
	local d2 = ut_main.main_wnd.ddl2.items[ut_main.main_wnd.ddl2.selection]

	for i = 1 to array_old.count do
	(
		local new_name = copy array_old[i]

		if array_old[i] != "" and array_old[i][1] == d1 and array_old[i][2] == ":" do 
			new_name[1] = d2

		if doesFileExist new_name then
			append array_new new_name
		else
			append array_new "missing"		
		
		if not (progressUpdate (progress_curval += progress_increment) ) do
		(
			res = false
			progressEnd ()
			exit 
		)
		
	)
	progressEnd ()
	progressUpdate 0
	res
)

function all_missings_clear array_old array_new =
(
	local progress_count = ut_main.file_owners.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Clearing missing file links"
	format "*********Clearing missing file links*********\n\n"
	local res = true
	for i = 1 to ut_main.file_owners.count do
	(
		clear_missings i array_old array_new
		if not (progressUpdate (progress_curval += progress_increment) ) do
		(
			res = false
			progressEnd ()
			exit 
		)
	)	
	
	progressEnd ()
	progressUpdate 0
	res
)

function clear_missings i old_arr new_arr =
(
	local full_obj_tree = ""
	local was_prop_processed = false
	for j = 1 to ut_main.file_owners_props[i].count do
	(
		local bim = undefined
		local param = undefined
		local e_text = ""
		local e_text1 = ""
		if full_obj_tree == "" do 
			full_obj_tree = get_full_obj_tree i
		local n = findItem old_arr ut_main.file_owners_props[i][j].param_value
		if n != 0 then
		(
			if new_arr[n] == "missing" then
			(
				local p_name = ""
				if ut_main.file_owners_props[i][j].param_index == 0 then
					p_name = ut_main.file_owners_props[i][j].param_name as string
				else
					p_name = (ut_main.file_owners_props[i][j].param_name as string) + "[" + (ut_main.file_owners_props[i][j].param_index as string) + "]"
				format "\n>>>Object changed:\n%\tParameter '%': '%' -> '%'\n" full_obj_tree p_name ut_main.file_owners_props[i][j].param_value new_arr[n]

				was_prop_processed = true
				if  ut_main.file_owners_props[i][j].param_name == "no_parameter" then
				(
					format "NOTE: This link can not be cleared as it is additional virtual paramater. It related to file somehow connected to object except via object property, for example using image file list (IFL)\n"
				)
				else
				(
					param = undefined
					e_text = ""
					try
					(
						param = getProperty ut_main.file_owners[i] ut_main.file_owners_props[i][j].param_name
					)
					catch 
					(
						e_text = getCurrentException()
					)
					if ut_main.file_owners_props[i][j].param_index == 0 then
					(
						if param != undefined then
						(
							if classof param == String then
								setProperty ut_main.file_owners[i] ut_main.file_owners_props[i][j].param_name ""
							else
							(
								if classof param == Bitmap then
								(
									try
									(
										setProperty ut_main.file_owners[i] ut_main.file_owners_props[i][j].param_name undefined
									)
									catch
									(
										e_text1 = getCurrentException()
										format "Exception while setting property: %\n" e_text1
									)
								)													
							)
						)
						else
						(
							format "WARNING: script can not access parameter (Exception: %). Trying to treat it as bitmap...\n" e_text
							try
							(
								setProperty ut_main.file_owners[i] ut_main.file_owners_props[i][j].param_name undefined
							)
							catch 
							( 
								e_text1 = getCurrentException()
								format "Exception while setting property: %\n" e_text1
							)
						)
					)
					else
					(
						if param != undefined then 
						(
							if param[ ut_main.file_owners_props[i][j].param_index ] != undefined then
							(
								if classof param[ ut_main.file_owners_props[i][j].param_index ] == String then
									param[ut_main.file_owners_props[i][j].param_index] = ""
								else
								(
									if classof param[ ut_main.file_owners_props[i][j].param_index ] == Bitmap then
									(
										try
										(
											param[ut_main.file_owners_props[i][j].param_index].filename = ""
										)
										catch
										(
											e_text1 = getCurrentException()
											format "Exception while setting property: %\n" e_text1
										)
									)													
								)
							)
							else
							(
								format "WARNING: script can not access parameter (Exception: %).\n    Trying to treat it as bitmap...\n" e_text
								try
								(
									param[ut_main.file_owners_props[i][j].param_index] = undefined
								)
								catch 
								(
									e_text1	= getCurrentException()														
									format "Exception while setting property: %\n" e_text1 
								)
							)
						)
						else
						(
							format "ERROR: script can not access parameter (Exception: %). Parameter of Array type expected - skipping\n" e_text 
						)
					)
				)
			)
		)						
	)
	
	if was_prop_processed do
		format "\n\n"
)

function ConvertFilesToJPEG files_array  =
(
	ut_utility.arg_ConvertFilesToJPEG_files_array = files_array	
	local enc_ok = false
	local res = false
	local func = ut_utility.GetJpgFunc()
	if func != "" do
	(
		try
		(
			res = execute func
			enc_ok = true
		)
		catch
		(
			enc_ok = false
		)
	)
	ut_utility.arg_ConvertFilesToJPEG_files_array = undefined
	if not enc_ok do
	(
		res = ConvertFilesToJPEG_ files_array
	)
	res
)

function ConvertFilesToJPEG_ files_array =
(	
	MessageBox "***This is only DEMO version, so script will convert not every file, but some***\n" caption:"DEMO warning"
	local res = true
	local bmps_num = 0
	local bmp_exts = #(".tif", ".tiff", ".psd", ".png", ".tga", ".bmp");
	for i = 1 to files_array.count do
	( 
		local ext = getFilenameType files_array[i]	
		if (finditem bmp_exts ext) != 0 do
			bmps_num += 1
	)
	
	local progress_count = bmps_num
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart "Converting to JPEG/TGA"
	local demo_num = random 3 6
	for n = 1 to files_array.count do
	(
			local ext = getFilenameType files_array[n]	
			if (finditem bmp_exts ext) != 0 do
			(
				if ( (mod n demo_num) as integer) == 0 then
				(		
					local old_name =  files_array[n] 
					local new_name = convertToJpegOrTga files_array[n]
					if new_name != files_array[n] then
					(		
						files_array[n] = new_name
						format "Converting: '%' -> '%'\n" old_name new_name
					)
					else			
						files_array[n] = "missing" --ONLY for JPGCONVERT: fix_objects_links will skip not converted 
				)
				else
					format "DEMO LIMITATION: not converting: '%' -> JPEG/TGA\n" files_array[n] 
				if not (progressUpdate (progress_curval += progress_increment) ) do
				(
					res = false
					progressEnd ()
					exit 
				)
			)
	)
	progressEnd ()
	progressUpdate 0
	res
)

function BackupCurrentFileIfNeeded = 
(
	local res = true
	if ut_main.config.make_backups then
	(
		if not ( MakeFileBackup (maxfilepath + maxfilename) ) then
		(
			if queryBox ("Can not backup file\r" + (maxfilepath + maxfilename) + "\rIt may be due insufficient disk space. Continue without backup?") then
			(
				format "WARNING: user decided to continue without backup\n"
			)
			else
			(
				format "WARNING: user decided to not proceed without backup\n"
				res = false
			)
		)
	)
	res
)

function MakeFileBackup fname = 
(
	local res = false
	if doesfileexist fname then
	(
		escapeEnable = false
		progressStart "Backing up"
		local backup_name = "" 
		if ut_main.config.incremental_backups then
			backup_name = (getFilenamePath fname) + (create_new_backup_name (getFilenamePath fname) fname )
		else
		(
			backup_name = (getFilenamePath fname) + (getFilenameFile fname) + (getFilenameType fname) + ".backup"	
			if (doesfileexist backup_name) do
				deletefile backup_name
		)
		res = copyfile fname backup_name
		if not res then
			format "ERROR: can not backup file '%'\n" fname
		else
			format "File '%' successfully backed up to '%'\n" fname backup_name
		progressUpdate 100
		progressEnd ()
		progressUpdate 0
	)
	else
		format "ERROR: backing up file '%' doesn't exist\n" fname
	res
)

function ClearMaterialEditorIfNeeded = 
(
	if ut_main.config.clear_medit_before_proceed do
	(
		undo off 
		(					
			with redraw off 
			(		
				for i in 1 to meditMaterials.count do
					meditMaterials[i] = StandardMaterial name:("Standard_" + i as string)
			)
		)
	)
)