utility ut_img_ask ""
(
	local result = 0
	local view_file_name = ""
	local view_img = undefined	
	local premultalpha = true
	
	rollout dlg "Warning!" width:447 height:588
	(
		bitmap bmp1 "" pos:[3,38] width:440 height:440
		dotNetControl edt4 "System.Windows.Forms.TextBox" pos:[6,518] width:436 height:36
		button btn47 "Don't convert" pos:[139,560] width:76 height:23
		label lbl139 "File contains alpha channel. If converted to JPEG alpha will be lost." pos:[7,4] width:435 height:15
		button btn73 "Convert to JPEG" pos:[9,560] width:87 height:23
		label lbl1 "" pos:[5,480] width:435 height:15
		label lbl2 "" pos:[5,499] width:435 height:15
		button btn21 "Convert to TGA" pos:[259,560] width:87 height:23
		checkbox chk27 "PreMultAlpha" pos:[352,565] width:88 height:14 checked:true
		label lbl23 "If converted to TGA all extra-channels excluding the first alpha will be lost." pos:[7,19] width:435 height:15

		local allow_exit = false		
	
		on dlg open do
		(
			edt4.Multiline = true
			edt4.WordWrap = true
			edt4.ReadOnly = true
			chk27.checked = ut_main.config.tga_premultiply_alpha --predefined value, user can uncheck this
			allow_exit = false
			is_tga = (getfilenametype view_file_name) == ".tga"
			result = false
			btn21.visible = not is_tga
			chk27.visible = not is_tga
			if view_file_name != "" and view_img != undefined then
			(
				edt4.text = view_file_name
				local ratio1 = view_img.height as float / view_img.width as float
				local img = undefined
				if ratio1 < 1 then
					img = bitmap 440 ( (440. * ratio1) as integer)
				else
					img = bitmap ( (440. / ratio1) as integer) 440
				copy view_img img
				dlg.bmp1.bitmap = img 
				local scale1 = ((((img.width as float / view_img.width as float * 100.) * 100 ) as integer ) as float) / 100. 
				local sz1 = ((( getFileSize view_file_name as float / 1024. ) * 100 ) as integer ) as float / 100.
				local dim1 = view_img.width as string + "x" + view_img.height as string  + " (" + scale1 as string + "%)"
				local info1 = sz1  as string + " Kb, " + view_img.channels.count as string + " additional channels, has alpha: " + view_img.hasAlpha as string
				lbl1.caption = dim1
				lbl2.caption = info1
				close img
			)
		)
		on dlg okToClose do
			allow_exit
		on btn47 pressed do
		(
			allow_exit = true
			result = 0
			DestroyDialog dlg
		)
		on btn73 pressed do
		(
			allow_exit = true
			result = 1
			DestroyDialog dlg
		)
		on btn21 pressed do
		(
			allow_exit = true
			result = 2
			premultalpha = chk27.checked
			DestroyDialog dlg
		)
	)
)

