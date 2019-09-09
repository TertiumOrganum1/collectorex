--different utils
Struct tree_node ( obj, children )
Struct param_info (param_name, param_type, param_index, param_value) -- type: "string", "bitmap" or "undefined" (if exception occuped. Assume "bitmap" though!)
--if param_name is "no_parameter" - it is bitmap, which is no need to be fixed in links (maybe ifl pointed file)
-------------------------------------------------------------------

function lowercase instring = 
( 
	if ((maxVersion())[1]) < 10000 then
	(
		(DotNetObject "System.String" instring).Tolower()
	)
	else
	(
		toLower instring
	)
)

-------------------------------------------------------------------

--utility func, used by getOnlyMeditEntities
function recursive_entity_search o arr = 
(
	if (finditem arr o) == 0 do
	(
		append arr o
		if iskindof o Material do
		(
			if not (iskindof o TextureMap) then
			(
				--submats
				local num = getNumSubMtls o 
				for i = 1 to num do
				(
					local v = getSubMtl o i
					if undefined != v then	
						recursive_entity_search v arr	
				)
					
			)
			local tex_num = getNumSubTexmaps o
			for i = 1 to tex_num do
			(
				local tex = getSubTexmap o i
				if undefined != tex  then	
					recursive_entity_search tex	arr
			)		
		)
	)
)

--get list of objects, that is only in mateditor
function getOnlyMeditEntities =
(
	local medit_ents = #()
	local scene_ents = #()
	for m in sceneMaterials do
		recursive_entity_search m scene_ents
	for m in meditMaterials do
		recursive_entity_search m medit_ents
	local retval = #()
	for i = 1 to medit_ents.count do
	(
		if (finditem scene_ents medit_ents[i]) == 0 do
			append retval medit_ents[i]
	)
	retval --retval
)

-------------------------------------------------------------------

--create unique name in path_prefix, based on getFilenameFile+getFilenameType of alien_file_path
function create_new_name path_prefix alien_file_path = 
(
	local short_name = getFilenameFile alien_file_path 
	local new_name = short_name
	local ext = getFilenameType alien_file_path
	if short_name != "" then
	(
		local num = 1
		while doesFileExist (path_prefix + new_name + ext) do 
		(
			new_name = short_name + num as string
			num = num + 1
		)
		new_name + ext
	)
	else
		""
)

--creates: filename(n).ext.backup
function create_new_backup_name path_prefix alien_file_path = 
(
	local short_name = getFilenameFile alien_file_path 
	local ext = getFilenameType alien_file_path
	local new_name = short_name + ext
	if (short_name +  ext) != "" then
	(
		local num = 1
		while doesFileExist (path_prefix + new_name + ".backup") do 
		(
			new_name = short_name + num as string + ext
			num = num + 1
		)
		new_name + ".backup"
	)
	else
		""
)

