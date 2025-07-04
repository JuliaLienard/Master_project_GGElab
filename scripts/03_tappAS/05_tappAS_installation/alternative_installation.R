# https://app.tappas.org/resources/downloads/install.pdf

# several R packages are necessary for tappAS. 
# Installing first all R packages missing (ex: BiocManager::install("DEXSeq")).

# I missed GOglm
install.packages("remotes")
remotes::install_github("gu-mi/GOglm")

# I also missed mdgsa which was installed as follow:
library(devtools)
install_github ("dmontaner/mdgsa")

# Problem with mdgsa package similar as https://github.com/ConesaLab/tappAS/issues/35
# Manually Modify the mdgsa Package to replace its dependencybecause to KEGG.db which is obsolete
1. Download the source code manually and unzip
system("git clone https://github.com/dmontaner/mdgsa.git")

2.Edit the DESCRIPTION file
Open mdgsa/DESCRIPTION and replace line that includes KEGG.db under Imports: by "KEGGREST"
which is the current Bioconductor-supported package

3. Edit the NAMESPACE file by replacing "import(kegg.db)" by "import(KEGGREST)"

4.Edit the R files get_GO_KEGG_names.R in the R folder (mdgsa/R/).
Change completely the second fuction by this:

##' @name getKEGGnames
##' @author David Montaner \email{dmontaner@@cipf.es}
##' 
##' @keywords KEGG names
##' @seealso \code{\link{getGOnames}}
##' 
##' @title Get KEGG names
##' 
##' @description
##' Finds the KEGG pathway name from KEGG pathway id.
##' 
##' @details
##' Uses the KEGGREST package to fetch KEGG pathway names dynamically.
##' 
##' @param x a character vector of KEGG pathway ids.
##' @param verbose verbose.
##'
##' @return A character vector with the corresponding KEGG names.
##'
##' @examples
##' getKEGGnames(c("path:hsa00010", "path:hsa00020", "BAD_KEGG"))
##' 
##' @import KEGGREST
##'
##' @export

getKEGGnames <- function(x, verbose = TRUE) {
  
    if (is.data.frame(x) | is.matrix(x)) {
        if (verbose) message("Using row names of the input matrix.")
        x <- rownames(x)
    }
    
    if (verbose) {
        message("Fetching KEGG data online using KEGGREST")
    }

    # Ensure IDs are properly formatted (KEGGREST requires full IDs)
    x <- ifelse(!grepl("^path:", x), paste0("path:hsa", x), x)  # Assumes human (hsa)
    
    # Fetch pathway names from KEGG
    id2name <- sapply(x, function(id) {
        tryCatch({
            keggGet(id)[[1]]$NAME
        }, error = function(e) NA)  # If ID is invalid, return NA
    })
    
    # Warn if any IDs were not found
    if (any(is.na(id2name))) {
        warning(sum(is.na(id2name)), " KEGG ids were not found; missing names generated.")
    }

    return(id2name)
}

4.Reinstall the modified package locally
Run the following in R:
  devtools::install_local("path/to/mdgsa")