#suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(Biostrings))

args <- commandArgs(trailingOnly = TRUE)
tab <- args[1]
fasta <- args[2]
#fasta <- "ex_align.fasta"
#tab <- "BLOSUM62"
seqs <- readAAStringSet(fasta)

first <- seqs[1]
#first <- "ABGN"
second <- seqs[2]
#second <- "ABNG"

#Reads the scoring matrix in. Change the skip number as required.
blosum <- read.table(tab, header = T, skip = 6)
rownames(blosum) <- append(row.names(blosum)[1:length(row.names(blosum))-1], "X.")

#Set your score to 0
score <-0
#count <-0

#Iterates through the fasta sequences. If an indel is detected, it adds 0 to the score (can be changed as desired). Otherwise it adds the appropriate score based on the matrix
for (i in 1:nchar(first)){
  pA <- substr(first, i, i)
  if (pA == "*"){
    pA <- "X."
  }
  pB <- substr(second, i, i)
  if (pB == "*"){
    pB <- "X."
  }
  if (pA =="-" | pB == "-"){
    score <- score + 0
    #print(paste0("Indel detected at ", pA, " and ", pB, ". Score is ", score))
    #count <- count +1
  } else {
    score <- score + blosum[pA, pB]
    #print(paste0("Score at ", pA, " and ", pB, " is ", score))
    #count <- count +1
  }
}

print(paste0("The score for the detected sequences is: ", score), stdout())