--CONVERT PROC
--returns jpeg|tga path+filename
--returns name in lo
function convertToJpegOrTga existing_path = 
(
	JPEG.ijpegio.setquality ut_main.config.jpeg_compression
	
	local retpath = existing_path
	if doesFileExist existing_path and not (getFileAttribute existing_path #directory) do
	(
		local is_tga = (getfilenametype existing_path) == ".tga"
		local v = undefined
		try 
		( 
			v = openBitMap existing_path 
		) 
		catch 
		(				
			format "ERROR: File: '%' can not be read: %\n" existing_path getCurrentException()
		)
		if v != undefined and v.width > 0 and v.height > 0 do
		(
			
			local save_anyway = false --jpeg
			local save_to_tga = false --tga
			if v.hasAlpha then
			(
				if ut_main.config.if_image_has_alpha == 2 then
				(
					save_anyway = true
					format "NoDialog: File: '%' has alpha channel, but it's converting to JPEG\n" existing_path
				)
				else
				(
					if ut_main.config.if_image_has_alpha == 4 then
					(
						if not is_tga then
						(
							save_to_tga = true
							format "NoDialog: File: '%' has alpha channel, and it's converting to TGA\n" existing_path
						)
						else
						(
							format "NoDialog: File: '%' has alpha channel, and is Targa file, so it will not be converted to tga and left unchanged\n" existing_path
						)
					)
					else
					(
						if ut_main.config.if_image_has_alpha == 1 then 
						(
							ut_img_ask.result = 0
							ut_img_ask.view_file_name = existing_path				
							ut_img_ask.view_img = v
							createDialog ut_img_ask.dlg width:447 height:588 modal:true escapeEnable:false
							ut_img_ask.view_img = undefined
							ut_img_ask.view_file_name = ""
							if ut_img_ask.result == 1 then
							(
								save_anyway = true
								format "Dialog: File: '%' has alpha channel, but user choose to convert it to JPEG\n" existing_path
							)
							else
							(
								if ut_img_ask.result == 2 then
								(
									save_to_tga = true
									format "Dialog: File: '%' has alpha channel, and user choose to convert it to TGA\n" existing_path
								)
								else
									format "Dialog: File: '%' has alpha channel, and user choose not to convert it\n" existing_path
							)
						)
						else
						(
							format "NoDialog: File: '%' has alpha channel, and will not be converted\n" existing_path
						)
					)
				)
			)
			else
				save_anyway = true

			if not save_anyway and not save_to_tga and v.hasAlpha then
			(
				close v 
				--gc()
			)
			else
			(
				local p = (getFilenamePath existing_path)
				local new_name = ""
				if save_anyway then
				(
					Jpeg.ijpegio.setquality ut_main.config.jpeg_compression
					new_name = p + (create_new_name p ((getFilenameFile existing_path) + ".jpg"))
				)
				else 
				(
					if save_to_tga then
					(
						new_name = p + (create_new_name p ((getFilenameFile existing_path) + ".tga"))
						Targa.itgaio.setCompressed true
						Targa.itgaio.setPreMultAlpha ut_img_ask.premultalpha
						Targa.itgaio.setColorDepth 32
					)
				)
				
				local already_converted = false
				if new_name != "" and save_anyway and ut_main.config.use_nconvert then
				(
					--in scripts/collectorex, max root, windowsroot, windowsroot/system32
					local path_to_nconvert = (symbolicPaths.getPathValue "$scripts") + "\\collectorex\\nconvert.exe"
					if not (doesFileExist path_to_nconvert) do
					(
						path_to_nconvert = (symbolicPaths.getPathValue "$max") + "\\nconvert.exe"
						if not (doesFileExist path_to_nconvert) do
						(
							path_to_nconvert = sysInfo.systemdir + "\\nconvert.exe"
							if not (doesFileExist path_to_nconvert) do
							(
								path_to_nconvert = sysInfo.windowsdir + "\\nconvert.exe"
								if not (doesFileExist path_to_nconvert) do
								(
									path_to_nconvert = ""
								)
							)
						)
					)

					if path_to_nconvert != "" do
					(
						local dos_res = 1
						local cmd_line = "-quiet -out jpeg -q " + ut_main.config.jpeg_compression as string + " -o \"" + new_name + "\" \"" + existing_path + "\""
						try
						(
							dos_res = DosCommand ("\"\"" + path_to_nconvert + "\" " + cmd_line + "\"")
						)
						catch (	)
						if (doesfileexist new_name) and dos_res == 0 then							
						(
							--gc()
							close v 
							already_converted = true
							retpath = new_name
							format "NOTICE: file name '%' has been converted by NConvert\n" existing_path
						)
						else
						(
							format "NOTICE: file name '%' can not be converted by NConvert and will be converted by MAX itself.\n" existing_path
						)
					)
				)
				
				if new_name != "" and not already_converted then				
				(
					local v2 = undefined
					try 
					( 
						v2 = bitmap v.width v.height filename:new_name
					)
					catch 
					(
						format "ERROR: File: '%' can not be created: %\n" new_name getCurrentException()
					)
					if v2 != undefined do
					(
						try
						(
							copy v v2
							save v2
							retpath = new_name
							close v
							close v2
							gc()
						)
						catch
						(
							format "ERROR: File: '%' can not be saved: %\n" new_name getCurrentException()
							close v
							close v2
							gc()
						)
					)
				)
			)
		)
	)
	retpath --retval
)

