# County variation in women’s access to mental-health diagnosis and treatment in California

Research memo — September 4, 2026

## Bottom line

No public dataset I found simultaneously provides all of the following: all California women, direct measures of need/diagnosis/treatment, sex or gender stratification, and usable estimates for all 58 individual counties.

The best match to the question as written is the **2024 California Health Interview Survey (CHIS), queried through AskCHIS**, because it directly asks about perceived need, provider visits, treatment, insurance coverage, and barriers, and it can be filtered to women. It supports **41 individual counties**; the other 17 counties appear only in three multi-county groups. Female-by-county estimates may be missing or statistically unstable, so years should be pooled when possible and only stable estimates should be reported.

If coverage of **all 58 counties** is mandatory, narrow the question to **adult female Medi-Cal beneficiaries** and use the **DHCS Behavioral Health Program Performance Data**. It records actual service use and has female rows for every county, though privacy suppression leaves 56–57 counties with usable rate components in a given year/system.

## Proposed research plan

1. Define the population before analysis. Use either (a) adult women in the 41 individually identified CHIS counties, or (b) adult female Medi-Cal beneficiaries in all 58 counties. Do not describe a Medi-Cal or recent-birth result as applying to all California women.
2. Define separate outcomes rather than one vague “access” measure:
   - diagnostic access: receipt of a mental-health screening or diagnostic evaluation;
   - realized treatment access: any counseling, therapy, medication, or mental-health service;
   - unmet access: perceived need without a provider visit, including cost or appointment barriers;
   - diagnosed prevalence: a condition documented or reported as diagnosed, treated as a contextual outcome rather than proof of access.
3. For the main CHIS analysis, select current gender = female (`AD66C=2`), use the direct access variables listed below, and request the longest defensible pooled period available in AskCHIS. Retain only the 41 named single-county strata. Do not relabel the three small-county groups as county estimates.
4. Report weighted percentages and 95% confidence intervals. Flag or omit AskCHIS estimates marked unstable or blank. A useful primary outcome is the percentage of women with perceived need (`AF81`) who saw a primary-care or other professional (`AF74` or `AF75`).
5. Use DHCS as a complementary all-county analysis. For each delivery system separately, calculate the female penetration rate as `100 × MHS1_CT / TOTAL_CT`; also examine `MHS5_CT / TOTAL_CT`. Never add NSMHS and SMHS counts because a beneficiary may appear in both systems.
6. Use MIHA only for a clearly labeled maternal subanalysis: screening and treatment among people with a recent live birth in the 35 published counties.
7. Compare counties descriptively, retain uncertainty and suppression flags, and avoid ranking modeled PLACES estimates. Investigate contextual explanations—rurality, insurance mix, provider supply, and county program structure—only after establishing the access measures.

## Dataset assessment

### 1. PLACES: Local Data for Better Health, County Data, 2025 release

