<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Home - Controle de Estoque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.2/font/bootstrap-icons.css" integrity="sha384-b6lVK+yci+bfDmaY1u0zE8YYJt0TZxLEAFyYSLHId4xoVvsrQu3INevFKo+Xir8e" crossorigin="anonymous">
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <link rel="stylesheet" href="styles/index_page.css">
</head>
<body>
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    <div id="app" class="container-fluid mt-4">
        <div class="row">
            
            <div class="col-md-10 offset-md-2">
                <h1 class="mb-4 mt-3 display-4">Bem-vindo ao Sistema de Controle de Estoque</h1>
                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <h5 class="card-title">Resumo do Estoque</h5>
                                <p class="card-text resumo-texto">Produtos Cadastrados: {{ totalProdutos }}</p>
                                <p class="card-text resumo-texto">Disponí­veis: {{ disponiveis }}</p>
                                <p class="card-text resumo-texto">Armazenados: {{ esgotados }}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <h5 class="card-title">Acessos Rápidos</h5>
                                <button @click="irParaPagina('estoque')" class="btn btn-primary w-100 mb-2">Estoque</button>
                                <button @click="irParaPagina('saida')" class="btn btn-primary w-100 mb-2">Saí­da de Produtos</button>
                                <button @click="irParaPagina('gerarCSV')" class="btn btn-primary w-100">Gerar CSV</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <h5 class="card-title">Alertas e Notificações</h5>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item bg-transparent" v-for="item in list" :key="item.id">
                                        ({{ item.tipo }}) {{ item.nome }}  possui {{ item.quantidade }} unidades.
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
      const app = Vue.createApp({
      data() {
        return {
          totalProdutos: 0,
          list: [],
          disponiveis: 0,
          esgotados: 0
          
          
        };
      },
      mounted() {
        this.loadList();
        
      },
      methods: {
          
           async request(url = "", method, data) {
                            try {
                                const response = await fetch(url, {
                                    method: method,
                                    headers: { "Content-Type": "application/json" },
                                    body: JSON.stringify(data)
                                });
                                if (response.status === 200) {
                                    return response.json();
                                } else {
                                    this.error = response.statusText;
                                }
                            } catch (e) {
                                this.error = e;
                                return null;
                            }
                        },
        
        async loadList() {
                            
                            try {
                                
                                const data = await this.request("/Almoxarifado/api/produtos", "GET");
                                if (data) {
                                    this.list = data.list;
                                }
                                
                                const dataTC = await this.request("/Almoxarifado/api/produtos?tot=true", "GET");
                                if (dataTC) {
                                    this.totalProdutos = dataTC.total;
                                    
                                    
                                }
                                const dataD = await this.request("/Almoxarifado/api/produtos?filtro=DISPONIVEL", "GET");
                                if (dataD) {
                                    this.disponiveis = dataD.total;
                                    
                                    
                                }
                                const dataE = await this.request("/Almoxarifado/api/produtos?filtro=NO ARMAZÉM", "GET");
                                if (dataE) {
                                    this.esgotados = dataE.total;
                                    
                                    
                                }
                               
                            } catch (error) {
                                console.error('Erro ao carregar a lista de produtos:', error);
                                this.error = 'Erro ao carregar a lista de produtos';
                            }
                        }
        
      }
    });

    app.mount('#app');
    </script>

    <style>
        body {
            background-color: #2C3E50;
            color: #ECF0F1;
        }
        .card {
            background-color: #34495E;
            border: none;
            border-radius: 10px;
        }
        .card-title, .card-text, .list-group-item {
            color: #ECF0F1;
            font-size: 2.00rem;
        }
        .btn-primary {
            background-color: #2980B9;
            border: none;
        }
        .btn-primary:hover {
            background-color: #3498DB;
        }
        .sidebar {
            min-height: 100vh;
            padding: 0;
        }
        .sidebar h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        .sidebar .nav-link {
            font-size: 1.1rem;
            padding: 0.75rem 1rem;
        }
        .sidebar .nav-link:hover {
            background-color: #34495E;
            border-radius: 0;
        }
        .resumo-texto {
            font-size: 1.75rem; /* Aumentando a fonte do resumo */
        }
        
        
    </style>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>
