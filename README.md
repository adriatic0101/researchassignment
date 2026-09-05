# Women's Access to Mental Health Care Across California

## Research Question

How does access to mental health diagnosis and treatment vary among women in different counties in California?

This dashboard addresses the question with an available county-level measure of realized mental-health service use. It does not claim to measure every part of diagnosis and treatment access.

## Study Area

The study examines all 58 California counties. County polygons provide the geographic units displayed on the map, while the health file contains records for adult female Medi-Cal beneficiaries associated with each county. The default dashboard view displays fiscal year 2022/23, and users can select any included fiscal year and delivery system.

## Data Sources

### Health data

- **Dataset:** [Behavioral Health Program Performance Data](https://catalog.data.gov/dataset/behavioral-health-program-performance-data), resource *Demographic Data for FY's 2020-2023*
- **Organization:** California Department of Health Care Services (DHCS)
- **Years:** California state fiscal years 2019/20, 2020/21, 2021/22, and 2022/23
- **Population used:** Adult female Medi-Cal beneficiaries (`POP_CAT = Adult`, `DEMO_CAT = Sex`, and `DEMO_GRP = S1 Female`)
- **Source variables:** `TOTAL_CT`, the number of eligible beneficiaries, and `MHS1_CT`, the number receiving at least one mental-health service during the fiscal year
- **Primary dashboard variable:** Mental-health service penetration percentage, calculated as `100 × MHS1_CT / TOTAL_CT`
- **Delivery systems:** Non-specialty mental-health services (`NSMHS`) and specialty mental-health services (`SMHS`), analyzed separately
- **Geographic level:** California county
- **Original file:** [DHCS demographic CSV](https://data.chhs.ca.gov/dataset/380ed3e6-3cef-4aa1-813e-ddad3dd6bb98/resource/aeb088b1-3904-47c3-b5c4-de564ff1426c/download/all_demo_data_new_3.csv)

### Geographic boundaries

- **Dataset:** [TIGERweb States and Counties](https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/State_County/MapServer)
- **Organization:** U.S. Census Bureau
- **Boundary access date:** September 4, 2026
- **Variables retained:** County name, five-character county `GEOID`, state FIPS, county FIPS, and polygon geometry
- **Geographic level:** California county
- **Prepared format:** GeoJSON in WGS 84 longitude/latitude coordinates
- **Exact boundary query:** [California counties as GeoJSON](https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/State_County/MapServer/1/query?where=STATE%3D%2706%27&outFields=STATE%2CCOUNTY%2CGEOID%2CNAME&returnGeometry=true&outSR=4326&f=geojson)

The verified files used by the website are:

- `data/mental-health-data.csv`
- `data/california-counties.geojson`

## Methods

The health records were filtered to adult female beneficiaries and actual county records. A service penetration percentage was calculated only when DHCS reported both the numerator and denominator. Suppressed or unavailable records were retained with a blank percentage and a status field; they were not converted to zero.

DHCS county names were checked against Census county names during data preparation, and the corresponding five-character Census county FIPS code was assigned to each health record. The website joins `county_fips` in the CSV to `GEOID` in the GeoJSON. Both fields are handled as text so the leading zero is preserved. The verified join covers all 58 counties with no unmatched identifiers.

The MapLibre choropleth filters the health file to one fiscal year and one delivery system, attaches the selected values to county features, and calculates five data-dependent classes for the legend. Missing values receive a separate gray category. The D3 charts use the same filtered records to produce:

1. A highest-to-lowest county ranking.
2. A four-year weighted trend for NSMHS and SMHS.
3. A scatterplot comparing the eligible adult female Medi-Cal population with service penetration.

The written county comparison is also calculated from the active selection rather than being populated with fixed statistics.

## Limitations

- The population is adult female Medi-Cal beneficiaries, not all women living in a county. “Female” is the administrative sex category available in the source.
- Receiving at least one service measures realized treatment use. It is a proxy for access and does not directly measure appointment availability, waiting time, affordability, unmet need, or the quality of treatment.
- The source does not allow the dashboard to measure access to diagnosis separately from access to treatment.
- Alpine County has a suppressed or unavailable rate in both delivery systems for all four years. Sierra County's SMHS rate is unavailable in 2019/20 and 2020/21. These values remain missing rather than being shown as zero.
- NSMHS and SMHS populations can overlap, so their counts and rates are displayed separately and should not be added together.
- Claims and encounter data may omit services that were not billed or reported. Changes in eligibility, coding, reporting, or delivery systems can affect comparisons over time.
- The dashboard is descriptive. It shows variation and association but does not establish that geography causes differences in service use.

## Tools

- **MapLibre GL JS** for the interactive choropleth and grayscale vector-tile basemap
- **D3.js** for loading the health CSV and drawing the ranking, trend, and scatterplot
- **GeoJSON** for California county identifiers and polygon geometry
- HTML, CSS, and JavaScript for the responsive page and interaction controls

## Run Locally

Open the project folder in VS Code, right-click `index.html`, and select **Open with Live Server**. The page loads its verified inputs through relative paths:

- `data/mental-health-data.csv`
- `data/california-counties.geojson`

An internet connection is required for the MapLibre GL JS and D3.js libraries and the grayscale CARTO vector-tile basemap.

For complete preparation and validation details, see `data-preparation-summary.md`.
