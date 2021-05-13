library(tidyverse)
library(readxl)
library(ggplot2)
library(hrbrthemes)
library(scales)
library(glue)
library(cowplot)
theme_set(theme_cowplot(font_size = 12))

setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Data")
table_GOcomponent <- read_excel("GO_Ssd1_all_motif_component.xlsx")

table_GOcomponent <- data.frame(table_GOcomponent)

Ssd1_component_heatmap <- ggplot(table_GOcomponent, aes(x = motif, y = GO_term, fill= minuslogP, las = 23)) + 
  geom_tile(color = "black") +
  theme(axis.text.x=element_text(angle=-90,hjust=1), axis.title = element_text(face = "bold"), legend.title = element_text(face = "bold"), legend.position = ("left")) +
  labs(fill = "-log(P)", x = "Ssd1 motif", y = "Component") +
  scale_x_discrete(position = "top") +
  scale_y_discrete(position = "right", limits = rev) +
  scale_fill_gradientn(limits = c(1, 5), colours=c("white","lightpink", "tomato", "red"), oob=squish, guide = guide_colorbar(title.position = "left")) +
  coord_equal()

