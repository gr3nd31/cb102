suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(Biostrings))

args <- commandArgs(trailingOnly = TRUE)

fasta <- args[1]
#fasta<-"p53_clean.fasta"
ids <- args[2]
#ids <- "required.txt"
outfile <- args[3]
#outfile <- "matchingSubset.fasta"
#This pulls in the fasta seqs
seqs <- readAAStringSet(fasta)
# ids <- ids[ids$V1 == "460",]
# ids <- ids$V6[c(1, 2)]
# write.table(ids, file = "required.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

#There are "."'s in the ids which generally speaking should be removed
idpet <- names(seqs)

pattern <- "^(\\S+)\\.|^(\\S+)\\s"
matches <- str_match(idpet, pattern)
idset <- c()
for (i in 1:nrow(matches)){
  if (is.na(matches[i,2])){
    idset <- append(idset, matches[i,3])
  } else {
    idset <- append(idset, matches[i,2])
  }
}
#required_ids <- read.table(ids, stringsAsFactors = F, header = F)
pattern <- "^(\\S+)\\.|^(\\S+)$"
if (grepl(".txt", ids)){
  ids <- read.table(ids, stringsAsFactors = FALSE, header = FALSE, fill = TRUE)
  matches <- str_match(ids$V1, pattern)
} else {
  matches <- str_match(ids, pattern)
}
required_ids <- c()
for (i in 1:nrow(matches)){
  if (is.na(matches[i,2])){
    required_ids <- append(required_ids, matches[i,3])
  } else {
    required_ids <- append(required_ids, matches[i,2])
  }
}

matching_index <- which(idset %in% required_ids)

seq_subset <- seqs[matching_index]
writeXStringSet(seq_subset, outfile)
write.table(as.character(seq_subset), stdout())