--utility function; used by recursive_object_lookup
function get_names name_ a = 
(
	append a (lowercase name_)
)

function process_invalid_prop param_name: "" param: undefined index: 0 param_array: undefined exception_msg:"" =
(
	local txt = ""
	if (matchPattern exception_msg pattern:("-" + "- Runtime error: Error opening bitmap: *")) then
	(
		txt = lowercase (substring exception_msg 41 -1)
		if txt != "" do
			append param_array (param_info param_name "undefined" index txt)
	)			
	txt
)

--utility function; used by recursive_object_lookup
function process_bmp_prop param_name: "" param: undefined index: 0 param_array: undefined =
(
	local img = undefined
	if index != 0 then 
	(
		if param != undefined and (classof param == Array or classof param == ArrayParameter) do
			img = param[index]
	)
	else
		img = param
	
	--print img
	local txt = ""
	if img != undefined and img.filename != "" do
	(
		txt = lowercase img.filename
		append param_array (param_info param_name "bitmap" index txt) -- add anyway	
	)
	txt 
)

--utility function; used by recursive_object_lookup
function process_string_prop param_name: "" param: undefined index: 0 param_array: undefined filenames: undefined missing_filenames: undefined =
(
	local txt = ""
	if index != 0 then 
	(
		if param != undefined and (classof param == Array or classof param == ArrayParameter) do
			txt = lowercase param[index]
	)
	else
		txt = lowercase param
	
	--print txt
	if txt != undefined do
	(
		local n = findItem filenames (lowercase (mapPaths.getFullFilePath txt))
		local m = findItem filenames txt
		if n != 0 or m != 0 then
			append param_array (param_info param_name "string" index txt) -- add anyway
		else
		(
			n = findItem missing_filenames txt
			if n != 0 then
				append param_array (param_info param_name "string" index txt) -- add anyway: will be missing
			else
			(
				local fnm =   mapPaths.getFullFilePath txt
				if fnm != "" and (doesFileExist fnm) and not (getFileAttribute fnm #directory) do
					append param_array (param_info param_name "string" index txt) -- add only if file exists (so can be added existing but not enumerated files)
			)
		)
	)
	txt
)


--RECURSIVE_OBJECT_LOOKUP
--each time you run script you need to clear ut_main.obj_searched and ut_main.name_stack and launch recursive_object_lookup on every object, that - you think - may point to file.
--fn recursively searches materials, textures, bitmaps, strings and arrays. In arrays it searches bitmaps and strings. Textures and mats continues recursion, overwise it stops.
--Each time entering fn we adding new name to global namestack. When adding path script makes full copy of stack. Each time leaving - deletes last added name.
--all useful objects added to ut_main.file_owners array (all searched added to ut_main.obj_searched) and their props (that hold files) added in ut_main.file_owners_props array:
--{name, index (if param is not array, index == 0) , stored_filename}. Recursive tree path to objects added to ut_main.file_owners_paths.
--ALL FOUND FILES ARE STORED IN LOWER CASE!!!
global g_top_level_obj = undefined
function recursive_object_lookup o =
(
	--if it is in array - skip it!
	if (findItem ut_main.obj_searched o) == 0 then
	(
		append ut_main.obj_searched o --add to global array to avoid ref-loop
		local d = ""
		try ( d = o.name + " {" + (getClassName o) + "}" ) catch ( d = "{" + (getClassName o) + "}" )
		append ut_main.name_stack d
		if ut_main.name_stack.count == 1 do
			g_top_level_obj = o
		
		-------------------
		--type casting
		-------------------
		
		local is_tex  = false 
		local is_mod  = false
		local is_rend = false
		local is_xref = false --posevdo super-super
			local is_mat  = false
			local is_atm  = false
			local is_base = false --super-super (baseobject)
			local is_node = false --super-super (holder or base)
				local is_xres = false --resolved xref
				local is_geom = false --super
					local is_vp   = false
				local is_warp = false --the same as geometry: modifiers
				local is_shp  = false --the same as geometry: modifiers, material
				local is_help = false --the same as geometry: modifiers
				local is_lt   = false --the same as geometry: modifiers
		
		
		if iskindof o TextureMap do
			is_tex = true

		if (not is_tex) and iskindof o Material do
		(
			is_mat = true
			if classof o == XRef_Material do
				is_xref = true
		)

		if iskindof o Modifier do
			is_mod = true
		
		if iskindof o RendererClass do
			is_rend = true
		
		if iskindof o Atmospheric do
		(
			is_atm = true
			if classof o == XRefAtmosWrapper do
				is_xref = true
		)

		if iskindof o Node do
			is_node = true
		local base_obj = undefined
		try ( base_obj = o.baseobject ) catch ( )
		if base_obj == undefined and is_node then		
			is_base = true
		
		if is_node do --holder or base
		(
			if base_obj != undefined then		
			(
				if iskindof o.baseobject GeometryClass do
					is_geom = true
				if iskindof o.baseobject SpacewarpObject do
					is_warp = true
				if iskindof o.baseobject Shape do
					is_shp = true
				if iskindof o.baseobject Light do
					is_lt = true
				if iskindof o.baseobject Helper do
					is_help = true
				
				if classof o.baseobject == VRayProxy do
					is_vp = true

				if classof o.baseobject == XRefObject do
				( 
					is_xref = true 
					is_xres = not o.unresolved
					local xobj = o.GetSourceObject true
					if xobj != undefined do
					(
						if iskindof xobj GeometryClass do
							is_geom = true
						if iskindof xobj SpacewarpObject do
							is_warp = true
						if iskindof xobj Shape do
							is_shp = true
						if iskindof xobj Light do
							is_lt = true
						if iskindof xobj Helper do
							is_help = true
					)
				)
			)
			else
			(
				is_base = true
				if iskindof o GeometryClass do
					is_geom = true
				if iskindof o SpacewarpObject do
					is_warp = true
				if iskindof o Shape do
					is_shp = true
				if iskindof o Light do
					is_lt = true
				if iskindof o Helper do
					is_help = true
				if classof o == VRayProxy do
					is_vp = true
				if classof o == XRefObject do
				( 
					is_xref = true 
					is_xres = not o.unresolved
					local xobj = o.GetSourceObject true
					if xobj != undefined do
					(
						if iskindof xobj GeometryClass do
							is_geom = true
						if iskindof xobj SpacewarpObject do
							is_warp = true
						if iskindof xobj Shape do
							is_shp = true
						if iskindof xobj Light do
							is_lt = true
						if iskindof xobj Helper do
							is_help = true
					)
				)
			)
		)
				
		-----------------------------
		--processing sub objects
		-----------------------------

		--holders only
		if not is_base do --apllied to xref objs too
		(
			--materials
			if is_geom or is_shp do 
			(
				if o.material != undefined do
					recursive_object_lookup o.material
			)
		
			--modifiers
			if is_geom or is_shp or is_warp or is_help or is_lt do 
			(
				if o.modifiers != undefined do 
				(
					for m in o.modifiers do
						if m != undefined do
							recursive_object_lookup m
				)
			)
		)			
		
		--submats and subtex
		if not is_xref do
		(	
			if is_mat do
			(
				--if mat use getNumSubMtls"; else - in common prop loop
				local num = getNumSubMtls o 
				for i = 1 to num do
				(
					local v = getSubMtl o i
					if undefined != v then	
						recursive_object_lookup v	
				)
			)
			if is_tex or is_mat do --if mat or tex use getNumSubTexmaps"; else - in common prop loop
			(
				local tex_num = getNumSubTexmaps o
				for n = 1 to tex_num do
				(
					local tex = getSubTexmap o n
					if undefined != tex  then	
						recursive_object_lookup tex	
				)		
			)
		)	

		--base processing
		if base_obj != undefined then 
			recursive_object_lookup base_obj
		
		--properties processing if it is node base or if it is not node at all (atm, mat, tex, mod, rend) !!!but not xref!!!
		if not is_xref and ( (is_node and is_base) or not is_node) then
		(
			local useful_params = #() -- array of structs
			local vals = #() --found filenames
			local vals_missed = #() --missing filenames
			local prop_names = #()
			local exc_txt = ""
			local get_props_ok = true
			try
			(
				prop_names = getPropNames o --all property names
			)
			catch 
			(
				get_props_ok = false
				exc_txt = getCurrentException()
				format "Warning: Exception while getPropNames: %\n" exc_txt
			)
			enumerateFiles o get_names vals	#localOnly
			enumerateFiles o get_names vals_missed #missing #localOnly
			
			--main props loop
			local added_bitmap_names = #()
			if get_props_ok then
			(
				for i = 1 to prop_names.count do
				(
					local prop = undefined
					local exception_text = ""
					try	( prop = getProperty o prop_names[i] ) catch ( exception_text = getCurrentException() )
					-- try to get filename from exception text
					local added_name = ""
					local real_name = ""
					if prop == undefined then 
					(	
						added_name = process_invalid_prop param_name:prop_names[i] param:prop index:0 param_array:useful_params exception_msg:exception_text
						if added_name != "" do
						(
							append added_bitmap_names added_name
							real_name = lowercase (mapPaths.getFullFilePath added_name)
							if real_name != "" and real_name != added_name do
								append added_bitmap_names real_name
						)
					)
					else
					(
						--string
						if not is_rend do --avoid getting all the stuff from renderer
							if classof prop == String and prop != "" do
							(
								added_name = process_string_prop param_name:prop_names[i] param:prop index:0 param_array:useful_params filenames:vals missing_filenames:vals_missed
								if added_name != "" do
								(
									append added_bitmap_names added_name
									real_name = lowercase (mapPaths.getFullFilePath added_name)
									if real_name != "" and real_name != added_name do
										append added_bitmap_names real_name
								)
							)
						--image
						if classof prop == Bitmap do
						(
							added_name = process_bmp_prop param_name:prop_names[i] param:prop index:0 param_array:useful_params
							if added_name != "" do
							(
								append added_bitmap_names added_name
								real_name = lowercase (mapPaths.getFullFilePath added_name)
								if real_name != "" and real_name != added_name do
									append added_bitmap_names real_name
							)
						)
						--material or texture
						if not (is_mat or is_tex) do --already collected by getNumSubMtls and getNumSubTexmaps, skip
							if (iskindof prop TextureMap) or (iskindof prop Material) do
								recursive_object_lookup prop
						--array
						if classof prop == ArrayParameter or classof prop == Array and prop != #() do
						(
							for j = 1 to prop.count do
							(
								if prop[j] != undefined then
								(
									--string
									if not is_rend do --avoid getting all the stuff from renderer
										if classof prop[j] == String and prop[j] != "" do
										(
											added_name = process_string_prop param_name:prop_names[i] param:prop index:j param_array:useful_params filenames:vals missing_filenames:vals_missed
											if added_name != "" do
											(
												append added_bitmap_names added_name
												real_name = lowercase (mapPaths.getFullFilePath added_name)
												if real_name != "" and real_name != added_name do
													append added_bitmap_names real_name
											)
										)
									--image
									if classof prop[j] == Bitmap do
									(
										added_name = process_bmp_prop param_name:prop_names[i] param:prop index:j param_array:useful_params
										if added_name != "" do
										(
											append added_bitmap_names added_name
											real_name = lowercase (mapPaths.getFullFilePath added_name)
											if real_name != "" and real_name != added_name do
												append added_bitmap_names real_name
										)
									)
									--material or texture
									if not (is_mat or is_tex) do --already collected by getNumSubMtls and getNumSubTexmaps, skip
									(
										if (iskindof prop[j] TextureMap) or (iskindof prop[j] Material) do
										(
											recursive_object_lookup prop[j]
										)
									)
								)
							)
						)
					)
				)
			)	
			--see bitmaps, not found by prop search (maybe descriped in ifl) and add them as "no_parameter"
			for i = 1 to vals.count do
			(
				local cur_v = vals[i]
				if (findItem added_bitmap_names cur_v) == 0 then
				(
					local fnm =  lowercase (mapPaths.getFullFilePath cur_v)
					if (findItem added_bitmap_names fnm) == 0 then
					(
						append useful_params (param_info "no_parameter" "string" 0 cur_v)
						append added_bitmap_names cur_v
					)
				)
			)
			for i = 1 to vals_missed.count do
			(
				local cur_v = vals_missed[i]
				if (findItem added_bitmap_names cur_v) == 0 then
				(
					append useful_params (param_info "no_parameter" "undefined" 0 cur_v)
				)
			)
			--if any params are useful, add object, it's params and path; separate because of search needs
			if useful_params.count > 0 then
			(
				append ut_main.file_owners o -- only ref
				append ut_main.file_owners_props (deepcopy useful_params) --full copy
				local path_arr = #()
				if g_top_level_obj != undefined and (iskindof g_top_level_obj Node) do
						join path_arr (deepcopy (FindObjectPath g_top_level_obj))
				join path_arr (deepcopy ut_main.name_stack)
				append ut_main.file_owners_paths (deepcopy path_arr)  --full copy
			)	
		)
		deleteItem ut_main.name_stack ut_main.name_stack.count
	)	
)

function FindObjectPath obj =
(
	local ret = #()
	local p = undefined 
	if iskindof obj Node do 
		p = obj.parent
	while  p != undefined do
	(
		local d = ""
		try ( d = p.name + " {" + (getClassName p) + "}" ) catch ( d = "{" + (getClassName p) + "}" )
		append ret d
		if iskindof p Node then
		(
			local p1 = p.parent
			p = p1
		)
		else
			p = undefined
	)
	local ret_rev = #()
	local n = ret.count 
	for i = 1 to ret.count do
		append ret_rev ret[n + 1 - i]
	ret_rev
)

function ProcessCollection col txt =
(
	local result = true
	local progress_count = col.count
	if progress_count > 0 do
	(
		local progress_increment = 100. / (progress_count as float)
		local progress_curval = 0.
		escapeEnable = true
		progressStart txt
		for o in col do
		(
			recursive_object_lookup o
			if not (progressUpdate (progress_curval += progress_increment) ) do
			(
				result = false
				progressEnd ()
				exit 
			)
		)
		progressEnd ()
	)
	result
)

--fills ut_main.file_owners, ut_main.file_owners_props, ut_main.file_owners_paths with data of currently using files
--this is initial information search. after it we can search for xrefscenes and process files in any operation
-- IT IS THE MAIN FILE SEARCH FUNCTION
-- it returns false if has been canceled
function findCurrentSceneFiles = 
(
	local result = true
	ut_main.file_owners = #()
	ut_main.file_owners_props = #()
	ut_main.file_owners_paths = #()
	ut_main.obj_searched = #()
	ut_main.name_stack = #()
	--g_xref_entities = #()
	
	if result then
		result = ProcessCollection geometry "Gathering geometry links"
	if result then
		result = ProcessCollection lights "Gathering lights links"
	if result then
		result = ProcessCollection spacewarps "Gathering spacewarps links"
	if result then
		result = ProcessCollection helpers "Gathering helpers links"
	if result then
		result = ProcessCollection shapes "Gathering shapes links"

	--vray
	if result then
	(
		progressStart "Gathering renderer links"
		escapeEnable = true
		recursive_object_lookup renderers.current
		if not (progressUpdate 100) do
			result = false
		progressEnd ()
	)
	
	--max_env
	if result then
	(
		progressStart "Gathering MaxEnv links"
		escapeEnable = true
		if environmentMap != undefined do
		(
			append ut_main.name_stack "Max Environment"
			recursive_object_lookup environmentMap
			deleteItem ut_main.name_stack ut_main.name_stack.count
		)
		if not (progressUpdate 100) do
			result = false
		progressEnd ()
	)
	--effects
	if result then
	(
		local progress_count = numEffects
		if progress_count > 0 do
		(
			local progress_increment = 100. / (progress_count as float)
			local progress_curval = 0.
			escapeEnable = true
			progressStart "Gathering effects links"
			for i = 1 to numEffects do
			(
				eff = getEffect i
				if eff != undefined do
					recursive_object_lookup eff
				if not (progressUpdate (progress_curval += progress_increment) ) do
				(
					result = false
					progressEnd ()
					exit 
				)
			)
			progressEnd ()
		)
	)

	--atmospherics
	if result then
	(
		local progress_count = numAtmospherics
		if progress_count > 0 do
		(
			local progress_increment = 100. / (progress_count as float)
			local progress_curval = 0.
			escapeEnable = true
			progressStart "Gathering atmospherics links"
			for i = 1 to numAtmospherics do
			(
				eff = getAtmospheric i
				if eff != undefined do
					recursive_object_lookup eff			
				if not (progressUpdate (progress_curval += progress_increment) ) do
				(
					result = false
					progressEnd ()
					exit 
				)
			)
			progressEnd ()
		)
	)

	
	if result do
	(
		local medit_only_content = getOnlyMeditEntities ()
		if ut_main.config.search_texture_instances then
		(
			--the rest
			local unfound_texs = #()
			local tex_names = TextureMap.classes
			local useful_tex_names = #() --exclude names with __
			for i = 1 to tex_names.count do
				if not (matchPattern (tex_names[i] as string) pattern:"*__*") do
					append useful_tex_names tex_names[i]
			
			local progress_increment = 100. / (useful_tex_names.count as float)
			local progress_curval = 0.
			escapeEnable = true
			progressStart "Scanning TextureMap instances"
			
			--gather all texturemaps
			for class_name in useful_tex_names do
			(
				join unfound_texs (getClassInstances class_name)
				if not (progressUpdate (progress_curval += progress_increment) ) do
				(
					result = false
					progressEnd ()
					exit 
				)
			)	
			progressEnd ()		
			
			if result then 
			(
				local progress_count = unfound_texs.count
				local progress_increment = 100. / (progress_count as float)
				local progress_curval = 0.
				escapeEnable = true
				progressStart "Checking textures not found"
				
				format "Textures not founded by standard search: \n"
				local found_any = false
				for t in unfound_texs do
				(
					if (findItem ut_main.obj_searched t) == 0 do
					(
						local process = true
						if (findItem medit_only_content t) != 0 do
							process = false
						if process then
						(
							format "************% [%]*************\n%" t.name ((classof t) as string) (getTextureTreeString t)
							append ut_main.name_stack ("Found at:\n" + (getTextureTreeString t))
							recursive_object_lookup t
							deleteItem ut_main.name_stack ut_main.name_stack.count
						)
						found_any = true
					)
					if not (progressUpdate (progress_curval += progress_increment) ) do
					(
						result = false
						progressEnd ()
						exit 
					)
				)
				if not found_any do
					format "none.\n"
				unfound_texs = #()
				progressEnd ()
			)
		)
	)
	if result and ut_main.config.process_medit_only_content then
		result = ProcessCollection medit_only_content "Processing medit content"
	progressUpdate 0 -- to redraw finally
	ut_main.name_stack = #()
	
	result --retval
)	

---------------------------------------------------------------
----------XREFS------------------------------------------------
---------------------------------------------------------------

--utility function; used by getAllXrefFiles
--get all included xref scene filenames (real, not stored); returns tree of tree_node
function xscenes_lookup o xreffile_list = 
(
	local m = #()
	local n = 0
	if o == undefined then
		n = xrefs.getXRefFileCount ()
	else
		n = xrefs.getXRefFileCount root:o
	
	for i = 1 to n do
	(
		local xscene = undefined 
		if o == undefined then
			xscene = xrefs.getXRefFile i 
		else
			xscene = xrefs.getXRefFile i root:o		
		local curpath = xrefPaths.getFullFilePath xscene.filename
		if curpath != "" and (findItem xreffile_list curpath) == 0 do 
		(	
			append m (tree_node curpath #())
			append xreffile_list curpath
			m[m.count].children = xscenes_lookup xscene xreffile_list
		)
	)
	m --retval
)

--utility function; used by getXrefScenesTreeStrings
function __get_xrefscenes_tree_strings_recursive__ arr &level_no =
(
	local output_val = #()
	level_no += 1
	for i = 1 to arr.count do
	(
		local v = ""
		for j = 1 to level_no - 1 do v += "  "
		append output_val (v + arr[i].obj)
		join output_val (__get_xrefscenes_tree_strings_recursive__ arr[i].children &level_no)
	)
	level_no -= 1
	output_val --retval
)

--returns array of strings with filenames, preceding apropriate number of space pairs; 
function getXrefScenesTreeStrings arr =
(
	local level_no = 0
	__get_xrefscenes_tree_strings_recursive__ arr &level_no
)

function ScanMaterialsForXrefRecursive cur_material xref_array arr =
(
	if (finditem arr cur_material) == 0 do
	(
		append arr cur_material
		if classof cur_material == XrefMaterial do
			append xref_array cur_material
		local num = getNumSubMtls cur_material 
		for i = 1 to num do
		(
			local mat = getSubMtl cur_material i
			if undefined != mat then	
				ScanMaterialsForXrefRecursive mat xref_array arr
		)
	)
)

--scene_xref_entities must be cleared
-- finds all XREF objects, atmospherics, materials
function find_all_xref_entities scene_xref_entities = 
(
	local mat_arr = #()
	for mat in sceneMaterials do
	(
		if iskindof mat Material and not iskindof mat TextureMap do
			ScanMaterialsForXrefRecursive mat scene_xref_entities mat_arr		
	)
	if ut_main.config.process_medit_only_content do
	(
		for mat in meditMaterials do
			if iskindof mat Material and not iskindof mat TextureMap do
				ScanMaterialsForXrefRecursive mat scene_xref_entities mat_arr				
	)
	for o in geometry do
		if classof o == XRefObject do
			append scene_xref_entities o
	for i in 1 to numAtmospherics do
	(
		local o = getAtmospheric i
		if classof o == XRefAtmosWrapper do
			append scene_xref_entities o
	)
)

-- xreffile_tree - tree of scene names in order they using each other (elements of type tree_node); xreffile_list - list of filenames
-- both must be cleared before execute function
-- IT IS THE MAIN XREF SEARCH FUNCTION
function getAllXrefFiles xreffile_list xreffile_tree = 
(
	local scene_xref_entities = #() --objects, atmospherics, materials, founded by find_all_xref_entities
	find_all_xref_entities scene_xref_entities
	
	join xreffile_tree (xscenes_lookup undefined xreffile_list) --from root; cannot do assign, while it is not ref

	--recursive search of all files in xref objects, materials, atmospherics
	for obj in scene_xref_entities do
	(
		local src = obj
		local prev1 = ""
		local prev2 = ""
		while src != undefined and (classof src == XRefObject or classof src == XRefMaterial or src == XRefAtmosWrapper) do
		(
			--xref
			if src.srcFileName != "" do
			(
				local curpath = xrefPaths.getFullFilePath src.srcFileName
				if curpath != "" and (findItem xreffile_list curpath) == 0 do 
				(
					append xreffile_list curpath
					add_subitem xreffile_tree curpath prev1
				)
				prev1 = copy curpath
			)
			--proxy
			if classof src == XRefObject or classof src == XRefAtmosWrapper do
			(
				if src.proxyFileName != "" do
				(
					local curpath = xrefPaths.getFullFilePath src.proxyFileName
					if curpath != "" and (findItem xreffile_list curpath) == 0 do 
					(
						append xreffile_list curpath
						add_subitem xreffile_tree curpath prev2
					)
					prev2 = copy curpath
				)
			)
			--get inner
			local src_obj = undefined
			if not src.unresolved then
			(
				if classof src == XRefObject do
					src_obj = src.GetSourceObject false
				if classof src == XRefMaterial do
					src_obj = src.GetSourceMaterial false
				if classof src == XRefAtmosWrapper do
					src_obj = src.GetSourceAtmospheric false			
			)	
			else
				src_obj = undefined
			src = src_obj	
		)
	)
)

