library(here)
library(tidyverse)
library(Biostrings)
library(readxl)
library(dplyr)
library(cat.extras)
library(cowplot)
theme_set(theme_cowplot(font_size = 8))

here::here() 

# define fasta filename
Ca_up1000_file <- paste(here::here(), "Data", "Calbicans_SC5314_ATG_upstream_1000nt_update.fasta",
                        sep= "/")
# load fasta file as DNA string set
Ca_up1000_DSS <- readDNAStringSet(Ca_up1000_file)
# remove truncated sequences, which we don't need.
Ca_up1000_DSS <- Ca_up1000_DSS[width(Ca_up1000_DSS) == 1000]
# assign just the ORF id to the name, but keep all the info. 
Ca_names_up_info <- 
  tibble(everything = names(Ca_up1000_DSS)) %>%
  tidyr::separate(everything,into = c("id","strain","info","seqtype","seq","length"), sep = " \\| ") %>%
  dplyr::select(id, info,seq)
names(Ca_up1000_DSS) <- Ca_names_up_info$id
# print the DNA string set to check it came out ok
Ca_up1000_DSS

## Count occurences in 1000nt 5'UTRs

motif_count_up_df <- tibble(id = Ca_names_up_info$id,
                            info = Ca_names_up_info$info,
                            count_up1000 = vcountPattern(pattern = DNAString("CNYTCNYT"),
                                                         subject = Ca_up1000_DSS,
                                                         fixed = "subject"),
                            count_up200 = vcountPattern(pattern = DNAString("CNYTCNYT"),
                                                        subject = subseq(Ca_up1000_DSS,start = 801L, end = 1000L),
                                                        fixed = "subject"),
                            count_up100 = vcountPattern(pattern = DNAString("CNYTCNYT"),
                                                        subject = subseq(Ca_up1000_DSS,start = 901L, end = 1000L),
                                                        fixed = "subject")
)
summary(motif_count_up_df) 


rename_S1_nicely <- function(colname) {
  str_replace(colname,"37C \\+ serum", "37Cserum") %>%
    str_remove_all("[#.\\(\\)]") %>% 
    str_replace_all("[ ]+", "_") 
}
tableS1 <- read_excel("Dataset S1.xlsx") %>%
  rename_with(rename_S1_nicely)

tableS1 <- tibble::as_tibble(tableS1)

tableS1$Gene_30C_TE <- tableS1$Gene_Ribo_30C_average_TPM / tableS1$Gene_RNA_30C_average_TPM

tableS1$Gene_37Cserum_TE <- tableS1$Gene_Ribo_37C_serum_average_TPM / tableS1$Gene_RNA_37C_serum_average_TPM

joined_tibble30C <- left_join (tableS1, motif_count_up_df, by = c("Gene_ID" = "id")) %>% 
  mutate(count_up100 = replace(count_up100,count_up100>=2, "2+") %>%
         factor(levels=c(0:1,"2+"))) %>%
  filter(Gene_RNA_30C_average_TPM > quantile(Gene_RNA_30C_average_TPM, 0.25)) %>%
  filter(count_up100 != "NA")

Ssd1_boxplot30C <- ggplot(data=joined_tibble30C,
       aes(x=count_up100,y=Gene_30C_TE)) +
  geom_jitter(colour="grey50",size=0.7) +
  geom_boxplot(colour="blue",outlier.colour=NA,fill=NA,size=0.75) +
  scale_y_log10nice("TE of Gene 30C",
                    limits=c(0.05,10),expand=c(0,0),
                    oob=scales::squish) +
  labs(x="CNYUCNYU 5'UTR motif count") +
  ggtitle("30C") +
  theme(axis.text.x = element_text(size = 10), axis.text.y = element_text(size=10), axis.title = element_text(size=10), plot.title = element_text(hjust = 0.5, face = 'bold', size = 10))

joined_tibble37Cserum <- left_join (tableS1, motif_count_up_df, by = c("Gene_ID" = "id")) %>% 
  mutate(count_up100 = replace(count_up100,count_up100>=2, "2+") %>%
           factor(levels=c(0:1,"2+"))) %>%
  filter(Gene_RNA_37C_serum_average_TPM > quantile(Gene_RNA_37C_serum_average_TPM, 0.25)) %>%
  filter(count_up100 != "NA")

Ssd1_boxplot37Cserum <- ggplot(data=joined_tibble37Cserum,
                     aes(x=count_up100,y=Gene_37Cserum_TE)) +
  geom_jitter(colour="grey50",size=0.7) +
  geom_boxplot(colour="blue",outlier.colour=NA,fill=NA,size=0.75) +
  scale_y_log10nice("TE of Gene 37C + serum",
                    limits=c(0.05,10),expand=c(0,0),
                    oob=scales::squish) +
  labs(x="CNYUCNYU 5'UTR motif count") +
  ggtitle("37C + serum") +
  theme(axis.text.x = element_text(size = 10), axis.text.y = element_text(size=10), axis.title = element_text(size=10), plot.title = element_text(hjust = 0.5, face = 'bold', size = 10))
