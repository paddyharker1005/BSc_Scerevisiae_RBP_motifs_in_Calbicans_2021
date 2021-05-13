signalP_CNYTCNYT_df <- data.frame(
  "signalP_no" = c(1149, 4918),
  "signalP_yes" = c(123, 278),
  row.names = c(">=1 CNYUCNYU motif 100nt upstream", "No CNYUCNYU motifs 100nt upstream"),
  stringsAsFactors = FALSE
)

colnames(signalP_CNYTCNYT_df) <- c("No Signal Peptide", "Signal Peptide")

signalP_CNYTCNYT_df

test_CNYTCNYT <- fisher.test(signalP_CNYTCNYT_df)

test_CNYTCNYT

signalP_CNN6_df <- data.frame(
  "signalP_no" = c(1947, 4120),
  "signalP_yes" = c(158, 243),
  row.names = c(">=1 CDS (CNN)6 motif", "No CDS (CNN)6 motifs"),
  stringsAsFactors = FALSE
)

colnames(signalP_CNN6_df) <- c("No Signal Peptide", "Signal Peptide")

test_CNN6 <- fisher.test(signalP_CNN6_df)

test_CNN6