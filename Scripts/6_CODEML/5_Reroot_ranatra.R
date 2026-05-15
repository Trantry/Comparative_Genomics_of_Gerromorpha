install.packages("ape")  
library(ape)


infile  <- "/Volumes/Trystan/Lyon/M2/Stage/Raxml/species_tree.raxml.bestTree"
outfile <- "/Volumes/Trystan/Lyon/M2/Stage/Raxml/species_tree.rooted_Ran_chi.nwk"
outgroup <- "Ran_chi"

tr <- read.tree(infile)

tr_root <- root(tr, outgroup = outgroup, resolve.root = TRUE)

write.tree(tr_root, file = outfile)

tr_root
plot(tr_root, cex=0.6)


