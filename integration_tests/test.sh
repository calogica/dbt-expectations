if [[ $# -gt 0 ]]
then

i=1;
for t in "$@"
do

    dbt seed -t $t &&
    dbt run -t $t &&
    dbt test -t $t

done

else
    echo "Please specify one or more targets as command-line arguments, i.e. test.sh bq snowflake"
fi
