#include <iostream>
#include <libpq-fe.h>

void do_exit(PGconn* conn){
    PQfinish(conn);
    exit(1);
}

void eseguiQuery(PGconn* conn){
    int nQuery= -1;
    bool stop= false;
    PGresult* res;
    std::string st="";
    while(!stop){
        std::cout<< "Scegliere la query inserendo il numero corrispondente:" <<std::endl
                 << "1) " <<std::endl
                 << "2) " <<std::endl
                 << "3) " <<std::endl
                 << "4) " <<std::endl
                 << "5) " <<std::endl
                 << "0) Chiudere programma" <<std::endl;
        std::cin>> nQuery;
        switch(nQuery){
            case 0:
                stop= true;
                break;
            case 1:
                st= "";
                res= PQexec(conn,st.c_str());
                break;
            case 2:
                st= "";
                res= PQexec(conn,st.c_str());
                break;
            case 3:
                st= "";
                res= PQexec(conn, st.c_str());
                break;
            case 4:
                st= "";
                res= PQexec(conn,st.c_str());
                break;
            case 5:
                st= "";
                res= PQexec(conn, st.c_str());
                break;
            default:
                std::cout<< "Numero errato";
        }
        if(PQresultStatus(res) != PGRES_TUPLES_OK){
            std::cout<< "Non è stato restituito un risutato" << PQerrorMessage(conn);
            PQclear(res);
            do_exit(conn);
        }
        int tuple= PQntuples(res);
        int campi= PQnfields(res);
        for(int i= 0; i<campi; ++i){
            std::cout<< PQfname(res,i) << "\t\t";
        }
        std::cout<<std::endl;
        for(int i= 0; i<tuple; ++i){
            for ( int j= 0; j < campi ; j++){
                std::cout<< PQgetvalue (res , i, j) << "\t\t";
            }
            std::cout<<std::endl ;
        }
        PQclear(res);
    }//while
}

int main() {
   
    PGconn* conn= PQconnectdb("");//dati database
    if(PQstatus(conn) == CONNECTION_BAD) {
        std::cout << "Errore di connessione: " << PQerrorMessage(conn) << std::endl;
        do_exit(conn);
    }
    esegui(conn);
    PQfinish(conn);
    return 0;
}
