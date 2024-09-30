import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="customers-form-validation"
export default class extends Controller {
  static targets = [
    "name",
    "email",
    "phone",
    "companyName",
    "cnpj",
    "errorName",
    "errorEmail",
    "errorPhone",
    "errorCompanyName",
    "errorCnpj",
  ];

  connect() {
    console.log("Form validation controller connected !!!");
  }

  validate(event) {
    console.log("Validação do formulário chamada"); // Deve ser impresso
    let valid = true;

    // Limpa mensagens de erro anteriores
    this.clearErrors();

    // Validação para o campo 'name'
    if (this.nameTarget.value.trim() === "") {
      this.errorNameTarget.textContent = "* Nome é obrigatório.";
      valid = false;
    }

    if (this.emailTarget.value.trim() === "") {
      this.errorEmailTarget.textContent = "Email é obrigatório.";
      valid = false;
    } else if (!this.isValidEmail(this.emailTarget.value)) {
      this.errorEmailTarget.textContent = "Email inválido.";
      valid = false;
    }

    if (this.emailTarget.value.trim() === "") {
      this.errorEmailTarget.textContent = "* Email é obrigatório";
      valid = false;
    }

    if (this.phoneTarget.value.trim() === "") {
      this.errorPhoneTarget.textContent = "* Telefone é obrigatório";
      valid = false;
    }

    if (this.companyNameTarget.value.trim() === "") {
      this.errorCompanyNameTarget.textContent = "* Razão Social é obrigatório";
      valid = false;
    }

    if (this.cnpjTarget.value.trim() === "") {
      this.errorCnpjTarget.textContent = "* CNPJ é obrigatório.";
      valid = false;
    }

    // Impede o envio do formulário se houver erros
    if (!valid) {
      event.preventDefault();
    }
  }

  isValidEmail(email) {
    return /\S+@\S+\.\S+/.test(email);
  }

  // Limpa a mensagem de erro
  clearErrors() {
    this.errorNameTarget.textContent = "";
    this.errorEmailTarget.textContent = "";
    this.errorPhoneTarget.textContent = "";
    this.errorCompanyNameTarget.textContent = "";
    this.errorCnpjTarget.textContent = "";
  }

  maskPhone(event) {
    let phone = event.target.value.replace(/\D/g, ""); // Remove tudo que não for número
    phone = phone.replace(/^(\d{2})(\d)/g, "($1) $2"); // Adiciona o parêntese no DDD
    phone = phone.replace(/(\d{5})(\d)/, "$1-$2"); // Adiciona o traço após os 5 primeiros números
    event.target.value = phone;
  }
}
