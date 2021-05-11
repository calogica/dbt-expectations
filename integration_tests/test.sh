if [[ $# -gt 0 ]]
then

i=1;
for t in "$@"
do

    dbt seed -t $t --no-version-check &&
    dbt run -t $t --no-version-check&&
    dbt test -t $t --no-version-check

done

else
    echo "Please specify one or more targets as command-line arguments, i.e. test.sh bq snowflake"
fi
