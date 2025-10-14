new.pkgs <- c("tidyverse", "argparse", "shinyjs", "shinyalert", "DT", "dplyr", "pillar", "this.path", "readxl", "writexl")
for (pkg in new.pkgs){
  if (pkg %in% installed.packages() == FALSE){
    install.packages(pkg)
  }  
}
new.bioc.pkgs <- c("pathview", "clusterProfiler",  
"DOSE", "org.Hs.eg.db", "org.Mm.eg.db", "scRepertoire",
"biomaRt", "msigdbr")
for (pkg in new.bioc.pkgs){
  if (pkg %in% installed.packages() == FALSE){
    BiocManager::install(pkg, update = FALSE)
  }  
}

if ("DoubletFinder" %in% installed.packages() == FALSE){
  remotes::install_github('chris-mcginnis-ucsf/DoubletFinder', force = TRUE)
}
BiocManager::install('glmGamPoi', update = FALSE)
