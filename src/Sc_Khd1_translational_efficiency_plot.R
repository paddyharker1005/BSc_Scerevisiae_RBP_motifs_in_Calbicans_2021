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
Sc_CDS_file <- paste(here::here(), "Data", "Scerevisiae_s288c_CDS.fasta",
                        sep= "/")
# load fasta file as DNA string set
Sc_CDS_DSS <- readDNAStringSet(Sc_CDS_file)
# assign just the ORF id to the name, but keep all the info. 
Sc_names_CDS_info <- 
  tibble(everything = names(Sc_CDS_DSS)) %>%
  tidyr::separate(everything,into = c("id","strain","info","seqtype","seq","length"), sep = " \\| ") %>%
  dplyr::select(id, info,seq)
names(Sc_CDS_DSS) <- Sc_names_CDS_info$id
# print the DNA string set to check it came out ok
Sc_CDS_DSS

## Count occurences in 1000nt 5'UTRs

Sc_motif_count_CDS_df <- tibble(id = Sc_names_CDS_info$id,
                            info = Sc_names_CDS_info$info,
                            count_CDS = vcountPattern(pattern = DNAString("CNYTCNYT"),
                                                         subject = Sc_CDS_DSS,
                                                         fixed = "subject"))
summary(Sc_motif_count_CDS_df) 


table_RPF <- read_excel("GSE75897_RPF_RPKMs.xlsx")
table_RPF <- tibble::as_tibble(table_RPF)
table_RNA <- read_excel("GSE75897_RiboZero_RPKMs.xlsx")
table_RNA <- tibble::as_tibble(table_RNA)

Sc_joined_tibble <- left_join(table_RPF, table_RNA, by = c("id"))
Sc_joined_tibble$TE <- Sc_joined_tibble$RPF_RPKM / Sc_joined_tibble$RNA_RPKM
Sc_joined_tibble <- left_join(Sc_motif_count_CDS_df, Sc_joined_tibble, by = c("id")) %>% 
  mutate(count_CDS = replace(count_CDS,count_CDS>=2, "2+") %>%
           factor(levels=c(0:1,"2+"))) %>% 
  filter(TE != "NA") %>%
  filter(count_CDS != "NA") %>%
  filter(RNA_RPKM > quantile(RNA_RPKM, 0.25))

Sc_Khd1_boxplot <- ggplot(data=Sc_joined_tibble,
       aes(x=count_CDS,y=TE)) +
  geom_jitter(colour="grey50",size=0.7) +
  geom_boxplot(colour="blue",outlier.colour=NA,fill=NA,size=0.75) +
  scale_y_log10nice("TE of Gene",
                    limits=c(0.05,10),expand=c(0,0),
                    oob=scales::squish) +
  labs(x="(CNN)6 CDS motif count")

