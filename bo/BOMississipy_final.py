#!/usr/bin/env python3

import pymssql
import xlwt
import xlrd
from os import getenv
import datetime
import os.path
import xml.etree.ElementTree as ET

conn = None
cursor = None

#cursor.callproc('AddAuthor', ("Louis Cypher", "Louisa Ferre", "1966-06-06", "Totally not a demon"))
#cursor.execute("""
#EXEC AddAuthor 'Louisa Ferre',
#'Louis Cypher',
#'1966-06-06',
#'Totally not a demon'
#""")
#conn.commit()


#   USER MANAGEMENT     #
def UserManage():
    while 1:
        print('Gestão de Users: ')
        print('1 - Pesquisa por Username')
        print('2 - Pesquisa por ID')
        print('3 - Contas bloqueadas')
        print('4 - Voltar')
        choice=int(input())

        print("\033[H\033[J")

        if choice == 1:
            #   SEARCH BY USERNAME   #
            while 1:
                usersearch=(input('\nInsira o nome do cliente a pesquisar. Insira 0 para sair.\n'))
                
                if usersearch == '0':
                    print("\033[H\033[J")
                    break
                
                cursor.execute("""
                SELECT * FROM Client WHERE email LIKE '""" + usersearch + """'"""
                )
                row = cursor.fetchone()
                
                if cursor.rowcount == 0:
                    print('Conta não encontrada.')
                else:
                    print("ID= " + str(row[0]) + " |USERNAME: " + str(row[1]) + " |ESTADO DA CONTA: " + str(row[8]))
                    if row[8] == False:
                        choice=input('Esta conta encontra-se inactiva, deseja reactiva-la? (S/N)\n').lower()
                        if choice == 's':
                            cursor.execute("""
                            UPDATE Client SET isactive = 1 WHERE ID = """ + str(row[0]))
                            conn.commit()
                            print('Utilizador desbloqueado.\n')


        elif choice == 2:
            #   SEARCH BY ID     #
            while 1:
                usersearch=(input('\nInsira o ID do cliente a pesquisar. Insira 0 para sair.\n'))
                
                if usersearch == '0':
                    print("\033[H\033[J")
                    break
                    
                
                cursor.execute("""
                SELECT * FROM Client WHERE id LIKE '""" + usersearch + """'"""
                )
                row = cursor.fetchone()
                
                if cursor.rowcount == 0:
                    print('Conta não encontrada.')
                else:
                    print("ID= " + str(row[0]) + " |USERNAME: " + str(row[1]) + " |ESTADO DA CONTA: " + str(row[8]))
                    if row[8] == False:
                        choice=input('Esta conta encontra-se inactiva, deseja reactiva-la? (S/N)\n').lower()
                        if choice == 's':
                            cursor.execute("""
                            UPDATE Client SET isactive = 1 WHERE ID = """ + str(row[0]))
                            conn.commit()
                            print('Utilizador desbloqueado.\n')

        elif choice == 3:
            #   SEARCH BY BLOCKED ACCOUNTS   #
            while 1:
                print('\nCONTAS BLOQUEADAS')
                cursor.execute("""
                SELECT * FROM Client WHERE isactive = 0"""
                )
                row = cursor.fetchone()

                if cursor.rowcount == 0:
                    print("\033[H\033[J")
                    print('Não existem contas bloqueadas.\n')
                    break

                while row:
                    print("ID= " + str(row[0]) + " |USERNAME: " + str(row[1]) + " |ESTADO DA CONTA: " + str(row[8]))
                    row = cursor.fetchone()
                
                choice=input('Indique o ID da conta a reactivar. Insira 0 para sair.\n')  

                if choice == '0':
                    print("\033[H\033[J")
                    break
                if choice != '':
                    cursor.execute("""
                    UPDATE Client SET isactive = 1 WHERE ID = """ + str(choice))
                    conn.commit()

        elif choice == 4:
            break
        else:
            print('Opção inválida')

