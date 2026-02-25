# 02_regression_models.R
# Regressions for total nomophobia and extended models

library(readxl)
library(dplyr)
library(car)
library(MASS)

# 1. Load data ---------------------------------------------------------------

dat <- read_excel("data/Nomophobia-data.xlsx")

# 2. Basic recodes -----------------------------------------------------------

dat$Gender_f <- factor(dat$Gender,
                       levels = c(1, 2),
                       labels = c("Male", "Female"))

dat$hours_num <- as.numeric(dat$How_many_hourse_in_day)
dat$Faculty_f <- factor(dat$Faculty)

# 3. Main linear model (total nomophobia) -----------------------------------

lm_total <- lm(NoMoFobi ~ Gender + Age + Faculty +
                 How_many_hourse_in_day +
                 How_often_do_you_check +
                 In_the_morning_when_I_wake_up,
               data = dat)

summary(lm_total)
vif_results <- car::vif(lm_total)

# 4. Robust regression (sensitivity) -----------------------------------------

lm_robust <- MASS::rlm(NoMoFobi ~ Gender + Age + Faculty +
                         How_many_hourse_in_day +
                         How_often_do_you_check +
                         In_the_morning_when_I_wake_up,
                       data = dat)

summary(lm_robust)

# 5. Quadratic hours model ---------------------------------------------------

dat$hours_c  <- scale(dat$hours_num, center = TRUE, scale = FALSE)
dat$hours_c2 <- dat$hours_c^2

lm_hours_quad <- lm(NoMoFobi ~ Gender + Age + Faculty +
                      hours_c + hours_c2 +
                      How_often_do_you_check +
                      In_the_morning_when_I_wake_up,
                    data = dat)

summary(lm_hours_quad)

# 6. Faculty model with factor -----------------------------------------------

lm_faculty <- lm(NoMoFobi ~ Gender + Age + Faculty_f +
                   hours_num +
                   How_often_do_you_check +
                   In_the_morning_when_I_wake_up,
                 data = dat)

anova_faculty <- anova(lm_faculty)
summary(lm_faculty)

# 7. Quartile profile of nomophobia -----------------------------------------

dat$NoMo_group <- cut(
  dat$NoMoFobi,
  breaks = quantile(dat$NoMoFobi, probs = c(0, .25, .5, .75, 1), na.rm = TRUE),
  include.lowest = TRUE,
  labels = c("Lowest 25%", "25–50%", "50–75%", "Highest 25%")
)

profile_means <- aggregate(cbind(hours_num,
                                 How_often_do_you_check,
                                 In_the_morning_when_I_wake_up) ~ NoMo_group,
                           data = dat, FUN = mean)

if (!dir.exists("outputs/tables")) dir.create("outputs/tables", recursive = TRUE)

write.csv(vif_results,      "outputs/tables/Table_S1_VIF.csv")
write.csv(profile_means,    "outputs/tables/Table_S2_QuartileProfiles.csv", row.names = FALSE)
