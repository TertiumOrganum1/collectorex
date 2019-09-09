function begin_log fn_code fname:"" =
(	
	local opname = "unknown"
	local postfix = "unknown"
	if fn_code <= ut_main.operation_types.count and fn_code >= 1 do
	(
		opname = ut_main.operation_types[fn_code]
		postfix = ut_main.log_postfixes[fn_code]
	)
	clearListener()
	if fname == "" do
	(
		fname = maxFilePath + maxFileName
		if fname == "" do
			fname = (symbolicPaths.getPathValue "$scenes") + "\\untitled.max"
	)
	local log_name = (getfilenamepath fname) +  ( create_new_name (getfilenamepath fname) ((getfilenamefile fname) + postfix + ".log") )
	openLog log_name outputOnly:true
	local demostring = ""
	if not (ut_utility.IsLicenseOk()) do
		demostring = "\n***DEMO VERSION***\nRead documentation about how to buy a license."
	format "***TOCollectoREX v.%***\nTertium Organum ® 2008-2019%\n%\nFile '%'\nOperation: %\n" ut_main.script_version demostring localTime fname opname
)

function end_log =
(
	format "Operation completed.\n" 
	closeLog()
)

function begin_batch_logfile fn_code after_crash:false =
(	
	local opname = "unknown"
	local postfix = "unknown"
	if fn_code <= ut_main.operation_types.count and fn_code >= 1 do
	(
		opname = ut_main.operation_types[fn_code]
		postfix = ut_main.log_postfixes[fn_code]
	)

	local suffix = "batch_after_crash"
	if not after_crash do
		suffix = "_batch"
	
	local path_ = maxFilePath
	if path_ == "" do
		path_ = (symbolicPaths.getPathValue "$scenes") + "\\"
	local name_ = maxFileName
	if name_ == "" do
		name_ = "untitled.max"
	
	local log_name = path_ + ( create_new_name path_ ((getFilenameFile name_) + postfix + suffix + ".log") )
	local fs_val = createFile log_name
	local demostring = ""
	if not (ut_utility.IsLicenseOk()) do
		demostring = "\n***DEMO VERSION***\nRead documentation about how to buy a license."
	format "***TOCollectoREX v.%***\nTertium Organum ® 2008-2019%\n%\nFile '%'\nBatch operation: %\n" ut_main.script_version demostring localTime (path_ + name_) opname to:fs_val
	fs_val
)

function end_batch_logfile fs_val =
(
	close fs_val
)
