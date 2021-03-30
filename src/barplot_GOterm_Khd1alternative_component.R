
library(tidyverse)
library(readxl)
library(ggplot2)
library(scales)

setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Data")

table_GOcomponent_Khd1 <- read_excel("GO_term_Khd1_alternative_component.xlsx")

ggplot(table_GOcomponent_Khd1, aes(x= reorder(GO_term, minuslogP), y= minuslogP)) +
  geom_point(colour = 'red') +
  geom_segment(aes(x=GO_term, xend=GO_term, y=0, yend=minuslogP), colour = 'red') +
  scale_y_continuous(limits = c(2,16), oob = rescale_none) +
  labs(x = "GO term", y = "-log(P)") +
  coord_flip() +
  theme_bw() +
  theme(axis.title = element_text(size = 15, face = "bold"), axis.text = element_text(size=10, face = "bold"))

