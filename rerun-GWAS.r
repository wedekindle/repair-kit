getwd()

library(data.table)

#Load in where sequence data is located
data_list = list.files("/SEQUENCE/DATA/DIRECTORY/")
data_list = data_list[2:length(data_list)]
data_list = paste0("/SEQUENCE/DATA/DIRECTORY/",data_list)
data_list_test = data_list[1:10]

#Upload a list of IDs of missing variants in previous GWAS results file
missing_ids =  readLines("MISSING_IDS.txt")

#Add any necessary formatting to missing ID terms so they exactly match the terms you're searching for in sequence data
missing_ids = paste0("snp_",missing_ids)
#missing_ids_test = missing_ids[1:10]

#Set up results file to display file name, column name (the missing variant), and column number (which number that column is in the sequence data file)
res = as.data.frame(matrix(ncol=3,nrow=0))
colnames(res) = c("filename", "colname", "colnum")

#Create if-loop to search for every single-nucleotide polymorphism (SNP) within missing_ids
ind = 1
system.time(
  for(file in data_list) {
    data = fread(file,header=TRUE)
    missing = missing_ids[missing_ids %in% colnames(data)]
    if(length(missing)!=0) {
      for (i in missing) {
        x = as.character(c(file,i,grep(i,colnames(data))))
        res[ind,] = x
        ind = ind+1
      }
    }
  }
)
write.csv(res,"res.csv")


# for (i in missing_ids_test) {
#   ind = 0
#   i = paste0("snp_",i)
#   for (file in data_list) {
#     data = fread(file,header=TRUE)
#     ind = ind+1
#     if (i %in% colnames(data)) {
#       x = as.character(c(file,i,grep(i,colnames(data))))
#       res[ind,] = x
#     }
#   }
# }

