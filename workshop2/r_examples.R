rm(list = ls()) #Clears current workspace
gc() #Garbage Collection function.  Mostly optimizes memory allocation between R & the OS
closeAllConnections() #Closes off any open requests or files
getwd() #look at what R / R Studio defaults your file path as
setwd(paste("C:/Users/", Sys.info()["user"], "/Downloads", sep = "")) #for Windows OS

#Group One
x %>%
  myFunction1() #is equal to...
myFunction1(x)

#Group Two
x %>%
  myFunction1() %>%
  myFunction2() #is equal to...
myFunction2(myFunction1(x))

# Suppose we want the last 5 years of the Knicks rosters:
for(year in 2015:2019){
  
  link <- paste0("https://www.basketball-reference.com/teams/NYK/", year, ".html")
  fileName <- paste0("bbref_NYK_", year, ".html")
  
  link %>%
    read_html() %>%
    write_xml(file=fileName)
}

rsd <- RSelenium::rsDriver(browser = "chrome", verbose = FALSE)
rsc <- rsd$client #this starts an instance of Selenium
#go to page
rsc$navigate("https://inmatesearch.charlestoncounty.org/")

#click on the date box
rsc$findElement("css", "#ctl00_MainContent_txtBookDtFrom")$clickElement()
#type in the date
rsc$findElement("css", "#ctl00_MainContent_txtBookDtFrom")$sendKeysToActiveElement(list("1/1/2018"))
#click enter
rsc$findElement("css", "#MainContent_btnSearch")$clickElement()

#click number of records dropdown
rsc$findElement("css", "#MainContent_ddnRcrdsPerPage")$clickElement()
#select 100 so we minimize interaction (and code written)
rsc$findElement("css", "#MainContent_ddnRcrdsPerPage > option:nth-child(4)")$clickElement()

rsc$findElement(using = 'tag name',"html")$getElementAttribute("innerHTML")[[1]] %>%
  read_html() %>%
  html_nodes("#MainContent_dpListView") %>%
  html_children() %>%
  length() -> numOfPages



read_html(“https://www.basketball-reference.com/teams/NYK/2019.html”) %>%
  html_nodes("#roster") %>%
  html_table() %>%
  as.data.frame() -> nykRoster
read_html("bbref_NYK_2019.html") %>% #R knows to go to the WD
  html_nodes("#roster") %>%
  html_table() %>%
  as.data.frame() -> nykRoster



allFiles <- list.files(paste("C:/Users/", Sys.info()["user"],"/Downloads"))
#allFiles <- list.files(); #this also works because we already set our WD.
allFiles <- allFiles[regexpr("bbref", allFiles) > 0]
allFiles <- paste0(getwd(), "/", allFiles)

#We need a data frame to store the data.  Notice how we add an extra column.
allRosters <- as.data.frame(matrix(ncol = 10, nrow = 0))

for(thisFile in allFiles){
  
  thisFile %>%
    read_html() %>%
    html_nodes("#roster") %>%
    html_table() %>%
    as.data.frame() -> intermediate
  
  intermediate$file <- thisFile
  
  allRosters <- rbind(allRosters, intermediate)
}


# Let’s pull the hyperlinked pages from the table
read_html("bbref_NYK_2019.html") %>%
  html_nodes("#roster") %>% 
  html_children() %>% #instead of using html_table(), we use html_children() to break down the table
  html_children() %>%
  html_children() %>%
  html_children() %>%
  html_attr("href") -> allLinks


#Remove all non-player links
allLinks <- allLinks[!is.na(allLinks)] #remove NAs
allLinks <- allLinks[regexpr("players", allLinks) > 0] #keep players only
allLinks <- paste0("https://www.basketball-reference.com", allLinks)

#For each link, visit the page and try to find the twitter handle
