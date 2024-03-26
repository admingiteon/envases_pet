view: rpt_mx_vtas {
  derived_table: {
    sql: SELECT *,DATE(PARSE_TIMESTAMP('%Y%m%d',CALDAY)) fecha,DATE_ADD(CURRENT_DATE(), INTERVAL -1 DAY) ACTUALIZACION FROM
    `corp-pet-looker-reports.RPT_S4H_MX_DEV.RPT_MX_VTAS`
    --`envases-analytics-eon-poc.RPT_PET.tbl_fact_vtas_devol_cancel`
    where CATEGORY  not in ('TOTAL MXN') and CATEGORY not in ('OTROS','SUBPRODUCTOS')
    ;;
  }


  filter: date_filter {
    label: "Período"
    description: "Use this date filter in combination with the timeframes dimension for dynamic date filtering"
    type: date

  }

  dimension: actualizacion {
    type: date
    sql: ${TABLE}.ACTUALIZACION   ;;
  }

  measure: ult_act {
    type: date
    label: "Fecha actualización"
    sql:  MAX(${actualizacion})   ;;
    convert_tz: no
  }


  dimension: fecha_ultimo {
    type: date
    sql:  CAST({% date_start date_filter %} AS DATE);;
   # CONCAT(CAST(EXTRACT(day FROM ${TABLE}.ACTUALIZACION) as STRING),

   #  "-",
   # #  CASE
   #  WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION ) = 1 THEN  'Ene'
   #  WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 2 THEN 'Feb'
   # WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 3 THEN 'Mar'
   # WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 4 THEN 'Abr'
   # #WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 5 THEN 'May'
   # WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 6 THEN 'Jun'
   # WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 7 THEN 'Jul'
   # WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 8 THEN 'Ago'
   # WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 9 THEN 'Sep'
   # WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 10 THEN 'Oct'
   # WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 11 THEN 'Nov'
   # WHEN  EXTRACT(Month FROM ${TABLE}.ACTUALIZACION)  = 12 THEN 'Dic'
   # ELSE 'Sin Clasificar'
   # END,
   # "-",
  #  CAST(EXTRACT(year FROM ${TABLE}.ACTUALIZACION) as STRING));;


 }





  dimension: base_uom {
    type: string
    sql: ${TABLE}.BASE_UOM ;;
  }

  dimension: bill_qty {
    type: number
    sql: ${TABLE}.BILL_QTY ;;
  }



  #dimension: calday {
  #  type: string
  #  sql: ${TABLE}.CALDAY ;;
  #}
  dimension: category {
    label: "Ventas por Sector"
    type: string
    sql: concat(UPPER(LEFT(${TABLE}.CATEGORY, 1)) , LOWER(SUBSTR(${TABLE}.CATEGORY, 2, 20)))    ;;
    #sql: UPPER(LEFT(${TABLE}.CATEGORY, 1)) + LOWER(SUBSTRING(${TABLE}.CATEGORY, 2, LEN(${TABLE}.CATEGORY)))   ;;


   # link: {
    #  label: "Solicitante"
    #  url:"https://envases.cloud.looker.com/dashboards/54?Período={{ _filters['date_filter'] | url_encode }}&Ventas+por+Sector={{ value }}"

      #   url: "https://grupoeon.cloud.looker.com/dashboards-next/35?&f[Sociedad]={{ _filters['Sociedad'] | url_encode }}"
    #  #https://corpcab.cloud.looker.com/dashboards/50?Material={{ value }}"
    #  icon_url: "https://cdn0.iconfinder.com/data/icons/real-estate-111/512/Real_Estate_expanded-14-512.png"
    #}


   # https://envases.cloud.looker.com/dashboards/54?Per%C3%ADodo=2023%2F09%2F05&Ventas%20por%20Sector=
  }


  dimension: planta_desc {
    label: "planta_desc"
    type: string
    sql: ${TABLE}.name1 ;;
  }


  dimension: logo {
    type: string
    sql: "";;
    html:<img src="https://www.envases.mx/media/10252/envases_rgb600x400px.png" height="170" width="255">;;

  }



  dimension: client {
    label: "Cliente"
    type: string
    sql: ${TABLE}.CLIENT ;;
  }
  dimension: distr_chan {
    type: string
    sql: ${TABLE}.DISTR_CHAN ;;
  }
  dimension: material {
    type: string
    sql: ${TABLE}.MATERIAL ;;
  }
  dimension: matl_group {
    type: string
    sql: ${TABLE}.MATL_GROUP ;;
  }
  dimension: plant {
    label : "Planta"
    type: string
    sql: ${TABLE}.PLANT ;;
  }
  dimension: prodh1 {
    type: string
    sql: ${TABLE}.PRODH1 ;;
  }
  dimension: sales_off {
    type: string
    sql: ${TABLE}.SALES_OFF ;;
  }
  dimension: salesorg {
    label: "Cliente_"
    type: string
    sql: ${TABLE}.SALESORG ;;
  }
  dimension: sold_to {
    type: string
    sql: ${TABLE}.SOLD_TO ;;
  }
  dimension: stat_curr {
    type: string
    sql: ${TABLE}.STAT_CURR ;;
  }
  dimension: version {
    type: string
    sql: ${TABLE}.VERSION ;;
  }
  dimension: znetval {
    type: number
    sql: ${TABLE}.ZNETVAL ;;
  }





  dimension: Fecha_venta {
    type: date
    sql:  CAST(${TABLE}.Fecha AS TIMESTAMP) ;;



    drill_fields:[category,Fecha_venta,MTD,YTD]
  }



  measure: count {
    type: count
  }

  measure: TOTAL_BILLY {
    type: sum
    sql: ${TABLE}.BILL_QTY ;;

  }


  measure: DIA{
    type: sum
    sql: ${TABLE}.BILL_QTY/1000  ;;

    filters: {
      field: is_current_period_DAY
      value: "yes"
    }
    value_format: "#,##0"
    drill_fields: [ category,planta_desc,client,DIA]
  }




  measure: DIA_formato{
    type: number
    sql:   CAST(${DIA} AS STRING FORMAT '999,999')    ;;


    value_format: "##,##0"
    drill_fields: [ category,planta_desc,client,DIA]
  }









  measure: DIA_anterior{
    label: "LY DIA"
    type: sum
    sql: ${TABLE}.BILL_QTY/1000  ;;
    filters: {
      field: is_current_period_DAY_anterior
      value: "yes"
    }
    value_format: "#,##0"
  }


  measure: VS_LY{
    type: number
    sql:    (${DIA}-${DIA_anterior})/NULLIF(${DIA_anterior},0) *100 ;;
    value_format: "0.0\%"
    drill_fields: [ category,planta_desc,client,VS_LY]

   html:
    {% if value > 0 %}
    {% assign indicator = "green,▲" | split: ',' %}
    {% else %}
    {% assign indicator = "red,▼" | split: ',' %}
    {% endif %}

    <font color="{{indicator[0]}}">

    {% if value == 99999.12345 %} &infin

    {% else %}{{rendered_value}}

    {% endif %} {{indicator[1]}}

    </font> ;;
  }

  measure: VS_LY_formato{
    type: number
    sql:  CAST(${VS_LY} AS STRING FORMAT '999.9')    ;;
    value_format: "000.0\%"
    drill_fields: [ category,planta_desc,client,VS_LY]

  }


  measure: MTD{
    type: sum
    sql: ${TABLE}.BILL_QTY/1000 ;;
    filters: {
      field: is_current_period_MONTH
      value: "yes"
    }

   drill_fields: [ category,planta_desc,client,MTD]
    value_format: "#,##0"
  }

  measure: MTD_yl{
    label: "LY MTD"
    type: sum
    sql: ${TABLE}.BILL_QTY/1000 ;;
    filters: {
      field: is_current_period_MONTH_anterior
      value: "yes"
    }
    value_format: "#,##0"
  }


  measure: VS_LY_1{
    type: number
    sql:    (${MTD}-${MTD_yl})/NULLIF(${MTD_yl},0) *100  ;;
    value_format: "0.0\%"
     drill_fields: [ category,planta_desc,client,VS_LY_1]
    html:
    {% if value > 0 %}
    {% assign indicator = "green,▲" | split: ',' %}
    {% else %}
    {% assign indicator = "red,▼" | split: ',' %}
    {% endif %}

    <font color="{{indicator[0]}}">

    {% if value == 99999.12345 %} &infin

    {% else %}{{rendered_value}}

    {% endif %} {{indicator[1]}}

    </font> ;;
  }



  measure: YTD{
    type: sum
    sql: ${TABLE}.BILL_QTY /1000;;
    filters: {
      field:  is_current_period_DAY_YTD
      value: "yes"
    }
    value_format: "#,##0"
     drill_fields: [ category,planta_desc,client,YTD]
  }

  measure: YTD_anterior{
    label: "LY YTD"
    type: sum
    sql: ${TABLE}.BILL_QTY /1000;;
    filters: {
      field:  is_current_period_DAY_YTD_anterior
      value: "yes"
    }
    value_format: "#,##0"
  }


  measure: VS_LY_2{
    type: number
    sql:    (${YTD}-${YTD_anterior})/NULLIF(${YTD_anterior},0) * 100 ;;
    value_format: "0.0\%"
     drill_fields: [ category,planta_desc,client,VS_LY_2]
    html:
    {% if value > 0 %}
        {% assign indicator = "green,▲" | split: ',' %}
    {% else %}
         {% assign indicator = "red,▼" | split: ',' %}
    {% endif %}

    <font color="{{indicator[0]}}">

{% if value == 99999.12345 %} &infin

{% else %}{{rendered_value}}

{% endif %} {{indicator[1]}}

</font> ;;



  }





  measure: MTD_2{
    type: sum
    sql: ${TABLE}.BILL_QTY ;;
    filters: {
      field: is_current_period_MONTH
      value: "yes"
    }

  }





  measure: total_BILL_QTY {
    type: sum
    sql: ${TABLE}.BILL_QTY  ;;
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










  dimension_group: created {
    label: "Fecha"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      month_name,
      year
    ]
    sql: CAST(${TABLE}.Fecha AS TIMESTAMP) ;;



  }

  dimension: is_previous_period {
    hidden: yes
    type: yesno
    sql: CAST(${created_date} AS DATE) >=  DATE_ADD(DATE (DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), MONTH)), INTERVAL -1 year)   AND CAST(${created_date} AS DATE) <= DATE_ADD(DATE (CAST({% date_start date_filter %} AS DATE)), INTERVAL -1 year)   ;;
  }



 ##################Dias ############################

  dimension: is_current_period_DAY {
    hidden: yes
    type: yesno
    sql:DATE_TRUNC(CAST(${created_date} AS DATE),DAY) =DATE_ADD( DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY),INTERVAL -0 DAY);;
  }

  dimension: is_current_period_DAY_anterior {
    hidden: yes
    type: yesno
    sql:DATE_TRUNC(CAST(${created_date} AS DATE),DAY) =DATE_ADD(DATE_ADD( DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY),INTERVAL -1 year),INTERVAL -0 day);;
  }

  ##################Dias ############################


  ##################Mes ############################
  dimension: is_current_period_MONTH{
    hidden: yes
    type: yesno
    sql: DATE_TRUNC(CAST(${created_date} AS DATE),DAY) >=DATE_ADD(DATE_ADD(LAST_DAY(CAST({% date_start date_filter %} AS DATE)), INTERVAL 1 DAY),INTERVAL -1 MONTH) AND DATE_TRUNC(CAST(${created_date} AS DATE),DAY) <= DATE_ADD((CAST({% date_start date_filter %} AS DATE)),INTERVAL -0 day)  ;;
    #sql: DATE_TRUNC(CAST(${created_date} AS DATE),DAY)>=DATE_ADD(DATE_ADD(LAST_DAY(CAST({% date_start date_filter %} AS DATE)), INTERVAL 1 DAY),INTERVAL -1 MONTH)    ;;
    #sql:DATE_TRUNC(CAST(${created_date} AS DATE),YEAR) =  DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), YEAR)  and DATE_TRUNC(CAST(${created_date} AS DATE),MONTH) = DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), MONTH) ;;
    #LAST_DAY
  }


  dimension: is_current_period_MONTH_anterior{
    hidden: yes
    type: yesno
    sql: DATE_TRUNC(CAST(${created_date} AS DATE),DAY) >=DATE_ADD(DATE_ADD(LAST_DAY(     DATE_ADD( CAST({% date_start date_filter %} AS DATE) ,INTERVAL -1 YEAR)        ), INTERVAL 1 DAY),INTERVAL -1 MONTH) AND DATE_TRUNC(CAST(${created_date} AS DATE),DAY) <= DATE_ADD(   DATE_ADD( CAST({% date_start date_filter %} AS DATE) ,INTERVAL -1 YEAR)    ,INTERVAL -0 day)  ;;
   # sql:DATE_TRUNC(CAST(${created_date} AS DATE),YEAR) =  DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), YEAR) -1  and   DATE_TRUNC(CAST(${created_date} AS DATE),MONTH) = DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), MONTH) ;;

  }
   ##################Mes ############################


  ##################año ############################


  dimension: is_current_period_DAY_YTD {
    hidden: yes
    type: yesno
    sql: ${created_date} >= CAST(CONCAT(CAST(EXTRACT(YEAR FROM DATE ({% date_start date_filter %})) AS STRING),"-01-01")  AS DATE) and  ${created_date} <= DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY)   ;;
    #DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), YEAR);;  FECHA         DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), MONTH)
  }

  dimension: is_current_period_DAY_YTD_anterior {
    hidden: yes
    type: yesno
    sql: ${created_date} >= CAST(CONCAT(CAST(EXTRACT(YEAR FROM DATE ({% date_start date_filter %})) -1 AS STRING),"-01-01")  AS DATE) and  ${created_date} <= DATE_ADD(DATE_ADD( DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY),INTERVAL -1 year),INTERVAL -0 day)   ;;
    #DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), YEAR);;  FECHA         DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), MONTH)
  }

   ##################año ############################

















  dimension: is_current_period_DAY_YL {
    hidden: yes
    type: yesno
     sql: DATE_TRUNC(CAST(${created_date} AS DATE),DAY) >=DATE_ADD(DATE_ADD(LAST_DAY(CAST({% date_start date_filter %} AS DATE)), INTERVAL 1 DAY),INTERVAL -1 MONTH) AND DATE_TRUNC(CAST(${created_date} AS DATE),DAY) <= DATE_ADD(LAST_DAY(CAST({% date_start date_filter %} AS DATE)),INTERVAL -1 day)  ;;
   # sql:DATE_TRUNC(CAST(${created_date} AS DATE),DAY) =DATE_ADD( DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY),INTERVAL -366 DAY);;
  }




  dimension: is_current_period_DAY_YL1 {
    hidden: yes
    type: yesno
    #sql: ${created_date} >= CAST(CONCAT(CAST(EXTRACT(YEAR FROM DATE ({% date_start date_filter %}))-1 AS STRING),"-01-01")  AS DATE) and  ${created_date} <= DATE_ADD( DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), DAY),INTERVAL -366 DAY)  ;;
    #DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), YEAR);;  FECHA         DATE_TRUNC(CAST({% date_start date_filter %} AS DATE), MONTH)
  }










  dimension: is_current_period_year {
    hidden: yes
    type: yesno
    sql:${created_year}  = EXTRACT(YEAR FROM CURRENT_DATE())-1 ;;
  }


  dimension: is_previous_period_day_vs_day {
    hidden: yes
    type: yesno
    sql: CAST(${created_date} AS DATE) >=  DATE_ADD(DATE (DATE_TRUNC(CAST(CURRENT_DATE() AS DATE), MONTH)), INTERVAL -1 year)   AND CAST(${created_date} AS DATE) <= DATE_ADD(DATE (CAST(CURRENT_DATE() AS DATE)), INTERVAL -1 year)   ;;

  }



  dimension: is_current_period_previus_last_year {
    hidden: yes
    type: yesno
    sql:DATE_TRUNC(DATE_ADD(CAST(${created_date} AS DATE), INTERVAL -1 year), year) = DATE_TRUNC(CURRENT_DATE(), year);;
  }

  measure: dash_nav {
    hidden: no
    label: "dia incremento"
    type: number
    sql: ${VS_LY_1} ;;



  }




  set: detail {
    fields: [
      category,Fecha_venta,MTD,YTD

    ]
    }









}
