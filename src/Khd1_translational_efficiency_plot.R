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
Ca_CDS_file <- paste(here::here(), "Data", "Calbicans_SC5314_CDS_edited.fasta",
                        sep= "/")
# load fasta file as DNA string set
Ca_CDS_DSS <- readDNAStringSet(Ca_CDS_file)
# assign just the ORF id to the name, but keep all the info. 
Ca_names_CDS_info <- 
  tibble(everything = names(Ca_CDS_DSS)) %>%
  tidyr::separate(everything,into = c("id","strain","info","seqtype","seq","length"), sep = " \\| ") %>%
  dplyr::select(id, info,seq)
names(Ca_CDS_DSS) <- Ca_names_CDS_info$id
# print the DNA string set to check it came out ok
Ca_CDS_DSS

## Count occurences in 1000nt 5'UTRs

motif_count_CDS_df <- tibble(id = Ca_names_CDS_info$id,
                            info = Ca_names_CDS_info$info,
                            count_CDS = vcountPattern(pattern = DNAString("CNNCNNCNNCNNCNNCNN"),
                                                         subject = Ca_CDS_DSS,
                                                         fixed = "subject")
)
summary(motif_count_CDS_df) 


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

joined_tibble30C <- left_join (tableS1, motif_count_CDS_df, by = c("Gene_ID" = "id")) %>% 
  mutate(count_CDS = replace(count_CDS,count_CDS>=2, "2+") %>%
         factor(levels=c(0:1,"2+"))) %>%
  filter(Gene_RNA_30C_average_TPM > quantile(Gene_RNA_30C_average_TPM, 0.25)) %>%
  filter(count_CDS != "NA")

Khd1_boxplot30C <- ggplot(data=joined_tibble30C,
       aes(x=count_CDS,y=Gene_30C_TE)) +
  geom_jitter(colour="grey50",size=0.7) +
  geom_boxplot(colour="blue",outlier.colour=NA,fill=NA,size=0.75) +
  scale_y_log10nice("TE of Gene 30C",
                    limits=c(0.05,10),expand=c(0,0),
                    oob=scales::squish) +
  labs(x="(CNN)6 CDS motif count")

joined_tibble37Cserum <- left_join (tableS1, motif_count_CDS_df, by = c("Gene_ID" = "id")) %>% 
  mutate(count_CDS = replace(count_CDS,count_CDS>=2, "2+") %>%
           factor(levels=c(0:1,"2+"))) %>%
  filter(Gene_RNA_37C_serum_average_TPM > quantile(Gene_RNA_37C_serum_average_TPM, 0.25)) %>%
  filter(count_CDS != "NA")

Khd1_boxplot37Cserum <- ggplot(data=joined_tibble37Cserum,
                     aes(x=count_CDS,y=Gene_37Cserum_TE)) +
  geom_jitter(colour="grey50",size=0.7) +
  geom_boxplot(colour="blue",outlier.colour=NA,fill=NA,size=0.75) +
  scale_y_log10nice("TE of Gene 37C + serum",
                    limits=c(0.05,10),expand=c(0,0),
                    oob=scales::squish) +
  labs(x="(CNN)6 CDS motif count")
