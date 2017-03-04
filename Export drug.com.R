library(rvest)

#looping pages and populoting data frames
for (i in disease.links[1:1951]){
  
  #creating data frames to host the drugs per page
  #define number of pages and disease
  #disease.name <- "malignant-melanoma"
  
  pages = 30
  data.name <- paste('kk','.',1:pages,sep = "")
  data.frames.dy <- sapply(data.name, function(x)
  {
    data.frame ()
  }) 
  for (k in 1:pages){
 
 url.meds <- paste("http://www.drugs.com",i,"?page_number=",k, sep = "")
 data.frames.dy[[0+k]] <- read_html(url.meds)%>%
 html_table(trim = TRUE ,fill=TRUE)%>%
.[[1]]  
 
 #adding a disease column to the final table
 data.frames.dy[[0+k]]$disease <- i
 #View(data.frames.dy["kk.1"])
 
  }#merging data frames to one data frame
  disease.table <- do.call("rbind", data.frames.dy)
  
  #removing unwanted rows
  ptrn <- '^Generic.*?' #creating a serach pattren
  ndx = grep(ptrn, disease.table$`Drug name`, perl=T) #creating index with the pattren
  disease.table <- disease.table[-c(ndx), ] #removing unwanted rows
  
  #removing duplicated rows
  disease.table <- disease.table[!duplicated(disease.table), ]
  #disease.table <- disease.table[-2,]
  
  #export table to excel
  library(xlsx)
  if(length(disease.table) > 2){
  write.xlsx(disease.table, paste("/Users/ilangofer/Documents/Meds/","all_meds_",floor(runif(1,min = 0,max = 10000)),".xls"), sheetName="Sheet1")
}}
