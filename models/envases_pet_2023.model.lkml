connection:
"envases-eon-alg"

#"pet_envases"

# include all the views
include: "/views/**/*.view.lkml"
include: "/LookML_Dashboard/*.dashboard.lookml"

datagroup: envases_pet_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: envases_pet_default_datagroup

explore: rpt_mx_vtas {}

explore: rpt_mx_vtas_periodo {}
