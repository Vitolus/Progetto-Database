#include <iostream>
#include "libpq-fe.h" //modificare all' occorrenza

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
                 << "1) Stampare quanto ogni utente ha speso fino a quel momento, sommando tutti i suoi ordini effettuati" <<std::endl
                 << "2) Visualizzare quanli utenti hanno creato dei personaggi con delle classi marziali" <<std::endl
                 << "3) Visualizzare per ogni classe di origini arcane quali incantesimi conosce" <<std::endl
                 << "4) Stampare il livello medio dei personaggi di una certa razza di taglia media, raggruppandoli per classi" <<std::endl
                 << "5) Visualizzare quanti manuali ogni utente ha acquistato tra quelli usciti prima del 2020" <<std::endl
                 << "0) Chiudere programma" <<std::endl;
        std::cin>> nQuery;
        switch(nQuery){
            case 0:
                stop= true;
                break;
            case 1:
                st= "SELECT Utente.nome, Utente.cognome, SUM(Ordine.importo) AS spesa_totale"
                    " FROM Utente JOIN Ordine ON (Ordine.utente=Utente.mail)"
                    " GROUP BY Utente.nome, Utente.cognome ORDER BY spesa_totale DESC;";
                res= PQexec(conn,st.c_str());
                break;
            case 2:
                st= "SELECT Utente.nome, Utente.cognome, Personaggio.nome AS personaggio,Personaggio.classe"
                    " FROM Utente JOIN Personaggio ON (Personaggio.utente=Utente.mail)"
                    " JOIN Classe ON (Personaggio.classe=Classe.nome)"
                    " WHERE (origine='marziale');";
                res= PQexec(conn,st.c_str());
                break;
            case 3:
                st= "SELECT Classe.nome, COUNT(Magia.incantesimo) AS N_incantesimi"
                    " FROM Classe JOIN Magia ON (Classe.nome=Magia.classe)"
                    " GROUP BY Classe.nome HAVING (Classe.origine='arcana')"
                    " ORDER BY N_incantesimi DESC;";
                res= PQexec(conn, st.c_str());
                break;
            case 4:
                st= "SELECT Personaggio.classe, ROUND(AVG(Personaggio.livello),0) AS livello_medio"
                    " FROM Personaggio JOIN Razza ON (Personaggio.razza=Razza.nome)"
                    " WHERE (Razza.taglia='media')"
                    " GROUP BY Personaggio.classe ORDER BY livello_medio;";
                res= PQexec(conn,st.c_str());
                break;
            case 5:
                st= "DROP VIEW IF EXISTS Manuale; CREATE VIEW Manuale AS"
                    " SELECT Avventura.nome, Avventura.dataPubblicazione"
                    " FROM Avventura WHERE (dataPubblicazione<='2020-01-01')"
                    " UNION SELECT Regolamento.nome, Regolamento.dataPubblicazione"
                    " FROM Regolamento WHERE (dataPubblicazione<='2020-01-01');"
                    " SELECT Utente.nome, Utente.cognome, COUNT(OrdineM.manuale) AS manuali_acquistati"
                    " FROM Utente JOIN Ordine ON (Utente.mail=Ordine.utente)"
                    " JOIN(SELECT ordine, avventura AS manuale"
                    " FROM OrdineT UNION SELECT ordine, regolamento AS manuale"
                    " FROM OrdineR ORDER BY ordine) AS OrdineM ON (Ordine.ID=OrdineM.ordine)"
                    " JOIN Manuale ON (Manuale.nome=OrdineM.manuale) GROUP BY Utente.nome, Utente.cognome;";
                res= PQexec(conn, st.c_str());
                break;
            default:
                std::cout<< "Numero errato";
        }

        std::cout<<std::endl;
        if(PQresultStatus(res) != PGRES_TUPLES_OK){
            std::cout<< "Non è stato restituito un risutato" << PQerrorMessage(conn);
            PQclear(res);
            do_exit(conn);
        }
        int tuple= PQntuples(res);
        int attributi= PQnfields(res);
        for(int i= 0; i<attributi; ++i){
            std::cout<< PQfname(res,i) << "\t\t";
        }
        std::cout<<std::endl;
        for(int i= 0; i<tuple; ++i){
            for ( int j= 0; j < attributi ; j++){
                std::cout<< PQgetvalue (res , i, j) << "\t\t";
            }
            std::cout<<std::endl;
        }
        std::cout<<std::endl;
        PQclear(res);
    }//while
}

int main() {
    //modificare all' occorrenza
    PGconn* conn= PQconnectdb("dbname=postgres");//dati database
    if(PQstatus(conn) == CONNECTION_BAD) {
        std::cerr << "Errore di connessione: " << PQerrorMessage(conn) << std::endl;
        do_exit(conn);
    }
    eseguiQuery(conn);
    PQfinish(conn);
    return 0;
}
