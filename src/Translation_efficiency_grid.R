titleSc <- ggdraw() + draw_label("S. cerevisiae", fontface = 'bold.italic', size = 13, hjust = 0.3)
titleCa <- ggdraw() + draw_label("C. albicans", fontface = 'bold.italic', size = 13, hjust =0.3)

panelb <- plot_grid(Ssd1_boxplot30C, Ssd1_boxplot37Cserum, nrow = 1)

panelbfinal <- plot_grid(titleCa, panelb, ncol = 1, rel_heights= c(0.1, 1))

panelafinal <- plot_grid(titleSc, Sc_boxplot, ncol = 1, rel_heights = c(0.1, 1))

top_row <- plot_grid(panelafinal, panelbfinal, nrow = 1, rel_widths = c(0.5, 1))

paneld <- plot_grid(Khd1_boxplot30C, Khd1_boxplot37Cserum, nrow = 1)

paneldfinal <- plot_grid(titleCa, paneld, ncol = 1, rel_heights= c(0.1, 1))

panelcfinal <- plot_grid(titleSc, Sc_Khd1_boxplot, ncol = 1, rel_heights = c(0.1, 1))

bottom_row <- plot_grid(panelcfinal, paneldfinal, nrow = 1, rel_widths = c(0.5, 1))

finalplot <- plot_grid(top_row, bottom_row, ncol = 1, labels = c("A", "B"))