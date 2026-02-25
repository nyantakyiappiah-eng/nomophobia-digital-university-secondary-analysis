# 03_figures.R
# Figures: CFA loadings (Figure 1) and gender × hours interaction (Figure 2)

library(readxl)
library(lavaan)
library(dplyr)
library(ggplot2)

if (!dir.exists("outputs/figures")) dir.create("outputs/figures", recursive = TRUE)

# 1. CFA loading plot (Figure 1) ---------------------------------------------

dat <- read_excel("data/Nomophobia-data.xlsx")

dat_cfa <- dat
nmp_items   <- names(dat)[7:26]
simple_names <- paste0("i", 1:20)
names(dat_cfa)[match(nmp_items, names(dat_cfa))] <- simple_names

nmp_model <- '
  Info_access    =~ i1 + i2 + i3 + i4
  Convenience    =~ i5 + i6 + i7 + i8
  Communicate    =~ i9 + i10 + i11 + i12 + i13 + i14 + i15
  Connectedness  =~ i16 + i17 + i18 + i19 + i20
'

fit_cfa <- cfa(nmp_model, data = dat_cfa, ordered = simple_names)
std_sol <- standardizedSolution(fit_cfa)

loadings_df <- std_sol %>%
  filter(op == "=~") %>%
  select(Factor = lhs, Item = rhs, Loading = est.std) %>%
  group_by(Factor) %>%
  arrange(desc(Loading), .by_group = TRUE) %>%
  mutate(Item = factor(Item, levels = rev(Item))) %>%
  ungroup()

tiff("outputs/figures/Figure1_Loadings.tiff",
     width = 2400, height = 1600, res = 300, compression = "lzw")

ggplot(loadings_df,
       aes(x = Loading, y = Item, color = Factor, shape = Factor)) +
  geom_point(size = 3) +
  geom_vline(xintercept = 0.40, linetype = "dashed", color = "grey60") +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  labs(x = "Standardized factor loading", y = "NMP-Q items") +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    axis.text.y = element_text(size = 10),
    panel.grid.minor = element_blank()
  )

dev.off()

# 2. Gender × hours interaction (Figure 2) -----------------------------------

dat$Gender_f <- factor(dat$Gender,
                       levels = c(1, 2),
                       labels = c("Male", "Female"))
dat$hours_num <- as.numeric(dat$How_many_hourse_in_day)

lm_int <- lm(NoMoFobi ~ Gender_f * hours_num +
               Age + Faculty +
               How_often_do_you_check +
               In_the_morning_when_I_wake_up,
             data = dat)

newdat <- expand.grid(
  hours_num = 1:5,
  Gender_f  = levels(dat$Gender_f)
)

newdat$Age  <- mean(dat$Age, na.rm = TRUE)
newdat$Faculty <- mean(dat$Faculty, na.rm = TRUE)
newdat$How_often_do_you_check <- mean(dat$How_often_do_you_check, na.rm = TRUE)
newdat$In_the_morning_when_I_wake_up <- mean(dat$In_the_morning_when_I_wake_up, na.rm = TRUE)

newdat$pred_NoMo <- predict(lm_int, newdata = newdat)

tiff("outputs/figures/Figure2_Gender_Hours_Interaction.tiff",
     width = 2400, height = 1600, res = 300, compression = "lzw")

ggplot(newdat,
       aes(x = hours_num, y = pred_NoMo,
           color = Gender_f, group = Gender_f)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  scale_x_continuous(breaks = 1:5,
                     labels = c("1–2h", "3–4h", "5–6h", "7–8h", "9–10h")) +
  labs(x = "Daily smartphone use (hours)",
       y = "Predicted total nomophobia (NoMoFobi)",
       color = "Gender") +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

dev.off()
