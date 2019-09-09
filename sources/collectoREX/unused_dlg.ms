utility ut_unused_files ""
(
	local files_array = #() --only ref
	rollout dlg "Unused files" width:798 height:559
	(
		dotNetControl actx6 "System.Windows.Forms.ListView" pos:[3,55] width:793 height:500
		button btn39 "Kill checked" pos:[11,21] width:73 height:25
		button btn40 "Kill all" pos:[90,21] width:73 height:25
		button btn41 "Checked to trash" pos:[169,21] width:95 height:25
		button btn42 "All to trash" pos:[270,21] width:73 height:25
		button btn43 "Invert" pos:[436,23] width:56 height:22
		GroupBox grp1 "Checkers" pos:[431,6] width:357 height:45
		button btn44 "All" pos:[568,23] width:56 height:22
		button btn45 "None" pos:[502,23] width:56 height:22
		button btn53 "selected on" pos:[634,23] width:69 height:22
		button btn54 "selected off" pos:[713,23] width:63 height:22
		label lbl15 "Dblclick on item to see bitmap (if it is possible). Don't forget to close VFB." pos:[13,3] width:412 height:16
		
		
		on dlg open do
		(
			--init
			actx6.BorderStyle = (dotNetClass "System.Windows.Forms.BorderStyle").FixedSingle
			actx6.GridLines = true
			actx6.view = (dotNetClass "System.Windows.Forms.View").Details
			actx6.checkboxes = true
			actx6.fullRowSelect = true
			actx6.HideSelection = false
			actx6.LabelEdit = false
			actx6.MultiSelect = true
			actx6.Columns.Add "size" 100
			actx6.Columns.Add "modified" 150 
			actx6.Columns.Add "File name" 1000 
			
			ut_unused_files.RefreshList true
		)
		on dlg close do
		(
			files_array = #()
		)
		on actx6 DoubleClick do
		(
			--show
			if actx6.SelectedItems.count  != 0 do
			(
				v = actx6.SelectedItems.Item[0].SubItems.Item[2].Text
				if v != "" and  v != undefined do
				(
					try
					(
						if doesFileExist v do
						(
							bm = openBitmap v
							if bm != undefined do 
								display bm
						)
					)
					catch ()
				)
			)
		)
		on btn39 pressed do
		(
			--kill selected		
			if actx6.Items.count > 0 then
			(
				if queryBox "Do you really want to kill all checked files?" then
				(
					for i = 0 to actx6.Items.count - 1 do 
					(
						if actx6.Items.Item[i].checked do 
						(
							v = actx6.Items.Item[i].SubItems.Item[2].Text
							if v != "" and  v != undefined do
							(
								if doesFileExist v do
								(
									try
									(
										deleteFile v
										format "Deleted file '%' \n" v
										n = findItem files_array v
										if n != 0 do
											deleteItem files_array n
									)
									catch ( format "Error: Can not delete file '%' \n" v )
								)
							)
						)
					)					
					ut_unused_files.RefreshList false
				)
			)
		)
		on btn40 pressed do
		(
			--kill all
			if actx6.Items.count > 0 then
			(
				if queryBox "Do you really want to kill all files?" then
				(
					for i = 0 to actx6.Items.count - 1 do 
					(
						v = actx6.Items.Item[i].SubItems.Item[2].Text
						if v != "" and  v != undefined do
						(
							if doesFileExist v do
							(
								try
								(
									deleteFile v
									format "Deleted file '%' \n" v
									n = findItem files_array v
									if n != 0 do
										deleteItem files_array n
								)
								catch ( format "Error: Can not delete file '%' \n" v )
							)
						)
					)					
					ut_unused_files.RefreshList false
				)
			)	
		)
		on btn41 pressed do
		(
			--sel to trash
			
			if actx6.Items.count > 0 then
			(
				if queryBox "Do you really want to move all checked files to trash?" then
				(
					for i = 0 to actx6.Items.count - 1 do 
					(
						if actx6.Items.Item[i].checked do 
						(
							local v = actx6.Items.Item[i].SubItems.Item[2].Text
							if v != "" and  v != undefined do
							(
								if doesFileExist v do
								(
									try
									(
										local trash_dir =  (getfilenamepath v) + "$trash$\\"
										if (makeDir trash_dir) then
										(
											local nm = create_new_name trash_dir v
											renameFile v (trash_dir + nm)
											if (stricmp nm (filenameFromPath v)) != 0 then
												format "Moved to trash folder file '%' and renamed to '%'\n" v nm
											else
												format "Moved to trash folder file '%'\n" v nm
											n = findItem files_array v
											if n != 0 do
												deleteItem files_array n
										)
										else
											format "Error: Can not create trash folder '%'. File remains on the same place.\n" trash_dir
									)
									catch ( format "Error: Can not move file '%' \n" v )
								)
							)
						)
					)					
					ut_unused_files.RefreshList false
				)
			)	
		)
		on btn42 pressed do
		(
			--all to trash
			if actx6.Items.count > 0 then
			(
				if queryBox "Do you really want to move all files to trash?" then
				(
					for i = 0 to actx6.Items.count - 1 do 
					(
						local v = actx6.Items.Item[i].SubItems.Item[2].Text
						if v != "" and  v != undefined do
						(
							if doesFileExist v do
							(
								try
								(
									local trash_dir =  (getfilenamepath v) + "$trash$\\"
									if (makeDir trash_dir) then
									(
										local nm = create_new_name trash_dir v
										renameFile v (trash_dir + nm)
										if (stricmp nm (filenameFromPath v)) != 0 then
											format "Moved to trash folder file '%' and renamed to '%'\n" v nm
										else
											format "Moved to trash folder file '%'\n" v nm
										n = findItem files_array v
										if n != 0 do
											deleteItem files_array n
									)
									else
										format "Error: Can not create trash folder '%'. File remains on the same place.\n" trash_dir
								)
								catch ( format "Error: Can not move file '%' \n" v )
							)
						)
					)					
					ut_unused_files.RefreshList false
				)
			)	
		)
		on btn43 pressed do
		(
		--inv sel
			for i = 0 to actx6.Items.count - 1 do 
				actx6.Items.Item[i].checked = not actx6.Items.Item[i].checked
		)
		on btn44 pressed do
		(
		--sel all
			for i = 0 to actx6.Items.count - 1 do 
				actx6.Items.Item[i].checked = true
		
		)
		on btn45 pressed do
		(
		--sel none
			for i = 0 to actx6.Items.count - 1 do 
				actx6.Items.Item[i].checked = false
		)
		on btn53 pressed do
		(
		--sel check
			for i = 0 to actx6.Items.count - 1 do 
				if actx6.Items.Item[i].selected do 
					actx6.Items.Item[i].checked = true
		)
		on btn54 pressed do
		(
		--unsel check
			for i = 0 to actx6.Items.count - 1 do 
			(
				if actx6.Items.Item[i].selected do 
					actx6.Items.Item[i].checked = false
			)
		)
	)

	function RefreshList logit = 
	(
		dlg.actx6.Items.Clear()
		theRange = #()
		for i = 1 to files_array.count do
		(
			if files_array[i] != "" do
			(
				try
				(
					li = dotNetObject "System.Windows.Forms.ListViewItem" ((getFileSize files_array[i]) as string)
					li.checked = true
					sub_li1 = li.SubItems.add (getFileModDate files_array[i])
					sub_li2 = li.SubItems.add files_array[i]
					append theRange li
					if logit do
						format "Found unused file '%' (% bytes) last modified: %\n" files_array[i] li.text sub_li1.text
				)
				catch 
				(
					format "ERROR: File: '%' can not be processed: %\n" files_array[i] getCurrentException()
				)
			)
		)
		dlg.actx6.Items.AddRange theRange
		dlg.actx6.Refresh()
	)
)