library(tidyverse)
library(readxl)
library(ggplot2)
library(scales)
library(cowplot)
theme_set(theme_cowplot(font_size = 12))

setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Data")

table_GOprocess_Khd1 <- read_excel("GO_Khd1_all_motif_process.xlsx")

process_lollipop <- ggplot(table_GOprocess_Khd1, aes(x= GO_term, y= minuslogP, fill = motif, colour = motif)) +
  geom_segment(aes(x=reorder(GO_term, minuslogP), xend=GO_term, y=0, yend=minuslogP), colour = "black") +
  geom_point(size = 2.5) +
  scale_colour_manual(values = c("(CNN)6" = "brown2", "HWNCATTWY" = "deepskyblue", "SECReTE" = "darkorange")) +
  scale_y_continuous(limits = c(2,35), oob = rescale_none) +
  labs(x = "Process", y = "-log(P)", colour = "Khd1 motif", fill= "Khd1 motif") +
  coord_flip() +
  theme(axis.title = element_text(face = "bold"), legend.title = element_text(face = "bold"))

