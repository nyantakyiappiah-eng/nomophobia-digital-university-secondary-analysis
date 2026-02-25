# Nomophobia in a Digitalized University: Secondary Analysis

Secondary analysis of university nomophobia data: CFA, nonlinear smartphone‑use models, and temporal routines for a Technology in Society submission.

This repository contains the **analysis code**, **project structure**, and **manuscript outline** for a secondary analysis of nomophobia among undergraduate students at a public university. The underlying dataset is **not public** but can be provided on reasonable request to the original data owners; this repo is intended to make the analytic workflow transparent for reviewers and collaborators.

---

## Project overview

**Aim**

To examine how nomophobia among university students is related to:

- Daily smartphone use (including nonlinear/threshold patterns),
- Temporal routines of use (especially early‑morning checking),
- Socio‑demographic characteristics (gender, age),
- Faculty affiliation (disciplinary context),

using the 20‑item Nomophobia Questionnaire (NMP‑Q; Yildirim & Correia, 2015) and multivariate regression models.

**Key components**

1. **Measurement model**  
   - Confirmatory factor analysis (CFA) of the NMP‑Q four‑factor structure:  
     - Information access  
     - Convenience  
     - Communication  
     - Connectedness  
   - Extraction of standardized loadings and reliability estimates.

2. **Regression models**  
   - Linear model of total nomophobia on gender, age, faculty, daily hours, checking frequency, morning use.  
   - Nonlinear (quadratic) model of daily hours to test threshold effects.  
   - Faculty‑adjusted model with faculty as a factor.  
   - Quartile profiles of nomophobia and associated usage patterns.

3. **Figures and tables**  
   - **Figure 1**: Standardized NMP‑Q factor loadings.  
   - **Figure 2**: Predicted total nomophobia by daily smartphone use (hours) and gender.  
   - CSV tables of CFA loadings, VIF diagnostics, and quartile profiles.

The analyses are implemented in R and organized into three main scripts.

---

## Repository structure

```text
nomophobia-digital-university-secondary-analysis/
  R/
    01_cfa.R                 # CFA and standardized loadings
    02_regression_models.R   # Main and extended regression analyses
    03_figures.R             # Figure 1 (CFA loadings) and Figure 2 (interaction)
  data/
    # Nomophobia-data.xlsx (NOT tracked; place here locally)
  outputs/
    figures/
      # Figure1_Loadings.tiff
      # Figure2_Gender_Hours_Interaction.tiff
    tables/
      # Table_CFA_Loadings.csv
      # Table_S1_VIF.csv
      # Table_S2_QuartileProfiles.csv
  manuscript/
    manuscript_outline.md     # Title, abstract, and section skeleton
  .gitignore
  LICENSE
  README.md