1. **Exact dataset name:** *PLACES: Local Data for Better Health, County Data, 2025 release*.
2. **Organization:** U.S. Centers for Disease Control and Prevention (CDC), Division of Population Health.
3. **Exact source URL:** [CDC PLACES county dataset](https://data.cdc.gov/500-Cities-Places/PLACES-Local-Data-for-Better-Health-County-Data-20/swc5-untb); [2025 release notes](https://www.cdc.gov/places/current-release-notes/index.html).
4. **Year(s):** 2025 release. The mental-health measures use 2023 BRFSS data; CDC reports that 35 of the release’s 40 measures use 2023 BRFSS, while five unrelated rotating measures use 2022 data.
5. **Exact variables:** `MeasureId = DEPRESSION` and `MeasureId = MHLTH`, with `Data_Value_Type` values for crude and age-adjusted prevalence, `Data_Value`, `Low_Confidence_Limit`, `High_Confidence_Limit`, `LocationName`, and `LocationID`.
6. **What they measure:** `DEPRESSION` is modeled lifetime prevalence of adults ever told by a doctor, nurse, or other health professional that they had a depressive disorder. `MHLTH` is modeled prevalence of adults reporting at least 14 mentally unhealthy days in the past 30 days. See the official [depression](https://www.cdc.gov/places/measure-definitions/health-outcomes.html) and [frequent mental distress](https://www.cdc.gov/places/measure-definitions/health-status.html) definitions.
7. **Women-specific/filterable by sex:** No. Sex is used inside the model, but CDC publishes only one estimate for the total adult population of each geography; [stratified estimates are not available](https://www.cdc.gov/places/faqs/data-faqs/index.html).
8. **Geographic level:** County, place, census tract, and ZCTA; this file is county-level.
9. **Individual California counties available:** Yes, but only for all adults.
10. **Number of California counties represented:** 58.
11. **Direct access or proxy:** `DEPRESSION` is a **proxy for diagnostic contact** and an outcome; it is not a measure of whether people who needed diagnosis obtained it. `MHLTH` is a need/outcome proxy, not access.
12. **Important limitations:** Small-area modeled rather than direct county estimates; no sex strata; lifetime depression mixes old and recent diagnoses; no treatment, unmet need, wait-time, or affordability measure; CDC cautions against using PLACES for local program evaluation or ranking counties.

**Fit:** useful contextual map, but it cannot answer the women-specific access question.

### 2. 2024 National Health Interview Survey, Sample Adult Interview

1. **Exact dataset name:** *2024 National Health Interview Survey (NHIS), Sample Adult Interview*.
2. **Organization:** CDC, National Center for Health Statistics (NCHS).
3. **Exact source URL:** [2024 NHIS datasets and documentation](https://www.cdc.gov/nchs/nhis/documentation/2024-nhis.html); [Sample Adult variable summary](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2024/Adult-summary.pdf).
4. **Year(s):** 2024; comparable files are released annually.
5. **Exact variables:** `MHRX_A`, `MHTHRPY_A`, `MHTPYNOW_A`, `MHTHDLY_A`, `MHTHND_A`, `ANXEV_A`, `DEPEV_A`, and `SEX_A`.
6. **What they measure:** mental-health medication in the past year; counseling/therapy in the past year; currently receiving therapy; delayed therapy due to cost; needed but did not get therapy due to cost; ever diagnosed anxiety; ever diagnosed depression; and respondent sex.
7. **Women-specific/filterable by sex:** Filterable using `SEX_A`.
8. **Geographic level:** National/public-use geography only at broad region; detailed geography is restricted through the NCHS Research Data Center.
9. **Individual California counties available:** No in the public-use file.
10. **Number of California counties represented:** 0 publicly identifiable counties.
11. **Direct access or proxy:** The therapy, delay, and unmet-need variables are direct access measures; diagnosis variables are outcomes/proxies.
12. **Important limitations:** NHIS is not designed to produce public county estimates; restricted geocodes do not guarantee adequate county samples; it therefore fails the required geographic criterion despite excellent variables. See the [restricted-use geography rules](https://www.cdc.gov/rdc/restricted-nchs-variables/nhis.html).

**Fit:** excellent concepts, unusable for the requested county comparison.

### 3. 2024 California Health Interview Survey (CHIS), Adult Survey / AskCHIS

1. **Exact dataset name:** *2024 California Health Interview Survey (CHIS), Adult Survey*; estimates are queried through *AskCHIS™*.
2. **Organization:** UCLA Center for Health Policy Research, with California Department of Health Care Services and California Department of Public Health as collaborating agencies.
3. **Exact source URL:** [AskCHIS dashboard](https://healthpolicy.ucla.edu/our-work/askchis/askchis-dashboard); [2024 Adult Questionnaire](https://healthpolicy.ucla.edu/sites/default/files/2025-07/CHIS%202024%20CATI%20v.1.28%2026JUNE2025%20Adult%20Questionnaire_Clean.pdf); [CHIS design](https://healthpolicy.ucla.edu/our-work/california-health-interview-survey-chis/chis-design-and-methods/chis-design).
4. **Year(s):** 2024 is the most recent complete public release. The core access questions also appear in earlier years, but definitions and availability must be checked before pooling.
5. **Exact variables:** `AF81`, `AJ1`, `AF74`, `AF75`, `AF114`, `AF76`, `AF77`, `AF78`, `AF79`, `AF80`, `AJ5`, `AF82`, `AF83`, `AF84`, `AF85`; women can be selected using current gender `AD66C` (female = 2) or, if substantively intended, sex assigned at birth `AD65E` (female = 2).
6. **What they measure:**
   - `AF81`: perceived need to see a professional in the past 12 months for mental health, emotions/nerves, or alcohol/drug use;
   - `AJ1`: whether insurance covers mental-health treatment;
   - `AF74`/`AF75`: past-year visit to a primary-care clinician or another professional for mental-health/emotional or alcohol/drug problems;
   - `AF114`: whether that care was in person, by video, or by telephone;
   - `AF76`/`AF77`: type of problem and number of professional visits;
   - `AF78`–`AF80`: still in treatment, completed recommended treatment, and reason treatment ended;
   - `AJ5`: near-daily prescription medication for an emotional/personal problem for at least two weeks;
   - `AF82`–`AF85`: cost, discomfort discussing problems, disclosure concern, and appointment difficulty among people who perceived need but did not see a professional.
7. **Women-specific/filterable by sex:** Yes. Current gender can be filtered to female; sex assigned at birth is also collected. The choice must match the study’s definition of “women.”
8. **Geographic level:** State, region, 41 individual counties, and three grouped small-county strata in direct CHIS estimates.
9. **Individual California counties available:** Yes, for the 41 most populous counties.
10. **Number of California counties represented:** 41 individually; the remaining 17 are represented only within three groups.
11. **Direct access or proxy:** Mostly **direct** measures of perceived need, treatment receipt, continuity, coverage, and barriers. CHIS does not itself clinically verify diagnosis.
12. **Important limitations:** Some questions combine mental health with alcohol/drug problems; self-report and recall error; county × female × need subsets may be small, unstable, or blank; public-use microdata do not contain sub-state geography, so use AskCHIS or the restricted Data Access Center; the three grouped strata cannot support claims about their constituent counties. UCLA advises pooling years or broadening the population when estimates are unstable and reporting only stable estimates.

**Fit:** strongest primary source for the broad question, provided 41-county coverage is acceptable.

### 4. MIHA Data Snapshots Dashboard

1. **Exact dataset name:** *Maternal and Infant Health Assessment (MIHA) Data Snapshots Dashboard*.
2. **Organization:** California Department of Public Health (CDPH), Maternal, Child and Adolescent Health Division, in collaboration with the UCSF Center for Health Equity.
3. **Exact source URL:** [MIHA Data Snapshots Dashboard](https://www.cdph.ca.gov/Programs/CFH/DMCAH/MIHA/Pages/Data-Snapshots-Dashboard.aspx); [direct CSV](https://www.cdph.ca.gov/Programs/CFH/DMCAH/MIHA/CDPH%20Document%20Library/MIHASnapshotsData.csv); [methods](https://www.cdph.ca.gov/Programs/CFH/DMCAH/MIHA/Pages/Methods.aspx).
4. **Year(s):** Access measures are published for pooled 2020–2022; prenatal/postpartum screening questions were fielded in 2020–2021. Other MIHA indicators span 2013–2022.
5. **Exact variables/indicator names:** `Screened for mental health conditions, prenatal`; `Screened for mental health conditions, postpartum`; `Screened for mental health conditions, prenatal or postpartum`; `Perceived need for mental health care`; `Receipt of mental health care when needed`.
6. **What they measure:** provider-administered form/series of questions during pregnancy or postpartum; self-perceived need for emotional/mental-health help; and, among those perceiving need, whether the respondent saw a doctor or mental-health professional for counseling or treatment.
7. **Women-specific/filterable by sex:** The survey population is birthing people aged 15+ with a recent live birth. It is highly relevant to women’s maternal mental health but is not a sample of all women and should not be described that way.
8. **Geographic level:** State, nine regions, and selected counties based on residence at delivery.
9. **Individual California counties available:** Yes, for the 35 counties with the greatest numbers of births.
10. **Number of California counties represented:** 35. I verified all 35 have nonmissing total-population percentages for the listed 2020–2022 access indicators in the official CSV.
11. **Direct access or proxy:** **Direct** for screening and treatment receipt; perceived need is the denominator/context for unmet access.
12. **Important limitations:** Restricted to people with a recent live birth, age 15+, English or Spanish survey, and selected eligibility exclusions; self-report; three-year pooled estimates obscure annual change; no county estimates for 23 smaller counties; subgroup estimates may be suppressed or flagged when unreliable.

**Fit:** strongest dataset for maternal mental-health access, not for all women.

### 5. Perinatal Mental Health Conditions at Delivery

1. **Exact dataset name:** *Perinatal Mental Health Conditions at Delivery*.
2. **Organization:** California Department of Public Health, Maternal, Child and Adolescent Health Division.
3. **Exact source URL:** [CDPH dashboard](https://www.cdph.ca.gov/Programs/CFH/DMCAH/surveillance/Pages/Perinatal-Mental-Health-Conditions-at-Delivery.aspx); [direct CSV](https://www.cdph.ca.gov/Programs/CFH/DMCAH/surveillance/CDPH%20Document%20Library/Data-Dashboards/Data-Perinatal-Mental-Health-Conditions-at-Delivery.csv); [About the Data](https://www.cdph.ca.gov/Programs/CFH/DMCAH/surveillance/CDPH%20Document%20Library/Data-Dashboards/About-the-Data-Perinatal-Mental-Health-Conditions-at-Delivery.pdf).
4. **Year(s):** State annual data, 2016–2024; county data in overlapping three-year periods from 2016–2018 through 2022–2024.
5. **Exact variables/fields:** `Indicator Name = Perinatal Mental Health Condition at Delivery`; `Category = Type`; `Subcategory = Any`, `Anxiety disorder`, and other condition types in the file; `Numerator`, `Denominator`, `Percent`, and confidence limits.
6. **What they measure:** diagnoses of mood, anxiety, and anxiety-related disorders coded in hospital records for delivery hospitalizations, by patient county of residence.
7. **Women-specific/filterable by sex:** Restricted to patients with a delivery hospitalization; it represents birthing patients, not all women.
8. **Geographic level:** State annually and county in pooled three-year periods.
9. **Individual California counties available:** Yes.
10. **Number of California counties represented:** 58 county rows. For `Type = Any`, 54 counties have an unsuppressed estimate in 2016–2018 and 55 in each later pooled period through 2022–2024.
11. **Direct access or proxy:** A **proxy/outcome** for access to recognition/diagnosis during hospital care; it does not measure whether diagnosis was timely, desired, or followed by treatment.
12. **Important limitations:** Hospital coding varies; only conditions documented at delivery are captured; county periods overlap and should not be compared as independent periods; numerator/rate/CI are suppressed when numerator <11; three counties remain suppressed in recent pooled periods.

**Fit:** strong contextual diagnosis measure for the perinatal population, not a treatment-access measure.

### 6. Behavioral Health Program Performance Data — adult utilization and demographics by sex

1. **Exact dataset name:** *Behavioral Health Program Performance Data*. The key resources are *Adult SMHS and MHS Service Utilization Data by Sex for FY’s 2020–2023* and *Demographic Data for FY’s 2020–2023*.
2. **Organization:** California Department of Health Care Services (DHCS), published through the California Health and Human Services Open Data Portal.
3. **Exact source URL:** [dataset catalog and resource list](https://catalog.data.gov/dataset/behavioral-health-program-performance-data); [adult utilization-by-sex CSV](https://data.chhs.ca.gov/dataset/380ed3e6-3cef-4aa1-813e-ddad3dd6bb98/resource/4a7fa3df-e3cb-49bc-a56c-dc0a65d5c422/download/adult_utilization_by_sex.csv); [companion demographic CSV](https://data.chhs.ca.gov/dataset/380ed3e6-3cef-4aa1-813e-ddad3dd6bb98/resource/aeb088b1-3904-47c3-b5c4-de564ff1426c/download/all_demo_data_new_3.csv); [DHCS dashboard documentation](https://www.dhcs.ca.gov/services/mental-health-services-division-default/mhs-performance-dashboard-reports-and-data-mhs-performance-dashboard-reports-and-data/).
4. **Year(s):** Fiscal years 2019/20, 2020/21, 2021/22, and 2022/23. The resource title’s “FY’s 2020–2023” refers to ending years.
5. **Exact variables:**
   - demographics: `TOTAL_CT`, `MHS1_CT`, `MHS5_CT`, `DEMO_GRP = S1 Female`, `POP_CAT = Adult`, `DEMO_CAT = Sex`, `MEDI_CAL_DELIVERY_SYSTEM`;
   - utilization: `MH Service Description`, `Units`, `Amount MH Service Received`, `Demographic Group = S1 Female`, and `Medi-Cal Delivery System`;
   - particularly relevant service values include `MHS_TOTAL`, `SMHS_TOTAL`, `PSYCH_DX_EVAL`, `PSYCH_DX_EVAL_WITH_MED_SVCS`, `MH_ASSESS-NON_MD`, `PSYCHOTHERAPY_SVCS`, `COMP_MEDICATION_SERVICES`, and `MEDICATION_SUPPORT_SVCS`.
6. **What they measure:** `TOTAL_CT` is the count of eligible Medi-Cal beneficiaries; `MHS1_CT` and `MHS5_CT` count beneficiaries receiving at least one or at least five mental-health services in the fiscal year. Utilization fields count beneficiaries or service units for specific claimed/encountered non-specialty mental-health services (NSMHS) and specialty mental-health services (SMHS).
7. **Women-specific/filterable by sex:** Yes, by `S1 Female`. The metadata calls this “sex,” not self-identified gender.
8. **Geographic level:** County mental-health plan/county, plus statewide, size-group, fee-for-service, managed-care-plan, and other delivery-system rollups. Use only numeric county IDs 1–58 for county analysis.
9. **Individual California counties available:** Yes.
10. **Number of California counties represented:** All 58 have female adult rows. Depending on fiscal year and delivery system, 56–57 counties have unsuppressed `TOTAL_CT` and `MHS1_CT` values needed for a female penetration rate. Total-utilization values are available for 55–56 counties.
11. **Direct access or proxy:** **Direct realized treatment utilization** based on claims/encounters. A penetration rate is a partial access measure; it cannot identify women who needed care but did not obtain it.
12. **Important limitations:** Medi-Cal adults age 21+ only; claims/encounters miss uninsured, privately insured, unbilled, and possibly incomplete services; sex classification is administrative; suppression affects the smallest counties; NSMHS and SMHS populations can overlap; changes in eligibility, coding, and delivery systems can affect trends; diagnosis-category files are statewide rather than county-by-sex.

**Fit:** strongest all-county administrative source after narrowing the population to adult female Medi-Cal beneficiaries.

## Comparison of the strongest datasets

| Dataset | Population | Direct access measure? | Women/sex dimension | Individual counties | Best use |
|---|---|---:|---|---:|---|
| CHIS 2024 / AskCHIS | California adults | Yes: need, provider use, continuity, coverage, barriers | Current gender or sex-at-birth filter | 41 | Primary analysis of adult women and unmet need |
| DHCS Behavioral Health Program Performance Data | Medi-Cal adults age 21+ | Yes: claimed/encountered service use | Female rows | 58 rows; 56–57 usable rate components | All-county realized utilization |
| MIHA Data Snapshots | People with a recent live birth | Yes: screening and care when needed | Maternal/birthing population | 35 | Maternal screening-to-treatment pathway |
| CDPH Perinatal Mental Health Conditions at Delivery | Delivery hospitalizations | Diagnosis proxy, not treatment access | Birthing patients | 58 rows; 54–55 unsuppressed | Context on documented perinatal diagnoses |
| CDC PLACES 2025 | All adults | No; diagnosis/distress proxies | No published sex strata | 58 | Context only |

## Recommendation

Use **CHIS 2024 / AskCHIS as the primary dataset** because it most faithfully captures the population and concept in the research question: adult women, perceived need, actual provider contact, treatment continuity, insurance coverage, and specific barriers. State the geographic scope honestly as the **41 individually identifiable counties**, not California’s full set of 58, and pool years only after confirming that question wording and coding are comparable.

Pair it with the **DHCS Behavioral Health Program Performance Data** as a secondary analysis. This supplies an objective, claims-based check across all 58 county systems, but the inference must be explicitly limited to adult female Medi-Cal beneficiaries and to realized service use. Use MIHA only if maternal mental health is a substantive focus.

If the assignment requires one dataset and all 58 counties, revise the question to: **“How does realized use of mental-health services vary among adult female Medi-Cal beneficiaries across California counties?”** Then use `MHS1_CT / TOTAL_CT` from the DHCS demographic file as the main measure, report suppressed counties as missing, and analyze NSMHS and SMHS separately.

## What not to claim

- Do not call PLACES estimates women-specific; they are overall adult estimates.
- Do not turn CHIS’s three grouped small-county strata into 17 county estimates.
- Do not interpret missing/suppressed values as zero.
- Do not treat service utilization as unmet need or proof that access is adequate.
- Do not generalize MIHA or delivery-hospitalization results to all women.
- Do not compare overlapping three-year CDPH periods as independent trends.