#   PRODUCT MANAGEMENT  #
def ProductManage():
    while 1:
        print('Gestão de produtos: ')
        print('1 - Listagem de produtos')
        print('2 - Desactivar produto')
        print('3 - Importar ficheiro .xlsx')
        print('4 - Importar ficheiro XML')
        print('5 - Voltar')
        choice=int(input())

        print("\033[H\033[J")

        if choice == 1:
            #   PRODUCT LISTING   #
            while 1:
                print('Listagem de produtos')
                print('1 - Listar por categoria')
                print('2 - Listar por descrição')
                print('3 - Produtos Esgotados')
                print('4 - Voltar')
                choice=int(input())

                print("\033[H\033[J")

                if choice == 1:
                    #   CATEGORY LISTING   #
                    print('\nLISTAGEM DE CATEGORIAS')
                    cursor.execute("SELECT id, name FROM Product_Type")
                    row = cursor.fetchone()
                    while row:
                        print(str(row[0]) + ": " + str(row[1]))
                        row = cursor.fetchone()
                    choice = int(input("Selecione uma categoria:"))
                    if choice == 1: #Book
                        nome = 'title'
                    elif choice == 2:
                        nome = 'name'

                    print()

                    cursor.execute("""SELECT id_product, string_val, STO.stock, PRO.isactive
                    FROM Product_Attr_Value
                    INNER JOIN Product PRO
                    ON product_id = PRO.id
                    INNER JOIN Stock STO
                    ON id_product = product_id
                    WHERE attr_name = '""" + nome + """'""")

                    row = cursor.fetchone()

                    while row:
                        print('ID: ' + str(row[0]) + ' |Produto: ' + str(row[1]) + ' |Stock: ' + str(row[2]) + ' |Activo?: ' + str(row[3]))
                        row = cursor.fetchone()
                        
                    print() 

                elif choice == 2:
                    #   DESCRIPTION LISTING   #
                    print('\nLISTAGEM POR DESCRIÇÂO')

                    search=input('Insira o termo que deseja pesquisar.\n')

                    cursor.execute("""
                    SELECT id, product_type_id FROM Product WHERE description LIKE '%""" + search + """%'
                    """)

                    row = cursor.fetchone()

                    if cursor.rowcount == 0:
                        print('Não existem produtos com esse termo na sua descrição\n')
                        break
                    else:
                        nomes = []
                        ids = []
                        count = 0
                        while row:
                            if row[1] == 1:
                                ids.append(row[0])
                                nomes.append('title')
                            elif row[1] == 2:
                                ids.append(row[0])
                                nomes.append('name')
                            count = count + 1
                            row = cursor.fetchone()
                        
                        for x in range(count):
                            
                            cursor.execute("""
                            SELECT id_product, string_val, STO.stock, PRO.isactive
                            FROM Product_Attr_Value
                            INNER JOIN Product PRO
                            ON product_id = PRO.id
                            INNER JOIN Stock STO
                            ON id_product = product_id
                            WHERE product_id = """ + str(ids[x]) + """ AND attr_name = '""" + nomes[x] + """'""")

                            row = cursor.fetchone()

                            print('ID: ' + str(row[0]) + ' |Produto: ' + str(row[1]) + ' |Stock: ' + str(row[2]) + ' |Activo?: ' + str(row[3]))
                        print()

                elif choice == 3:
                    #   SOLD OUT PRODUCTS   #
                    print('\nPRODUTOS ESGOTADOS')
                    cursor.execute("""
                    SELECT id_product, product_type_id FROM Stock WHERE stock = 0
                    """)

                    row = cursor.fetchone()

                    if cursor.rowcount == 0:
                        print('Não há produtos esgotados\n')
                        break
                    else:
                        nomes = []
                        ids = []
                        count = 0
                        while row:
                            if row[1] == 1:
                                ids.append(row[0])
                                nomes.append('title')
                            elif row[1] == 2:
                                ids.append(row[0])
                                nomes.append('name')
                            count = count + 1
                            row = cursor.fetchone()
                        
                        for x in range(count):
                            
                            cursor.execute("""
                            SELECT id_product, string_val, STO.stock, PRO.isactive
                            FROM Product_Attr_Value
                            INNER JOIN Product PRO
                            ON product_id = PRO.id
                            INNER JOIN Stock STO
                            ON id_product = product_id
                            WHERE product_id = """ + str(ids[x]) + """ AND attr_name = '""" + nomes[x] + """'""")

                            row = cursor.fetchone()

                            print('ID: ' + str(row[0]) + ' |Produto: ' + str(row[1]) + ' |Stock: ' + str(row[2]) + ' |Activo?: ' + str(row[3]))
                        print()

                elif choice == 4:
                    break
                else:
                    print('Opção inválida')

        elif choice == 2:
            #   DEACTIVATE PRODUCT     #
            print('\nDesactivar produto por ID')
            choice=int(input('\nInsira o ID do produto que deseja desactivar:\n'))
            cursor.execute("""
            UPDATE Product SET isactive = 0 WHERE id = """ + str(choice)
            )
            conn.commit()
            print('\nProduto desactivado.')

        elif choice == 3:
            #   IMPORT FILE   #
            print('Importação de ficheiro .xlsx\n')
            inputfile=input('Indique a localização do ficheiro .xlsx:\n')
            if not inputfile[-5:].lower() == '.xlsx':
                print('Ficheiro não é um .xlsx')
            else:
                fileloc=inputfile
                if not os.path.isfile(fileloc):
                    print('Ficheiro não existente.')
                else:
                    book = xlrd.open_workbook(fileloc)
                    sh = book.sheet_by_index(0)
                    row = sh.row_values(1)
                    rownum = 1
                    while True:
                        if row[0] == 'book':
                            row[1] = int(row[1])
                            row[3] = "'" + row[3] + "'"
                            row[4] = int(row[4])
                            row[5] = int(row[5])
                            row[6] = int(row[6])
                            row[7] = "'" + row[7] + "'"
                            row[8] = "'" + row[8] + "'"
                            row[9] = "'" + row[9] + "'"
                            row[10] = int(row[10])
                            if not row[11] == 'NULL':
                                row[11] = "'" + row[11] + "'"
                            if not row[12] == 'NULL':
                                row[12] = "'" + row[12] + "'"
                            row[13] = "'" + row[13] + "'"
                            row[14] = "'" + row[14] + "'"
                            row[15] = "'" + row[15] + "'"
                            row[16] = "'" + row[16] + "'"
                            row[17] = "'" + str(datetime.datetime(*xlrd.xldate_as_tuple(row[17], book.datemode))) + "'"
                            row[18] = int(row[18])
                            row[19] = int(row[19])
                            row[20] = int(row[20])
                            row[21] = "'" + row[21] + "'"
                            row[22] = int(row[22])
                            row[23] = "'" + row[23] + "'"
                            row[24] = int(row[24])


                            cursor.execute("""
                             EXEC AddBook """ + str(row[1]) + """,
                             """ + str(row[2]) + """,
                             """ + str(row[3]) + """,
                             """ + str(row[4]) + """,
                             """ + str(row[5]) + """,
                             """ + str(row[6]) + """,
                             """ + str(row[7]) + """,
                             """ + str(row[8]) + """,
                             """ + str(row[9]) + """,
                             """ + str(row[10]) + """,
                             """ + str(row[11]) + """,
                             """ + str(row[12]) + """,
                             """ + str(row[13]) + """,
                             """ + str(row[14]) + """,
                             """ + str(row[15]) + """,
                             """ + str(row[16]) + """,
                             """ + str(row[17]) + """,
                             """ + str(row[18]) + """,
                             """ + str(row[19]) + """,
                             """ + str(row[20]) + """,
                             """ + str(row[21]) + """,
                             """ + str(row[22]) + """,
                             """ + str(row[23]) + """,
                             """ + str(row[24]) + """,
                             """ + '-1')
                            conn.commit()

                        elif row[0] == 'electronic':
                            row[1] = int(row[1])
                            row[3] = "'" + row[3] + "'"
                            row[5] = int(row[5])
                            row[6] = int(row[6])
                            row[7] = "'" + row[7] + "'"
                            row[8] = "'" + row[8] + "'"
                            row[9] = "'" + row[9] + "'"
                            row[17] = "'" + str(datetime.datetime(*xlrd.xldate_as_tuple(row[17], book.datemode))) + "'"
                            row[24] = int(row[24])
                            row[25] = "'" + row[25] + "'"
                            row[26] = "'" + row[26] + "'"


                            cursor.execute("""
                             EXEC AddElectronic """ + str(row[1]) + """,
                             """ + str(row[2]) + """,
                             """ + str(row[3]) + """,
                             """ + str(row[5]) + """,
                             """ + str(row[6]) + """,
                             """ + str(row[7]) + """,
                             """ + str(row[8]) + """,
                             """ + str(row[9]) + """,
                             """ + str(row[25]) + """,
                             """ + str(row[26]) + """,
                             """ + str(row[17]) + """,
                             """ + str(row[24]) + """,
                             """ + '-1')

                            conn.commit()
                        rownum = rownum + 1  
                        if(rownum < sh.nrows):
                            row= sh.row_values(rownum)
                        else:
                            print("Terminado")
                            break

        elif choice == 4:
            #   IMPORT FILE   #
            print('Importação de ficheiro XML\n')
            inputfile=input('Indique a localização do ficheiro XML:\n')
            if not inputfile[-4:].lower() == '.xml':
                print('Ficheiro não é um XML')
            else:
                fileloc=inputfile
                if not os.path.isfile(fileloc):
                    print('Ficheiro não existente.')
                else:
                    tree = ET.parse(fileloc)
                    root = tree.getroot()
                    for x in range(len(root.getchildren())):
                        if root[x][0].text == '"book"':
                            root[x][1].text = int(root[x][1].text)
                            root[x][4].text = int(root[x][4].text)
                            root[x][5].text = int(root[x][5].text)
                            root[x][6].text = int(root[x][6].text)
                            root[x][10].text = int(root[x][10].text)
                            if root[x][11].text == '"NULL"':
                                root[x][11].text = "NULL"
                            if root[x][12].text == '"NULL"':
                                root[x][12].text = "NULL"


                            root[x][18].text = int(root[x][18].text)
                            root[x][19].text = int(root[x][19].text)
                            root[x][20].text = int(root[x][20].text)
                            root[x][22].text = int(root[x][22].text)
                            root[x][24].text = int(root[x][24].text)

                            cursor.execute("""
                             EXEC AddBook """ + str(root[x][1].text) + """,
                             """ + str(root[x][2].text) + """,
                             """ + str(root[x][3].text) + """,
                             """ + str(root[x][4].text) + """,
                             """ + str(root[x][5].text) + """,
                             """ + str(root[x][6].text) + """,
                             """ + str(root[x][7].text) + """,
                             """ + str(root[x][8].text) + """,
                             """ + str(root[x][9].text) + """,
                             """ + str(root[x][10].text) + """,
                             """ + str(root[x][11].text) + """,
                             """ + str(root[x][12].text) + """,
                             """ + str(root[x][13].text) + """,
                             """ + str(root[x][14].text) + """,
                             """ + str(root[x][15].text) + """,
                             """ + str(root[x][16].text) + """,
                             """ + str(root[x][17].text) + """,
                             """ + str(root[x][18].text) + """,
                             """ + str(root[x][19].text) + """,
                             """ + str(root[x][20].text) + """,
                             """ + str(root[x][21].text) + """,
                             """ + str(root[x][22].text) + """,
                             """ + str(root[x][23].text) + """,
                             """ + str(root[x][24].text) + """,
                             """ + '-1')
                            conn.commit()

                        elif root[x][0].text == '"electronic"':
                            root[x][1].text = int(root[x][1].text)
                            root[x][2].text = int(root[x][2].text)
                            root[x][4].text = int(root[x][4].text)
                            root[x][5].text = int(root[x][5].text)
                            root[x][12].text = int(root[x][12].text)


                            cursor.execute("""
                             EXEC AddElectronic """ + str(root[x][1].text) + """,
                             """ + str(root[x][2].text) + """,
                             """ + str(root[x][3].text) + """,
                             """ + str(root[x][4].text) + """,
                             """ + str(root[x][5].text) + """,
                             """ + str(root[x][6].text) + """,
                             """ + str(root[x][7].text) + """,
                             """ + str(root[x][8].text) + """,
                             """ + str(root[x][9].text) + """,
                             """ + str(root[x][10].text) + """,
                             """ + str(root[x][11].text) + """,
                             """ + str(root[x][12].text) + """,
                             """ + '-1')
                            
                            conn.commit()

                    print('Importação concluída\n')

        elif choice == 5:
            break
        else:
            print('Opção inválida')

