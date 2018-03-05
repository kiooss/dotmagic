#// vim: set ft=zsh:

function doctrine-schema-update() {
    (
        echo "SET AUTOCOMMIT=0;"
        echo "SET UNIQUE_CHECKS=0;"
        echo "SET FOREIGN_KEY_CHECKS=0;"
        sf doctrine:schema:update --dump-sql
        echo "SET FOREIGN_KEY_CHECKS=1;"
        echo "SET UNIQUE_CHECKS=1;"
        echo "SET AUTOCOMMIT=1;"
        echo "COMMIT;"
    ) | mysql -uroot "$1"
}

function add-mysql-user() {
    if [[ $# -eq 0 ]] ; then
        echo "Usage: $0 [username] [password]";
        return 1
    fi

    (
        echo "CREATE USER '$1'@'%' IDENTIFIED BY '$2';"
        echo "GRANT ALL ON *.* TO '$1'@'%' WITH GRANT OPTION;"
    ) | mysql -uroot
}

function export-alter() {
cat <<- EOF | mysql -u root
    SELECT
    table_name,
    column_name,
    CONCAT('ALTER TABLE ``',
            table_name,
            '`` CHANGE ``',
            column_name,
            '`` ``',
            column_name,
            '`` ',
            column_type,
            ' ',
            IF(is_nullable = 'YES', '' , 'NOT NULL '),
            IF(column_default IS NOT NULL, concat('DEFAULT ', IF(column_default = 'CURRENT_TIMESTAMP', column_default, CONCAT('\'',column_default,'\'') ), ' '), ''),
            IF(column_default IS NULL AND is_nullable = 'YES' AND column_key = '' AND column_type = 'timestamp','NULL ', ''),
            IF(column_default IS NULL AND is_nullable = 'YES' AND column_key = '','DEFAULT NULL ', ''),
            extra,
            ' COMMENT \'',
            column_comment,
            '\' ;') as script
    FROM
        information_schema.columns
    WHERE
        table_schema = '$1'
    ORDER BY table_name , column_name
    INTO OUTFILE '$HOME/alters.csv'
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n';
EOF
}

function reset-table() {
    echo "SET FOREIGN_KEY_CHECKS=0;"
    echo "DELETE FROM $1;"
    echo "SET FOREIGN_KEY_CHECKS=1;"
    echo "ALTER TABLE $1 AUTO_INCREMENT = 1;"
}

function mysql-dump-command() {
  DBNAME=$1
  echo "mysqldump -u [user] -h [host] -p --single-transaction --quick ${DBNAME} [table] | gzip > ${DBNAME}_$(date +%Y%m%d%H%M%S).sql.gz"
}

function mysql-import-command() {
  echo "gunzip < outputfile.sql.gz | mysql < mysql options>"
}
