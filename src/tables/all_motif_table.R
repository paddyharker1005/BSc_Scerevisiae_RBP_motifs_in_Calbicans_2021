library(ggpubr)
library(readxl)
library(stringr)

table <- read_excel("all_motif_table.xlsx")
table$Method = str_wrap(table$Method, 50)
colnames(table)[4] <- "Method(s)"
tab <- ggtexttable(table, rows=NULL, theme = ttheme(
  colnames.style = colnames_style(color = "black", fill = "#A0A0A0", size = 16),
  tbody.style = tbody_style(color = "black", fill = c("#e6e6e6", "#cdcdcd"))))
