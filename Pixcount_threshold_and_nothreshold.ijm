source1 = "C:/Users/Mangana/Dropbox (Dumitriu Lab)/Dumitriu Lab Team Folder/Alessia/Rinki/6595/IL_imageJ_outputs/";
source2 = "C:/Users/Mangana/Dropbox (Dumitriu Lab)/Dumitriu Lab Team Folder/Alessia/Rinki/6595/GFP_bgcorrected/";
//source2 = "C:/Users/Mangana/Dropbox (Dumitriu Lab)/Dumitriu Lab Team Folder/Alessia/Rinki/Rinki_brain1/Rinki_6202_Rfiles/"

list = getFileList(source1);

for (i = 0; i< list.length; i++)
        action(source1, source2, list[i]);

function action(source1, source2, filename1) {
 open(source1 + filename1);
 //folder="output_" + substring(filename1, 13, 24) + "/";
// filename2=substring(filename1, 0, 24) + "_undistorted";
 filename2=substring(filename1, 13, 24);
// open(source2 + folder + filename2 + ".tif");
 open(source2 + filename2 + ".tif");
 run("Images to Stack", "method=[Scale (largest)] name=Stack title=[] use keep");
 selectWindow(filename1);
 close();
 selectWindow(filename2 + ".tif");
 close();
 selectWindow("Stack");
 run("Stack to Images");
 selectWindow(filename1);
 //run("Brightness/Contrast...");
 run("Enhance Contrast", "saturated=0.35");
 selectWindow(filename1);
 //setTool("wand");
 title = "WandTool";
 msg = "Use the \"wand\" tool to select the border, then click \"OK\".";
 waitForUser(title, msg);
 selectWindow(filename1);
 roiManager("Add");
 selectWindow(filename2);
 roiManager("Select", 0);
  //run("Brightness/Contrast...");
 run("Enhance Contrast", "saturated=0.35");
 //Histogram_list nbins 256 for 16-bit
 //run("Clear Results");
 //getHistogram(values, counts, 256);
  //run("Histogram");
  //nbins= 256;
  //row=0;
  //j=0;
  //for (j=0; j<nbins; j++) {
  //setResult("Value", row, values[j]);
  //setResult("Count", row, counts[j]);
  //row++;
  //}
  //updateResults();
 run("Set Measurements...", "area mean area_fraction display redirect=None decimal=3");
 run("Measure");
 //run("Threshold...");
 title = "SetThreshold";
 msg = "Use the \"Threshold\" tool to select the range for segmentation, then click \"OK\".";
 waitForUser(title, msg);
 run("Set Measurements...", "area mean area_fraction display limit redirect=None decimal=3");
 run("Measure");
 //saveAs("Results", source1 + filename2 + "_histlist.csv");
 //clear Roimanager
 roiManager("Delete");
 //selectWindow("Histogram of " + filename2);
 selectWindow(filename2);
 close();
 selectWindow(filename1);
 close();
}