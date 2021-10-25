// Open all files from a source directory
// crop them to the same rectangular shape
// convert to 8-bit
// save them in a target directory in TIFF format

output = "C:/Users/Mangana/Dropbox (Dumitriu Lab)/Dumitriu Lab Team Folder/Alessia/Rinki/6806/IPN_IF_imageJ_outputs/";
//output = "C:/Users/Mangana/Desktop/imagej_outputs3/";
input = "C:/Users/Mangana/Dropbox (Dumitriu Lab)/Dumitriu Lab Team Folder/Alessia/Rinki/6806/IPN_IF_R_outputs/";
//input = "C:/Users/Mangana/Dropbox (Dumitriu Lab)/Dumitriu Lab Team Folder/Alessia/Rinki/Rinki_brain4/6211_Rfiles/DB_R_outputs/";

list = getFileList(input);
for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
        


function action(input, output, filename) {
	//setTool("rectangle");
        open(input + filename);
        //selectRectangle with wand tool;
        waitForUser("select rectangle to crop out");
        run("Crop");
       // doWand(438, 75);
        run("8-bit");
        saveAs("Tiff", output + filename);
        close();
}