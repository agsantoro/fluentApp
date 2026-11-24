modalText = function(page) {
  if (page == "map") {
    list(
      title = HTML(paste(icon("globe", style = "
        font-size: 1em; 
        color: #766bd3;
        filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));"),"Mapas Interactivos" )),
      content = HTML(
        '
            
        <p>Este mapa utiliza <strong>colores</strong> (un <a href="#" title="Mapa de Coropletas: Un tipo de mapa temático en el que las áreas geográficas están sombreadas con colores o patrones que representan valores estadísticos de una variable en esa área.">Mapa de Coropletas</a>) para mostrar la <strong>Razón de Mortalidad Estandarizada (RME)</strong> en los distintos departamentos o partidos de Argentina, clasificada en <strong>cuatro grupos (cuartiles)</strong>.</p>

        <h4 style="margin-top: 20px; color: #4682b4;">Definiciones Clave:</h4>
        <ul style="list-style-type: disc; padding-left: 20px; font-size: 14px;">
            <li><strong>Mapa de Coropletas:</strong> Un tipo de mapa en el que las áreas geográficas (departamentos/partidos) se colorean o sombrean para representar la magnitud de una variable estadística.</li>
            <li><strong>Razón de Mortalidad Estandarizada (RME):</strong> Es una medida que compara el número de muertes observadas en una población con el número de muertes que se esperarían, ajustando por diferencias en la estructura de edad de la población. Permite comparar de forma justa la mortalidad entre distintas regiones o períodos.</li>
        </ul>

        <hr style="border-top: 1px solid #ccc; margin: 15px 0;">

        <h3>¿Qué te permite ver?</h3>

        <ol style="padding-left: 20px;">
            <li>
                <p><strong>Comparación Geográfica:</strong> Al mirar el mapa en un momento dado, podés ver fácilmente qué áreas tienen una RME <strong>significativamente más alta o más baja</strong> que el promedio nacional (representado por los cuartiles más oscuros y más claros, respectivamente).</p>
            </li>
            <li>
                <p><strong>Evolución en el Tiempo:</strong> Al <strong>cambiar el año</strong> o período de tiempo, podés observar <strong>cómo ha cambiado la mortalidad</strong> en cada región. Esto es crucial para identificar:</p>
                <ul style="list-style-type: circle; margin-top: 5px; padding-left: 20px;">
                    <li><strong>Tendencias:</strong> ¿La mortalidad está empeorando o mejorando en ciertas zonas?</li>
                    <li><strong>Puntos Críticos:</strong> ¿Dónde persisten las altas tasas de mortalidad?</li>
                    <li><strong>Impacto de Políticas:</strong> ¿Las intervenciones o programas de salud han tenido un efecto visible en la reducción de la RME en áreas específicas?</li>
                </ul>
            </li>
        </ol>

        <p style="margin-top: 15px; background-color: #f0f8ff; padding: 10px; border-radius: 5px;">Con esta herramienta podés <strong>identificar rápidamente las áreas más vulnerables</strong> y a <strong>monitorear el progreso</strong> o el deterioro de la situación de salud a nivel territorial.</p>
        <hr>
        <p style="margin-top: 15px; background-color: #e5f5e0; padding: 10px; border-radius: 5px;">En el panel de la izquierda <strong>podés seleccionar el trienio y el grupo de causas de muerte para visualizar</strong>.</p>
        '
      ) 
    )
    
    
  } else if (page == "gaps") {
    list(
      title = HTML(paste(icon("arrows-split-up-and-left", style = "
        font-size: 1em; 
        color: #a1d99b;
        filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));"),"Brechas de género" )),
      content = HTML(
        '
            
        <p>Estos gráficos muestran la evolución de un indicador de mortalidad (como la <strong>Tasa de Mortalidad</strong> o la <strong>Cantidad de Defunciones Prematuras</strong>) a lo largo del tiempo para las jurisdicciones seleccionadas (provincia o CABA).</p>

        <h4 style="margin-top: 20px; color: #4682b4;">Componentes Clave:</h4>
        <ul style="list-style-type: disc; padding-left: 20px; font-size: 14px;">
            <li><strong>Indicador:</strong> Puedes seleccionar diferentes métricas, desde la <strong>Cantidad de defunciones</strong> hasta la <strong>Tasa de mortalidad ajustada por edad</strong> o las muertes <strong>prematuras</strong> (prevenibles y tratables).</li>
            <li><strong>Series:</strong> Se presentan dos series separadas para identificar las diferencias en la mortalidad según el sexo: <strong>Varones</strong> y <strong>Mujeres</strong>.</li>
        </ul>

        <hr style="border-top: 1px solid #ccc; margin: 15px 0;">

        <h3>¿Qué te permite ver?</h3>

        <ol style="padding-left: 20px;">
            <li>
                <p><strong>Tendencias Temporales:</strong> Observar si la mortalidad en la jurisdicción seleccionada está <strong>aumentando, disminuyendo o se mantiene estable</strong> a lo largo de los años para el indicador elegido.</p>
            </li>
            <li>
                <p><strong>Brecha de Sexo:</strong> Identificar la <strong>magnitud de la diferencia</strong> en la mortalidad entre varones y mujeres. </p>
            </li>
            <li>
                <p><strong>Análisis de Desigualdad (Tasas Ajustadas):</strong> Si se seleccionan <strong>tasas ajustadas por edad</strong>, el gráfico puede desplegar el <strong>Cociente de Tasas</strong>. Este cociente es una métrica de desigualdad que facilita ver cuánto mayor es la tasa de un sexo respecto al otro (por ejemplo, si el cociente es 1.5, la mortalidad en varones es 50% superior a la de mujeres).</p>
            </li>
            <li>
                <p><strong>Impacto Específico:</strong> Al seleccionar indicadores específicos (como tasas ajustadas o defunciones prevenibles/tratables), se puede evaluar la <strong>efectividad de los sistemas de salud</strong> y las políticas de prevención en la jurisdicción.</p>
            </li>
        </ol>

        <p style="margin-top: 15px; background-color: #f0f8ff; padding: 10px; border-radius: 5px;">Estos gráficos son esenciales para el <strong>análisis de la situación de salud a nivel provincial en términos comparativos</strong>, permitiendo monitorear la evolución y dirigir intervenciones específicas basadas en el género y la desigualdad.</p>
        <hr>
        <p style="margin-top: 15px; background-color: #e5f5e0; padding: 10px; border-radius: 5px;">En el panel de la izquierda se puede seleccionar el indicador a mostrar, las jurisdicciones seleccionadas y el grupo de causas de muerte.</p>
        </div>

        
        '
      ) 
    )
    
  } else if (page == "/") {
    
    list(
      title = HTML('<h2 style="color: #004a99; font-size: 1em; margin-top: 0; padding-bottom: 8px;">
        Le damos la bienvenida al Observatorio de Inequidades de Género en la mortalidad de Argentina
        </h2>'),
      content = HTML('
        <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 100%; padding: 15px; border: 0px solid #ddd; border-radius: 8px; background-color: #ffffff;">
            
            
            
            <div style="padding: 10px;">

    <p style="margin-bottom: 20px; font-size: 1.1em; line-height: 1.5;">
        <strong>Este espacio ha sido diseñado para una exploración de datos intuitiva.</strong> La navegación comienza en esta página de inicio, accediendo a la información a través de las <strong>tarjetas interactivas</strong>.
        <strong style="color: #EE7F00;">Haga clic en cualquiera de las secciones</strong> para dirigirse a la página de su interés.
    </p>

    <p><strong>En cada sección encontrará:</strong></p>
    <ul style="list-style: none; padding-left: 0;">
        <li style="margin-bottom: 20px;">
            <strong style="color: #2C5F8B;">1. Panel de Filtros:</strong> en el lateral, encontrará un panel de filtros detallado que le permitirá <strong>segmentar y personalizar los datos</strong> (por jurisdicción, rango de años, causa de mortalidad u otras variables), ajustando instantáneamente las visualizaciones.
        </li>
        <li style="margin-bottom: 20px;">
            <strong style="color: #2C5F8B;">2. Figuras y Visualizaciones:</strong> el cuerpo principal de cada página contendrá las <strong>visualizaciones clave</strong> (gráficos, mapas, tablas) específicas de la sección que seleccionó.
        </li>
    </ul>

    
    <h3 style="color: #4a4a4a; font-size: 1.4em; margin-top: 25px; border-bottom: 1px solid #ddd; padding-bottom: 5px;">
        Descarga y Reutilización de Información 
    </h3>
    <p style="margin-bottom: 10px;">
        El Observatorio promueve el uso y la difusión de sus datos. En cada sección, tendrá la capacidad de <strong style="color: #EE7F00;">descargar</strong> la información analizada:
    </p>
    <ul style="list-style-type: square; padding-left: 25px; margin-top: 0;">
        <li style="margin-bottom: 5px;"><strong>Imágenes (.png/.svg):</strong> descargue las visualizaciones para presentaciones o publicaciones.</li>
        <li style="margin-bottom: 5px;"><strong>Tablas de Datos:</strong> acceda a los datos crudos subyacentes en formato tabla para sus propios procesamientos.</li>
        <li style="margin-bottom: 5px;"><strong>Reportes:</strong> genere y descargue reportes resumidos con las cifras y análisis principales de la sección.</li>
    </ul>
    

    <p style="margin-top: 25px; font-style: italic; color: #777; border-top: 1px dashed #ccc; padding-top: 10px;">
        Haga clic en el botón "Comenzar" o en la "X" para cerrar esta guía y empezar su exploración.
    </p>
</div>'))
  } else if (page == "juri") { # Corregido: Usando 'page' en lugar de 'get_page()'
    list(
      title = HTML(paste(icon("chart-bar", style = "
        font-size: 1em; 
        color: #766bd3;
        filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));"),"Indicadores por jurisdicción" )),
      content = HTML('
        
        <p>Estos gráficos de barras muestran <strong>seis indicadores clave de mortalidad</strong> para todas las jurisdicciones de Argentina (provincias y CABA) en un período seleccionado, permitiendo evaluar la situación de una región específica en el contexto nacional.</p>

        <h4 style="margin-top: 20px; color: #4682b4;">Componentes y Código de Colores:</h4>
        <ul style="list-style-type: disc; padding-left: 20px; font-size: 14px;">
            <li><strong>Indicadores Clave:</strong> Incluyen la **Tasa de mortalidad** (bruta y ajustada por edad) y las tasas de mortalidad **prematura** (general, prevenible y tratable).</li>
            <li><strong>Color Azul:</strong> Identifica el valor del indicador para la **Jurisdicción Seleccionada**.</li>
            <li><strong>Color Gris:</strong> Marca el valor del indicador para el **Total País** (referencia nacional).</li>
            <li><strong>Color Naranja:</strong> Representa los valores de las **Otras Jurisdicciones** del país.</li>
        </ul>

        <hr style="border-top: 1px solid #ccc; margin: 15px 0;">

        <h3>¿Qué te permite ver?</h3>

        <ol style="padding-left: 20px;">
            <li>
                <p><strong>Posicionamiento Regional:</strong> Determinar rápidamente si la **Jurisdicción Seleccionada** (azul) se encuentra **por encima o por debajo** del promedio nacional (gris) para cada uno de los seis indicadores.</p>
            </li>
            <li>
                <p><strong>Contexto Nacional:</strong> Identificar el **rango de variación** del indicador a nivel país, visualizando las jurisdicciones con los valores más altos y más bajos (naranja).</p>
            </li>
            <li>
                <p><strong>Prioridades de Intervención:</strong> Al comparar las tasas brutas con las **tasas ajustadas por edad** y las tasas de mortalidad **prevenible/tratable**, se puede focalizar la atención en los indicadores donde la jurisdicción presenta la mayor desventaja relativa.</p>
            </li>
        </ol>

        <p style="margin-top: 15px; font-style: italic; background-color: #f0f8ff; padding: 10px; border-radius: 5px;">Estos gráficos son una herramienta fundamental para el **diagnóstico comparativo**, facilitando la identificación de las **fortalezas y debilidades** de la jurisdicción en relación con el panorama de mortalidad nacional.</p>
        <p style="margin-top: 15px; background-color: #e5f5e0; padding: 10px; border-radius: 5px;">En el panel de la izquierda se puede seleccionar la jurisdicción.</p>
        ')
    ) # <-- Cierre de list()
  } else if (page == "chart") { # Corregido: Usando 'page' en lugar de 'get_page()'
    
    list(
      title = HTML(paste(icon("chart-bar", style = "
        font-size: 1em; 
        color: #766bd3;
        filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));"),"Gráficos interactivos" )),
      content = HTML(
        '
            <p style="margin-bottom: 15px;">
                Esta sección permite una exploración detallada de la evolución de las disparidades de género en la mortalidad a lo largo del tiempo.
            </p>

            <h3 style="color: #4a4a4a; font-size: 1.2em; margin-top: 20px;">Configuración y Filtros de Análisis</h3>
            <p style="margin-bottom: 10px;">
                Para iniciar el análisis, usted deberá configurar los siguientes parámetros en el <strong>Panel de Filtros:</strong>
            </p>
            <ul style="list-style: none; padding-left: 0;">
                <li style="margin-bottom: 10px;">
                    <strong style="color: #6a1b9a;">• Indicador de Mortalidad:</strong> Seleccione el indicador estadístico (ej., Tasa Bruta, Tasa Ajustada) que desea utilizar como base del análisis.
                </li>
                <li style="margin-bottom: 10px;">
                    <strong style="color: #6a1b9a;">• Áreas Geográficas:</strong> Elija una o múltiples jurisdicciones de interés para comparar su evolución.
                </li>
                <li style="margin-bottom: 10px;">
                    <strong style="color: #6a1b9a;">• Causa(s) de Muerte:</strong> Defina el grupo específico de causas de mortalidad a analizar (ej., Enfermedades Cardiovasculares, Causas Externas).
                </li>
            </ul>

            <div style="background-color: #f3e5f5; border-left: 5px solid #6a1b9a; padding: 15px; margin-top: 20px; border-radius: 4px;">
                <h3 style="color: #6a1b9a; font-size: 1.2em; margin-top: 0; margin-bottom: 10px;">Resultados y Visualizaciones Clave</h3>
                <p style="margin-bottom: 10px;">
                    Una vez aplicados los filtros, el dashboard generará automáticamente cuatro gráficos de series temporales:</p>
                <ul style="list-style-type: circle; padding-left: 20px; margin-top: 0;">
                    <li style="margin-bottom: 5px;">
                        <strong style="color: #cc0000;">Gráfico Principal (Razón Mujer/Varón):</strong> Muestra la serie de la <strong>razón de mortalidad (Mujeres/Varones) por 100</strong>, permitiendo identificar el sentido y la magnitud de la brecha a lo largo del tiempo.
                    </li>
                    <li style="margin-bottom: 5px;">
                        <strong>Serie Total:</strong> Evolución del indicador de mortalidad seleccionado para la población total.
                    </li>
                    <li style="margin-bottom: 5px;">
                        <strong>Serie Varones:</strong> Evolución del indicador exclusivamente para la población masculina.
                    </li>
                    <li style="margin-bottom: 5px;">
                        <strong>Serie Mujeres:</strong> Evolución del indicador exclusivamente para la población femenina.
                    </li>
                </ul>
            </div>
            
            <p style="margin-top: 15px;">
                Utilice los gráficos individuales por sexo para comprender los factores que impulsan los cambios en la Razón Mujer/Varón.
            </p>
            
            ')
    )
  } else if (page == "hotspots") { # Corregido: Usando 'page' en lugar de 'get_page()'
    
    list(
      title = HTML(paste(icon("map", style = "
        font-size: 1em; 
        color: #766bd3;
        filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));"),"Hot Spots de mortalidad" )),
      content = HTML(
        '
            <h2 style="color: #d35400; font-size: 1.5em; margin-top: 0; padding-bottom: 8px; border-bottom: 2px solid #ccc;">
                Análisis Geoespacial: Hot Spots (Puntos Calientes) 
            </h2>

            <p style="margin-bottom: 15px;">
                Esta sección permite identificar <strong>patrones de concentración espacial</strong> de la mortalidad y su relación con un indicador de vulnerabilidad social, como son las Necesidades Básicas Insatisfechas (NBI). El análisis se centra en la unidad geográfica de <strong>departamento</strong>.
            </p>

            <h3 style="color: #4a4a4a; font-size: 1.2em; margin-top: 20px;">Configuración de Análisis Temporal y Causalidad</h3>
            <p style="margin-bottom: 10px;">
                En el <strong>Panel de Filtros a la izquierda</strong>, usted deberá configurar dos parámetros clave:
            </p>
            <ul style="list-style: none; padding-left: 0;">
                <li style="margin-bottom: 10px;">
                    <strong style="color: #d35400;">• Grupo de Causas de Muerte:</strong> Seleccione las causas que desea analizar.
                </li>
                <li style="margin-bottom: 10px;">
                    <strong style="color: #d35400;">• Trienio de Análisis:</strong> Elija uno de los tres periodos de tres años centrados alrededor de los últimos censos nacionales.
                </li>
            </ul>

            <div style="background-color: #fcefe3; border-left: 5px solid #d35400; padding: 15px; margin-top: 20px; border-radius: 4px;">
                <h3 style="color: #d35400; font-size: 1.2em; margin-top: 0; margin-bottom: 10px;">Resultados: Mapas y Visualizaciones Interactivas</h3>
                <p style="margin-bottom: 10px;">
                    La plataforma entrega una serie de visualizaciones para un análisis multivariado:
                </p>
                <ul style="list-style-type: disc; padding-left: 20px; margin-top: 0;">
                    <li style="margin-bottom: 5px;">
                        <strong>Mapa 1:</strong> Distribución de las <strong>Razones de Mortalidad Estandarizadas (RME)</strong> en cuartiles por departamento.
                    </li>
                    <li style="margin-bottom: 5px;">
                        <>strong>Mapa 2 (LISA Univariado):</strong> Muestra los clusters de la RME.
                    </li>
                    <li style="margin-bottom: 5px;">
                        <strong>Mapa 3:</strong> Distribución del <strong>Porcentaje de Mujeres en Hogares con NBI</strong> en cuartiles por departamento.
                    </li>
                    <li style="margin-bottom: 5px;">
                        <strong>Mapa 4 (LISA Bivariado):</strong> Muestra los clusters de la relación espacial <strong>NBI - RME</strong>.
                    </li>
                    <li style="margin-bottom: 5px;">
                        <strong>Gráfico de Dispersión:</strong> Relación no espacial entre NBI y RME.
                    </li>
                    <li style="margin-bottom: 5px;">
                        <strong>Spatial Correlation Plot:</strong> Diagnóstico de la correlación espacial.
                    </li>
                </ul>
            </div>
            
            <h3 style="color: #4a4a4a; font-size: 1.2em; margin-top: 20px;">Interpretación de Resultados Clave</h3>
            <ul style="list-style-type: none; padding-left: 0;">
                <li style="margin-bottom: 15px;">
                    <strong style="color: #007bff;">Razón de Mortalidad Estandarizada (RME):</strong>
                    <p style="margin-left: 10px; font-size: 0.9em;">
                        Es un indicador de riesgo relativo. Un valor de RME mayor a 100 indica que la mortalidad observada en ese departamento es <strong>mayor</strong> a la esperada (basada en la tasa nacional o provincial), y viceversa.
                    </p>
                </li>
                <li style="margin-bottom: 15px;">
                    <strong style="color: #007bff;">Clusters LISA (Local Indicators of Spatial Association):</strong>
                    <p style="margin-left: 10px; font-size: 0.9em;">
                        Los mapas LISA identifican áreas donde la variable (o la relación de dos variables) no es aleatoria. Los tipos de clusters son:
                        <ul style="list-style-type: square; padding-left: 20px;">
                            <li style="margin-bottom: 3px;"><strong>Alto-Alto (Hot Spot):</strong> Un área con valor alto rodeada de áreas con valores altos (cluster de alta mortalidad/vulnerabilidad).</li>
                            <li style="margin-bottom: 3px;"><strong>Bajo-Bajo (Cold Spot):</strong> Un área con valor bajo rodeada de áreas con valores bajos (cluster de baja mortalidad/vulnerabilidad).</li>
                            <li style="margin-bottom: 3px;"><strong>Alto-Bajo y Bajo-Alto:</strong> Valores atípicos donde el área local tiene un valor muy diferente al de sus vecinas inmediatas (ej., una zona de alta mortalidad rodeada de baja).</li>
                        </ul>
                    </p>
                </li>
                <li style="margin-bottom: 15px;">
                    <strong style="color: #007bff;">Gráfico de Dispersión y Spatial Correlation Plot:</strong>
                    <p style="margin-left: 10px; font-size: 0.9em;">
                        Mientras el <strong>Gráfico de Dispersión</strong> muestra la correlación simple (no espacial) entre NBI y RME, el <strong>Spatial Correlation Plot</strong> (Diagrama de Moran) evalúa si existe <strong>autocorrelación espacial</strong>. Si los puntos se agrupan en los cuadrantes Alto-Alto y Bajo-Bajo, confirma que las observaciones están influenciadas por sus vecinas.
                    </p>
                </li>
            </ul>
            
            '
      )
    )
  } else if (page == "download") { 
    
    list(
      title = HTML(paste(icon("download", style = "
        font-size: 1em; 
        color: #766bd3;
        filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));"),"Tablas y descarga" )),
      content = HTML('
      
      
      
      <p style="margin-bottom: 15px;">
        Esta sección le permite generar <strong>tablas de datos personalizadas</strong> con indicadores de mortalidad para su procesamiento y análisis externo. La información puede descargarse en formato <strong>XLSX</strong>.
    </p>

    <h3 style="color: #4a4a4a; font-size: 1.2em; margin-top: 20px;">Panel de Configuración (Panel Izquierdo)</h3>
    <p style="margin-bottom: 10px;">
        Utilice el panel de la izquierda para definir el contenido y la estructura de su tabla. Se pueden configurar los siguientes elementos:
    </p>
    <ul style="list-style: none; padding-left: 0;">
        <li style="margin-bottom: 12px;">
            <strong style="color: #27ae60;">• Selección de Indicadores (Múltiple):</strong> Elija uno o varios indicadores de mortalidad para incluir en las columnas de la tabla. Los 9 indicadores disponibles son:
            <ul style="list-style-type: circle; padding-left: 20px; margin-top: 5px; font-size: 0.9em;">
                <li>Cantidad de defunciones</li>
                <li>Tasa de mortalidad (por 100.000)</li>
                <li>Tasa de mortalidad ajustada por edad (por 100.000)</li>
                <li>Cantidad de defunciones prematuras</li>
                <li>Cantidad de defunciones prematuras prevenibles</li>
                <li>Cantidad de defunciones prematuras tratables</li>
                <li>Tasa de mortalidad prematura (por 100.000)</li>
                <li>Tasa de mortalidad prematura prevenible (por 100.000)</li>
                <li>Tasa de mortalidad prematura tratable</li>
            </ul>
        </li>
        <li style="margin-bottom: 12px;">
            <strong style="color: #27ae60;">• Período Temporal (Slider):</strong> Seleccione el año deseado dentro del rango <strong>2000-2023</strong> utilizando el control deslizante con incremento anual.
        </li>
        <li style="margin-bottom: 12px;">
            <strong style="color: #27ae60;">• Nivel Geográfico:</strong> Defina si desea la información desagregada por <strong>Jurisdicción</strong> (provincia) o agrupada por <strong>Región</strong>.
        </li>
        <li style="margin-bottom: 12px;">
            <strong style="color: #27ae60;">• Categoría de Causas:</strong> Elija entre generar la tabla para la <strong>Mortalidad General</strong> o para un <strong>Grupo Específico de Causas de Muerte</strong>.
        </li>
    </ul>

    <div style="background-color: #e8f5e9; border-left: 5px solid #27ae60; padding: 15px; margin-top: 20px; border-radius: 4px;">
        <h3 style="color: #27ae60; font-size: 1.2em; margin-top: 0; margin-bottom: 10px;">Visualización y Descarga (Panel Derecho)</h3>
        <p style="margin-bottom: 10px;">
            Al configurar sus filtros, la tabla se generará dinámicamente en el <strong>Panel Derecho</strong>.
        </p>
        <p style="margin-bottom: 5px;">
            Una vez que la tabla refleje los datos deseados, podrá descargarla utilizando el <strong>botón de descarga</strong> que se encuentra ubicado en la parte inferior del Panel de Configuración.
        </p>
        <p style="margin-top: 10px; font-weight: bold;">
            Formato de Salida: <span style="color: #1a7d43;">Microsoft Excel (.xlsx)</span>
        </p>
      
      
      
      
      ')
    )
    
    
    } else {
    list(
      title = "Titulo",
      content = "Texto"
    )
    
  }
}