#   ORDER MENU   #
def OrderManage():
    while 1:
        print('Gestão de encomendas: ')
        print('1 - Pesquisa de encomendas')
        print('2 - Encomendas não processadas c/Exportação')
        print('3 - Voltar')
        choice=int(input())

        print("\033[H\033[J")

        if choice == 1:
            #   ORDER SEARCH   #
            export=(input('Deseja exportar os resultados para ficheiro? (Y/N)')).lower()
            while 1:
                print('Pesquisa de encomendas')
                print('1 - Pesquisar por cliente')
                print('2 - Pesquisar por data de encomenda')
                print('3 - Pesquisar por total ')
                print('4 - Pesquisar por produto')
                print('5 - Voltar')
                choice=int(input())

                print("\033[H\033[J")

                if choice == 1:
                    #   CLIENT SEARCH   #
                    print('\nPesquisa por cliente')
                    while 1:
                        choice=(input('Insira o ID do cliente. Insira 0 para sair.\n'))

                        if choice == '0':
                            break
                                           
                        cursor.execute("""
                        SELECT ORD.id, Cli.firstname, Cli.surname, ORD.delivery_addr, ORD.order_date
                        FROM [Order] ORD
                        INNER JOIN Client Cli
                        ON Cli.id = client_id
                        WHERE client_id = """ + str(choice))

                        row = cursor.fetchone()

                        if cursor.rowcount == 0:
                            print('Este cliente não existe ou não tem encomendas registadas\n')
                        else:
                            if export == 'y':
                                book = xlwt.Workbook()
                                sh = book.add_sheet('sheet1')
                                sh.write(0, 0, 'ID caso')
                                sh.write(0, 1, 'ID cliente')
                                sh.write(0, 2, 'Nome cliente')
                                sh.write(0, 3, 'Data')
                                sh.write(0, 4, 'ID produtos')
                                rownum = 1

                            nomes = []
                            ids = []
                            address = []
                            datas = []
                            count = 0
                            while row:
                                ids.append(row[0])
                                nomes.append(str(row[1]) + ' ' + str(row[2]))
                                address.append(str(row[3]))
                                datas.append(str(row[4]))
                                count = count + 1
                                row = cursor.fetchone()

                            for x in range(count):
                                dataprint = str(datas[x])
                                print('ID da encomenda: ' + str(ids[x]) + ' |Nome: ' + str(nomes[x]) + ' |Morada: ' + str(address[x]) + ' |Data: ' + dataprint[0:10])
                               
                                cursor.execute("""
                                SELECT OI.product_id, PAV.string_val
                                FROM Order_Item OI
                                INNER JOIN Product_Attr_Value PAV
                                ON PAV.product_id = OI.product_id
                                WHERE (PAV.attr_name = 'title'
                                OR PAV.attr_name = 'name')
                                AND OI.order_id = """ + str(ids[x]))   
                                row = cursor.fetchone()
                                produtoslista = ''

                                while row:                            
                                    print(' -Product ID: ' + str(row[0]) + ' |Nome: ' + row[1]) 
                                    produtoslista = produtoslista + str(row[0]) + ' '                                 
                                    row = cursor.fetchone()
                                
                                if export == 'y':
                                    sh.write(rownum, 0, ids[x])
                                    sh.write(rownum, 1, choice)
                                    sh.write(rownum, 2, nomes[x])
                                    sh.write(rownum, 3, datas[x])
                                    sh.write(rownum, 4, produtoslista)
                                    rownum = rownum + 1
                            
                            if export == 'y':
                                now = datetime.datetime.now()
                                book.save('pesquisaorders_' + str(now) + '.xlsx')


                elif choice == 2:
                    #   SEARCH BY ORDER DATE    #
                    print('\nPesquisa por data de encomenda')
                    while 1:
                        choice=(input('Insira a data da encomenda (YYYY-MM-DD). Insira 0 para sair.\n'))

                        if choice == '0':
                            break
                                           
                        cursor.execute("""
                        SELECT ORD.id, Cli.firstname, Cli.surname, ORD.delivery_addr, ORD.order_date, ORD.client_id
                        FROM [Order] ORD
                        INNER JOIN Client Cli
                        ON Cli.id = client_id
                        WHERE ORD.order_date LIKE '""" + str(choice) + """%'""")

                        row = cursor.fetchone()

                        if cursor.rowcount == 0:
                            print('Não existem encomendas para esta data\n')
                        else:
                            if export == 'y':
                                book = xlwt.Workbook()
                                sh = book.add_sheet('sheet1')
                                sh.write(0, 0, 'ID caso')
                                sh.write(0, 1, 'ID cliente')
                                sh.write(0, 2, 'Nome cliente')
                                sh.write(0, 3, 'Data')
                                sh.write(0, 4, 'ID produtos')
                                rownum = 1
                            
                            nomes = []
                            ids = []
                            address = []
                            datas = []
                            clientids = []
                            count = 0

                            while row:
                                ids.append(row[0])
                                nomes.append(str(row[1]) + ' ' + str(row[2]))
                                address.append(str(row[3]))
                                datas.append(str(row[4]))
                                clientids.append(str(row[5]))
                                count = count + 1
                                row = cursor.fetchone()

                            for x in range(count):
                                dataprint = str(datas[x])
                                print('ID da encomenda: ' + str(ids[x]) + ' |Nome: ' + str(nomes[x]) + ' |Morada: ' + str(address[x]) + ' |Data: ' + dataprint[0:10])
                               
                                cursor.execute("""
                                SELECT OI.product_id, PAV.string_val
                                FROM Order_Item OI
                                INNER JOIN Product_Attr_Value PAV
                                ON PAV.product_id = OI.product_id
                                WHERE (PAV.attr_name = 'title'
                                OR PAV.attr_name = 'name')
                                AND OI.order_id = """ + str(ids[x]))   
                                row = cursor.fetchone()
                                produtoslista = ''
                                while row:                            
                                    print(' -Product ID: ' + str(row[0]) + ' |Nome: ' + row[1])
                                    produtoslista = produtoslista + str(row[0]) + ' '                                                                   
                                    row = cursor.fetchone()

                                if export == 'y':
                                    sh.write(rownum, 0, ids[x])
                                    sh.write(rownum, 1, clientids[x])
                                    sh.write(rownum, 2, nomes[x])
                                    sh.write(rownum, 3, datas[x])
                                    sh.write(rownum, 4, produtoslista)
                                    rownum = rownum + 1

                            if export == 'y':
                                now = datetime.datetime.now()
                                book.save('pesquisaorders_' + str(now) + '.xlsx')



                elif choice == 3:
                    #   SEARCH BY TOTAL   #                   ------------------------
                    print('\nPesquisa por total')
                    while 1:
                        minsel=(input('Insira o total mínimo. Insira -1 para sair.\n'))
                        if minsel == '-1':
                            break
                        
                        maxsel=(input('Insira o total máximo.\n'))

                        cursor.execute("""
                        SELECT id FROM [Order]
                        """)

                        row = cursor.fetchone()
                        idorder = []
                        countid = 0

                        while row:
                            idorder.append(row[0])
                            row = cursor.fetchone()
                            countid = countid + 1
                        
                        counttotal = 0

                        idtotal = []

                        for x in range(countid):
                            cursor.execute("""
                            SELECT price
                            FROM Product PRO
                            INNER JOIN Order_Item ORD
                            ON product_id = PRO.id
                            WHERE order_id = """ + str(idorder[x]))
                            row = cursor.fetchone()
                            total = 0
                            while row:
                                total = total + row[0]
                                row = cursor.fetchone()

                            if total >= int(minsel) and total <= int(maxsel):
                                #ERRO AQUI#
                                idtotal.append(idorder[x])
                                counttotal = counttotal + 1

                        if counttotal == 0:
                            print('Não existem encomendas dentro desses valores.\n')
                        else:
                            for y in range(counttotal):

                                cursor.execute("""
                                SELECT ORD.id, Cli.firstname, Cli.surname, ORD.delivery_addr, ORD.order_date, ORD.client_id
                                FROM [Order] ORD
                                INNER JOIN Client Cli
                                ON Cli.id = client_id
                                WHERE ORD.id = """ + str(idtotal[y]))

                                row = cursor.fetchone()

                                if export == 'y':
                                    book = xlwt.Workbook()
                                    sh = book.add_sheet('sheet1')
                                    sh.write(0, 0, 'ID caso')
                                    sh.write(0, 1, 'ID cliente')
                                    sh.write(0, 2, 'Nome cliente')
                                    sh.write(0, 3, 'Data')
                                    sh.write(0, 4, 'ID produtos')
                                    rownum = 1
                                
                                nomes = []
                                ids = []
                                address = []
                                datas = []
                                clientids = []
                                count = 0

                                while row:
                                    ids.append(row[0])
                                    nomes.append(str(row[1]) + ' ' + str(row[2]))
                                    address.append(str(row[3]))
                                    datas.append(str(row[4]))
                                    clientids.append(str(row[5]))
                                    count = count + 1
                                    row = cursor.fetchone()

                                for x in range(count):
                                    dataprint = str(datas[x])
                                    print('ID da encomenda: ' + str(ids[x]) + ' |Nome: ' + str(nomes[x]) + ' |Morada: ' + str(address[x]) + ' |Data: ' + dataprint[0:10])
                                
                                    cursor.execute("""
                                    SELECT OI.product_id, PAV.string_val
                                    FROM Order_Item OI
                                    INNER JOIN Product_Attr_Value PAV
                                    ON PAV.product_id = OI.product_id
                                    WHERE (PAV.attr_name = 'title'
                                    OR PAV.attr_name = 'name')
                                    AND OI.order_id = """ + str(ids[x]))   
                                    row = cursor.fetchone()
                                    produtoslista = ''
                                    while row:                            
                                        print(' -Product ID: ' + str(row[0]) + ' |Nome: ' + row[1])
                                        produtoslista = produtoslista + str(row[0]) + ' '                                                                   
                                        row = cursor.fetchone()

                                    if export == 'y':
                                        sh.write(rownum, 0, ids[x])
                                        sh.write(rownum, 1, clientids[x])
                                        sh.write(rownum, 2, nomes[x])
                                        sh.write(rownum, 3, datas[x])
                                        sh.write(rownum, 4, produtoslista)
                                        rownum = rownum + 1

                                if export == 'y':
                                    now = datetime.datetime.now()
                                    book.save('pesquisaorders_' + str(now) + '.xlsx')

                elif choice == 4:
                    #   SEARCH BY PRODUCT    #
                    print('\nPesquisa por produto')
                    while 1:
                        choice=(input('Insira o ID do produto que deseja procurar. Insira 0 para sair.\n'))

                        if choice == '0':
                            break
                        
                        cursor.execute("""
                        SELECT order_id
                        FROM Order_Item
                        WHERE product_id = """ + str(choice))

                        row = cursor.fetchone()

                        if cursor.rowcount == 0:
                            print('Não existem encomendas com este produto\n')
                        else:
                            order_id = []
                            count = 0
                            while row:
                                order_id.append(str(row[0]))
                                count = count+1
                                row = cursor.fetchone()

                            for x in range(count):
                                cursor.execute("""
                                SELECT ORD.id, Cli.firstname, Cli.surname, ORD.delivery_addr, ORD.order_date, ORD.client_id
                                FROM [Order] ORD
                                INNER JOIN Client Cli
                                ON Cli.id = client_id
                                WHERE ORD.id = """ + str(order_id[x]))

                                row = cursor.fetchone()

                                if cursor.rowcount == 0:
                                    print('Não existem encomendas com este produto\n')
                                else:
                                    if export == 'y':
                                        book = xlwt.Workbook()
                                        sh = book.add_sheet('sheet1')
                                        sh.write(0, 0, 'ID caso')
                                        sh.write(0, 1, 'ID cliente')
                                        sh.write(0, 2, 'Nome cliente')
                                        sh.write(0, 3, 'Data')
                                        sh.write(0, 4, 'ID produtos')
                                        rownum = 1
                                    
                                    nomes = []
                                    ids = []
                                    address = []
                                    dates = []
                                    clientids = []

                                    while row:
                                        ids.append(row[0])
                                        nomes.append(str(row[1]) + ' ' + str(row[2]))
                                        address.append(str(row[3]))
                                        dates.append(str(row[4]))
                                        clientids.append(str(row[5]))
                                        row = cursor.fetchone()

                                for t in range(count):
                                    dataprint = str(dates[x])
                                    print('ID da encomenda: ' + str(ids[t]) + ' |Nome: ' + str(nomes[t]) + ' |Morada: ' + str(address[t]) + ' |Data: ' + dataprint[0:10])
                                
                                    cursor.execute("""
                                    SELECT OI.product_id, PAV.string_val
                                    FROM Order_Item OI
                                    INNER JOIN Product_Attr_Value PAV
                                    ON PAV.product_id = OI.product_id
                                    WHERE (PAV.attr_name = 'title'
                                    OR PAV.attr_name = 'name')
                                    AND OI.order_id = """ + str(ids[t]))   
                                    row = cursor.fetchone()
                                    produtoslista = ''
                                    while row:                            
                                        print(' -Product ID: ' + str(row[0]) + ' |Nome: ' + row[1])
                                        produtoslista = produtoslista + str(row[0]) + ' '                                                                                                     
                                        row = cursor.fetchone()

                                    if export == 'y':
                                        sh.write(rownum, 0, ids[x])
                                        sh.write(rownum, 1, clientids[x])
                                        sh.write(rownum, 2, nomes[x])
                                        sh.write(rownum, 3, dates[x])
                                        sh.write(rownum, 4, produtoslista)
                                        rownum = rownum + 1

                                if export == 'y':
                                    now = datetime.datetime.now()
                                    book.save('pesquisaorders_' + str(now) + '.xlsx')

                elif choice == 5:
                    break
                else:
                    print('Opção inválida')

        elif choice == 2:
            #   EXPORT NON-PROCESSED ORDERS     #
            print('Encomendas não processadas com exportação\n')                           
            
            cursor.execute("""
            SELECT ORD.id, Cli.firstname, Cli.surname, ORD.delivery_addr, ORD.order_date, ORD.client_id
            FROM [Order] ORD
            INNER JOIN Client Cli
            ON Cli.id = client_id
            WHERE ORD.status = 'IP'""")

            row = cursor.fetchone()

            if cursor.rowcount == 0:
                print('Não existem encomendas pendentes\n')
            else:
                book = xlwt.Workbook()
                sh = book.add_sheet('sheet1')
                sh.write(0, 0, 'ID caso')
                sh.write(0, 1, 'ID cliente')
                sh.write(0, 2, 'Nome cliente')
                sh.write(0, 3, 'Data')
                sh.write(0, 4, 'ID produtos')
                rownum = 1
            
                nomes = []
                ids = []
                address = []
                datas = []
                clientids = []
                count = 0

                while row:
                    ids.append(row[0])
                    nomes.append(str(row[1]) + ' ' + str(row[2]))
                    address.append(str(row[3]))
                    datas.append(str(row[4]))
                    clientids.append(str(row[5]))
                    count = count + 1
                    row = cursor.fetchone()

                for x in range(count):
                    dataprint = str(datas[x])
                    print('ID da encomenda: ' + str(ids[x]) + ' |Nome: ' + str(nomes[x]) + ' |Morada: ' + str(address[x]) + ' |Data: ' + dataprint[0:10])
                    
                    cursor.execute("""
                    SELECT OI.product_id, PAV.string_val
                    FROM Order_Item OI
                    INNER JOIN Product_Attr_Value PAV
                    ON PAV.product_id = OI.product_id
                    WHERE (PAV.attr_name = 'title'
                    OR PAV.attr_name = 'name')
                    AND OI.order_id = """ + str(ids[x]))   
                    row = cursor.fetchone()
                    produtoslista = ''
                    while row:                            
                        print(' -Product ID: ' + str(row[0]) + ' |Nome: ' + row[1])
                        produtoslista = produtoslista + str(row[0]) + ' '                                                                   
                        row = cursor.fetchone()

                    sh.write(rownum, 0, ids[x])
                    sh.write(rownum, 1, clientids[x])
                    sh.write(rownum, 2, nomes[x])
                    sh.write(rownum, 3, datas[x])
                    sh.write(rownum, 4, produtoslista)
                    rownum = rownum + 1

                now = datetime.datetime.now()
                book.save('encomendaspendentes_' + str(now) + '.xlsx')
                print('Documento exportado.')

        elif choice == 3:
            break
        else:
            print('Opção inválida')


