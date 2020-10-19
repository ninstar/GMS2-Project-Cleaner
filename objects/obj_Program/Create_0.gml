Total_Removed = 0;
Total_Found = 0;
Target = get_open_filename("GameMaker Studio 2 Project|*.yyp", "");

if(Target != ""){
	
	show_message("The project will be scanned, a new window will appear when the process is finished.\nPress OK to proceed.");
	
	Filter = [

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

		// Tipo de asset alvo
		var _TypeDir = filename_path(Target)+Filter[t]+"\\";
	
		#region Analisar
	
		// Buscar pastas de assets
		var _Index = 0;
		var _Find = file_find_first(_TypeDir+"*", fa_directory);
	
		// Enquanto busca for válida...
		while(_Find != ""){
		
			// Salvar nome do asset
			AssetName[_Index] = filename_name(_Find);
		
			// Buscar próximo asset...
			_Find = file_find_next();
			_Index++;
		}
	
		// Terminar busca
		file_find_close();
	
		#endregion
		#region Limpar
	
		// Selecionar pasta do asset alvo...
		for(var a = 0; a < array_length(AssetName); ++a){
	
			// Buscar arquivos .yy dentro da pasta do asset
			var _aFind = file_find_first(_TypeDir+AssetName[a]+"\\*.yy", 0);
		
			// Enquanto busca for válida...
			while(_aFind != ""){
		
				// Remover se arquivo não tiver mesmo nome do asset
				if(string_lower(_aFind) != string_lower(AssetName[a]+".yy")){
				
					// Registrar
					Log_Queue[Total_Removed] = _aFind;
					
					// Remover
					file_delete(_TypeDir+AssetName[a]+"\\"+_aFind);
					Total_Removed++;
				}
			
				// Buscar próximo arquivo...
				_aFind = file_find_next();
				Total_Found++;
			}

			// Terminar busca
			file_find_close();
		}
	
		#endregion
	}

	show_message("Finished, select the location where you want to save the log file");
	
	// Salvar log
	var List = get_save_filename("Text File|*.txt","Log.txt");
	if(List != ""){
	
		var TxtFile = file_text_open_write(List);
		file_text_write_string(TxtFile, "Removed "+string(Total_Removed)+" / "+string(Total_Found)+" files.");
		file_text_writeln(TxtFile);
		file_text_writeln(TxtFile);
		for(var i = 0; i < array_length(Log_Queue); ++i){
		
			file_text_write_string(TxtFile, Log_Queue[i]);
			file_text_writeln(TxtFile);
		}
		file_text_close(TxtFile);
	}
}

game_end();