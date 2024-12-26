const sql = require('mssql');
const mysql = require('mysql2/promise');
const fs = require('fs');

const mssqlConfig = {
    user: 'hirev5',
    password: 'hirev5@123',
    server: '10.51.7.56',
    port: 2228,
    database: 'Esourcingv5',
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
};

const mysqlConfig = {
    host: '10.50.164.93',
    port: 3306,
    user: 'dmstest2',
    password: 'Hire@123',
    database: 'RMS_PRD'
};

const log_file_location="./clientMigrationLog.txt";
var writableStream = fs.createWriteStream(log_file_location);

async function EntityMigration( orgLevel) {
    try {
        let mssqlPool = await sql.connect(mssqlConfig);
        var QueryD="SELECT distinct MainGrp,MainGrp_Descr FROM HireCraftV5_PSFT.PSFT_Interface.commonhr.HC_DEPARTMENT_MASTER where MainGrp_Descr<>''"
        const result = await mssqlPool.request().query(QueryD);
        const mysqlConnection = await mysql.createConnection(mysqlConfig);
        for (let row of result.recordset) {
            const MainGrp = row.MainGrp.toString();
            const MainGrp_Descr=row.MainGrp_Descr.toString();
            var cellQuery="CALL usp_clientMigration('"+MainGrp+"', '"+MainGrp_Descr+"');"
            if(MainGrp.length>1){
                try{
                    await mysqlConnection1.execute(cellQuery);
                }
                catch(ex){
                    writableStream.write("Error for :"+MainGrp+" ---- "+ex+"\n");
                }   
            }
        }

        await mssqlPool.close();
        await mysqlConnection.end();

    }
    catch(Ex){
        writableStream.write("Error :"+Ex+"\n");
    }
}


function main_method(){
    return EntityMigration(1).then();
}

main_method();
        


