library(tidyverse)
library(readxl)
library(ggplot2)
library(scales)
library(cowplot)
theme_set(theme_cowplot(font_size = 12))

setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Data")
table_GOprocess <- read_excel("GO_Ssd1_all_motif_process.xlsx")

table_GOprocess <- data.frame(table_GOprocess)

Ssd1_process_heatmap <- ggplot(table_GOprocess, aes(x = motif, y = GO_term, fill= minuslogP, las = 23)) + 
  geom_tile(color = "black") +
  theme(axis.text.x=element_text(angle=-90,hjust=1), axis.title = element_text(face = "bold"), legend.title = element_text(face = "bold"), legend.position = ("left")) +
  labs(fill = "-log(P)", x = "Ssd1 motif", y = "Process") +
  scale_x_discrete(position = "top") +
  scale_y_discrete(position = "right", limits = rev) +
  scale_fill_gradientn(limits = c(1, 5), colours=c("white","skyblue", "royalblue", "blue"), oob=squish, guide = guide_colorbar(title.position = "left")) +
  coord_equal()

