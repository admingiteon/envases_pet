view: rpt_mx_vtas_periodo {
  derived_table: {
    sql:
    WITH ventas as (
    SELECT PLANT,CLIENT,name1,CATEGORY,CALDAY,BILL_QTY,DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) fecha,DATE_ADD(CURRENT_DATE(), INTERVAL -1 DAY) ACTUALIZACION FROM
   -- `corp-pet-looker-reports.RPT_S4H_MX_DEV.RPT_MX_VTAS`
    `envases-analytics-eon-poc.RPT_PET.tbl_fact_vtas_devol_cancel`
    where CATEGORY  not in ('TOTAL MXN') and CATEGORY not in ('OTROS','SUBPRODUCTOS')
    )
    ,dia as (
    SELECT BILL_QTY/1000 Valor
           ,*
     FROM ventas where  DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) =CAST({% date_start date_filter %} AS DATE)
    )
    ,dia_lY as (
     SELECT BILL_QTY/1000 Valor
            ,*
     FROM ventas
     where DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) =DATE_ADD(DATE_ADD( DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY),INTERVAL -1 year),INTERVAL -0 day)
    )
    ,day_index as (

    SELECT (dia-dia_ly) / NULLIF(dia_ly ,0)  valor
          ,CATEGORY ,name1,PLANT,CLIENT FROM (
    SELECT
          COALESCE(SUM(case when DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) =CAST({% date_start date_filter %} AS DATE) then BILL_QTY else NULL end),0) dia
          ,COALESCE(SUM(case when DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) =DATE_ADD(DATE_ADD( DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY),INTERVAL -1 year),INTERVAL -0 day) then BILL_QTY else NULL end),0)  dia_ly
          ,CATEGORY
          ,name1
          ,PLANT
          ,CLIENT
     FROM ventas
    GROUP BY CATEGORY,name1,PLANT,CLIENT
     ) a
    )

    ,mes as (
    SELECT BILL_QTY/1000 Valor
           ,*
     FROM ventas where DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) >=DATE_ADD(DATE_ADD(LAST_DAY(CAST({% date_start date_filter %} AS DATE)), INTERVAL 1 DAY),INTERVAL -1 MONTH) AND DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) <= DATE_ADD((CAST({% date_start date_filter %} AS DATE)),INTERVAL -0 day)
    )

     ,mes_lY as (
     SELECT BILL_QTY/1000 Valor
            ,*
     FROM ventas
     where DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) >=DATE_ADD(DATE_ADD(LAST_DAY(     DATE_ADD( CAST({% date_start date_filter %} AS DATE) ,INTERVAL -1 YEAR)        ), INTERVAL 1 DAY),INTERVAL -1 MONTH) AND DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) <= DATE_ADD(   DATE_ADD( CAST({% date_start date_filter %} AS DATE) ,INTERVAL -1 YEAR)    ,INTERVAL -0 day)
    )

     ,mes_index as (

    SELECT (((dia-dia_ly) / NULLIF(dia_ly ,0)) /1000)*100 valor
          ,CATEGORY ,name1,PLANT,CLIENT FROM (
    SELECT
           COALESCE(SUM(case when DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) >=DATE_ADD(DATE_ADD(LAST_DAY(CAST({% date_start date_filter %} AS DATE)), INTERVAL 1 DAY),INTERVAL -1 MONTH) AND DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) <= DATE_ADD((CAST({% date_start date_filter %} AS DATE)),INTERVAL -0 day) then BILL_QTY else NULL end),0) dia
          ,COALESCE(SUM(case when DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) >=DATE_ADD(DATE_ADD(LAST_DAY(     DATE_ADD( CAST({% date_start date_filter %} AS DATE) ,INTERVAL -1 YEAR)        ), INTERVAL 1 DAY),INTERVAL -1 MONTH) AND DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) <= DATE_ADD(   DATE_ADD( CAST({% date_start date_filter %} AS DATE) ,INTERVAL -1 YEAR)    ,INTERVAL -0 day) then BILL_QTY else NULL end),0)  dia_ly
          ,CATEGORY
          ,name1
          ,PLANT
          ,CLIENT
     FROM ventas
    GROUP BY CATEGORY,name1,PLANT,CLIENT
     ) a
    )


    ,year as (
    SELECT BILL_QTY/1000 Valor
           ,*
     FROM ventas where DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) >= CAST(CONCAT(CAST(EXTRACT(YEAR FROM DATE ({% date_start date_filter %})) AS STRING),"-01-01")  AS DATE) and  DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) <= DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY)
    )

     ,year_lY as (
     SELECT BILL_QTY/1000 Valor
            ,*
     FROM ventas
     where DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) >= CAST(CONCAT(CAST(EXTRACT(YEAR FROM DATE ({% date_start date_filter %})) -1 AS STRING),"-01-01")  AS DATE) and  DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) <= DATE_ADD(DATE_ADD( DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY),INTERVAL -1 year),INTERVAL -0 day)
    )


    ,year_index as (

    SELECT (((dia-dia_ly) / NULLIF(dia_ly ,0)) /1000)*100 valor
          ,CATEGORY ,name1,PLANT,CLIENT FROM (
    SELECT
           COALESCE(SUM(case when DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) >= CAST(CONCAT(CAST(EXTRACT(YEAR FROM DATE ({% date_start date_filter %})) AS STRING),"-01-01")  AS DATE) and  DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) <= DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY) then BILL_QTY else NULL end),0) dia
          ,COALESCE(SUM(case when DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) >= CAST(CONCAT(CAST(EXTRACT(YEAR FROM DATE ({% date_start date_filter %})) -1 AS STRING),"-01-01")  AS DATE) and  DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) <= DATE_ADD(DATE_ADD( DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY),INTERVAL -1 year),INTERVAL -0 day) then BILL_QTY else NULL end),0)  dia_ly
          ,CATEGORY
          ,name1
          ,PLANT
          ,CLIENT
     FROM ventas
    GROUP BY CATEGORY,name1,PLANT,CLIENT
     ) a
    )








   Select * from (
    select Valor,CATEGORY,name1,PLANT,CLIENT,'Dia' Periodo,'2.Dia' medida,1 Orden from dia
    union all
    select Valor,CATEGORY,name1,PLANT,CLIENT,'Dia' Periodo,'1.LY Dia'medida,2 Orden from dia_lY
    union all
    select Valor,CATEGORY,name1,PLANT,CLIENT,'Dia' Periodo,'3.VS LY' medida,3 Orden from day_index




    union all
    select Valor,CATEGORY,name1,PLANT,CLIENT,'Mes' Periodo,'5.Mes' medida,3 Orden from mes
    union all
    select Valor,CATEGORY,name1,PLANT,CLIENT,'Mes' Periodo,'4.LY Mes'medida,4 Orden from mes_lY
    union all
    select Valor,CATEGORY,name1,PLANT,CLIENT,'Mes' Periodo,'6.VS LY Mes' medida,5 Orden from mes_index


    union all
    select Valor,CATEGORY,name1,PLANT,CLIENT,'Año' Periodo,'8.Año' medida,6 Orden from year
    union all
    select Valor,CATEGORY,name1,PLANT,CLIENT,'Año' Periodo,'7.LY Año'medida,7 Orden from year_lY
    union all
    select Valor,CATEGORY,name1,PLANT,CLIENT,'Año' Periodo,'9.VS LY Año' medida,8 Orden from year_index
    ) a order by Orden










    ;;
  }


  filter: date_filter {
    label: "Fecha"
    description: "Use this date filter in combination with the timeframes dimension for dynamic date filtering"
    type: date

  }

  dimension: Periodo {
    label: "Periodo tiempo"
    type: string
    sql: ${TABLE}.Periodo   ;;
  }

  dimension: medida {

    type: string
    sql: ${TABLE}.medida   ;;
  }

  dimension: CATEGORY {
    label: "Ventas por Sector"
    type: string
    sql: concat(UPPER(LEFT(${TABLE}.CATEGORY, 1)) , LOWER(SUBSTR(${TABLE}.CATEGORY, 2, 20)))    ;;
  }

  dimension: planta_desc {
    label: "planta_desc"
    type: string
    sql: ${TABLE}.name1 ;;
  }

  dimension: client {
    label: "Cliente"
    type: string
    sql: ${TABLE}.CLIENT ;;
  }

  dimension: plant {
    label : "Planta"
    type: string
    sql: ${TABLE}.PLANT ;;
  }


  dimension: Orden {
    label: "Orden"
    type: number
    sql: ${TABLE}.Orden   ;;
    hidden: yes
  }

  dimension: case_categoria {
    label: "Sector"
    type: string
    sql: CASE
          WHEN ${client} IN ('EMBOTELLADORA MEXICANA', 'BEBIDAS MUNDIALES', 'JUGOS DEL VALLE', 'EMBOTELLADORA NOVAMEX') THEN 'Preforma'
          WHEN ${client} IN ('Compañía Topo Chico', 'ELORO', 'BEBIENDO') THEN 'Botella'
          WHEN ${client} IN ('La Asunción', 'Las Margaritas') THEN 'Linea General'
          WHEN ${client} IN ('Industrial GRUMEX', 'PROPIMEX') THEN 'Otros'
          ELSE 'Desconocido'
          END ;;
    drill_fields: [,client]
  }

  dimension: Planta_descripcion {
    label: "Venta por planta"
    type: string
    sql: CASE
          WHEN ${TABLE}.plant = 'MP01' THEN 'PET-Cuautitlán, México'
          WHEN ${TABLE}.plant = 'MP02' THEN 'PET-San Juan Del Río, México'
          WHEN ${TABLE}.plant = 'MP03' THEN 'PET-Tepotzotlán, México'
          WHEN ${TABLE}.plant = 'MP05' THEN 'PET-Recovery, México'
          WHEN ${TABLE}.plant = 'MP06' THEN 'PET-Ecatepec Jumex, Mexico'
          WHEN ${TABLE}.plant = 'MP07' THEN 'PET-Apizaco, México'
          WHEN ${TABLE}.plant = 'MP08' THEN 'PET-El Salto Eum, México'
          WHEN ${TABLE}.plant = 'MP09' THEN 'PET-La Favorita, México'
          WHEN ${TABLE}.plant = 'MP10' THEN 'PET-Colima, México'
          WHEN ${TABLE}.plant = 'MP11' THEN 'PET-Administrativo, México'
          WHEN ${TABLE}.plant = 'MP12' THEN 'PET-Guadalupe Mty, México'
          WHEN ${TABLE}.plant = 'MP13' THEN 'PET-Matamoros, México'
          WHEN ${TABLE}.plant = 'MP14' THEN 'PET-Piedras Negras, México'
          WHEN ${TABLE}.plant = 'MP15' THEN 'PET-Torreon Eum, México'
          WHEN ${TABLE}.plant = 'MP16' THEN 'PET-Coatepec Eum, México'
          WHEN ${TABLE}.plant = 'MP17' THEN 'PET-Apodaca Mty, México'
          WHEN ${TABLE}.plant = 'MP18' THEN 'PET-Insurgentes Mty, México'
          WHEN ${TABLE}.plant = 'MP19' THEN 'PET-Topochico Mty, México'
          WHEN ${TABLE}.plant = 'MP20' THEN 'PET-Aguascalientes, México'
          WHEN ${TABLE}.plant = 'MP21' THEN 'PET-Leon Eum, México'
          WHEN ${TABLE}.plant = 'MP22' THEN 'PET-Leon Femsa Eum, México'
          WHEN ${TABLE}.plant = 'MP23' THEN 'PET-Morelia Eum, México'
          WHEN ${TABLE}.plant = 'MP24' THEN 'PET-Altamira, México'
          WHEN ${TABLE}.plant = 'MP26' THEN 'PET-Tijuana, Mexico'
          WHEN ${TABLE}.plant = 'MP27' THEN 'PET-Mochis, Mexico'
          WHEN ${TABLE}.plant = 'MP30' THEN 'PET-Durango, Mexico'
          WHEN ${TABLE}.plant = 'MP31' THEN 'PET-Apan Inyección, México'
          WHEN ${TABLE}.plant = 'MP51' THEN 'PET-COM-Cuautitlán, México'
          WHEN ${TABLE}.plant = 'MP53' THEN 'PET-COM-Tepotzotlán, México'
          WHEN ${TABLE}.plant = 'MP55' THEN 'PET-COM-Recovery, México'
          WHEN ${TABLE}.plant = 'MP56' THEN 'PET-COM-Ecatepec JUMEX, México'
          WHEN ${TABLE}.plant = 'MP57' THEN 'PET-COM-Apizaco, México'
          WHEN ${TABLE}.plant = 'MP58' THEN 'PET-COM-El Salto EUM, México'
          WHEN ${TABLE}.plant = 'MP59' THEN 'PET-COM-La Favorita, México'
          WHEN ${TABLE}.plant = 'MP60' THEN 'PET-COM-Colima, México'
          WHEN ${TABLE}.plant = 'MP62' THEN 'PET-COM-Guadalupe MTY, México'
          WHEN ${TABLE}.plant = 'MP63' THEN 'PET-COM-Matamoros, México'
          WHEN ${TABLE}.plant = 'MP64' THEN 'PET-COM-Piedras Negras, México'
          WHEN ${TABLE}.plant = 'MP65' THEN 'PET-COM-Torreon EUM, México'
          WHEN ${TABLE}.plant = 'MP67' THEN 'PET-COM-Apodaca II Mty, México'
          WHEN ${TABLE}.plant = 'MP68' THEN 'PET-COM-Insurgentes MTY, Mx'
          WHEN ${TABLE}.plant = 'MP69' THEN 'PET-COM-Topochico MTY, MX'
          WHEN ${TABLE}.plant = 'MP70' THEN 'PET-COM-Aguascalientes, México'
          WHEN ${TABLE}.plant = 'MP71' THEN 'PET-COM-Leon EUM, México'
          WHEN ${TABLE}.plant = 'MP80' THEN 'PET-COM Durango, Mexico'
          ELSE 'Planta Desconocida'
        END ;;
  }







  measure: TOTAL_BILLY {
    type: sum
    value_format: "#,##0"
    # sql: ${TABLE}.Valor ;;
    sql: ${TABLE}.Valor  ;;

    html:

    {% if medida._value  == '3.VS LY' or medida._value  == '6.VS LY Mes' or medida._value=='9.VS LY Año' %}

    {% if value > 0 %}

    {% assign indicator = "green,▲" | split: ',' %}
    {% else %}
    {% assign indicator = "red,▼" | split: ',' %}
    {% endif %}

    <font color="{{indicator[0]}}">

    {% if value == 99999.12345 %} &infin
    {% else %}{{value | round: 1  | append: "%"}}
    {% endif %} {{indicator[1]}}

    </font>

    {% else %}
     {{rendered_value  }}
    {% endif %}


    ;;

  }




}