#    LOGIN   #
#while 1:
uinsert=input('Insira o seu username:')
pinsert=input('Insira a password:')

    # #   CREDENTIAL VERIFICATION  #
    # if uinsert != userval:
    #     print('User inválido')
    # elif pinsert != passval:
    #     print('Password errada')
    # else:
    #     break

conn = pymssql.connect(server='192.168.10.20', user=str(uinsert), password=str(pinsert), database='WebDB')
cursor = conn.cursor()

print("\033[H\033[J")

print('Bem vindo user: ' + uinsert)

#   MENU    #
while 1:
    print('Selecione a operação que deseja fazer')
    print('1 - Gestão de Users')
    print('2 - Gestão de Products')
    print('3 - Gestão de Orders')
    print('4 - Backup')
    print('5 - Sair')
    choice=int(input())

    print("\033[H\033[J")

    if choice == 1:
        UserManage()
    elif choice == 2:
        ProductManage()
    elif choice == 3:
        OrderManage()
    elif choice == 4:
        print('Backup\n')
        conn.autocommit(True)
        filename = 'MISSDB_' + str(datetime.datetime.today().strftime('%Y-%m-%d')) + '.bak'
        cursor.execute("BACKUP DATABASE WebDB TO DISK = '\\\MISSNAS\Backups\_" + filename + "'")
        conn.autocommit(False)
        print('Backup realizado com sucesso')
    elif choice == 5:
        print('Byebye!')
        break
    else:
        print('Opção inválida')
