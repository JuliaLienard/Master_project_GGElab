# Merging SqQC class file with the <sample>.flnc_count.txt from Isoseq Collapse to get the proper FL counts 
# (not the FL collapsed counts wrongly collected from the collapseabundance.tsv by SqQC)

library(readr)
library(dplyr)

# loading output from IsoSeq Collapse
FLcounts_bc01 <- read_delim("Desktop/Master/BINP50/project_work/BetaCells_kinnex/git/00_raw_data/IsoCollapse/collapsed_bc01.flnc_count.txt", 
                            delim = ",", escape_double = FALSE, trim_ws = TRUE)

FLcounts_bc02 <- read_delim("Desktop/Master/BINP50/project_work/BetaCells_kinnex/git/00_raw_data/IsoCollapse/collapsed_bc02.flnc_count.txt", 
                            delim = ",", escape_double = FALSE, trim_ws = TRUE)

# loading output from Sqanti-QC (GRCh38 ref genome used for mapping)
bc01_class <- read_delim("Desktop/Master/BINP50/project_work/BetaCells_kinnex/git/00_raw_data/SqantiQC/bc01_classification.txt" , delim = "\t", escape_double = FALSE, trim_ws = TRUE)

bc02_class <- read_delim("Desktop/Master/BINP50/project_work/BetaCells_kinnex/git/00_raw_data/SqantiQC/bc02_classification.txt" , delim = "\t", escape_double = FALSE, trim_ws = TRUE)

# renaming columns in IsoSeq Collapse files for future merging
FLcounts_bc01 <- FLcounts_bc01 %>%
  rename(FLNC = BioSample_1,
         isoform = id)

FLcounts_bc02 <- FLcounts_bc02 %>%
  rename(FLNC = BioSample_2,
         isoform = id)
# merging
bc01_class_FLNC <- bc01_class %>% left_join(FLcounts_bc01, by = "isoform")
bc02_class_FLNC <- bc02_class %>% left_join(FLcounts_bc02, by = "isoform")

# output the merge files
write_tsv(file = "Desktop/Master/BINP50/project_work/BetaCells_kinnex/git/analysis/01_NIC_NNC_ratio_analysis/00_Merge_SqQCclass_FLcounts/bc01_class_FLNC.txt", x = bc01_class_FLNC)
write_tsv(file = "Desktop/Master/BINP50/project_work/BetaCells_kinnex/git/analysis/01_NIC_NNC_ratio_analysis/00_Merge_SqQCclass_FLcounts/bc02_class_FLNC.txt", x = bc02_class_FLNC)

# check Tot FL count
bc01_tot_FL_count <- sum(bc01_class_FLNC$FLNC, na.rm=T)
bc02_tot_FL_count <- sum(bc02_class_FLNC$FLNC, na.rm=T)