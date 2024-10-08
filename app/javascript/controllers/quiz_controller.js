import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="quiz"
export default class extends Controller {
  static targets = ["question", "dot", "progressText", "nextButton"];
  static values = { currentIndex: Number };

  connect() {
    let url = window.location.href;
    let id = url.match(/\/axi\/(\d+)/)[1];
    this.axiIdValue = id;

    this.responses = [];
    this.currentIndexValue = 1; // Começamos no primeiro tema
    this.totalDots = this.dotTargets.length;
    this.progressTextTarget.textContent = `1 de ${this.totalDots}`;
    this.themeCurrentId = 0;
    this.scenarioCurrentId = 0;
  }

  initialize() {
    this.customerId = this.getCookie("customer_id");
    console.log(this.customerId); // Exibe o ID do cliente no console
  }

  next() {
    if (this.isAnswerSelected()) {
      this.currentThemeIndex = this.currentIndexValue;
      this.currentIndexValue++;
      if (this.currentIndexValue >= this.totalDots) {
        this.currentIndexValue = this.questionTargets.length - 1; // Não ultrapassa o limite de temas
      }
      this.loadTheme(this.currentIndexValue);
    } else {
      Swal.fire({
        icon: "warning",
        title: "Atenção",
        text: "Por favor, selecione uma resposta antes de continuar.",
        confirmButtonText: "Ok",
        customClass: {
          confirmButton: "btn btn-success",
        },
        buttonsStyling: false, // Para usar os estilos personalizados do Bootstrap
      });
      return;
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

  currentScenario() {
    const dotClasses = {
      1: "dot-quiz-environmental-active",
      2: "dot-quiz-social-active",
      3: "dot-quiz-governance-active",
    };

    // Aqui, você pode dinamicamente escolher a classe correta baseada em algum valor, por exemplo, um ID de eixo
    const activeDotClass = dotClasses[this.axiIdValue]; // Supondo que axiIdValue seja 1, 2 ou 3

    // Seleciona o elemento dot com a classe ativa correta
    let dotElement = document.querySelector(`.${activeDotClass}`);

    if (dotElement) {
      this.themeCurrentId = dotElement.dataset.themeId;
    } else {
      console.error("Elemento dot ativo não encontrado.");
    }

    // Seleciona o input da resposta marcada
    let selectedInput = document.querySelector(
      'input[name="question"]:checked',
    );

    // Se houver uma resposta marcada, define o scenarioCurrentId; caso contrário, define como null
    this.scenarioCurrentId = selectedInput ? selectedInput.value : null;

    // Log para verificar se os valores estão corretos
    console.log("themeCurrentId:", this.themeCurrentId);
    console.log("scenarioCurrentId:", this.scenarioCurrentId);
  }

  currentScenario_old() {
    const dotClasses = {
      1: "dot-quiz-environmental-active",
      2: "dot-quiz-social-active",
      3: "dot-quiz-governance-active",
    };
    let dotElement = document.querySelector(".dot-quiz-environmental-active"); // Seleciona o elemento
    this.themeCurrentId = dotElement.dataset.themeId;

    let selectedInput = document.querySelector(
      'input[name="question"]:checked',
    );
    this.scenarioCurrentId = selectedInput ? selectedInput.value : null;
  }

  currentSlide(event) {
    const index = Number(event.currentTarget.dataset.slidesIndexParam);
    console.log("Esse é o valor de index no currentSlide", index);
    this.currentThemeIndex = index - 1;
    if (this.isAnswerSelected()) {
      this.storeAnswer();
    } else {
      Swal.fire({
        icon: "warning",
        title: "Atenção",
        text: "Por favor, selecione uma resposta antes de continuar.",
        confirmButtonText: "Ok",
        customClass: {
          confirmButton: "btn btn-success",
        },
        buttonsStyling: false, // Para usar os estilos personalizados do Bootstrap
      });

      return;
    }
    this.loadTheme(index);
    if (index == this.totalDots) {
      this.nextButtonTarget.textContent = "Finalizar";
      this.nextButtonTarget.dataset.action = "click->quiz#saveQuiz";
      return;
    } else {
      this.nextButtonTarget.textContent = "Próxima";
      this.nextButtonTarget.dataset.action = "click->quiz#next";
    }
  }

  isAnswerSelected() {
    // Verifica se alguma resposta foi selecionada no tema atual
    const currentQuestion = document.querySelector(".answers-container");
    return (
      currentQuestion.querySelector('input[type="radio"]:checked') !== null
    );
  }

  loadTheme(themeId) {
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
        <input class="form-check-input" type="radio" name="question" id="option${index + 1}" value="${answer.id}" data-action="click->quiz#currentScenario">
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
    const dotClasses = {
      1: {
        active: "dot-quiz-environmental-active",
        inactive: "dot-quiz-environmental",
      },
      2: { active: "dot-quiz-social-active", inactive: "dot-quiz-social" },
      3: {
        active: "dot-quiz-governance-active",
        inactive: "dot-quiz-governance",
      },
    };

    const currentDotClass = dotClasses[this.axiIdValue]; // Pega a classe correta para o axiIdValue

    if (currentDotClass) {
      this.dotTargets.forEach((dot, index) => {
        // Alterna as classes com base no índice atual
        if (index === this.currentThemeIndex) {
          dot.classList.add(currentDotClass.active);
          dot.classList.remove(currentDotClass.inactive);
        } else {
          dot.classList.add(currentDotClass.inactive);
          dot.classList.remove(currentDotClass.active);
        }
      });
    }
  }

  updateActiveDot123() {
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
    const dotClasses = {
      1: "dot-quiz-environmental-active",
      2: "dot-quiz-social-active",
      3: "dot-quiz-governance-active",
    };
    // Mostra a pergunta atual e oculta as outras
    this.questionTargets.forEach((element, index) => {
      element.style.display =
        index === this.currentIndexValue ? "block" : "none";
    });

    // Atualiza os dots
    this.dotTargets.forEach((dot, index) => {
      const activeClass = dotClasses[this.axiIdValue];
      if (activeClass) {
        dot.classList.toggle(activeClass, index === this.currentIndexValue);
      }
    });

    // Atualiza o texto do progresso "X de 6"
    this.progressTextTarget.textContent = `${this.currentIndexValue + 1} de ${this.questionTargets.length}`;
  }

  storeAnswer() {
    debugger;
    const responseData = {
      customer_id: this.customerId,
      theme_id: this.themeCurrentId,
      scenario_id: this.scenarioCurrentId,
    };
    this.responses.push(responseData);
  }

  saveQuiz() {
    console.log("Quiz finalizado! Salvando dados...");
    const responseData = {
      customer_id: this.customerId,
      theme_id: this.themeCurrentId,
      scenario_id: this.scenarioCurrentId,
      axi_id: this.axiIdValue,
    };
    this.responses.push(responseData);
    fetch("/answers", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
      body: JSON.stringify(this.responses),
    }).then((response) => {
      if (response.ok) {
        let nextSlide = Number(this.axiIdValue) + 1;
        if (nextSlide <= 3) {
          window.location.href = "/answers/start?slide=" + nextSlide;
        } else {
          window.location.href = "/result_quizzes";
        }
        //Swal.fire("Sucesso!", "Seu quiz foi salvo.", "success");
      } else {
        //Swal.fire("Erro!", "Houve um problema ao salvar o quiz.", "error");
      }
    });
  }

  getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(";").shift();
  }

  setCookie(name, value, days) {
    let expires = "";
    if (days) {
      const date = new Date();
      date.setTime(date.getTime() + days * 24 * 60 * 60 * 1000);
      expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "") + expires + "; path=/";
  }
}
