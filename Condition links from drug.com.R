library(rvest)
library(XML)
library(httr)
library(scrapeR)
#creating data frames to host the conditions per letter
data.name <- paste(letters,sep = "")
condition.letter <- sapply(data.name, function(x)
{
 data.frame()
}) 

for(i in 1:length(condition.letter)) {
  assign(paste0(letters, i), condition.letter [[i]])
}

#looping pages and populoting data frames
for (k in letters)
  
{
  url <- paste("http://www.drugs.com/condition/",k, ".html",sep = "")
 
  #getting all links from condition letter
  condition.letter[[k]] <- xpathSApply(htmlParse(rawToChar(GET(url)$content)),"//a/@href")
  #a10 <- xpathSApply(a10, "//a/@href")


  #keeping only condition links
  ptrn <- '^/condition/.*?' #creating a serach pattren
  ndx = grep(ptrn,condition.letter[[k]], perl=T) #creating index with the pattren
  condition.letter[[k]] <- condition.letter[[k]][c(ndx)] #removing unwanted rows
  condition.letter[[k]]<- strsplit( condition.letter[[k]], "\nhref\n")
  condition.letter[[k]] <- t(condition.letter[[k]])
  condition.letter[[k]] <- gsub("href","", condition.letter[[k]])
  condition.letter[[k]] <- head(condition.letter[[k]],-26)
}
#mearging data to one list

disease.links <- do.call("rbind", condition.letter)
disease.links <- as.vector(disease.links)

#removing duplicated rows
disease.links <- disease.links[!duplicated(disease.links)]

