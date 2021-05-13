library(png)
library(cowplot)
library(readxl)
library(ggplot2)

setwd("~/Documents/SENIOR HONOURS/Honours Project 20:21/Results/Motif analysis/Novel motif search/plots")
img <- readPNG("100nt_upstream_filamentous_growth_classic.png")


img2 <- readPNG("CDS_filamentous_growth_classic.png")

img3 <- readPNG("200nt_downstream_filamentous_growth_classic.png")

img4 <- readPNG("CDS_filamentous_growth_differentialenrichment.png")

table <- read_excel("motif_table.xlsx")
table <- gridExtra::tableGrob(table, rows = NULL)

table <- ggplot() + theme(axis.line = element_blank(), panel.background = element_rect(fill = "white")) + annotation_custom(table)





img <- ggplot2::ggplot() + ggplot2::annotation_custom(grid::rasterGrob(img,
                                                                width=ggplot2::unit(1,"npc"),
                                                                height=ggplot2::unit(1,"npc")),
                                               -Inf, Inf, -Inf, Inf) + theme(axis.line = element_blank(), panel.background = element_rect(fill = "white"))

img2 <- ggplot2::ggplot() + ggplot2::annotation_custom(grid::rasterGrob(img2,
                                                                        width=ggplot2::unit(1,"npc"),
                                                                        height=ggplot2::unit(1,"npc")),
                                                       -Inf, Inf, -Inf, Inf) + theme(axis.line = element_blank(), panel.background = element_rect(fill = "white"))

img3 <- ggplot2::ggplot() + ggplot2::annotation_custom(grid::rasterGrob(img3,
                                                                        width=ggplot2::unit(1,"npc"),
                                                                        height=ggplot2::unit(1,"npc")),
                                                       -Inf, Inf, -Inf, Inf) + theme(axis.line = element_blank(), panel.background = element_rect(fill = "white"))

img4 <- ggplot2::ggplot() + ggplot2::annotation_custom(grid::rasterGrob(img4,
                                                                        width=ggplot2::unit(1,"npc"),
                                                                        height=ggplot2::unit(1,"npc")),
                                                       -Inf, Inf, -Inf, Inf) + theme(axis.line = element_blank(), panel.background = element_rect(fill = "white"))



grid <- plot_grid(img, img2, img3, img4, labels = c("A", "B", "C", "D"), ncol = 4)

grid <- plot_grid(grid, table, ncol = 1, labels = c("", "E"))

grid <- plot_grid(grid, img4, ncol = 1, labels = c("", "D"), rel_widths = c(5, 1))


grid <- plot_grid(grid, table, rel_widths = c(1,4), ncol = 1, labels = c("", "E"))


