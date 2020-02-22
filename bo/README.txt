############## README BACKOFFICE MISSISSIPY ##############
Notas de funcionamento:
	-Concebido para base de dados Microsoft SQL Server.
	-Existe executável standalone, no entanto de acordo com enunciado de projecto, este não será enviado mas a sua compilação e execução demonstrada.
	-Programa préconfigurado para 'estar à espera' de um servidor Microsoft SQL Server no endereço 192.168.10.20 (no entanto isto pode ser facilmente modificado se necessário).
	-Conecção Backoffice através do porto 1433.
Funções implementadas:
	-Pesquisa por Username
	-Pesquisa por ID
	-Listagem de contas bloqueadas
	-Desbloqueamento de contas
	-Listagem de produtos por categoria e descrição
	-Listagem de produtos esgotados
	-Desactivação de produto por ID
	-Importação de ficheiro .xlsx e XML (através do uso dos templates incluídos)
	-Pesquisa de encomendas (com a opção de exportar o output para ficheiro xlsx)
	-Listagem de encomendas não processadas (com output exportado por defeito para xlsx)
	-Pesquisa de encomendas por cliente
	-Pesquisa por data de encomenda
	-Pesquisa por total (inserção de valor minimo e máximo, devolve encomendas com valores compreendidos entre os dois)
	-Pesquisa por produto (ou ID de produto)
	-Login implementado (com uso de connection string)
	-Sistema de backup (faz backup da base de dados para a MISSNAS, podendo ser facilmente alterável para outra network share se necessário)
