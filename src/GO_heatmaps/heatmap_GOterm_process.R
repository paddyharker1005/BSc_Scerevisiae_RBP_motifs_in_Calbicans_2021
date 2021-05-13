library(tidyverse)
library(readxl)
library(ggplot2)
library(hrbrthemes)
library(scales)
library(glue)
library(cowplot)
theme_set(theme_cowplot(font_size = 9))
setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Data")
table_GOprocess <- read_excel("GO_term_process_enrichment.xlsx")

table_GOprocess <- data.frame(table_GOprocess)

#Turn your 'Region' column into a character vector
table_GOprocess$Region <- as.character(table_GOprocess$Region)
#Then turn it back into a factor with the levels in the correct order
table_GOprocess$Region <- factor(table_GOprocess$Region, levels=unique(table_GOprocess$Region))
table_GOprocess$GO_term <- as.character(table_GOprocess$GO_term)
table_GOprocess$GO_term <- factor(table_GOprocess$GO_term, levels=unique(table_GOprocess$GO_term))


heatmap_process <- ggplot(table_GOprocess, aes(x = RBP, y = GO_term, fill= minuslogP, las = 23)) + 
  geom_tile(color = "black") +
  theme(axis.text.x=element_text(angle=-60,hjust=1), axis.title = element_text(face = "bold"), legend.title = element_text(face = "bold"), legend.position = ("left"), strip.text = element_text(face = "bold")) +
  labs(fill = "-log(P)", x = "RBP motif", y = "Process") +
  scale_x_discrete(position = "top") +
  scale_y_discrete(position = "right", limits = rev(levels(table_GOprocess$GO_term))) +
  scale_fill_gradientn(limits = c(1, 5), colours=c("white","skyblue", "royalblue", "blue"), oob=squish, guide = guide_colorbar(title.position = "left")) +
  coord_equal() +
  facet_wrap(~ Region)

