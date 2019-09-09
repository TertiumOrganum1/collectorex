function CollectCurrentFile =
(
	local res = true
	begin_log ut_main.EON_Collect
	undo off 
	(					
		with redraw off 
		(
			ClearMaterialEditorIfNeeded ()
			local old_file_names = #()
			local new_file_names = #()
			res = BackupCurrentFileIfNeeded	()
			if res do
				res = findCurrentSceneFiles ()
			if res do
				res = addFilesAccordingToFilter old_file_names 
			if res do
				res = resolveRealNames old_file_names new_file_names
			if res do
				printResolvedFilesMap old_file_names new_file_names
			if res do
				check_and_log_missing_files old_file_names new_file_names
			if res do
				res = collect_files new_file_names
			if res do
				res = fix_objects_links old_file_names new_file_names
			
			if not res then
				format "User has interrupted operation. Some actions may be undone\n"
		)
	)
	end_log()
	res --retval
)

function JPEGConvertCurrentFile =
(
	local res = true
	begin_log ut_main.EON_Collect
	undo off 
	(					
		with redraw off 
		(
			ClearMaterialEditorIfNeeded ()
			local old_file_names = #()
			local new_file_names = #()
			res = BackupCurrentFileIfNeeded	()
			if res do
				res = findCurrentSceneFiles ()
			if res do
				res = addImageFilesForConvert old_file_names 
			if res do
				res = resolveRealNames old_file_names new_file_names
			if res do
				printResolvedFilesMap old_file_names new_file_names
			local deep_copy = deepcopy new_file_names
			if res do
				res = convertFilesToJPEG new_file_names
			if res do
				printConvertedFilesMap deep_copy new_file_names
			deep_copy = #()
			if res do
				res = fix_objects_links old_file_names new_file_names
			if not res then
				format "User has interrupted operation. Some actions may be undone\n"
		)
	)
	end_log()
	res --retval
)

function ResolveLinksToExistingCurrentFile =
(
	local res = true
	begin_log ut_main.EON_Resolve
	undo off 
	(					
		with redraw off 
		(
			ClearMaterialEditorIfNeeded ()
			local old_file_names = #()
			local new_file_names = #()
			res = BackupCurrentFileIfNeeded	()
			if res do
				res = findCurrentSceneFiles ()
			if res do
				res = addFilesAccordingToFilter old_file_names add_all: false
			if res do
				res = resolveRealNames old_file_names new_file_names
			if res do
				printResolvedFilesMap old_file_names new_file_names
			if res do
				check_and_log_missing_files old_file_names new_file_names
			if res do
				res = fix_objects_links old_file_names new_file_names
			
			if not res then
				format "User has interrupted operation. Some actions may be undone\n"
		)
	)
	end_log()
	res --retval
)

function MissingFilesSearchCurrentFile =
(
	local res = true
	begin_log ut_main.EON_Missing
	undo off 
	(					
		with redraw off 
		(
			ClearMaterialEditorIfNeeded ()
			local old_file_names = #()
			local new_file_names = #()
			res = findCurrentSceneFiles ()
			if res do
				res = addFilesAccordingToFilter old_file_names 
			if res do
				res = resolveRealNames old_file_names new_file_names
			if res do
				printResolvedFilesMap old_file_names new_file_names
			if res do
				check_and_log_missing_files old_file_names new_file_names
			if res and ut_main.main_wnd.ckb1.checked do
				all_missings_clear old_file_names new_file_names
			
			if not res then
				format "User has interrupted operation. Some actions may be undone\n"
		)
	)
	end_log()
	res --retval
)

function FindUnusedFilesCurrentFile =
(
	local res = true
	begin_log ut_main.EON_Unused
	undo off 
	(					
		with redraw off 
		(
			ClearMaterialEditorIfNeeded ()
			local old_file_names = #()
			local new_file_names = #()
			local found_files = #()
			ut_unused_files.files_array = #()
			
			res = findCurrentSceneFiles ()
			if res do
				res = addFilesAccordingToFilter old_file_names 
			if res do
				res = resolveRealNames old_file_names new_file_names
			if ut_main.show_unused_dlg_every_file then
			(
				if res do
					get_existing_file_names_according_to_filter found_files
				if res do
					res = get_unused_only_files found_files new_file_names ut_unused_files.files_array
				if res and ut_unused_files.files_array.count > 0 do
					createdialog ut_unused_files.dlg width:798 height:559 modal:true
			)
			if not res then
				format "User has interrupted operation. Some actions may be undone\n"
			
			join ut_main.total_files_used new_file_names
		)
	)
	end_log()
	res --retval
)

function RelinkToResourcesRootsCurrentFile =
(
	local res = true
	begin_log ut_main.EON_Relink
	undo off 
	(					
		with redraw off 
		(
			ClearMaterialEditorIfNeeded ()
			local old_file_names = #()
			local new_file_names = #()
			res = BackupCurrentFileIfNeeded	()
			if res do
				res = findCurrentSceneFiles ()
			if res do
				res = addFilesAccordingToFilter old_file_names 
			if res do
				res = relink_files old_file_names new_file_names
			if res do
				res = fix_objects_links old_file_names new_file_names
			if res do
				printResolvedFilesMap old_file_names new_file_names
			if res do 
				check_and_log_missing_files old_file_names new_file_names
			if not res then
				format "User has interrupted operation. Some actions may be undone\n"
		)
	)
	end_log()
	res --retval
)

function RelinkToAnotherDiscCurrentFile =
(
	local res = true
	begin_log ut_main.EON_Redisc
	undo off 
	(					
		with redraw off 
		(
			ClearMaterialEditorIfNeeded ()
			local old_file_names = #()
			local new_file_names = #()
			res = BackupCurrentFileIfNeeded	()
			if res do
				res = findCurrentSceneFiles ()
			if res do
				res = addFilesAccordingToFilter old_file_names 
			if res do
				res = redisc_files old_file_names new_file_names			
			if res do
				res = fix_objects_links old_file_names new_file_names
			if res do
				printResolvedFilesMap old_file_names new_file_names
			if res do 
				check_and_log_missing_files old_file_names new_file_names
			if not res then
				format "User has interrupted operation. Some actions may be undone\n"
		)
	)
	end_log()
	res --retval
)

