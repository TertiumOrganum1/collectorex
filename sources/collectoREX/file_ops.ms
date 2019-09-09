utility ut_duplicates ""
(
	local result = 0
	local dialog_first_path = ""
	local dialog_second_path = ""
	local img1 = undefined
	local img2 = undefined
	local new_file_name = ""
	local eq_result = false   -- filling in in onopen
	local eq_result_a = false -- got from outside (if one of files is not bitmap)
	local hash_result = false --(if not image it holds hash compare value)
	
	rollout dlg "Warning: files with same names" width:908 height:565
	(
		local allow_exit = false
		
		bitmap bmp1 "" pos:[3,21] width:440 height:440
		bitmap bmp2 "" pos:[466,21] width:440 height:440
		label lbl1 "" pos:[4,462] width:440 height:15
		label lbl2 "" pos:[4,477] width:440 height:15
		label lbl3 "" pos:[466,462] width:438 height:15
		label lbl4 "" pos:[466,477] width:437 height:15
		button btn2 "Rename to..." pos:[348,534] width:78 height:23
		button btn3 "Replace" pos:[184,534] width:65 height:23
		edittext edt2 "" pos:[428,535] width:397 height:21
		label lbl5 "" pos:[4,493] width:898 height:30
		label lbl6 "rgb" pos:[446,163] width:17 height:15
		button btn47 "Use existing" pos:[261,534] width:76 height:23
		label lbl139 "Existing file" pos:[6,3] width:438 height:15
		label lbl140 "Found" pos:[467,3] width:437 height:15
		label lbl164 "rgba" pos:[444,261] width:21 height:15
		label lbl165 "" pos:[447,179] width:17 height:15
		label lbl166 "" pos:[448,279] width:17 height:15
		label lbl189 "" pos:[829,539] width:72 height:15
		button btn73 "ABORT COLLECT" pos:[9,532] width:107 height:28

		on dlg open do
		(
			dlg.bmp1.visible = true
			dlg.bmp2.visible = true

			result = 0
			local simple_file = false
			
			--one or more valid
			if img1 != undefined or img2 != undefined then
			(
				local dim1 = ""
				local info1 = ""
				local dim2 = ""
				local info2 = ""
				local img3 = undefined
				local img4 = undefined
				if img1 != undefined then
				(
					local ratio1 = img1.height as float / img1.width as float
					if ratio1 < 1 then
						img3 = bitmap 440 ( (440. * ratio1) as integer)
					else
						img3 = bitmap ( (440. / ratio1) as integer) 440
					copy img1 img3
					dlg.bmp1.bitmap = img3 
					local scale1 = ((((img3.width as float / img1.width as float * 100.) * 100 ) as integer ) as float) / 100. 
					local sz1 = ((( getFileSize dialog_first_path as float / 1024. ) * 100 ) as integer ) as float / 100.
					dim1 = img1.width as string + "x" + img1.height as string  + " (" + scale1 as string + "%)"
					info1 = sz1  as string + " Kb, " + img1.channels.count as string + " additional channels, has alpha: " + img1.hasAlpha as string
				)
				else
				(
					local sz1 = ((( getFileSize dialog_first_path as float / 1024. ) * 100 ) as integer ) as float / 100.
					info1 = sz1 as string + " Kb"
					dlg.bmp1.visible = false
				)
			
				if img2 != undefined then
				(
					local ratio2 = img2.height as float / img2.width as float
					if ratio2 < 1 then
						img4 = bitmap 440 ( (440. * ratio2) as integer)
					else
						img4 = bitmap ( (440. / ratio2) as integer) 440
					copy img2 img4
					dlg.bmp2.bitmap = img4 
					local scale2 = ((((img4.width as float / img2.width as float * 100.) * 100 ) as integer ) as float) / 100.
					local sz2 = ((( getFileSize dialog_second_path as float / 1024. ) * 100 ) as integer ) as float / 100.
					dim2 = img2.width as string + "x" + img2.height as string  + " (" + scale2 as string + "%)"
					info2 = sz2  as string + " Kb, " + img2.channels.count as string + " additional channels, has alpha: " + img2.hasAlpha as string
				)
				else
				(
					local sz2 = ((( getFileSize dialog_second_path as float / 1024. ) * 100 ) as integer ) as float / 100.
					info2 = sz2 as string + " Kb"
					dlg.bmp2.visible = false
				)
				
				if eq_result then 
					lbl165.caption = "=="
				else
					lbl165.caption = "<>"
				if eq_result_a then 
					lbl166.caption = "=="
				else
					lbl166.caption = "<>"

				if img1 != undefined then
					close img3
				if img2 != undefined then
					close img4
				ut_duplicates.DeInitDlg()	

				lbl1.caption = dim1
				lbl2.caption = info1
				lbl3.caption = dim2
				lbl4.caption = info2
			)
			else
			(
				simple_file = true
			)
			
			--not bitmaps
			if simple_file do
			(
				dlg.bmp1.visible = false
				dlg.bmp2.visible = false 
				dlg.lbl6.caption = "bin"
				dlg.lbl164.caption = ""
				local sz1 = ((( getFileSize dialog_first_path as float / 1024. ) * 100 ) as integer ) as float / 100.
				local sz2 = ((( getFileSize dialog_second_path as float / 1024. ) * 100 ) as integer ) as float / 100.
				lbl2.caption = sz1  as string + " Kb"
				lbl4.caption = sz2  as string + " Kb"
				if hash_result then 
					lbl165.caption = "=="
				else
					lbl165.caption = "<>"
			)

			lbl5.caption = dialog_second_path --current path of alien
			edt2.text 	 = getFilenameFile new_file_name
			lbl189.caption = getFilenameType new_file_name
			result = 0
			allow_exit = false		
		)
		
		on dlg close do
			gc ()
		on dlg okToClose do
			allow_exit
		on btn2 pressed do
		(
			test_file_name = (getFilenamePath dialog_first_path) + edt2.text + lbl189.caption
			if doesFileExist test_file_name then
			(
				if queryBox "File with this name already exists!\rGenerate unique name (Yes),\ror you can try enter another name by yourself(No)?" then
				(
					local new_nm = create_new_name (getFilenamePath dialog_first_path) dialog_second_path
					edt2.text 	 = getFilenameFile new_nm
					lbl189.caption = getFilenameType new_nm
				)
			)
			else
			(
				result = 1 --rename
				new_file_name = edt2.text + lbl189.caption
				allow_exit = true
				DestroyDialog dlg
			)
		)
		on btn3 pressed do
		(
			if queryBox "Do you really want to replace existing file?" then
			(
				result = 2 --replace
				allow_exit = true
				DestroyDialog dlg
			)
		)
		on btn47 pressed do
		(
			result = 3 --use existing
			allow_exit = true
			DestroyDialog dlg
		)
		on btn73 pressed  do
		(
			if queryBox "Attention!!! Do you really want to ABORT FULL COLLECT OPERATION?" then
			(
				result = 4 --full abort
				allow_exit = true
				DestroyDialog dlg
			)
		)
	)
	
	--returns fully equal or not
	-- 0 - notequal; 1 - equal image; 2 - equal binary
	function TryInitDlg fname1 fname2 new_name =
	(
		local res = 0
		dialog_first_path = fname1
		dialog_second_path = fname2
		new_file_name = new_name
		img1  = undefined
		img2  = undefined
		eq_result_a = false
		eq_result = false
		hash_result = false
		--ext of both files the same
		if ext != ".vrmesh" and ext != ".ies" and ext != ".cibse" and ext != ".ltli" and ext != ".max" then
		(
			try
			(
				img1 = openBitMap dialog_first_path --existing in collector
			)
			catch
			(
				format "ERROR: can not open collected bimap '%'\n" dialog_first_path
			)
			try
			(
				img2 = openBitMap dialog_second_path --new from far away 
			)
			catch
			(
				format "ERROR: can not open foreign bimap '%'\n" dialog_second_path
			)

			if img1 != undefined and img2 != undefined then
			(
				eq_result = CompareBitmaps img1 img2 0 0 useAlpha:false
				if not img1.hasAlpha and not img2.hasAlpha then -- none a
				(
					eq_result_a = eq_result
				)
				else
				(
					if not img1.hasAlpha or not img2.hasAlpha then -- one a
						eq_result_a = false
					else -- both a
						eq_result_a = CompareBitmaps img1 img2 0 0 useAlpha:true 
				)
				if eq_result_a then
					res = 1
				else
					res = 0
			)
			else
			(
				hash_result = compareBinary dialog_first_path dialog_second_path
				if img1 == undefined and img2 == undefined then -- none valid
				(
					if hash_result then
						res = 2
					else
						res = 0
				)
				else -- one valid (generally speacking, impossible situation: one opens, another - no, but hash are equal)
					res = 0
			)
		)
		else
		(
			hash_result = compareBinary dialog_first_path dialog_second_path
			if hash_result then
				res = 2
			else
				res = 0
		)
		res --retval
	)
	function DeInitDlg =
	(
		if img1 != undefined do
			close img1
		if img2 != undefined do
			close img2
	)
)


