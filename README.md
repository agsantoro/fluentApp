# Observatorio de las inequidades de género en la mortalidad

[English version](README.en.md)

Tablero interactivo en R/Shiny para analizar la mortalidad en Argentina con perspectiva de género. Está pensado para que **tomadores de decisión** en salud puedan explorar la evolución de la mortalidad, las brechas entre varones y mujeres, y las desigualdades territoriales por jurisdicción y departamento.

Lo desarrolló el **Centro de Implementación e Innovación en Políticas de Salud (CIIPS)** del [Instituto de Efectividad Clínica y Sanitaria (IECS)](https://iecs.org.ar/home-organizacion/centros/ciips/), en el marco del proyecto **Vital Strategies**.

- **Tablero publicado:** _pendiente: agregar URL_
- **Período:** 2000–2024
- **Cobertura:** Argentina: total país, regiones, 24 jurisdicciones y departamentos

---

## Secciones del tablero

| Sección | Ruta | Qué muestra |
|---|---|---|
| Inicio | `/` | Presentación y acceso a las secciones. |
| Gráficos interactivos | `chart` | Evolución temporal de un indicador por jurisdicción o región, causa de muerte y sexo. |
| Brechas de género | `gaps` | Comparación varones/mujeres, con diferencia y cociente de tasas. |
| Jurisdicciones | `juri` | Posición de una jurisdicción frente al resto (último año disponible), con semáforo según su ranking. |
| Mapas | `map` | Razón de mortalidad estandarizada (RME) por departamento en tres trienios (2000–2002, 2009–2011 y 2021–2023), agrupada por cuartiles. |
| Hot Spots | `hotspots` | Agrupamientos espaciales de mortalidad por departamento (Moran local / LISA) y su relación con las necesidades básicas insatisfechas (NBI). |
| Tablas y descarga | `download` | Consulta tabular y descarga en Excel (.xlsx). |

### Indicadores

Cantidad de defunciones; tasa bruta de mortalidad; tasa ajustada por edad; defunciones y tasas de mortalidad prematura, prematura prevenible y prematura tratable (tasas por 100.000 habitantes).

---

## Fuentes de datos

- **Defunciones:** estadísticas vitales de la Dirección de Estadísticas e Información en Salud (**DEIS**) del Ministerio de Salud de la Nación.
- **Población y NBI:** censos nacionales del Instituto Nacional de Estadística y Censos (**INDEC**).
- **Cartografía base:** teselas del Instituto Geográfico Nacional (IGN).

Los datos que usa la app ya están procesados y guardados como archivos `.rda` en `data/`. _Pendiente: documentar o enlazar el proceso de preparación (ETL) de estos archivos._

---

## Estructura del repositorio

```
fluentApp/
├── app.R                  # Punto de entrada: UI, servidor y rutas
├── fluentApp.Rproj
├── R/
│   ├── pages/             # Una página por sección (UI de cada ruta)
│   ├── components/        # Componentes de interfaz: menús, cajas, modales, leyendas
│   ├── charts/            # Gráficos y mapas: comparación, brechas, hot spots
│   ├── calc/              # Indicadores y cálculos: cocientes, diferencias, RME
│   └── ai/                # Cliente de la API de Gemini
├── data/
│   ├── dataMortProv.rda   # Mortalidad por jurisdicción
│   ├── dataMortReg.rda    # Mortalidad por región
│   ├── dataMortProvEdad.rda
│   ├── mortalityCauses.rda, tablaCausas.RDA
│   ├── labels/            # Etiquetas de provincias, regiones y sexo
│   ├── population/        # Población censal, defunciones por trienio y tasas estandarizadas
│   ├── indicators/        # NBI por departamento
│   └── maps/              # Geometrías y matrices de vecindad espacial
└── www/                   # Recursos estáticos (logos)
```

Los archivos de `R/` se cargan explícitamente con `source()` desde `app.R`.

---

## Cómo correr la app localmente

### Requisitos

- R (≥ 4.1 recomendado) y, opcionalmente, RStudio.
- Paquetes:

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

`shinytreeview` no está en CRAN para versiones recientes de R. Instalalo desde GitHub:

```r
install.packages("remotes")
remotes::install_github("dreamRs/shinytreeview")
```

### Datos para el análisis departamental

Los mapas departamentales y el análisis de puntos calientes requieren `defTri1.rda`, `defTri2.rda` y `defTri3.rda` en `data/population/`. Si tenés acceso autorizado a esos archivos de defunciones, colocá copias locales en esa carpeta.

### Ejecutar

Abrí `fluentApp.Rproj` y corré:

```r
shiny::runApp()
```

---

## Autoría y contacto

- Lucía Bartolomeu (IECS)
- Adrián Santoro (IECS)

Centro de Implementación e Innovación en Políticas de Salud (CIIPS), IECS. Buenos Aires, Argentina.

## Financiamiento

Proyecto Vital Strategies.
