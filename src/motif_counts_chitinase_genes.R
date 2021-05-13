library(readr)
library(magrittr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(cowplot)
setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Scerevisiae_RBP_motifs_Calbicans/Data")
features <- read_tsv("chitinase_homologs_features.txt", 
                     comment = "#", col_types = "cccciiiiii") %>%
  mutate(SpName = paste(Species,Name,sep="_"))

features$SpName <- factor(features$SpName, levels = features$SpName)

features_long <- 
  features %>%
  select(SpName, CNYUCNYU_5,CNYUCNYU_CDS,CNYUCNYU_3, CNN_5, CNN_CDS, CNN_3) %>%
  pivot_longer(c(CNYUCNYU_5,CNYUCNYU_CDS,CNYUCNYU_3, CNN_5, CNN_CDS, CNN_3)) %>%
  separate(name,c("motif","region"),remove = FALSE) %>%
  mutate(region = factor(region, 
                         levels = c("5","CDS","3"), 
                         labels = c("5′UTR","CDS","3′UTR"))) %>%
  mutate(present = value > 0)



plot_CNYUCNYU <- 
  ggplot(data=filter(features_long, motif == "CNYUCNYU"), aes(x=region, y=SpName)) +
  geom_raster(aes(fill=present)) +
  geom_text(aes(label = value)) +
  scale_fill_manual(values = c("TRUE" = "#2b9744", "FALSE" = NA)) +
  theme_void() + 
  ggtitle("CNYUCNYU\ncount") +
  theme(axis.text.x = element_text(angle=90, size = 13),
        plot.title = element_text(colour = "#2b9744", hjust = 0.5, face = 'bold'),
        legend.position = "none")

plot_CNN <- 
  ggplot(data=filter(features_long, motif == "CNN"), aes(x=region,y=SpName)) +
  geom_raster(aes(fill=present)) +
  geom_text(aes(label = value)) +
  scale_fill_manual(values = c("TRUE" = "#3fa6b0", "FALSE" = NA)) +
  theme_void() + 
  labs(y = "Homologous chitinase genes") + 
  ggtitle("(CNN)6\ncount") +
  theme(axis.text.x = element_text(angle=90, size = 13), 
        axis.text.y = element_text(angle=0, size = 10, face = 'bold', margin = margin(l = 5)),
        axis.title.y = element_text(angle=90, size = 15, margin = margin(b = 5)),
        plot.title = element_text(colour = "#3fa6b0", hjust = 0.5, face = 'bold'),
        legend.position = "none")

plot_features <- 
  plot_grid(plot_CNN, plot_CNYUCNYU,
            nrow=1,align="h", rel_widths = c(1.5,1), labels = c("A","B"))