function compareBinary fname1 fname2 = 
(
	local res = false
	if ut_main.config.binary_compare_of_non_img then
	(
		--if hash_compare == true try full compary
		if (compareBinaryHash fname1 fname2) then
			res = compareBinaryPerByte fname1 fname2
		else
			res = false
	)
	else
		res = compareBinaryHash fname1 fname2
	res --retval
)

function compareBinaryHash fname1 fname2 = 
(
	local result = false
	if doesfileexist fname1 and doesfileexist fname2 do
	(
		local n1 = getfilesize fname1
		local n2 = getfilesize fname2
		if n1 == n2 then
		(
			local test1 = openFile fname1 mode:"rb"
			local test2 = openFile fname2 mode:"rb"
			local good = false
			if test1 != undefined and test2 != undefined do 
				good = true
			if test1 != undefined do
				close test1
			if test2 != undefined do
				close test2
			if good do
			(
				local HMACSHA512 =  DotNetObject "system.security.cryptography.HMACSHA512"
				local fs1 = DotNetObject "system.io.filestream" fname1 (dotnetclass "system.io.FileMode").Open (dotnetclass "system.io.FileAccess").Read
				local fs2 = DotNetObject "system.io.filestream" fname2 (dotnetclass "system.io.FileMode").Open (dotnetclass "system.io.FileAccess").Read
				local theHashValue1 = HMACSHA512.ComputeHash fs1
				local theHashValue2 = HMACSHA512.ComputeHash fs2
				result = true
				for i = 1 to theHashValue1.count do
				(
					if theHashValue1[i] != theHashValue2[i] do
					(
						result = false
						exit 
					)
				)
				fs1.close()
				fs2.close()
			)
		)	
	)
	result
)

