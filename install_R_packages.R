################################################################################
# This script is used to clean the envrionment and import all necessary packages
################################################################################
# Specify the list of packages that need to be imported ########################
list.of.packages <- c("BiocManager",
                      "optparse", 
                      "tidyverse", 
                      "ggplot2", 
                      "SoupX",
                      "comprehenr",
                      "DoubletFinder",
                      "vroom",
                      "hash",
                      "DT",
                      "janitor",
                      "knitr",
                      "circlize",
                      "formattable",
                      "htmlwidgets",
                      "plotly",
                      "stringr",
                      "rcompanion",
                      "argparse",
                      "scatterpie", 
                      "scales",
                      "rstatix",
                      "remotes",
                      "PPCI",
                      "writexl",
                      "devtools",
                      "svglite",
                      "lme4",
                      "ggpubr", 
                      "testit", 
                      "heatmaply",
                      "devtools",
                      "sp",
                      "shiny",
                      "tidyverse",
                      "dplyr"
)

bioc.packages <- c("Seurat",
                   "SingleCellExperiment", 
                   "celda", 
                   "BiocSingular", 
                   "PCAtools", 
                   "SingleCellExperiment",
                   "scRepertoire", 
                   "sctransform", 
                   "progeny",
                   "powerTCR",
                   "scRepertoire",
                   "org.Hs.eg.db",
                   "org.Mm.eg.db",
                   "DESeq2",
                   "diptest",
                   "CATALYST",
                   "HDCytoData",
                   "diffcyt",
                   "FlowSOM",
                   "flowCore", 
                   "scater",
                   "enrichplot", 
                   "monocle",
                   "celldex",
                   "clusterProfiler")

# Check if packages are installed ##############################################

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
new.bioc.packages <- bioc.packages[!(bioc.packages %in% installed.packages()[,"Package"])]

# Install new packages #########################################################
if(length(new.packages)) install.packages(new.packages)
if(length(new.bioc.packages)) BiocManager::install(new.bioc.packages, update = FALSE, ask = TRUE)

# Import all packages ##########################################################
package_loading_Status <- lapply(list.of.packages, 
                                 require, 
                                 character.only = TRUE)

package_loading_Status_bioc <- lapply(bioc.packages, 
                                      require, 
                                      character.only = TRUE)


#####
#####----------------------------------------------------------------------#####
##### UPGRADE THE CLUSTERPROFILER PACKAGES
install.packages("devtools")
devtools::install_github("YuLab-SMU/yulab.utils", upgrade = "never")
remotes::install_github("GuangchuangYu/GOSemSim", upgrade = "never")
remotes::install_github("GuangchuangYu/clusterProfiler", upgrade = "never")

##### install cellchat v2 from my github repo
if ("CellChat" %in% installed.packages()){
  remove.packages("CellChat")
}

devtools::install_github("immunogenomics/presto", upgrade = "never")
devtools::install_github("https://github.com/hieunguyen4193/CellChatv2_862ab34", upgrade = "never")

##### temporary fix --> https://github.com/jinworks/CellChat/issues/202
# cellchat.sample1@data.smooth <- cellchat.sample1@data.project
# cellchat.sample2@data.smooth <- cellchat.sample2@data.project
##### issue: non conformable array: https://github.com/sqjin/CellChat/issues/708
##### https://github.com/jinworks/CellChat/issues/159

reticulate::install_python(version = '3.8')
reticulate::py_install(packages = 'umap-learn')