-------------------------------------------------------------------
--add subitem to matched prev item or to the top level if not found
function add_subitem arr val prev = 
(
	if (__add_subitem_recursive__ arr val prev) == false do
		append arr (tree_node val #()) 
)

--utility function, used by add_subitem
function __add_subitem_recursive__ arr val prev =
(
	local added = false
	if prev == "" then
	(
		append arr (tree_node val #()) 
		added = true
	)
	else
	(
		for i = 1 to arr.count do
		(
			if arr[i].obj == prev then
			(
				append arr[i].children (tree_node val #()) 
				added = true
				exit
			)
		)
	)
	if not added do
	(
		for i = 1 to arr.count do
		(
			if (__add_subitem_recursive__ (arr[i].children) val prev) == true then
			(
				added = true
				exit
			)
		)
	)
	added
)

-------------------------------------------------------------------

--utility fuinction; used by getTextureTreeString
function __getObjectTreeString_recursive__ o objs_seen  &level_no &prev_name immediate: false =
(
	level_no += 1
	local textout = ""
	local a = undefined
	if immediate then
		a = refs.dependents o immediateOnly:true
	else
		a = refs.dependents o 
	if a != undefined do
	(
		for i = 1 to a.count do
		(
			if (findItem objs_seen a[i]) == 0 do 
			(
				local d = ""
				try ( d = a[i].name + " {" + (getClassName a[i]) + "}" ) catch ( d = "{" + (getClassName a[i]) + "}" )
				local nm = exprForMAXObject a[i] + " : ( " + d + " )"
				if (nm[1] != "<" or nm[2] != "<") and prev_name != nm then --to avoid refvalues and duplicates
				(
					v = ""
					for j = 1 to (level_no - 1) do v += "  "
					textout += (v + nm + "\n")
					prev_name = nm
				)
				append objs_seen a[i]
				textout += __getObjectTreeString_recursive__ a[i] objs_seen &level_no &prev_name immediate: immediate
			)
		)
	)
	level_no -= 1
	textout --retval
)

--get texture "find path"; right_offset - fulltext offset in pairs or spaces; for textures found by getallinstances of all texture derived classes
function getTextureTreeString o right_offset:0 =
(
	if iskindof o TextureMap then
	(
		local objs_seen = #()
		local level_no = right_offset
		local prev_name = ""
		local v = __getObjectTreeString_recursive__ o objs_seen &level_no &prev_name immediate: false
		objs_seen = #()
		v --retval
	)
	else
	(
		""
	)
)

------------------------------------------------------------------

--gets from ut_main.file_owners_paths stored full object tree (array of strings) and makes (tree-branch-view ) string
function get_full_obj_tree num = 
(
	local txt = ""
	if ut_main.file_owners_paths.count >= num and ut_main.file_owners_paths[num] != undefined then
	(
		for p = 1 to ut_main.file_owners_paths[num].count do
		(
			local v = ""
			for j = 1 to (p - 1) do v += "  "			
			txt +=  "\t" + v + ut_main.file_owners_paths[num][p] 
			if p == ut_main.file_owners_paths[num].count then
				txt += "\n"
			else
				txt += " ->\n"
		)
	)
	txt
)

fn i642dw i64 = 
( 
	local arr = #()
	append arr ((bit.and i64 0x000000000FFFFFFFFL) as integer)
	append arr ((bit.shift (bit.and i64 0xFFFFFFFF00000000L) -32) as integer) 
	arr 
)

fn b2dw b1 b2 b3 b4 = 
( 
	bit.or (bit.charasint b1) (bit.or (bit.shift (bit.charasint b2) 8) (bit.or (bit.shift (bit.charasint b3) 16)  (bit.shift (bit.charasint b4) 24) ) ) 
)

fn bytes2dw b1 b2 b3 b4 = 
( 
	bit.or (b1) (bit.or (bit.shift b2 8) (bit.or (bit.shift b3 16)  (bit.shift b4 24) ) ) 
)

fn dw2b dw = 
( 
	local arr = #()
	append arr (bit.intaschar (bit.and dw 0x000000FF))
	append arr (bit.intaschar (bit.shift (bit.and dw 0x0000FF00) -8))
	append arr (bit.intaschar (bit.shift (bit.and dw 0x00FF0000) -16))
	append arr (bit.intaschar (bit.shift (bit.and dw 0xFF000000) -24))
	arr 
)

fn add_to_byte byte v =
(
	local res = (mod byte 0xff) as integer + (mod v 0xff) as integer
	if res > 0xff then
		res = res - 0xff
	if res < 0 then
		res = 0xff + res
	res
)

utility ut_utility ""
(
	local keys_array = #() -- cpuid[1] cpuid[2] cpuhash mbhash maxhlockid
	local customer_name = ""
	local company_name = ""
	local customer_email = ""
	local result = 0
	local last_saved_file = ""
	local generated_request = false
	local license_file_name = ""
	local arg_collect_files_collection = undefined
	local arg_fix_objects_links_old_arr = undefined
	local arg_fix_objects_links_new_arr = undefined
	local arg_ConvertFilesToJPEG_files_array = undefined
	local arg_fix_object_links_i = 0
	
	
	local crctable32bit = #(
	0x00000000L, 0x77073096L, 0xee0e612cL, 0x990951baL,
	0x076dc419L, 0x706af48fL, 0xe963a535L, 0x9e6495a3L,
	0x0edb8832L, 0x79dcb8a4L, 0xe0d5e91eL, 0x97d2d988L,
	0x09b64c2bL, 0x7eb17cbdL, 0xe7b82d07L, 0x90bf1d91L,
	0x1db71064L, 0x6ab020f2L, 0xf3b97148L, 0x84be41deL,
	0x1adad47dL, 0x6ddde4ebL, 0xf4d4b551L, 0x83d385c7L,
	0x136c9856L, 0x646ba8c0L, 0xfd62f97aL, 0x8a65c9ecL,
	0x14015c4fL, 0x63066cd9L, 0xfa0f3d63L, 0x8d080df5L,
	0x3b6e20c8L, 0x4c69105eL, 0xd56041e4L, 0xa2677172L,
	0x3c03e4d1L, 0x4b04d447L, 0xd20d85fdL, 0xa50ab56bL,
	0x35b5a8faL, 0x42b2986cL, 0xdbbbc9d6L, 0xacbcf940L,
	0x32d86ce3L, 0x45df5c75L, 0xdcd60dcfL, 0xabd13d59L,
	0x26d930acL, 0x51de003aL, 0xc8d75180L, 0xbfd06116L,
	0x21b4f4b5L, 0x56b3c423L, 0xcfba9599L, 0xb8bda50fL,
	0x2802b89eL, 0x5f058808L, 0xc60cd9b2L, 0xb10be924L,
	0x2f6f7c87L, 0x58684c11L, 0xc1611dabL, 0xb6662d3dL,
	0x76dc4190L, 0x01db7106L, 0x98d220bcL, 0xefd5102aL,
	0x71b18589L, 0x06b6b51fL, 0x9fbfe4a5L, 0xe8b8d433L,
	0x7807c9a2L, 0x0f00f934L, 0x9609a88eL, 0xe10e9818L,
	0x7f6a0dbbL, 0x086d3d2dL, 0x91646c97L, 0xe6635c01L,
	0x6b6b51f4L, 0x1c6c6162L, 0x856530d8L, 0xf262004eL,
	0x6c0695edL, 0x1b01a57bL, 0x8208f4c1L, 0xf50fc457L,
	0x65b0d9c6L, 0x12b7e950L, 0x8bbeb8eaL, 0xfcb9887cL,
	0x62dd1ddfL, 0x15da2d49L, 0x8cd37cf3L, 0xfbd44c65L,
	0x4db26158L, 0x3ab551ceL, 0xa3bc0074L, 0xd4bb30e2L,
	0x4adfa541L, 0x3dd895d7L, 0xa4d1c46dL, 0xd3d6f4fbL,
	0x4369e96aL, 0x346ed9fcL, 0xad678846L, 0xda60b8d0L,
	0x44042d73L, 0x33031de5L, 0xaa0a4c5fL, 0xdd0d7cc9L,
	0x5005713cL, 0x270241aaL, 0xbe0b1010L, 0xc90c2086L,
	0x5768b525L, 0x206f85b3L, 0xb966d409L, 0xce61e49fL,
	0x5edef90eL, 0x29d9c998L, 0xb0d09822L, 0xc7d7a8b4L,
	0x59b33d17L, 0x2eb40d81L, 0xb7bd5c3bL, 0xc0ba6cadL,
	0xedb88320L, 0x9abfb3b6L, 0x03b6e20cL, 0x74b1d29aL,
	0xead54739L, 0x9dd277afL, 0x04db2615L, 0x73dc1683L,
	0xe3630b12L, 0x94643b84L, 0x0d6d6a3eL, 0x7a6a5aa8L,
	0xe40ecf0bL, 0x9309ff9dL, 0x0a00ae27L, 0x7d079eb1L,
	0xf00f9344L, 0x8708a3d2L, 0x1e01f268L, 0x6906c2feL,
	0xf762575dL, 0x806567cbL, 0x196c3671L, 0x6e6b06e7L,
	0xfed41b76L, 0x89d32be0L, 0x10da7a5aL, 0x67dd4accL,
	0xf9b9df6fL, 0x8ebeeff9L, 0x17b7be43L, 0x60b08ed5L,
	0xd6d6a3e8L, 0xa1d1937eL, 0x38d8c2c4L, 0x4fdff252L,
	0xd1bb67f1L, 0xa6bc5767L, 0x3fb506ddL, 0x48b2364bL,
	0xd80d2bdaL, 0xaf0a1b4cL, 0x36034af6L, 0x41047a60L,
	0xdf60efc3L, 0xa867df55L, 0x316e8eefL, 0x4669be79L,
	0xcb61b38cL, 0xbc66831aL, 0x256fd2a0L, 0x5268e236L,
	0xcc0c7795L, 0xbb0b4703L, 0x220216b9L, 0x5505262fL,
	0xc5ba3bbeL, 0xb2bd0b28L, 0x2bb45a92L, 0x5cb36a04L,
	0xc2d7ffa7L, 0xb5d0cf31L, 0x2cd99e8bL, 0x5bdeae1dL,
	0x9b64c2b0L, 0xec63f226L, 0x756aa39cL, 0x026d930aL,
	0x9c0906a9L, 0xeb0e363fL, 0x72076785L, 0x05005713L,
	0x95bf4a82L, 0xe2b87a14L, 0x7bb12baeL, 0x0cb61b38L,
	0x92d28e9bL, 0xe5d5be0dL, 0x7cdcefb7L, 0x0bdbdf21L,
	0x86d3d2d4L, 0xf1d4e242L, 0x68ddb3f8L, 0x1fda836eL,
	0x81be16cdL, 0xf6b9265bL, 0x6fb077e1L, 0x18b74777L,
	0x88085ae6L, 0xff0f6a70L, 0x66063bcaL, 0x11010b5cL,
	0x8f659effL, 0xf862ae69L, 0x616bffd3L, 0x166ccf45L,
	0xa00ae278L, 0xd70dd2eeL, 0x4e048354L, 0x3903b3c2L,
	0xa7672661L, 0xd06016f7L, 0x4969474dL, 0x3e6e77dbL,
	0xaed16a4aL, 0xd9d65adcL, 0x40df0b66L, 0x37d83bf0L,
	0xa9bcae53L, 0xdebb9ec5L, 0x47b2cf7fL, 0x30b5ffe9L,
	0xbdbdf21cL, 0xcabac28aL, 0x53b39330L, 0x24b4a3a6L,
	0xbad03605L, 0xcdd70693L, 0x54de5729L, 0x23d967bfL,
	0xb3667a2eL, 0xc4614ab8L, 0x5d681b02L, 0x2a6f2b94L,
	0xb40bbe37L, 0xc30c8ea1L, 0x5a05df1bL, 0x2d02ef8dL
	)	

	global ConvertFilesToJPEG_func = "
(
	local files_array = ut_utility.arg_ConvertFilesToJPEG_files_array 
	local res = true
	local bmps_num = 0
	local bmp_exts = #(\".tif\", \".tiff\", \".psd\", \".png\", \".tga\", \".bmp\");
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
	progressStart \"Converting to JPEG/TGA\"
	
	for n = 1 to files_array.count do
	(
		local ext = getFilenameType files_array[n]	
		if (finditem bmp_exts ext) != 0 do
		(
			local old_name =  files_array[n] 
			local new_name = convertToJpegOrTga files_array[n]
			if new_name != files_array[n] then
			(		
				files_array[n] = new_name
				format \"Converting: '%' -> '%'\\n\" old_name new_name
			)
			else			
				files_array[n] = \"missing\" --ONLY for JPGCONVERT: fix_objects_links will skip not converted 

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
"

global fix_objects_links_func = "
(
	local old_arr = ut_utility.arg_fix_objects_links_old_arr 
	local new_arr = ut_utility.arg_fix_objects_links_new_arr
	local progress_count = ut_main.file_owners.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart \"Fixing file links\"
	
	local res = true
	local func = ut_utility.GetObjFixFunc()
	for i = 1 to ut_main.file_owners.count do
	(
		_fix_object_links i old_arr new_arr func
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
"

global collect_files_func = "
(
	local collection = ut_utility.arg_collect_files_collection
	local progress_count = collection.count
	local progress_increment = 100. / (progress_count as float)
	local progress_curval = 0.
	escapeEnable = true
	progressStart \"Files processing\"
	
	local res = true
	for i = 1 to collection.count do
	(
		local abs_path = \"\"
		local ext = getfilenameType collection[i]
		if ext == \".vrmesh\" then
			abs_path = ut_main.config.vrmesh_root + \"\\\\\"
		else
		(
			if ext == \".hdri\" or ext == \".hdr\" then
				abs_path = ut_main.config.hdri_root + \"\\\\\"
			else
				abs_path = ut_main.config.img_ies_root + \"\\\\\"
		)
		if abs_path != \"\" do
			res = collect_file collection i abs_path

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
"

global fix_object_links_func ="
(
	local old_arr = ut_utility.arg_fix_objects_links_old_arr 
	local new_arr = ut_utility.arg_fix_objects_links_new_arr
	local i = ut_utility.arg_fix_object_links_i
	local full_obj_tree = \"\"
	local was_prop_processed = false
	for j = 1 to ut_main.file_owners_props[i].count do
	(
		local bim = undefined
		local param = undefined
		local e_text = \"\"
		local e_text1 = \"\"
		if full_obj_tree == \"\" do 
			full_obj_tree = get_full_obj_tree i
		local n = findItem old_arr ut_main.file_owners_props[i][j].param_value
		if n != 0 then
		(
			if new_arr[n] != \"missing\" and new_arr[n] != old_arr[n] then 
			(
				local p_name = \"\"
				if ut_main.file_owners_props[i][j].param_index == 0 then
					p_name = ut_main.file_owners_props[i][j].param_name as string
				else
					p_name = (ut_main.file_owners_props[i][j].param_name as string) + \"[\" + (ut_main.file_owners_props[i][j].param_index as string) + \"]\"
				format \">>>Object changed:\\n%\\tParameter '%': '%' -> '%'\\n\" full_obj_tree p_name ut_main.file_owners_props[i][j].param_value new_arr[n]

				was_prop_processed = true
				if  ut_main.file_owners_props[i][j].param_name == \"no_parameter\" then
				(
					format \"NOTE: This link can not be fixed as it is additional virtual paramater. It related to file somehow connected to object except via object property, for example using image file list (IFL)\\n\"
				)
				else
				(
					param = undefined
					e_text = \"\"
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
								setProperty ut_main.file_owners[i] ut_main.file_owners_props[i][j].param_name new_arr[n]
							else
							(
								if classof param == Bitmap then
								(
									if ut_main.config.load_files_when_fix_links then
									(
										bim = undefined
										try
										(
											bim = openBitMap new_arr[n]
										)
										catch 
										(
											format \"ERROR: can not load texture '%'\\n\" new_arr[n]
										)
										if bim != undefined then
										(
											bim.filename = new_arr[n]
											try
											(
												setProperty ut_main.file_owners[i] ut_main.file_owners_props[i][j].param_name bim
											)
											catch
											(
												e_text1 = getCurrentException()
												format \"Exception while setting property: %\\n\" e_text1
											)
										)
									)
									else
									(
										bim = getProperty ut_main.file_owners[i] ut_main.file_owners_props[i][j].param_name
										bim.filename = new_arr[n]
										try
										(
											setProperty ut_main.file_owners[i] ut_main.file_owners_props[i][j].param_name bim
										)
										catch
										(
											e_text1 = getCurrentException()
											format \"Exception while setting property: %\\n\" e_text1
										)
									)
								)													
							)
						)
						else
						(
							format \"WARNING: script can not access parameter (Exception: %). Trying to treat it as bitmap...\\n\" e_text
							bim = undefined
							try
							(
								bim = openBitMap new_arr[n]
							)
							catch 
							(
								format \"ERROR: can not load texture '%'\\n\" new_arr[n]
							)
							if bim != undefined then
							(
								bim.filename = new_arr[n]
								try
								(
									setProperty ut_main.file_owners[i] ut_main.file_owners_props[i][j].param_name bim
								)
								catch 
								( 
									e_text1 = getCurrentException()
									format \"Exception while setting property: %\\n\" e_text1
								)
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
									param[ut_main.file_owners_props[i][j].param_index] = new_arr[n]
								else
								(
									if classof param[ ut_main.file_owners_props[i][j].param_index ] == Bitmap then
									(
										if ut_main.config.load_files_when_fix_links then
										(
											bim = undefined
											try
											(
												bim = openBitMap new_arr[n]
											)
											catch 
											(
												format \"ERROR: can not load texture '%'\\n\" new_arr[n]
											)
											if bim != undefined then
											(													
												bim.filename = new_arr[n]
												try
												(
													param[ut_main.file_owners_props[i][j].param_index] = bim
												)
												catch
												(
													e_text1 = getCurrentException()
													format \"Exception while setting property: %\\n\" e_text1
												)
											)
										)
										else
										(
											param[ut_main.file_owners_props[i][j].param_index].filename = new_arr[n]
										)
									)													
								)
							)
							else
							(
								format \"WARNING: script can not access parameter (Exception: %).\\n    Trying to treat it as bitmap...\\n\" e_text
								bim = undefined
								try
								(
									bim = openBitMap new_arr[n]
								)
								catch 
								(
									format \"ERROR: can not load texture '%'\\n\" new_arr[n]
								)
								if bim != undefined then
								(													
									bim.filename = new_arr[n]
									try
									(
										param[ut_main.file_owners_props[i][j].param_index] = bim
									)
									catch 
									(
										e_text1	= getCurrentException()														
										format \"Exception while setting property: %\\n\" e_text1 
									)
								)
							)
						)
						else
						(
							format \"ERROR: script can not access parameter (Exception: %). Parameter of Array type expected - skipping\\n\" e_text 
						)
					)
				)
			)
		)						
	)
	
	if was_prop_processed do
		format \"\\n\\n\"
)
"

	
	rollout dlg "License Request" width:269 height:136
	(
		edittext edt1 "First Name" pos:[23,25] width:234 height:18
		edittext edt3 "Second Name" pos:[5,43] width:252 height:18
		edittext edt2 "Company" pos:[29,61] width:228 height:18
		edittext edt4 "Email" pos:[48,79] width:209 height:18
		label lbl1 "Please enter your details below for license request" pos:[16,5] width:248 height:15
		button btn1 "Make request" pos:[153,110] width:104 height:18
		button btn2 "Maybe later" pos:[35,110] width:104 height:18
		on dlg close do
		(
			if generated_request == false then
				Messagebox "Ok, Tertium Organum CollectoREX is working in demo mode so far" title:"License request" 
		)
		
		on dlg open do
		(
			generated_request = false
			result = 0
			last_saved_file = ""
			local nm_arr = filterString (sysInfo.username as string) " "
			if nm_arr.count >= 1 do
			(
				edt1.text = nm_arr[1]
				if nm_arr.count >= 2 do
					edt3.text = nm_arr[2]
			)
		)
		on btn1 pressed do
		(
			if edt1.text == "" and edt3.text == "" then
				Messagebox "You must enter either First Name or Second Name" title:"License request" 
			if (matchpattern edt4.text pattern:"?*@?*.?*") == false do
				Messagebox "You must enter correct email for identification" title:"License request" 
			if (edt1.text != "" or edt3.text != "") and (matchpattern edt4.text pattern:"?*@?*.?*") then
			(
				customer_name = ""
				if edt1.text != "" do 
					customer_name += edt1.text
				if edt3.text != "" do
				(
					if customer_name != "" do
						customer_name += " " 
					customer_name += edt3.text
				)
				company_name = edt2.text
				customer_email = edt4.text
				local fnm = getSavePath caption:"Choose where to save request file" initialDir:"c:\\"
				if fnm != undefined do 
				(
					local name_to_save = fnm
					if name_to_save[name_to_save.count] != "\\" do
						name_to_save += "\\"
					name_to_save += "request.dat"
					if (ut_utility.GenerateRequestFile name_to_save) then
					(
						last_saved_file = name_to_save
						MessageBox ("Request file has been saved here:\r" + name_to_save + "\rIn order to receive license file please send it to developer by email.\rSee documentation for details.") title:"License request" 
						result = 1	
						generated_request = true
						DestroyDialog dlg
					)
					else
					(
						MessageBox ("File system error! Try to save to another folder") title:"License request" 
					)
				)
			)
		)
		on btn2 pressed do
		(
			DestroyDialog dlg
		)
	)
	
	function Init =
	(
		keys_array = #()
		local holder = #()
		local cpuid_str = ut_utility.GetProcessorData holder
		local cpuhash = ut_utility.getStringArrayHash holder
		local cpuid = i642dw (bit.hexasint (cpuid_str + "L"))
		append keys_array cpuid[1]
		append keys_array cpuid[2]
		--append keys_array cpuid[1]
		--append keys_array cpuid[2]
		--append keys_array cpuid[1]
		
		--inorder not to generate new id on new install

		append keys_array cpuhash
		local holder1 = #()
		ut_utility.GetMotherBoardData holder1
		local mbhash = ut_utility.getStringArrayHash holder1
		append keys_array mbhash
		--append keys_array hardwarelockid --dont do that - or every max install
		local h2 = join holder1 holder
		append keys_array (ut_utility.getStringArrayHash h2)
		keys_array.count
	)
	
	function IsLicenseOk = 
	(
		--license_file_name != ""
		true
	)
	
	function GetMotherBoardData holder =
	(
		local got_fields = #("Manufacturer","Model","Product","Version","SerialNumber")
		dotnet.loadAssembly ("system.management")
		local mbs = dotNetObject "System.Management.ManagementObjectSearcher" "Select * From Win32_BaseBoard"
		local mbsList = mbs.Get()
		local list_enum = mbsList.getenumerator()
		while list_enum.MoveNext() do
		(
			local val = list_enum.current
			if val != undefined then
			(
				local prop_enum = val.properties.getenumerator()
				while prop_enum.MoveNext() do 
				( 
					if prop_enum.current != undefined then
					(
						if (finditem got_fields prop_enum.current.name) != 0 do
						(
							if prop_enum.current.value != undefined do
							(
								append holder (prop_enum.current.value as string)
							)
						)
					)
				)
			)
		)
	)

	function GetProcessorData holder =
	(
		local got_fields = #( "AddressWidth","Architecture","DataWidth","Family","L2CacheSize","Level","Manufacturer","ProcessorId","ProcessorType","Revision","SocketDesignation","Stepping")
		local processorid = ""
		dotnet.loadAssembly ("system.management")
		local mbs = dotNetObject "System.Management.ManagementObjectSearcher" "Select * From Win32_Processor"
		local mbsList = mbs.Get()
		local list_enum = mbsList.getenumerator()
		while list_enum.MoveNext() do
		(
			local val = list_enum.current
			if val != undefined then
			(
				local prop_enum = val.properties.getenumerator()
				while prop_enum.MoveNext() do 
				( 
					if prop_enum.current != undefined then
					(
						if (finditem got_fields prop_enum.current.name) != 0 do
						(
							if (stricmp prop_enum.current.name "ProcessorId") == 0 do
								processorid = prop_enum.current.value
							if prop_enum.current.value != undefined do
								append holder (prop_enum.current.value as string)
						)
					)
				)
			)
		)
		processorid
	)

	function getArrayHash arr =
	(
		local crc = 0xffffffff
		local ind = 0
		for i = 1 to arr.count do
		(
			ind = (bit.and (bit.xor crc arr[i]) 0xff ) + 1
			if ind > 256 do
				ind = 256
			crc = bit.xor crctable32bit[ind] (bit.shift crc -8)
		)
		crc = bit.xor crc 0xffffffff
		crc as integer
	)

	function getStringHash str =
	(
		local crc = 0xffffffff
		local ind = 0
		for i = 1 to str.count do
		(
			ind = (bit.and (bit.xor crc (bit.charasint str[i]) ) 0xff ) + 1
			if ind > 256 do
				ind = 256
			crc = bit.xor crctable32bit[ind] (bit.shift crc -8)
		)
		crc = bit.xor crc 0xffffffff
		crc as integer
	)
	
	function getStringArrayHash str_arr =
	(
		local str = ""
		for i = 1 to str_arr.count do
			str += str_arr[i]
		getStringHash str
	)

	--generate random val - it's first_bytes
	--write first_bytes random bytes, key = sum of them; 
	--xoring by key keys_array[i]+i^5; 
	--xoring by (0xe5 b+ key_bytes[1]) customer_name[i] b+ i^3 
	--xoring by (0xcf b+ key_bytes[2]) company_name[80] b+ i^3
	--xoring by (0xd5 b+ key_bytes[1]) customer_email[80] b+ i^3
	--write alternated byte by byte: customer_name, company_name, customer_email, customer_name, company_name, customer_email, etc
	--write remaining random bytes
	
	function GenerateRequestFile fname = 
	(
		seed (timeStamp())
		local f = fopen fname "wb"
		if f == undefined then 
			return false
		local first_bytes = random 312 616
		local sum = 0
		local arr = #()
		local key = 0
		do
		(
			arr = #()
			sum = 0
			for i = 1 to first_bytes do
			(
				local val = (random 1 255)
				sum += val
				append arr val
			)
			key = sum
		) 
		while key == 0

		writeshort f first_bytes #unsigned
		for i = 1 to first_bytes do
			writebyte f arr[i] #unsigned
		
		for i = 1 to 5 do
			writelong f (bit.xor (keys_array[i] + i*i*i*i*i) key) #signed

		local nm_arr = #(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
		for i = 1 to customer_name.count do
			if i <= 80 do
				nm_arr[i] = bit.charasint customer_name[i] 
		local company_arr = #(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
		for i = 1 to company_name.count do
			if i <= 80 do
				company_arr[i] = bit.charasint company_name[i]
		local email_arr = #(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
		for i = 1 to customer_email.count do
			if i <= 80 do
				email_arr[i] = bit.charasint customer_email[i]
		
		local key_bytes = dw2b key	
		for i = 1 to 80 do
		(
			writebyte f (bit.xor (add_to_byte nm_arr[i]      (i*i*i)) (add_to_byte 0xe5 (bit.charasint key_bytes[1])) ) #unsigned
			writebyte f (bit.xor (add_to_byte company_arr[i] (i*i*i)) (add_to_byte 0xcf (bit.charasint key_bytes[2])) ) #unsigned
			writebyte f (bit.xor (add_to_byte email_arr[i]   (i*i*i)) (add_to_byte 0xd2 (bit.charasint key_bytes[1])) ) #unsigned
		)
		
		local remain = 1024 - first_bytes - 5*4 - 80*3 - 2
		for i = 1 to remain do
			writebyte f (random 1 255) #unsigned
		fclose f
		true
	)
	
	function DecryptString enc_arr secure_arr =
	(
		local arr = #()
		join arr enc_arr
		local cnt = (arr.count / 5) as integer
		local r = (mod arr.count 5) as integer
		local cur = 0
		for i = 1 to 5 do
		(
			local v = 0
			for j = 1 to cnt do
				arr[j+cur] = (bit.xor arr[j+cur] secure_arr[i]) - j*j*j
			cur += cnt
		)
		for j = 1 to r do
			arr[j+cur] = (bit.xor arr[j+cur] secure_arr[5]) - j*j*j
		local str = ""
		for i = 1 to arr.count do
		(
			local a = dw2b arr[i]
			append str ( a[1] + a[2] + a[3] + a[4] )
		)
		str
	)

	function GetStringFromLicenseFile lic_filename key_array =
	(
		local res = ""
		local f = fopen lic_filename "rb"
		local dwcnt = readlong f #unsigned
		local arr = #()
		arr.count = dwcnt
		for i = 1 to dwcnt do
			arr[i] = readlong f #unsigned
		res = DecryptString	arr key_array
		res
	)

	function FindAndLoadLicenseFile =
	(
		license_file_name = ""
		local path_to_license = (symbolicPaths.getPathValue "$scripts") + "\\collectorex\\tocollectorex.lic"
		if not (doesFileExist path_to_license) do
		(
			path_to_license = (symbolicPaths.getPathValue "$max") + "\\tocollectorex.lic"
			if not (doesFileExist path_to_license) do
			(
				path_to_license = sysInfo.systemdir + "\\tocollectorex.lic"
				if not (doesFileExist path_to_license) do
				(
					path_to_license = sysInfo.windowsdir + "\\tocollectorex.lic"
					if not (doesFileExist path_to_license) do
					(
						path_to_license = ""
					)
				)
			)
		)
		if path_to_license != "" then
		(
			local str = GetStringFromLicenseFile path_to_license keys_array
			if str != undefined and str.count == 8608 then --str.count is multiply of 4
				license_file_name = path_to_license
		)
		license_file_name != ""
	)
	
	function GetJpgFunc =
	(
		local result = ""
		/*if IsLicenseOk() then
		(
			local str = GetStringFromLicenseFile license_file_name keys_array
			if str.count == 8608 then --str.count is multiply of 4
				result = substring str 1 1143
		)*/
		result = ConvertFilesToJPEG_func
		result
	)
	
	function GetFixFunc =
	(
		local result = ""
		/*if IsLicenseOk() then
		(
			local str = GetStringFromLicenseFile license_file_name keys_array
			if str.count == 8608 then --str.count is multiply of 4
				result = substring str 1144 632
		)*/
		result = fix_objects_links_func
		result
	)
	
	function GetCollectFunc =
	(
		local result = ""
		/*if IsLicenseOk() then
		(
			local str = GetStringFromLicenseFile license_file_name keys_array
			if str.count == 8608 then --str.count is multiply of 4
				result = substring str 1776 856
		)*/
		result = collect_files_func
		result
	)
	
	function GetObjFixFunc =
	(
		local result = ""
		/*if IsLicenseOk() then
		(
			local str = GetStringFromLicenseFile license_file_name keys_array
			if str.count == 8608 then --str.count is multiply of 4
				result = substring str 2632 5974
		)*/
		result = fix_object_links_func
		result
	)
)
