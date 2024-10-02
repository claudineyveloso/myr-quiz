import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="quiz"
export default class extends Controller {
  static targets = ["question", "dot", "progressText"];
  static values = { currentIndex: Number };

  connect() {
    this.currentIndexValue = 1; // Começamos no primeiro tema
    this.totalDots = this.dotTargets.length;
    this.progressTextTarget.textContent = `1 de ${this.totalDots}`;
  }

  next() {
    console.log("Clicou no botão proximo!");
    if (this.isAnswerSelected()) {
      this.currentThemeIndex = this.currentIndexValue;
      this.currentIndexValue++;
      // debugger;
      if (this.currentIndexValue >= this.totalDots) {
        this.currentIndexValue = this.questionTargets.length - 1; // Não ultrapassa o limite de temas
      }
      this.loadTheme(this.currentIndexValue);
    } else {
      alert("Por favor, selecione uma resposta antes de continuar.");
    }
  }

  previous() {
    console.log("Clicou no botão anterior!");

    // this.currentIndexValue--;
    // if (this.currentIndexValue < 0) {
    //   this.currentIndexValue = 0;
    // }
    // this.updateView();
  }

  selectDot(event) {
    const index = parseInt(event.currentTarget.dataset.index, 10);
    this.currentIndexValue = index;
    this.updateView();
  }

  currentSlide(event) {
    const index = Number(event.currentTarget.dataset.slidesIndexParam);
    this.currentThemeIndex = index - 1;
    if (this.isAnswerSelected()) {
    } else {
      alert("Por favor, selecione uma resposta antes de prosseguir.");
      return;
    }
    this.loadTheme(index);
  }

  isAnswerSelected() {
    // Verifica se alguma resposta foi selecionada no tema atual
    const currentQuestion = document.querySelector(".answers-container");
    return (
      currentQuestion.querySelector('input[type="radio"]:checked') !== null
    );
  }

  loadTheme(themeId) {
    console.log("Valor de themeId", themeId);
    fetch(
      `/answers/quiz_by_theme?axi_id=${this.axiIdValue}&theme_id=${themeId}`,
    )
      .then((response) => response.json())
      .then((data) => {
        this.updateAnswers(data.answers, data.main_theme);
        this.updateProgress();
      });
  }

  updateAnswers(answers, mainTheme) {
    const answersContainer = document.querySelector(".answers-container");
    const themeTitle = document.querySelector("#theme-current");

    themeTitle.textContent = mainTheme;
    answersContainer.innerHTML = ""; // Limpa as respostas antigas

    answers.forEach((answer, index) => {
      const answerHTML = `
      <div class="form-check mb-4">
        <input class="form-check-input" type="radio" name="question" id="option${index + 1}" value="${answer.id}">
        <label class="form-check-label" for="option${index + 1}">
          ${answer.description}
        </label>
      </div>
    `;
      answersContainer.insertAdjacentHTML("beforeend", answerHTML);
    });
    this.updateActiveDot();
  }

  updateActiveDot() {
    this.dotTargets.forEach((dot, index) => {
      // Verifica qual dot deve estar ativo com base no índice atual
      if (index === this.currentThemeIndex) {
        dot.classList.add("dot-quiz-environmental-active");
        dot.classList.remove("dot-quiz-environmental");
      } else {
        dot.classList.add("dot-quiz-environmental");
        dot.classList.remove("dot-quiz-environmental-active");
      }
    });
  }

  updateProgress() {
    // Atualiza o texto "1 de 6" ou "3 de 6"
    this.progressTextTarget.textContent = `${this.currentThemeIndex + 1} de ${this.totalDots}`;
    console.log("Total de Dots", this.totalDots); // Agora usamos 'this.totalDots'
  }

  updateView() {
    // Mostra a pergunta atual e oculta as outras
    this.questionTargets.forEach((element, index) => {
      element.style.display =
        index === this.currentIndexValue ? "block" : "none";
    });

    // Atualiza os dots
    this.dotTargets.forEach((dot, index) => {
      dot.classList.toggle(
        "dot-quiz-environmental-active",
        index === this.currentIndexValue,
      );
    });

    // Atualiza o texto do progresso "X de 6"
    this.progressTextTarget.textContent = `${this.currentIndexValue + 1} de ${this.questionTargets.length}`;
  }
}
