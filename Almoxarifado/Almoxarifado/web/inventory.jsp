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
                            Estoque
                            <div class="d-flex align-items-center">
                                <input type="text" v-model="searchQuery" placeholder="Digite algo..."
                                    class="form-control custom-input mx-2">
                                <button @click="resetForm()" type="button"
                                    class="btn btn-success btn-sm ms-auto buttons" data-bs-toggle="modal"
                                    data-bs-target="#addInventoryModal">
                                    Adicionar
                                </button>
                            </div>
                        </h2>

                        <div class="modal fade" id="addInventoryModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5">Adicionar Produto</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form @submit.prevent="addProduto">
                                            <div class="mb-3">
                                                <label for="inputName" class="form-label">Nome do Item</label>
                                                <input type="text" v-model="newName" class="form-control"
                                                    id="inputName">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputLocation" class="form-label">Quantidade</label>
                                                <input type="number" v-model="newQuantidade" class="form-control"
                                                    id="inputLocation" min="0">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputStatus" class="form-label">Status</label>
                                                <select class="form-select" v-model="newStatus" id="inputStatus">
                                                    <option value="DISPONIVEL">Disponivel</option>
                                                    <option value="NO ARMAZÉM">No Armazém</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="data">Data da Entrada</label>
                                                <input type="date" v-model="newData" id="data" name="data">
                                                <label for="horario">Horário da Entrada</label>
                                                <input type="time" v-model="newHorario" id="horario" name="horario">
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

                        <div class="modal fade" id="edtInventoryModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5">Editar Produto</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form @submit.prevent="updateProd">
                                            <div class="mb-3">
                                                <label for="inputName" class="form-label">Nome do Item</label>
                                                <input type="text" v-model="newName" class="form-control"
                                                    id="inputName">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputLocation" class="form-label">Quantidade</label>
                                                <input type="number" v-model="newQuantidade" class="form-control"
                                                    id="inputLocation" min="0">
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputStatus" class="form-label">Status</label>
                                                <select class="form-select" v-model="newStatus" id="inputStatus">
                                                    <option value="DISPONIVEL">Disponivel</option>
                                                    <option value="NO ARMAZÉM">No Armazém</option>
                                                    <option value="ESGOTADO">Esgotado</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="data">Data da Entrada</label>
                                                <input type="date" v-model="newData" id="data" name="data">
                                                <label for="horario">Horário da Entrada</label>
                                                <input type="time" v-model="newHorario" id="horario" name="horario">
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
                                <th>NOME DO ITEM</th>
                                <th>QUANTIDADE</th>
                                <th>STATUS</th>
                                <th>DATA DA ENTRADA</th>
                                <th>AÇÕES</th>
                            </tr>
                            <tr v-for="item in list" :key="item.rowid">
                                <td>{{ item.nome }}</td>
                                <td>{{ item.quantidade }}</td>
                                <td>{{ item.tipo }}</td>
                                <td>{{ item.data }} || {{ item.horario }}</td>
                                <td>
                                    <div class="btn-group" role="group" aria-label="Basic Example">
                                        <button type="button" @click="setVariables(item)" class="btn btn-warning btn-sm"
                                            data-bs-toggle="modal" data-bs-target="#edtInventoryModal"><i
                                                class="bi bi-pen"></i></button>
                                        <button type="button" @click="removeProd(item.id)"
                                            class="btn btn-danger btn-sm"><i class="bi bi-trash"></i></button>
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
            </div>

            <script>
                const app = Vue.createApp({
                    data() {
                        return {
                            shared: shared,
                            error: null,
                            newType: '',
                            newName: '',
                            newQuantidade: 0,
                            newStatus: 'DISPONIVEL',
                            newData: '',
                            newHorario: '',
                            prod: null,
                            list: [],
                            currentPage: 1,
                            itemsPerPage: 5,
                            searchQuery: '',
                            totalPages: 0
                        };
                    },
                    computed: {
                        filteredList() {
                            
                            if (this.searchQuery) {
                                
                                //getProds();
                                return this.list.filter(item =>
                                    item.nome.toLowerCase().includes(this.searchQuery.toLowerCase())
                                );
                            } else {
                                return this.list;
                            }
                            
                            
                        }
                        /*paginatedList() {
                            const startIndex = (this.currentPage - 1) * this.itemsPerPage;
                            const endIndex = startIndex + this.itemsPerPage;
                            return this.filteredList.slice(startIndex, endIndex);
                        },
                        totalPages() {
                            return Math.ceil(this.filteredList.length / this.itemsPerPage);
                        }*/
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
                        async getProds(){
                            const data = await this.request("/Almoxarifado/api/produtos", "GET");
                                if (data) {
                                    this.list = data.list;
                                }
                        },
                        async insertOrUpdate() {
                            if (prod) {
                                await this.updateProd();
                            } else {
                                await this.addProduto();
                            }
                        },
                        async addProduto() {
                            if (this.newQuantidade < 0) {
                                this.error = 'Quantidade não pode ser negativa';
                                return;
                            }
                            const dataHora = new Date(this.newData + 'T' + this.newHorario);
                            const produtoData = {
                                nome: this.newName,
                                quantidade: this.newQuantidade,
                                tipo: this.newStatus,
                                data: dataHora.toISOString(),
                                horario: this.newHorario
                            };

                            try {
                                const response = await this.request('/Almoxarifado/api/produtos', 'POST', produtoData);
                                if (response) {
                                    await this.loadList(this.currentPage);
                                    this.resetForm();
                                }
                            } catch (error) {
                                console.error('Erro ao adicionar produto:', error);
                                this.error = 'Erro ao adicionar produto';
                            }
                        },
                        async updateProd() {
                            if (this.newQuantidade < 0) {
                                this.error = 'Quantidade não pode ser negativa';
                                return;
                            }
                            const dataHora = new Date(this.newData + 'T' + this.newHorario);
                            const index = this.list.findIndex(item => item.id === this.prod.id);
                            if (index !== -1) {
                                this.list[index] = {
                                    ...this.list[index],
                                    nome: this.newName,
                                    quantidade: this.newQuantidade,
                                    tipo: this.newStatus,
                                    data: this.newData,
                                    horario: this.newHorario
                                };
                            }
                            const data = await this.request("/Almoxarifado/api/produtos?id=" + (this.prod.id), "PUT", {
                                id: this.prod.id,
                                nome: this.newName,
                                quantidade: this.newQuantidade,
                                tipo: this.newStatus,
                                data: dataHora.toISOString(),
                                horario: this.newHorario
                            });

                            this.resetForm();
                            this.closeModal('#edtInventoryModal');
                            this.prod = null;
                            await this.loadList(this.currentPage);
                        },
                        setVariables(prod) {
                            if (prod) {
                                this.prod = { ...prod };
                                this.newName = this.prod.nome;
                                this.newQuantidade = this.prod.quantidade;
                                this.newStatus = this.prod.tipo;
                                const dateTime = new Date(this.prod.data);
                                this.newData = dateTime.toISOString().split('T')[0];
                                this.newHorario = dateTime.toTimeString().split(' ')[0];
                            } else {
                                this.resetForm();
                            }
                        },
                        async removeProd(id) {
                            try {
                                const data = await this.request("/Almoxarifado/api/produtos?id=" + id, "DELETE");
                                if (data) {
                                    await this.loadList(this.currentPage);
                                }
                            } catch (error) {
                                console.error("Erro ao excluir o Produto:", error);
                            }
                        },
                        async loadList(page = 1) {
                            
                            try {
                                
                                const data = await this.request("/Almoxarifado/api/produtos?page=" + page, "GET");
                                if (data) {
                                    this.list = data.list;
                                    this.totalPages = Math.ceil(data.total / 5);
                                    
                                }
                               
                            } catch (error) {
                                console.error('Erro ao carregar a lista de produtos:', error);
                                this.error = 'Erro ao carregar a lista de produtos';
                            }
                        },
                        resetForm() {
                            this.newName = '';
                            this.newQuantidade = 0;
                            this.newStatus = 'DISPONIVEL';
                            this.newData = '';
                            this.newHorario = '';
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
                        
                        closeModal(modalId) {
                            const modal = document.querySelector(modalId);
                            if (modal) {
                                const modalInstance = bootstrap.Modal.getInstance(modal);
                                if (modalInstance) {
                                    modalInstance.hide();
                                }
                            }
                        }
                    }
                    
                });

                app.mount('#app');
            </script>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
                crossorigin="anonymous"></script>
    </body>

    </html>