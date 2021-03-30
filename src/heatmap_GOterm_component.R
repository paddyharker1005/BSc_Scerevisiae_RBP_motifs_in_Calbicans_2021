library(tidyverse)
library(readxl)
library(ggplot2)
library(hrbrthemes)
library(scales)
library(glue)
setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Data")
table_GOcomponent <- read_excel("GO_term_component_enrichment.xlsx")

table_GOcomponent <- data.frame(table_GOcomponent)

#Turn your 'Region' column into a character vector
table_GOcomponent$Region <- as.character(table_GOcomponent$Region)
#Then turn it back into a factor with the levels in the correct order
table_GOcomponent$Region <- factor(table_GOcomponent$Region, levels=unique(table_GOcomponent$Region))


table_GOcomponent$GO_term <- as.character(table_GOcomponent$GO_term)
table_GOcomponent$GO_term <- factor(table_GOcomponent$GO_term, levels=unique(table_GOcomponent$GO_term))


ggplot(table_GOcomponent, aes(x = RBP, y = GO_term, fill= minuslogP, las = 23)) + 
  geom_tile(color = "black") +
  theme(axis.text.x=element_text(angle=-70,hjust=1, size = 10, face = "bold"), axis.title = element_text(size = 15, face = "bold"), axis.text.y = element_text(size=10, face = "bold"), legend.title = element_text(face = "bold"), strip.text = element_text(face = "bold", size = 12)) +
  labs(fill = "-log(P)", x = "RBP motif", y = "GO term") +
  scale_x_discrete(position = "top") +
  scale_y_discrete(position = "right", limits = rev(levels(table_GOcomponent$GO_term))) +
  scale_fill_gradientn(limits = c(1, 5), colours=c("white","lightpink", "tomato", "red"), oob=squish) +
  coord_equal() +
  facet_wrap(~ Region)

