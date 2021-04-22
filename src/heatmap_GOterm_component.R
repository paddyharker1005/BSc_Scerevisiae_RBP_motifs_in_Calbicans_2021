library(tidyverse)
library(readxl)
library(ggplot2)
library(hrbrthemes)
library(scales)
library(glue)
library(cowplot)
theme_set(theme_cowplot(font_size = 9))
setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Data")
table_GOcomponent <- read_excel("GO_term_component_enrichment.xlsx")

table_GOcomponent <- data.frame(table_GOcomponent)

#Turn your 'Region' column into a character vector
table_GOcomponent$Region <- as.character(table_GOcomponent$Region)
#Then turn it back into a factor with the levels in the correct order
table_GOcomponent$Region <- factor(table_GOcomponent$Region, levels=unique(table_GOcomponent$Region))


table_GOcomponent$GO_term <- as.character(table_GOcomponent$GO_term)
table_GOcomponent$GO_term <- factor(table_GOcomponent$GO_term, levels=unique(table_GOcomponent$GO_term))


heatmap_component <- ggplot(table_GOcomponent, aes(x = RBP, y = GO_term, fill= minuslogP, las = 23)) + 
  geom_tile(color = "black") +
  theme(axis.text.x=element_text(angle=-60,hjust=1), axis.title = element_text(face = "bold"), legend.title = element_text(face = "bold"), legend.position = ("left"), strip.text = element_text(face = "bold")) +
  labs(fill = "-log(P)", x = "RBP motif", y = "Component") +
  scale_x_discrete(position = "top") +
  scale_y_discrete(position = "right", limits = rev(levels(table_GOcomponent$GO_term))) +
  scale_fill_gradientn(limits = c(1, 5), colours=c("white","lightpink", "tomato", "red"), oob=squish, guide = guide_colorbar(title.position = "left")) +
  coord_equal() +
  facet_wrap(~ Region)

