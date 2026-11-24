# Gender Inequalities in Mortality Observatory

[Versión en español](README.md)

An interactive R/Shiny dashboard for analyzing mortality in Argentina from a gender perspective. It is designed for health **decision-makers** to explore mortality trends, gaps between men and women, and territorial inequalities at the province and department level.

Developed by the **Center for Implementation and Innovation in Health Policy (CIIPS)** at the [Institute for Clinical Effectiveness and Health Policy (IECS)](https://iecs.org.ar/home-organizacion/centros/ciips/), as part of the **Vital Strategies** project.

- **Published dashboard:** _pending: add URL_
- **Period:** 2000–2024
- **Coverage:** Argentina: national total, regions, 24 jurisdictions and departments

> The dashboard interface is in Spanish.

---

## Dashboard sections

| Section | Route | What it shows |
|---|---|---|
| Home | `/` | Overview and navigation. |
| Interactive charts | `chart` | Trends of an indicator by jurisdiction or region, cause of death and sex. |
| Gender gaps | `gaps` | Male/female comparison, including rate differences and rate ratios. |
| Jurisdictions | `juri` | Where a jurisdiction stands relative to the others (latest year), with a traffic-light rating based on its rank. |
| Maps | `map` | Standardized mortality ratio (SMR) by department for three periods (2000–2002, 2009–2011 and 2021–2023), grouped into quartiles. |
| Hot Spots | `hotspots` | Spatial clusters of mortality by department (local Moran's I / LISA) and their relationship with unmet basic needs (NBI). |
| Tables & download | `download` | Tabular queries and Excel (.xlsx) export. |

### Indicators

Number of deaths; crude mortality rate; age-adjusted mortality rate; premature, preventable premature and treatable premature deaths and rates (rates per 100,000 population).

---

## Data sources

- **Deaths:** vital statistics from the Directorate of Health Statistics and Information (**DEIS**), National Ministry of Health of Argentina.
- **Population and NBI:** national censuses from the National Institute of Statistics and Censuses (**INDEC**).
- **Base map:** tiles from the National Geographic Institute (IGN).

The data used by the app is already processed and stored as `.rda` files in `data/`. _Pending: document or link the data preparation (ETL) process._

---

## Repository structure

```
fluentApp/
├── app.R                  # Entry point: UI, server and routing
├── fluentApp.Rproj
├── R/
│   ├── pages/             # One page per section (UI for each route)
│   ├── components/        # UI components: menus, boxes, modals, legends
│   ├── charts/            # Charts and maps: comparison, gaps, hot spots
│   ├── calc/              # Indicators and calculations: ratios, differences, SMR
│   └── ai/                # Gemini API client
├── data/
│   ├── dataMortProv.rda   # Mortality by jurisdiction
│   ├── dataMortReg.rda    # Mortality by region
│   ├── dataMortProvEdad.rda
│   ├── mortalityCauses.rda, tablaCausas.RDA
│   ├── labels/            # Province, region and sex labels
│   ├── population/        # Census population, deaths by period and standardized rates
│   ├── indicators/        # NBI by department
│   └── maps/              # Geometries and spatial neighbor matrices
└── www/                   # Static assets (logos)
```

Files in `R/` are loaded explicitly with `source()` from `app.R`.

---

## Running the app locally

### Requirements

- R (≥ 4.1 recommended) and, optionally, RStudio.
- Packages:

```r
install.packages(c(
  "shiny", "shiny.fluent", "shiny.router", "shinyjs", "shinyWidgets",
  "shinyalert", "shinycssloaders",
  "dplyr", "tidyr", "purrr", "stringr", "glue", "jsonlite", "markdown",
  "ggplot2", "scales", "paletteer", "highcharter", "apexcharter",
  "reactable", "leaflet", "sf", "spdep", "epitools",
  "writexl", "htmltools"
))
```

`shinytreeview` is not on CRAN for recent R versions. Install it from GitHub:

```r
install.packages("remotes")
remotes::install_github("dreamRs/shinytreeview")
```

### Data for department-level analysis

Department-level maps and hotspot analysis require `defTri1.rda`, `defTri2.rda`, and `defTri3.rda` in `data/population/`. If you have authorized access to these mortality files, place local copies in that directory.

### Run

Open `fluentApp.Rproj` and run:

```r
shiny::runApp()
```

---

## Authors and contact

- Lucía Bartolomeu (IECS)
- Adrián Santoro (IECS)

Center for Implementation and Innovation in Health Policy (CIIPS), IECS. Buenos Aires, Argentina.

## Funding

Vital Strategies project.
