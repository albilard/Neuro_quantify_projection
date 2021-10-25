###Script for find the coordinates of single brain area after registration and plot them in Tiff format###

quartz<-function(width,height){windows(width, height)}
library(wholebrain)
library(tiff)

folder="C:/Users/Mangana/Dropbox (Dumitriu Lab)/Dumitriu Lab Team Folder/Alessia/Rinki/6806/"
#Load dataset and regi (THIS WILL OVERWRITE ANY EXISTING regi OR dataset NAMED OBJECTS)
setwd(folder)
Rdatafiles<-list.files(pattern = "*.Rdata")
length(Rdatafiles)

load(file=Rdatafiles[1])

##check regi$outputfile to see where your undistorted/distorted images are, and change it
regi$outputfile
regi$outputfile<-paste0(folder,"output_",tools::file_path_sans_ext(basename(Rdatafiles[1])),"/",basename(regi$outputfile))

##tryout the schematic plot function
schematic.plot(dataset)

##tryout the plot.registration() function
plot.registration(regi)


                               ###PLOT SINGLE AREA###

for (c in Rdatafiles[1:length(Rdatafiles)]) {
  print(c)
  load(file=c)
  ##check regi$outputfile too see where your undistorted/distorted images are
#  outputfile_old<-regi$outputfile
#  regi$outputfile<-paste0(folder,"output_",tools::file_path_sans_ext(basename(c)),"/",basename(regi$outputfile))
  ##load in the atlas index and the atlas ontology
  data(atlasIndex, envir=environment())
  data(ontology, envir=environment())
  ##load the atlas contours
  data(EPSatlas, envir=environment())
  ##get the coordinate form your registration
  your.coordinate<-regi$coordinate
  ## there is a bug in the calculation of plate for coord 1.1 and 0.1 (because the plates 133-152 have +values from bregma)
  if (your.coordinate == 1.1) { 
    plate<-43
  } else if (your.coordinate == 0.1) {
    plate<-53
  } else {
    plate <- which(abs(your.coordinate - atlasIndex$mm.from.bregma) == min(abs(your.coordinate - atlasIndex$mm.from.bregma)))
  }
  
  #list of brain areas in the selected plate, from id nr to name
  areas_in_plate<- EPSatlas$plate.info[[plate]]$structure_id
  
  ROI<- list()
  for (i in areas_in_plate) {
    name_areas<- paste(ontology$name[which(ontology$id == i)], i)
    ROI[[i]]<-name_areas
  }
  
  ##region of interests
  #region.of.interests<-list('PL', 'PL1', 'PL2','PL5','PL6a','PL6b', 'PL2/3')
  #region.of.interests<-list('ILA', 'ILA1', 'ILA2','ILA5','ILA6a','ILA6b', 'ILA2/3')
  #region.of.interests<-list('ACB')
  #region.of.interests<-list('LS','LSX','LSc','LSr','LSv')
  #region.of.interests<-list('NDB','db')
  #region.of.interests<-list('LHA')
  #region.of.interests<-list('VTA','VTN')
  region.of.interests<-list('IPN','IF')
  #region.of.interests<-list('DR')
  #region.of.interests<-list('PAG')
  
  #PL<-dataset[which(dataset$acronym %in% get.sub.structure(region.of.interest)),]
  
  ##scale factor to your image
  scale.factor <- mean(dim(regi$transformationgrid$mx)/c(regi$transformationgrid$height, regi$transformationgrid$width))
  
  ##Loop for outline selection of all ROI if present in the plate
  
  for (i in region.of.interests) {
    print(i)
    k<-which(EPSatlas$plate.info[[plate]]$structure_id %in% id.from.acronym(i))
    if (isTRUE(k != 0)) {
      #   quartz()
      if (i == "PL2/3") {
        tiff(filename = paste0(basename(regi$outputfile),'PL23.tiff'), res = 300, width = 2612, height = 2418)
      }  
      else if (i == "ILA2/3") {
        tiff(filename = paste0(basename(regi$outputfile),'ILA23.tiff'), res = 300, width = 2612, height = 2418)
      }
      else {
        tiff(filename = paste0(basename(regi$outputfile),i,'.tiff'), res = 300, width = 2612, height = 2418)
      }
      
      plot.registration(regi, border = FALSE)
      lapply(k, function(x) {
        polygon(regi$atlas$outlines[[x]]$xrT/scale.factor, 
                regi$atlas$outlines[[x]]$yrT/scale.factor, 
                border = "black") })
      lapply(k, function(x) {
        polygon(regi$atlas$outlines[[x]]$xlT/scale.factor, 
                regi$atlas$outlines[[x]]$ylT/scale.factor) }) 
      
      #  if (i == "PL2/3") {
      #   i<-"PL2"
      #  }
      #dev.copy(pdf, paste0(basename(regi$outputfile),i,'.pdf'))
      dev.off()
    }
  }
}
###END###



#plot the cells in ROI i.e. thalamus
points(TH$x, TH$y, pch = 20, col = TH$color)

#plot the original atlas plate outline in real scale for right and left hemisphere

for (d in 1:96) {
  lapply(d, function(x){
    polygon(regi$atlas$outlines[[x]]$xrT,regi$atlas$outlines[[x]]$yrT, border = "red")})
}

for (d in 1:96) {
  lapply(d, function(x){
    polygon(regi$atlas$outlines[[x]]$xlT,regi$atlas$outlines[[x]]$ylT, border = "red")})
}
