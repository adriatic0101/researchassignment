# California county women's mental-health data: preparation summary

## Prepared files

- `mental-health-data.csv`: 464 rows (58 counties × 4 fiscal years × 2 delivery systems).
- `california-counties.geojson`: 58 California county polygon features.
- `scripts/prepare_county_data.rb`: reproducible filtering, calculation, FIPS assignment, and validation script.

No `index.html` was created.

## Health data

**Source dataset:** California Department of Health Care Services (DHCS), *Behavioral Health Program Performance Data*, resource *Demographic Data for FY's 2020-2023*.

- Dataset catalog: https://catalog.data.gov/dataset/behavioral-health-program-performance-data
- Exact CSV used: https://data.chhs.ca.gov/dataset/380ed3e6-3cef-4aa1-813e-ddad3dd6bb98/resource/aeb088b1-3904-47c3-b5c4-de564ff1426c/download/all_demo_data_new_3.csv
- Years: California state fiscal years 2019/20, 2020/21, 2021/22, and 2022/23.
- Population retained: `POP_CAT = Adult`, `DEMO_CAT = Sex`, and `DEMO_GRP = S1 Female`. In this dataset, adult means age 21 or older.
- Geographic records retained: DHCS county records with internal `Health Care Delivery System Id` values 1–58. Statewide, plan, and other aggregate records were excluded.

The main prepared variable is `mental_health_service_penetration_percent`:

`100 × MHS1_CT / TOTAL_CT`

It is the percentage of eligible adult female Medi-Cal beneficiaries who received at least one mental-health service during the fiscal year. The CSV retains its numerator and denominator so the calculation can be checked:

- `eligible_adult_female_medi_cal_beneficiaries`: source field `TOTAL_CT`.
- `adult_female_beneficiaries_with_1plus_mental_health_service`: source field `MHS1_CT`.
- `mental_health_service_penetration_percent`: calculated percentage, rounded to two decimals.
- `value_status`: `reported` or `suppressed_or_unavailable`.
- `source_mhs1_annotation`: the original DHCS annotation code when the numerator is unavailable. The source package does not provide a machine-readable annotation-code definition, so the numeric codes are preserved without guessing their meaning.

`NSMHS` (non-specialty mental-health services) and `SMHS` (specialty mental-health services) are kept as separate rows. They must not be added because beneficiaries may appear in both systems.

This is a **realized-treatment-use measure and a proxy for access**, not a direct measure of appointment availability, wait time, unmet need, affordability, or receipt of a diagnosis. It applies only to adult female Medi-Cal beneficiaries, not all women in a county. Claims and encounter data can omit unbilled care, and eligibility, reporting, coding, or delivery-system changes can affect comparisons.

## Geographic data

**Source:** U.S. Census Bureau TIGERweb, *States and Counties*, Counties layer (layer 1), accessed September 4, 2026.

- Service metadata: https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/State_County/MapServer
- Exact GeoJSON query used: https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/State_County/MapServer/1/query?where=STATE%3D%2706%27&outFields=STATE%2CCOUNTY%2CGEOID%2CNAME&returnGeometry=true&outSR=4326&f=geojson

The query selects state FIPS `06` (California) and requests WGS 84 coordinates (`EPSG:4326`). The prepared GeoJSON retains only the geometry and the identifiers `GEOID`, `NAME`, `STATEFP`, and `COUNTYFP`.

Both sources use county-level geography. The safest join is:

`mental-health-data.csv county_fips` → `california-counties.geojson properties.GEOID`

Both join fields are five-character Census county FIPS codes such as `06001`. They must be read as text so the leading zero is not lost. DHCS's internal county number is not used as the final join key. During preparation, DHCS county names were matched exactly to Census county names, the Census `GEOID` was assigned, and uniqueness and full coverage were checked.

Because the health file has multiple years and two delivery systems, this is a one-to-many relationship. For a county choropleth, first filter the CSV to one `fiscal_year` and one `delivery_system`; that produces one health row per county.

## Join and missing-data audit

| Check | Result |
|---|---:|
| California counties in GeoJSON | 58 |
| Counties represented by health rows | 58 |
| Counties with at least one reported calculated value | 57 |
| County FIPS values matching a GeoJSON feature | 58 |
| Health counties without a geographic match | 0 |
| Geographic counties without health rows | 0 |
| Duplicate county–fiscal-year–delivery-system keys | 0 |
| Total health rows with a reported calculated value | 454 |
| Total suppressed/unavailable outcome rows | 10 |

### Suppressed or unavailable values

| Fiscal year | Delivery system | County/counties |
|---|---|---|
| 2019/20 | NSMHS | Alpine County (source annotation `1`) |
| 2019/20 | SMHS | Alpine County (`2`); Sierra County (`1`) |
| 2020/21 | NSMHS | Alpine County (`1`) |
| 2020/21 | SMHS | Alpine County (`2`); Sierra County (`1`) |
| 2021/22 | NSMHS | Alpine County (`1`) |
| 2021/22 | SMHS | Alpine County (`2`) |
| 2022/23 | NSMHS | Alpine County (`1`) |
| 2022/23 | SMHS | Alpine County (`1`) |

These records remain in the CSV with a blank calculated percentage. They must be treated as missing—not zero. In the latest fiscal year, 57 counties have a reported value for NSMHS and 57 have a reported value for SMHS; Alpine County is unavailable in both.

## Connection result

The files connect successfully through five-digit county FIPS. All 58 county identifiers match in both directions. The geographic join itself has no failures; missing map values arise only from the health-data suppression/unavailability listed above.
