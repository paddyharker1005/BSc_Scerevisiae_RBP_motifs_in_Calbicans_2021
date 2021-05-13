library(here)
library(tidyverse)
library(Biostrings)
library(readxl)
library(dplyr)
library(cat.extras)
library(VennDiagram)
library(cowplot)
library(RColorBrewer)
library(hrbrthemes)


theme_set(theme_cowplot(font_size = 8))
setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Results/SignalP searches")
table_signalP <- read_excel("SignalP_Calbicans.xlsx")
table_signalP <- table_signalP %>% filter(table_signalP$Prediction == "SP(Sec/SPI)")

signalP_list <- paste(table_signalP$Gene_ID)

setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Results/Motif searches/Ssd1 Alternative")
CNYTCNYT_up100_list <- readLines("Ca_id_list_CNYTCNYT1_up100.txt")

setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Results/Plots")
venn.diagram(x = list(CNYTCNYT_up100_list, signalP_list), 
             category.names = c(">=1 CNYTCNYT motif 100nt upstream" , "Signal peptide"),
             filename = 'IMGvenn2.png',
             output = TRUE, 
             imagetype="png",
             height = 600 , 
             width = 600,  , 
             resolution = 300,
             compression = "lzw", 
             lwd = 1, 
             col=c("#440154ff", '#21908dff'), fill = c(alpha("#440154ff",0.3), alpha('#21908dff',0.3)),  
             cex = 0.5,
             fontfamily = "sans",
             cat.cex = 0.3,
             cat.default.pos = "outer",
             cat.pos = c(-20, 20),
             cat.dist = c(0.055, 0.055),
             cat.fontfamily = "sans",
             cat.col = c("#440154ff", '#21908dff')
)
