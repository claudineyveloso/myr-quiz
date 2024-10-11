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
      this.errorNameTarget.textContent = "Nome é obrigatório.";
      this.nameTarget.classList.add("invalid-field");
      valid = false;
    } else {
      this.nameTarget.classList.remove("invalid-field");
    }

    if (this.emailTarget.value.trim() === "") {
      this.errorEmailTarget.textContent = "Email é obrigatório.";
      valid = false;
    } else if (!this.isValidEmail(this.emailTarget.value)) {
      this.errorEmailTarget.textContent = "Email inválido.";
      valid = false;
    }

    if (this.phoneTarget.value.trim() === "") {
      this.errorPhoneTarget.textContent = "Telefone é obrigatório";
      valid = false;
    }

    if (this.companyNameTarget.value.trim() === "") {
      this.errorCompanyNameTarget.textContent = "Razão Social é obrigatório";
      valid = false;
    }

    // Impede o envio do formulário se houver erros
    if (!valid) {
      event.preventDefault();
    }
  }

  checkEmail(event) {
    const email = this.emailTarget.value.trim();
    let valid = true;

    if (email === "") {
      this.errorEmailTarget.textContent = "Email é obrigatório.";
      return;
    }

    // Requisição AJAX para verificar se o e-mail já existe
    fetch(`/customers/check_email?email=${email}`)
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "finished") {
          this.showMessage(
            "E-mail já utilizado",
            "Este e-mail já finalizou o questionário.",
            "error",
          );
        } else if (data.status === "not_finished") {
          // Mostra a mensagem e só continua após o usuário clicar em "Ok"
          Swal.fire({
            title: "Questionário não finalizado",
            text: "O questionário não foi finalizado. Você pode prosseguir.",
            icon: "info",
            confirmButtonText: "Ok",
          }).then((result) => {
            if (result.isConfirmed) {
              // Só executa o preenchimento dos campos após o usuário clicar "Ok"
              this.fillCustomerData(data.customer);
              document.getElementById("submitButton").textContent = "Continuar";
              this.allowSubmit = false;
            }
          });
        } else if (data.status === "not_found") {
          // this.showMessage(
          //   "E-mail não encontrado",
          //   "Você pode iniciar o questionário.",
          //   "success",
          // );
          this.allowSubmit = true;
        }
      })
      .catch((error) => {
        console.error("Erro na verificação do email:", error);
        this.errorEmailTarget.textContent =
          "Erro ao verificar o email. Tente novamente mais tarde.";
        this.emailTarget.focus();
        valid = false;
      });
    return valid;
  }

  validateName() {
    let valid = true;

    if (this.nameTarget.value.trim().length < 3) {
      this.errorNameTarget.textContent =
        "O nome deve ter pelo menos 3 caracteres.";
      this.nameTarget.classList.add("invalid-field");
      valid = false;
    } else {
      this.nameTarget.classList.remove("invalid-field");
      this.errorNameTarget.textContent = ""; // Remove a mensagem de erro se válido
    }
    return valid;
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

  addInvalidClass(target) {
    target.classList.add("invalid-field");
  }

  removeInvalidClass(target) {
    target.classList.remove("invalid-field");
  }

  maskPhone(event) {
    let phone = event.target.value.replace(/\D/g, ""); // Remove tudo que não for número
    phone = phone.replace(/^(\d{2})(\d)/g, "($1) $2"); // Adiciona o parêntese no DDD
    phone = phone.replace(/(\d{5})(\d)/, "$1-$2"); // Adiciona o traço após os 5 primeiros números
    event.target.value = phone;
  }

  validate(event) {
    // Verifica se o botão é "Continuar" antes de permitir o submit
    const submitButton = document.getElementById("submitButton");

    if (submitButton.textContent === "Continuar") {
      event.preventDefault(); // Impede o submit do formulário

      // Redireciona para a URL específica
      window.location.href = "http://localhost:3000/answers/start";
    } else if (!this.allowSubmit) {
      event.preventDefault(); // Impede o submit se o cliente já existir e o questionário não estiver finalizado
    }
  }

  showMessage(title, text, icon) {
    Swal.fire({
      title: title,
      text: text,
      icon: icon,
      confirmButtonText: "Ok",
    });
  }

  fillCustomerData(customer) {
    // Supondo que os campos tenham os seguintes IDs
    document.getElementById("phone").value = customer.phone;
    document.getElementById("company_name").value = customer.company_name;
    document.getElementById("cnpj").value = customer.cnpj;
  }
};