function compareBinaryPerByte fname1 fname2 = 
(
    local result = false
    local n1 = getfilesize fname1
    local n2 = getfilesize fname2
    if n1 == n2 then
    (
        local f1 = MemStreamMgr.openFile fname1
        local f2 = MemStreamMgr.openFile fname2
        if f1 != undefined and f2 != undefined then
        (
            local res = true
            for i = 1 to n1 do
            (
                if f1.readChar() != f2.readChar() do
                (
                    res = false
                    exit 
                )
            )
            result = res
        )
        if f1 != undefined do
            MemStreamMgr.close f1
        if f2 != undefined do
            MemStreamMgr.close f2
    )    
    result 
)

function collect_file collection num abs_path =
(
	local normally_passed = true
	if (stricmp (getFilenamePath collection[num]) abs_path) != 0 and collection[num] != "missing" then
	(				
		local short_name = filenameFromPath collection[num]
		local projected_file_name = abs_path + short_name
		if doesFileExist projected_file_name then --already has such file!
		(
			local ask = false
			local equal = ut_duplicates.TryInitDlg projected_file_name collection[num] (create_new_name abs_path collection[num])
			if equal == 1 and ut_main.config.ask_even_if_bmps_are_equal do 
				ask = true
			if equal == 2 and ut_main.config.ask_even_if_binary_are_equal do
				ask = true
			if equal == 0 do
				ask = true
			--if not showning dlg - close opened in TryInitDlg
			if not ask do
				ut_duplicates.DeInitDlg()
			
			if ask then
				createDialog ut_duplicates.dlg width:908 height:561 modal:true escapeEnable:false
			else
				ut_duplicates.result = 3
			
			if ut_duplicates.result == 1 then --rename
			(      
				format "Dialog: Found file with same name '%'. User decided to rename new file into '%'.\n" short_name ut_duplicates.new_file_name
				local new_name = abs_path + ut_duplicates.new_file_name
				if (copyFile collection[num] new_name) then
				(
					collection[num] = new_name
				)
				else
				(
					if ut_main.config.ask_user_when_file_op_fails == true then
					(
						if queryBox ("Copying\r'" + collection[num] + "'\rto\r'" + new_name + "'\rfailed. Continue Collector?") then
							format "ERROR: Copying failed. User decided to continue. Link remains the same: '%'\n" collection[num]   
						else
						(
							format "ERROR: Copying failed. User decided to abort full operation.\n"   
							ut_duplicates.result = 4
						)
					)
					else
					(
						format "ERROR: Copying failed. Script continues execution. Link remains the same: '%'\n" collection[num]  
					)
				)
			)
			if ut_duplicates.result == 2 then --replace
			(
				format "Dialog: Found file with same name '%'. User decided to replace existing file with new.\n" short_name
				format "Script will make reserv copy, then try to overwrite file. If attempt fails it will restore original version.\n" 
				--reserv_copy
				local reserv_nm = create_new_name abs_path projected_file_name
				if copy projected_file_name (abs_path + reserv_nm) then
				(
				
					if ut_main.config.ask_user_when_file_op_fails == false then
					(
						if deleteFile projected_file_name then
						(
							if copyFile collection[num] projected_file_name then
							(
								collection[num] = abs_path + short_name
								deleteFile (abs_path + reserv_nm)
							)
							else
							(
								renameFile (abs_path + reserv_nm) projected_file_name -- restore backuped
								format "ERROR: Copying the new file failed. Script restored backuped file and continues execution. Link remains the same: '%'\n" collection[num]  
							)
						)
						else
						(
							deleteFile (abs_path + reserv_nm) -- kill backup
							format "ERROR: Deleting the old file failed. Script continues execution. Link remains the same: '%'\n" collection[num]  
						)
					)
					else
					(
						if deleteFile projected_file_name then
						(
							if copyFile collection[num] projected_file_name then
							(
								collection[num] = abs_path + short_name
								deleteFile (abs_path + reserv_nm)
							)
							else
							(
								renameFile (abs_path + reserv_nm) projected_file_name --restore backuped
								if queryBox ("Copying the new file\r'" + collection[num] + "'\rto\r'" + projected_file_name + "'\rfailed. Continue Collector?") then
									format "ERROR: Dialog: Copying the new file failed. Script restored backuped file. User decided to continue. Link remains the same: '%'\n" collection[num]
								else
								(
									format "ERROR: Dialog: Copying the new file failed. Script restored backuped file. User decided to abort full operation.\n"
									ut_duplicates.result = 4 --exit
								)
							)
						)
						else
						(
							deleteFile (abs_path + reserv_nm) -- kill backup
							if queryBox ("Deleting the old file\r'" + projected_file_name + "'\rfailed. Continue Collector?") then
								format "ERROR: Dialog: Deleting the old file failed. User decided to continue. Link remains the same: '%'\n" collection[num] 
							else
							(
								format "ERROR: Dialog: Deleting the old file failed. User decided to abort full operation.\n"
								ut_duplicates.result = 4 --exit
							)
						)
					)
				)
				else
				(
					if ut_main.config.ask_user_when_file_op_fails == true then 
					(
						if queryBox ("Reserv copying\r'" + projected_file_name + "'\rto\r'" + (abs_path + reserv_nm) + "'\rfailed. Continue Collector?") then
							format "ERROR: Dialog: Reserv copying failed. User decided to continue. Link remains the same: '%'\n" collection[num]  
						else
						(
							format "ERROR: Dialog: Reserv copying failed. User decided to abort full operation.\n" 
							eg_dialog_result = 4 --exit
						)
					)
					else
						format "ERROR: Reserv copying failed. Script continues execution. Link remains the same: '%'\n" collection[num]  
				)
			)
			if ut_duplicates.result == 3 then --use existing
			(
				collection[num] = abs_path + short_name
				if ask == true then
					format "Dialog: Found file with same name '%'. User decided to use existing file.\n" short_name
				else
				(
					format "No dialog: Found file with same name '%'. Script using existing file as files seem to be equal\n" short_name
				)
			)	
		)
		else
		(
			if copyFile collection[num] projected_file_name then
			(
				format "Found file '%'. File was copied to '%'.\n" collection[num] projected_file_name
				collection[num] = abs_path + short_name
			)
			else
			(
				if ut_main.config.ask_user_when_file_op_fails == true then 
				(
					if queryBox ("Copying\r'" + collection[num] + "'\rto\r'" + projected_file_name + "'\rfailed. Continue Collector?") then
						format "ERROR: Dialog: Copying failed. User decided to continue. Link remains the same: '%'\n" collection[num]  
					else
					(
						format "ERROR: Dialog: Copying '%' to '%' failed. User decided to abort full operation.\n" collection[num] projected_file_name
						eg_dialog_result = 4 --exit
					)
				)
				else
					format "ERROR: Copying '%' to '%' failed. Script continues execution. Link remains the same\n" collection[num] projected_file_name 
			)
		)
		--------
		--exit
		if ut_duplicates.result == 4 then --EXIT COLLECTOR
		(
			normally_passed = false
			format "Full collect operation aborted!\n"
			exit
		)
	)

	normally_passed
)
