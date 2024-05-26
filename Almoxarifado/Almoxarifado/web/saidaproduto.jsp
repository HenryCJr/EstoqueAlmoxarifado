<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Controle de Estoque</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
            integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.2/font/bootstrap-icons.css"
            integrity="sha384-b6lVK+yci+bfDmaY1u0zE8YYJt0TZxLEAFyYSLHId4xoVvsrQu3INevFKo+Xir8e" crossorigin="anonymous">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="styles/page.css">
    </head>

    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
            <div id="app" class="container">
                <div v-if="shared.session">
                    <div v-if="error" class="alert alert-danger m-2" role="alert">
                        {{ error }}
                    </div>
                    <div v-else>
                        <h2 class="mb-3 d-flex align-items-center justify-content-between">
                            Saida de Produtos
                            <div class="d-flex align-items-center">
                                <input type="text" v-model="searchQuery" placeholder="Digite algo..."
                                    class="form-control custom-input mx-2">
                                <button @click="resetForm()" type="button"
                                    class="btn btn-success btn-sm ms-auto buttons" data-bs-toggle="modal"
                                    data-bs-target="#addSaidaModal">
                                    Adicionar
                                </button>
                            </div>
                        </h2>

                        <div class="modal fade" id="addSaidaModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5">Adicionar Saida</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form @submit.prevent="addProduto">
                                            <div class="mb-3">
                                                <label for="data">Data de Saida</label>
                                                <input type="date" v-model="newDataSaida" id="data" name="data">
                                                <label for="horario">Horário de Saida</label>
                                                <input type="time" v-model="newHorarioSaida" id="horario"
                                                    name="horario">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputProduct" class="form-label">Produto</label>
                                                <select class="form-select" v-model="newProd" id="inputName"
                                                    @change="getProds()">
                                                    <option v-for="item3 in produtos" :key="item3.id" :value="item3">{{
                                                        item3.nome }}</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputDepartment" class="form-label">Departamento</label>
                                                <input type="text" v-model="newDepartment" class="form-control"
                                                    id="inputName">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputEmployee" class="form-label">Funcionario</label>
                                                <select class="form-select" v-model="newFuncionario" id="inputEmployee"
                                                    @change="getSubjects()">
                                                    <option v-for="item2 in employees" :key="item2.rowid"
                                                        :value="item2">{{ item2.name }}</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputQtd" class="form-label">Quantidade</label>
                                                <input type="number" v-model="newQuantidade" class="form-control"
                                                    id="inputLocation" min="0">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputAlmoxarifante" class="form-label">Amoxarifante</label>
                                                <input type="text" v-model="newAlmoxarifante" class="form-control"
                                                    id="inputName">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputDesc" class="form-label">Descrição</label>
                                                <input type="text" v-model="newDescricao" class="form-control"
                                                    id="inputName">
                                            </div>
                                            <div class="modal-footer">
                                                <div>
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal" @click="resetForm()">Cancelar</button>
                                                </div>
                                                <div>
                                                    <button type="submit" class="btn btn-primary">Salvar</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal fade" id="edtSaidaModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5">Editar Saida do Produto</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form @submit.prevent="updateSaidaProd">
                                            <div class="mb-3">
                                                <label for="data">Data de Saida</label>
                                                <input type="date" v-model="newDataSaida" id="data" name="data">
                                                <label for="horario">Horário de Saida</label>
                                                <input type="time" v-model="newHorarioSaida" id="horario"
                                                    name="horario">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputProduct" class="form-label">Produto</label>
                                                <select class="form-select" v-model="newProd" id="inputName"
                                                    @change="getProds()">
                                                    <option v-for="item3 in produtos" :key="item3.id" :value="item3">{{
                                                        item3.nome }}</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputDepartment" class="form-label">Departamento</label>
                                                <input type="text" v-model="newDepartment" class="form-control"
                                                    id="inputName">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputEmployee" class="form-label">Funcionario</label>
                                                <select class="form-select" v-model="newFuncionario" id="inputEmployee"
                                                    @change="getSubjects()">
                                                    <option v-for="item2 in employees" :key="item2.rowid"
                                                        :value="item2">{{ item2.name }}</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputQtd" class="form-label">Quantidade</label>
                                                <input type="number" v-model="newQuantidade" class="form-control"
                                                    id="inputLocation" min="0">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputAlmoxarifante" class="form-label">Amoxarifante</label>
                                                <input type="text" v-model="newAlmoxarifante" class="form-control"
                                                    id="inputName">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputDesc" class="form-label">Descrição</label>
                                                <input type="text" v-model="newDescricao" class="form-control"
                                                    id="inputName">
                                            </div>
                                            <div class="modal-footer">
                                                <div>
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal" @click="resetForm()">Cancelar</button>
                                                </div>
                                                <div>
                                                    <button type="submit" class="btn btn-primary">Salvar</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <table class="table">
                            <tr>
                                <th>DATA E HORA</th>
                                <th>NOME DO ITEM</th>
                                <th>RETIRANTE</th>
                                <th>DEPARTAMENTO</th>
                                <th>QUANTIDADE</th>
                                <th>ALMOXARIFANTE</th>
                                <th>DESCRIÇÃO</th>
                                <th>AÇÕES</th>
                            </tr>
                            <tr v-for="item in list" :key="item.rowid">
                                <td>{{ item.data}} || {{ item.horario }}</td>
                                <td>{{ item.produto.nome }}</td>
                                <td>{{ item.funcionario.name }}</td>
                                <td>{{ item.departamento }}</td>
                                <td>{{ item.quantidade }}</td>
                                <td>{{ item.almoxarifante }}</td>
                                <td>{{ item.descricao }}</td>
                                <td>
                                    <div class="btn-group" role="group" aria-label="Basic Example">
                                        <button type="button" @click="setVariables(item)" class="btn btn-warning btn-sm"
                                            data-bs-toggle="modal" data-bs-target="#edtSaidaModal"><i
                                                class="bi bi-pen"></i></button>
                                        <button type="button" @click="removeProd(item)" class="btn btn-danger btn-sm"><i
                                                class="bi bi-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                        </table>

                        <div class="pagination-container">
                        <div class="pagination">
                            <button @click="previousPage" :disabled="currentPage === 1">Anterior</button>
                            <div v-if="totalPages > 1">
                                <span v-for="page in pagination()" :key="page">
                                    <button v-if="page === 'prevJump'" @click="jumpPages(-5)">←</button>
                                    <button v-else-if="page === 'nextJump'" @click="jumpPages(5)">→</button>
                                    <button v-else @click="goToPage(page)" :class="{ 'active': page === currentPage }">{{ page }}</button>
                                </span>
                            </div>
                            <button @click="nextPage" :disabled="currentPage === totalPages">Próxima</button>
                        </div>
                    </div>
                </div>
            </div>


            <script>
                const app = Vue.createApp({
                    data() {
                        return {
                            list: [],
                            employees: [],
                            produtos: [],
                            shared: shared,
                            newDataSaida: '',
                            newHorarioSaida: '',
                            newProd: null, // Atualizado para refletir que será um objeto
                            newDepartment: '',
                            newFuncionario: null, // Atualizado para refletir que será um objeto
                            newQuantidade: 0,
                            newAlmoxarifante: '',
                            newDescricao: '',
                            error: null,
                            prod: null,
                            currentPage: 1,
                            itemsPerPage: 5,
                            searchQuery: ''
                        };
                    },
                    /*computed: {
                        filteredList() {
                            if (this.searchQuery) {
                                return this.list.filter(item =>
                                    item.produto.nome.toLowerCase().includes(this.searchQuery.toLowerCase())
                                );
                            } else {
                                return this.list;
                            }
                        },
                        paginatedList() {
                            const startIndex = (this.currentPage - 1) * this.itemsPerPage;
                            const endIndex = startIndex + this.itemsPerPage;
                            return this.filteredList.slice(startIndex, endIndex);
                        },
                        totalPages() {
                            return Math.ceil(this.filteredList.length / this.itemsPerPage);
                        }
                    },*/
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
                        setVariables(saida) {
                            if (saida) {
                                this.saida = { ...saida };
                                const dateTime = new Date(this.saida.data);
                                this.newDataSaida = dateTime.toISOString().split('T')[0];
                                this.newHorarioSaida = dateTime.toTimeString().split(' ')[0];
                                this.newProd = this.produtos.find(p => p.id === this.saida.produto.id); // Encontrar o produto correto
                                this.newDepartment = this.saida.departamento;
                                this.newFuncionario = this.employees.find(e => e.id === this.saida.funcionario.id); // Encontrar o funcionário correto
                                this.newQuantidade = this.saida.quantidade;
                                this.newAlmoxarifante = this.saida.almoxarifante;
                                this.newDescricao = this.saida.descricao;
                            } else {
                                this.resetForm();
                            }
                        },
                        async addProduto() {
                            if (!this.newProd || !this.newFuncionario) {
                                this.error = 'Por favor, selecione um produto e um funcionário válidos.';
                                return;
                            }

                            const dataHora = new Date(this.newDataSaida + 'T' + this.newHorarioSaida);

                            const produtoData = {
                                data: dataHora.toISOString(),
                                horario: this.newHorarioSaida,
                                produto_id: this.newProd.id,
                                departamento: this.newDepartment,
                                funcionario_id: this.newFuncionario.rowid,
                                quantidade: this.newQuantidade,
                                almoxarifante: this.newAlmoxarifante,
                                descricao: this.newDescricao
                            };

                            try {
                                const response = await this.request('/Almoxarifado/api/saida_produtos', 'POST', produtoData);
                                if (response) {
                                    await this.loadList(this.currentPage); // Preserve currentPage
                                    this.updateProd(0);
                                    this.resetForm();
                                }
                            } catch (error) {
                                console.error('Erro ao adicionar saída de produto:', error);
                                this.error = 'Erro ao adicionar saída de produto';
                            }
                        }
                        ,
                        async getSubjects() {
                            const dataS = await this.request(`/Almoxarifado/api/employee_subject`, "GET");
                            if (dataS) {
                                this.subjects = dataS.list.filter(subject => subject.employee === this.newEmployee);
                            }
                        },
                        async getProds() {
                            const dataP = await this.request(`/Almoxarifado/api/produtos`, "GET");
                            if (dataP) {
                                this.produtos = dataP.list;
                            }
                        },
                        async updateSaidaProd() {
                            const dataHora = new Date(this.newDataSaida + 'T' + this.newHorarioSaida);
                            const produtoData = {
                                rowid: this.saida.rowid,
                                data: dataHora.toISOString(),
                                horario: this.newHorarioSaida,
                                produto_id: this.newProd.id,
                                departamento: this.newDepartment,
                                funcionario_id: this.newFuncionario.rowid,
                                quantidade: this.newQuantidade,
                                almoxarifante: this.newAlmoxarifante,
                                descricao: this.newDescricao
                            };

                            try {
                                await this.request(`/Almoxarifado/api/saida_produtos?rowid=` + this.saida.rowid, 'PUT', produtoData);
                                await this.loadList(this.currentPage); // Preserve currentPage
                                this.updateProd(1);
                                this.resetForm();
                                this.closeModal('#edtSaidaModal');

                            } catch (error) {
                                console.error('Erro ao atualizar saída de produto:', error);
                                this.error = 'Erro ao atualizar saída de produto';
                            }
                        },

                        async removeProd(saidaRemo) {
                            try {
                                await this.getProds();

                                await this.request(`/Almoxarifado/api/produtos?id=` + saidaRemo.produto.id, "PUT", {
                                    id: saidaRemo.produto.id,
                                    nome: saidaRemo.produto.nome,
                                    quantidade: (this.produtos[saidaRemo.produto.id - 1].quantidade + saidaRemo.quantidade),
                                    tipo: saidaRemo.produto.tipo,
                                    data: saidaRemo.produto.data,
                                    horario: saidaRemo.produto.horario
                                });

                                await this.request(`/Almoxarifado/api/saida_produtos?rowid=` + saidaRemo.rowid, 'DELETE');
                                await this.loadList(this.currentPage); // Preserve currentPage
                            } catch (error) {
                                console.error('Erro ao excluir saída de produto:', error);
                                this.error = 'Erro ao excluir saída de produto';
                            }
                        },
                        pagination() {
            const pages = [];
            const maxPagesToShow = 7;
            if (this.totalPages <= maxPagesToShow) {
                for (let i = 1; i <= this.totalPages; i++) {
                    pages.push(i);
                }
            } else {
                pages.push(1);
                let start = Math.max(2, this.currentPage - 2);
                let end = Math.min(this.totalPages - 1, this.currentPage + 2);
                if (this.currentPage > this.totalPages - Math.floor(maxPagesToShow / 2)) {
                    start = this.totalPages - maxPagesToShow + 2;
                    end = this.totalPages - 1;
                } else if (this.currentPage <= Math.floor(maxPagesToShow / 2)) {
                    start = 2;
                    end = maxPagesToShow - 1;
                }
                if (start > 2) {
                    pages.push('prevJump');
                }
                for (let i = start; i <= end; i++) {
                    pages.push(i);
                }
                if (end < this.totalPages - 1) {
                    pages.push('nextJump');
                }
                pages.push(this.totalPages);
            }
            return pages;
        },
        previousPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
                this.loadList(this.currentPage);
            }
        },
        nextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
                this.loadList(this.currentPage);
            }
        },
        goToPage(page) {
            this.currentPage = page;
            this.loadList(page);
        },
        jumpPages(pages) {
            this.currentPage = Math.min(this.totalPages, Math.max(1, this.currentPage +
                    pages));
            this.loadList(this.currentPage);
        },
                        resetForm() {
                            this.newDataSaida = '';
                            this.newHorarioSaida = '';
                            this.newProd = null;
                            this.newDepartment = '';
                            this.newFuncionario = null;
                            this.newQuantidade = 0;
                            this.newAlmoxarifante = '';
                            this.newDescricao = '';
                            this.error = null;
                        },
                        closeModal(modalId) {
                            const modal = document.querySelector(modalId);
                            if (modal) {
                                const modalInstance = bootstrap.Modal.getInstance(modal);
                                if (modalInstance) {
                                    modalInstance.hide();
                                }
                            }
                        },
                        async updateProd(crud) {

                            const dataHora = new Date(this.newData + 'T' + this.newHorario);
                            const index = this.list.findIndex(item => item.id === this.newProd.id);
                            if (index !== -1) {
                                this.list[index] = {
                                    ...this.list[index],
                                    nome: this.newProd.nome,
                                    quantidade: this.newProd.quantidade,
                                    tipo: this.newProd.tipo,
                                    data: this.newProd.data,
                                    horario: this.newProd.horario
                                };
                            }
                            if (crud == 0) {
                                const data = await this.request(`/Almoxarifado/api/produtos?id=` + (this.newProd.id), "PUT", {
                                    id: this.newProd.id,
                                    nome: this.newProd.nome,
                                    quantidade: (this.newProd.quantidade - this.newQuantidade),
                                    tipo: this.newProd.tipo,
                                    data: this.newProd.data,
                                    horario: this.newProd.horario
                                });
                            } else if (crud == 1) {
                                const data = await this.request(`/Almoxarifado/api/produtos?id=` + (this.newProd.id), "PUT", {
                                    id: this.newProd.id,
                                    nome: this.newProd.nome,
                                    quantidade: (this.newProd.quantidade - (this.newQuantidade - this.saida.quantidade)),
                                    tipo: this.newProd.tipo,
                                    data: this.newProd.data,
                                    horario: this.newProd.horario
                                });
                            }


                        },
                        async loadList(page = 1) {
                            try {
                                const response = await this.request("/Almoxarifado/api/saida_produtos?page=" + page, "GET");
                                if (response) {
                                    this.list = response.list;
                                    this.totalPages = Math.ceil(response.total / 5);
                                }
                                const dataE = await this.request("/Almoxarifado/api/employees", "GET");
                                if (dataE) {
                                    this.employees = dataE.list;
                                }
                                const dataP = await this.request("/Almoxarifado/api/produtos", "GET");
                                if (dataP) {
                                    this.produtos = dataP.list;
                                }
                            } catch (error) {
                                console.error('Erro ao carregar a lista de produtos:', error);
                                this.error = 'Erro ao carregar a lista de produtos';
                            }
                        }
                    },
                    mounted() {
                        this.loadList();
                    }
                });

                app.mount('#app');

            </script>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
                crossorigin="anonymous"></script>
    </body>

    </html>