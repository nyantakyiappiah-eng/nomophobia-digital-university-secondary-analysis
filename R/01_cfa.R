# 01_cfa.R
# CFA of NMP-Q (4-factor model) and reliability

library(readxl)
library(lavaan)
library(dplyr)

# 1. Load data ---------------------------------------------------------------

dat <- read_excel("data/Nomophobia-data.xlsx")

# 2. Prepare CFA dataset: rename items i1–i20 --------------------------------

dat_cfa <- dat
nmp_items   <- names(dat)[7:26]
simple_names <- paste0("i", 1:20)
names(dat_cfa)[match(nmp_items, names(dat_cfa))] <- simple_names

# 3. Specify 4-factor model --------------------------------------------------

nmp_model <- '
  Info_access    =~ i1 + i2 + i3 + i4
  Convenience    =~ i5 + i6 + i7 + i8
  Communicate    =~ i9 + i10 + i11 + i12 + i13 + i14 + i15
  Connectedness  =~ i16 + i17 + i18 + i19 + i20
'

# 4. Fit CFA (ordered items) -------------------------------------------------

fit_cfa <- cfa(nmp_model, data = dat_cfa, ordered = simple_names)

summary(fit_cfa, fit.measures = TRUE, standardized = TRUE)

# 5. Export standardized loadings for later use ------------------------------

std_sol <- standardizedSolution(fit_cfa)
loadings_df <- std_sol %>%
  filter(op == "=~") %>%
  select(Factor = lhs, Item = rhs, Loading = est.std)

if (!dir.exists("outputs/tables")) dir.create("outputs/tables", recursive = TRUE)
write.csv(loadings_df, "outputs/tables/Table_CFA_Loadings.csv", row.names = FALSE)
