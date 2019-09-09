function ContinueAfterCrash op =
(
	local log_stream = begin_batch_logfile op after_crash:true
	local start_file = ""
	if ut_main.files_remained.count > 0 then
		start_file = ut_main.files_remained[1]
	local batch_res = ProcessSaved log_stream
	end_batch_logfile log_stream	
	if op == ut_main.EON_Unused do 
	(
		if batch_res and ut_main.total_files_used.count > 0 do
		(
			begin_log ut_main.EON_UnusedGroup fname:start_file
			local res = true
			local found_files = #()
			get_existing_file_names_according_to_filter found_files
			if res do
				res = get_unused_only_files found_files ut_main.total_files_used ut_unused_files.files_array
			if res and ut_unused_files.files_array.count > 0 then
			(
				createdialog ut_unused_files.dlg width:798 height:559 modal:true
			)
			else
			(
				if ut_unused_files.files_array.count == 0 then
					format "No files found which are not used by at least one scene from X-ref tree, starting from '%'\n" start_file
			)
			if not res then
				format "User has interrupted operation. Some actions may be undone\n"
			end_log()
		)
	)
	ut_unused_files.files_array = #()
	ut_main.total_files_used = #()
	ut_main.CheckButtonsEnability()
)

function PerfromOperationOnCurrentFile op =
(
	local single_op_result = false
	single_op_result = case op of
	(
		1: CollectCurrentFile()
		2: FindUnusedFilesCurrentFile()					
		3: MissingFilesSearchCurrentFile()					
		4: JPEGConvertCurrentFile()					
		5: RelinkToResourcesRootsCurrentFile()					
		7: ResolveLinksToExistingCurrentFile()					
		8: RelinkToAnotherDiscCurrentFile()					
	)
	gc()
	local result = 0
	if (op == ut_main.EON_Collect or op == ut_main.EON_Convert or op == ut_main.EON_Relink or op == ut_main.EON_Redisc or op == ut_main.EON_Resolve or (op == ut_main.EON_Missing and ut_main.main_wnd.ckb1.checked)) and single_op_result then
		if not (saveMaxFile (maxfilepath + maxfilename) ) then
			result = 2
	if not single_op_result do 
		result = 1
	result
)

function ProcessOperation op =
(
	ut_main.total_files_used = #()
	if ut_main.config.process_xref_structure then
		BatchProcess op
	else
	(
		ut_main.show_unused_dlg_every_file = true
		PerfromOperationOnCurrentFile op 
	)
	ut_main.CheckButtonsEnability()
)

function BatchProcess operation = 
(
	local xreffile_list = #()
	local xreffile_tree = #()
	getAllXrefFiles xreffile_list xreffile_tree
	if xreffile_list.count > 0 then
	(
		if not ut_main.config.unused_summary_only then
			ut_main.show_unused_dlg_every_file = true
		else
			ut_main.show_unused_dlg_every_file = false
		ut_main.files_remained = getXrefScenesTreeStrings xreffile_tree
		ut_main.interrupted_op = operation
		local filenames = #()
		local start_file = maxfilepath + maxfilename
		append filenames start_file
		CreateDialog ut_main.show_xref_tree_wnd width:556 height:269 modal:true
		if ut_main.xreftree_result == 1 then
		(
			local log_stream = begin_batch_logfile operation
			join filenames xreffile_list
			ut_main.config.CriticalSave filenames operation
			local batch_res = ProcessSaved log_stream
			end_batch_logfile log_stream
			if operation == ut_main.EON_Unused do 
			(
				if batch_res and ut_main.total_files_used.count > 0 do
				(
					begin_log ut_main.EON_UnusedGroup fname:start_file
					local res = true
					local found_files = #()
					get_existing_file_names_according_to_filter found_files
					if res do
						res = get_unused_only_files found_files ut_main.total_files_used ut_unused_files.files_array
					if res and ut_unused_files.files_array.count > 0 then
					(
						createdialog ut_unused_files.dlg width:798 height:559 modal:true
					)
					else
					(
						if ut_unused_files.files_array.count == 0 then
							format "No files found which are not used by at least one scene from X-ref tree, starting from '%'\n" start_file
					)
					if not res then
						format "User has interrupted operation. Some actions may be undone\n"
					end_log()
				)
			)
			ut_unused_files.files_array = #()
			ut_main.total_files_used = #()
		)
		else
		(
			if ut_main.xreftree_result == 2 do
			(
				ut_main.show_unused_dlg_every_file = true
				PerfromOperationOnCurrentFile operation 	
			)
		)
	)
	else
	(
		ut_main.show_unused_dlg_every_file = true
		PerfromOperationOnCurrentFile operation 
	)
)

function ProcessSaved log_stream =
(
	try ( callbacks.removescripts #filePostOpen ) catch ()
	local result = true
	local files = #()
	do
	(
		files = #()
		local op = 0
		local passed = false --file loaded, successfully processed and successfully saved
		ut_main.config.CriticalLoad &files &op
		if files.count != 0 then 
		(
			local nm = files[1]
			local opened = false
			if (doesFileExist nm) and (isMaxFile nm) do
			(
				if (stricmp nm  (maxfilepath + maxfilename)) != 0 then
				(
					format "Opening %...\n" nm to:log_stream
					try
					(
						opened = loadMaxFile nm quiet:true missingExtFilesAction:#logmsg missingDLLsAction:#logmsg missingXRefsAction:#logmsg
					)
					catch ()
				)
				else
					opened = true
			)
			if opened then
			(
				local single_op_result = PerfromOperationOnCurrentFile op
				if single_op_result == 0 then
				(
					passed = true	--if operation completed and saved				
					format "File successfully processed\n" to:log_stream	
					try	( resetMaxFile #noPrompt ) catch()
				)
				else
				(
					if single_op_resilt == 2 then
					(
						format "Error while saving of file: %\n" nm to:log_stream
						if queryBox ("Error while saving of file:\r" + nm + "\rSkip and continue(Y) or save batch setup and exit(N) ?") title:"File save error" then
						(
							format "User decided to continue\n" to:log_stream
							passed = true							
						)
					)
					else
					(
						format "User has interrupted processing of file: %\n" nm to:log_stream
						if queryBox ("User has interrupted processing of file:\r" + nm + "\rSkip and continue(Y) or save batch setup and exit(N) ?") title:"Operation interrupted" then
						(
							format "User decided to continue\n" to:log_stream
							passed = true							
						)
					)
				)
			)
			else
			(
				format "File can not be opened: %\n" nm to:log_stream
				if queryBox ("File can not be opened:\r" + nm + "\rSkip and continue(Y) or save batch setup and exit(N) ?") title:"File open error" then
				(
					format "User decided to continue\n" to:log_stream
					passed = true							
				)
			)

			if passed then
			(
				deleteitem files 1
				ut_main.config.CriticalSave files op
			)
			else
			(
				result = false
				exit
			)
		)
	)
	while (files.count > 0)
	
	if result then --if ok clear data
	(
		ut_main.config.KillCacData()
		format "Batch operation completed\n" to: log_stream
	)
	else
	(
		format "Batch execution interrupted. Setup saved to file '%'. You may try to restart 3dsmax and run 'Continue after crush'\n" ut_main.config.GetCriticalSaveName() to:log_stream
	)
	
	try ( callbacks.addScript	#filePostOpen "ut_main.config.loadAll(); ut_main.config.setAll(); ut_main.CheckButtonsEnability(); ut_main.config.getAll(); ut_main.config.saveAll()" ) catch ()		
	result
)
