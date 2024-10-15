import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="rating"
export default class extends Controller {
  static targets = ["star", "errorMessage"];
  connect() {
    this.selectedRating = 0;
    this.comment = "";
    this.stars = this.element.querySelectorAll(".star");
    this.stars.forEach((star) => {
      star.addEventListener("click", this.selectRating.bind(this));
    });
  }

  selectStar(event) {
    // Oculta a mensagem de erro, se ela estiver visível
    this.errorMessageTarget.style.display = "none";
  }

  selectRating(event) {
    const selectedValue = event.target.dataset.value;
    this.selectedRating = selectedValue;

    this.stars.forEach((star) => {
      if (star.dataset.value <= selectedValue) {
        star.classList.add("selected");
      } else {
        star.classList.remove("selected");
      }
    });
  }

  submitRating() {
    const comment = document.getElementById("comment").value;
    if (this.selectedRating > 0) {
      // Faz uma requisição para atualizar os campos de customers
      fetch("/answers/save_rating", {
        // Substitua esta rota pela rota correta em seu controlador Rails
        method: "PUT", // Usar PUT para atualização de registros
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content"),
        },
        body: JSON.stringify({
          customerId: this.customerId,
          satisfaction_score: this.selectedRating,
          finished_quiz: true,
          comment: comment,
        }),
      })
        .then((response) => {
          if (response.ok) {
            // Se a atualização foi bem-sucedida, redireciona para a página de resultados
            window.location.href = "/result_quizzes";
          } else {
            // Exibe um erro se a requisição falhar
            Swal.fire(
              "Erro!",
              "Houve um problema ao salvar sua avaliação.",
              "error",
            );
          }
        })
        .catch((error) => {
          // Exibe um erro se houver algum problema na conexão
          console.error("Erro ao fazer a requisição:", error);
          Swal.fire(
            "Erro!",
            "Houve um problema ao processar sua requisição.",
            "error",
          );
        });
    } else {
      this.showErrorMessage(); // Exibe a mensagem de erro se nenhuma estrela for selecionada
    }
  }

  showErrorMessage() {
    const errorMessage = this.element.querySelector(".error-message");
    errorMessage.style.display = "block";
  }
}
