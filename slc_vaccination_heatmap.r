#First we need to load the RSocrata package.  You may need to install it first.

require(RSocrata)

#Next we will need the plyr package.

require(plyr)

#Now we'll load the dataframe.

slc <- read.socrata("https://opendata.utah.gov/Health/Salt-Lake-School-District-Vaccinations-2014/yud6-5333")

head(slc) #Let's see what the data looks like.


row.names(slc) <- slc$School #Replaces the numbered rows with values from the column 'School'
slc <- slc[,-c(1:5)] #Removes columns 1:5, columns start at 1

#Remove the '%' sign from the numerical data in the three rows we are analyzing  

slc$X..adequately.immunized <- gsub("%", "", as.character(slc$X..adequately.immunized))
slc$X..receiving.MMR <- gsub("%", "", as.character(slc$X..receiving.MMR))
slc$X..receiving.DTaP <- gsub("%", "", as.character(slc$X..receiving.DTaP))

slc <- slc[order(slc$X..adequately.immunized),] #Order the data with priority to the column X..adequately.immunized

#Rename columns using the plyr library
slc <- rename(slc, c(X..adequately.immunized="All Six Vaccines", X..receiving.MMR="MMR", X..receiving.DTaP="DTaP")) 

slc_matrix <- data.matrix(slc) #The heatmap needs data in a matrix format

#Create the heatmap with R's built in heatmap function
slc_heatmap <- heatmap(slc_matrix, Rowv=NA, Colv=NA, col=brewer.pal(9,"Blues"), scale="column", margins=c(17,17), main="Salt Lake School District Vaccinations 2014")
