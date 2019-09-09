# collectorex
a tool to replace 3ds max resoource collector and more

# Foreword
After more than 10 years I've finally decided to turn collectorex from internal utility to a public open source project. In the beginning it was paid utility, now it's completely free and not binded to hardware.
Please feel free to edit code and commit here, use it as you like, distribute it freely, I just don't allow to sell my software as your own. That's it.



# Install
Unpack archive. In Max select MAXScript->Run script and choose mzp-file. Then select Custimize->Custoimize User Interface..., in window "Custoimize User Interface" go to Toolbars tab and choose "Tertium Organum" from Category combo box. Draq button "Tertium Organum CollectoREX" to toolbar. In order to view CollectoREX icon you must restart Max.
Quick start
Main utilite purpose - collect all files linked with project to choosen by user folders. It's for order in mind and on hard disk. It's for transferring scenes to another computers. For collector quick start: 
1. Load your scene (for beginning - not containing Xrefs).
2. Launch utility (utility button on toolbar is trigger button - click it once more to close utility). 
3. To realtime log view open MAXScript Listener (F11 or MAXScript -> MAXScript Listener) 
4. Choose collect folders, options from category Affect will become available
5. Click Collect Resources button.
6. Utitlity will collect all project resources, update resource links in scene and save scene. In scene folder will appear two files: backup-file and log-file.


# Terms in this manual
* XRef-tree – current scene plus all scenes linked to it by XRef links (XRef Scene, XRef Object, XRef Material, XRef Atmospheric). XRef-links may be looped
* IES-file – simplified name of photometric data files, used by photometric lights.
* Links (to files/resources) – properties of scene entities (materials, objects, modifiers, etc.) of "FileName/String" and "Bitmap" types, pointing to files of any type (bitmaps, shaders, IES-files, etc.), except Xref links.
* Collect folders – three choosing by user folders in which utility will copy:
bitmaps and IES-files
HDR-images
Vray meshes
* Link's tree in scene – list of objects connected by relation "the whole - part", showing link's place in scene. For example link-property of subtexture of texture of submaterial of multimaterial, applied to one of scene objects, have such link's tree: object name -> multimaterial name -> submaterial name -> texture name -> subtexture name -> property name.
* Real file path – path of existing file - not always path stored in max scene. When Max can not find file by stored path it tries to search in scene folder and all it's subfoilders, then in system and user defined paths. That's why stred path may differ from real file path. When you merge objects in your scene - things become more confusing. 
* Project – in this manual context project - current scene's XRef-tree. If scene contains no Xref links, project is scene itself.

# Technical requirements and usage hints
Tertium Organum CollectoREX created to work with scenes, which render by Default Scanline Renderer or Chaous Group VRay Renderer. Fry Renderer not supported. Maxwell renderer's materials: utility can extract only current layer and current coating info.
Utility has tested with following 3dsmax versions: 9sp1-sp2, 2008, 2009. Work in 9 w/o sp1 and previous versions - impossible.
Utility supports network paths. If you want to collect to network folder you must have read and write access to it.
It's desirable - but not indispensable - to restart Max before using utility. Utility operates with big data arrays - so MAXScript garbage collector errors may appear. In some cases instability and amassing gc errors may cause Max crash.
It's recommended to increase size of Initial Heap Allocation on MAXScript tab of Preference Settings window (Customize->Preferences…) at least to 100Mb. It will help utility to work more stable.


# Why choose Tertium Organum CollectoREX
Because it:
* allows collect resources of selected types only
* collects resources of different types to different folders (if you want, you may set one folder for all types)
* sujests variant of operation, if file with copying file name already exists in collect folder, providing small view of * file and info for you can choose what to do
* when compares files uses full image comparison with and w/o alpha channel - if it is image or HDRI - and CRC comparison - if it is not image
* collects only used in scene resources (bypassing Asset Tracking)
* if you want can skip Material Editor content which is not used in scene; utility can clear it before each operation
* skip resources from Scene States
* after collect updates ALL links to ALL collected resources so as they point to real files
* has many settings, which automatically save with current scene and later load from it
* allows to save settings as global defaults - in order not to make setup with each new scene
* allows to build workflow, based on periodical resource collect and semiautomatic maintenance of three or less collect folders (utility copies files to collect folders and can delete unused)
* makes backup files (one or many when increment backup is on), not using Max but working with file system: saving by Max sometimes cause crash and data loss
* automatically saves scene after operation complete: you may forget to save scene and so - lost data
* allows to find out which scene objects point to missing files
* allows to set new collect folders and rewrite all file links (without file copying) so that they point to files inside new collect folders - when you move your project to another machine or place it to another location within your machine you will need such relink to access moved resource files
* outputs information about real file paths and allows to rewrite wrong links
* allows (after collect operation) to view which files are unused by project and suggests to delete them or move to local recycle bin
* converts big images (".tif", ".tiff", ".psd", ".png", ".tga" and ".bmp") to JPEG or TGA+alpha - for less disk space usage and scene load speed increasing
* allows to process all scenes linked to current scene by XRef-links of all kinds, in batch mode
* has anti-crash mechanism for batch mode: stores its state before processing each file to be able to continue after crash, if one occures
* outputs (in files and in console) detailed log about all operations and their parameters; log file names contains incrementing number
* allows break every operation on every phase, including batch operation

# Utility functions

1. Collect resources – collection of all resources (images, HDR images, Vray meshes, IES-files, shader files) pointed by current scene or Xref-tree to specified folders and update scene links 

2. Unused – search in collect folders files that no longer used by any scene (or whole Xref-tree) link. You can delete founded files or move them to "local recycle bin" - subfolder "$trash$" created in folder where unused file had founded

3. Relink to resources roots – attempt to rewrite all scene (or whole Xref-tree) links so that they poin to files with same names as before but within specified collect folders. If some file doesn't exist in corresponding collect folder, link pointing to it remains the same. This function is needed when you move the whole project or its resources to another location or even computer

4. Resolve links to existing – this function is for ascertainment of real file paths (instead of stored in scene) of resources used by scene (or whole Xref-tree) and for rewriting all scene links so that they point to really existing files

5. Missing files Identity – output full object trees of scene (or whole Xref-tree) entities, that point to missing files

6. Convert to JPEG/TGA – conversion ".tif", ".tiff", ".psd", ".png", ".tga" and ".bmp" files to JPEG or TGA (w/alpha, RLE-compressed) files; if converting file has alpha channel, user can choose operation variant





___You can find full docs inside collectorex folder.___
