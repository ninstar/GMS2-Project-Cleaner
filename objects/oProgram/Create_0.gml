var Target = get_open_filename("GameMaker Studio 2 Project (.yyp)|*.yyp", "");
if(Target != ""){

	var _Confirm = show_question("It is recommended to close the project from your GameMaker Studio 2 IDE before proceeding, a new window will appear when the process is finished.\nDo you want to start the scanning and cleaning process?");
	if(_Confirm){
	
		var Total_Removed = 0;
		var Total_Found = 0;
		var AssetName = "";
		var Log_Queue = "";
		var Filter = [

			"animcurves",
			"extensions",
			"fonts",
			"notes",
			"objects",
			"paths",
			"rooms",
			"scripts",
			"sequences",
			"shaders",
			"sprites",
			"tilesets"
		];

		for(var t = 0; t < array_length(Filter); ++t){

			// Asset filter
			var _TypeDir = filename_path(Target)+Filter[t]+"\\";
	
			#region Scan
	
			// Search asset directories
			var _Index = 0;
			var _Find = file_find_first(_TypeDir+"*", fa_directory);
			while(_Find != ""){
		
				// Save asset name
				AssetName[_Index] = filename_name(_Find);
		
				// Search for next asset...
				_Find = file_find_next();
				_Index++;
			}
	
			// End search
			file_find_close();
	
			#endregion
			#region Clean
	
			// Target asset folder
			for(var a = 0; a < array_length(AssetName); ++a){
	
				// Search for .yy files within the asset directory
				var _aFind = file_find_first(_TypeDir+AssetName[a]+"\\*.yy", 0);
				while(_aFind != ""){
		
					// Remove if file does not have the same asset name
					if(string_lower(_aFind) != string_lower(AssetName[a]+".yy")){
				
						// Log
						Log_Queue[Total_Removed] = Filter[t]+" -> "+AssetName[a]+" -> "+_aFind;
					
						// Remove
						file_delete(_TypeDir+AssetName[a]+"\\"+_aFind);
						Total_Removed++;
					}
			
					// Search next file...
					_aFind = file_find_next();
					Total_Found++;
				}

				// End search
				file_find_close();
			}
	
			#endregion
		}
	
		// Save log
		var TxtFile = file_text_open_write(Target+".cleanlog.txt");
		file_text_write_string(TxtFile, "Removed "+string(Total_Removed)+" / "+string(Total_Found)+" files.");
		file_text_writeln(TxtFile);
		file_text_writeln(TxtFile);
		for(var i = 0; i < array_length(Log_Queue); ++i){
		
			file_text_write_string(TxtFile, Log_Queue[i]);
			file_text_writeln(TxtFile);
		}
		file_text_close(TxtFile);
	
		show_message("Cleaning completed, a log file ("+filename_name(Target)+".cleanlog.txt) has been generated in the project directory.");
	}
}

game_end();