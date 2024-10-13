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

  next(event) {
    const nextThemeData = this.getNextThemeData(event);

    const index = parseInt(nextThemeData.slidesIndexParam);
    const indexTheme = parseInt(nextThemeData.themeId);

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
    this.loadTheme(indexTheme);

    if (index == this.totalDots) {
      this.nextButtonTarget.textContent = "Finalizar";
      this.nextButtonTarget.dataset.action = "click->quiz#saveQuiz";
      return;
    } else {
      this.nextButtonTarget.textContent = "Próxima";
      this.nextButtonTarget.dataset.action = "click->quiz#next";
    }
  }

  getNextThemeData(event) {
    event.preventDefault(); // Evitar o comportamento padrão do evento
    const activeDot = document.querySelector(
      ".dot-quiz-environmental-active, .dot-quiz-social-active, .dot-quiz-governance-active",
    );

    if (activeDot) {
      const activeIndex = Number(activeDot.dataset.slidesIndexParam);
      const nextIndex = activeIndex + 1;
      const nextDot = document.querySelector(
        `.dot-quiz-environmental[data-slides-index-param="${nextIndex}"], .dot-quiz-social[data-slides-index-param="${nextIndex}"], .dot-quiz-governance[data-slides-index-param="${nextIndex}"]`,
      );

      if (nextDot) {
        const nextThemeId = nextDot.dataset.themeId;
        const nextSlidesIndexParam = nextDot.dataset.slidesIndexParam; // Obter o próximo data-slides-index-param

        console.log("Próximo tema ID:", nextThemeId);
        console.log("Próximo slides index param:", nextSlidesIndexParam);

        // Retornar um objeto com os dois valores
        return {
          themeId: nextThemeId,
          slidesIndexParam: nextSlidesIndexParam,
        };
      } else {
        console.log("Não há mais temas disponíveis.");
        // Retornar null ou um objeto padrão para indicar que não há próximo tema
        return null;
      }
    } else {
      console.log("Nenhuma dot ativa encontrada.");
      // Retornar null ou um objeto padrão para indicar que não há dot ativa
      return null;
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
    // Obtendo a classe ativa e inativa para cada eixo
    let activeDotClass, inactiveDotClass;

    if (parseInt(this.axiIdValue) === 1) {
      activeDotClass = "dot-quiz-environmental-active";
      inactiveDotClass = "dot-quiz-environmental";
    } else if (parseInt(this.axiIdValue) === 2) {
      activeDotClass = "dot-quiz-social-active";
      inactiveDotClass = "dot-quiz-social";
    } else if (parseInt(this.axiIdValue) === 3) {
      activeDotClass = "dot-quiz-governance-active";
      inactiveDotClass = "dot-quiz-governance";
    }

    // Tenta selecionar o elemento dot que possui a classe ativa
    let dotElement = document.querySelector(`.${activeDotClass}`);

    // Se não encontrar o dot com a classe ativa, tenta o dot com a classe inativa
    if (!dotElement) {
      dotElement = document.querySelector(`.${inactiveDotClass}`);
    }

    // Verifica se o dot foi encontrado
    if (dotElement) {
      // Se o dot estava com a classe inativa, alterna para ativa
      if (dotElement.classList.contains(inactiveDotClass)) {
        dotElement.classList.remove(inactiveDotClass);
        dotElement.classList.add(activeDotClass);
      }

      // Armazena o ID do tema associado ao dot ativo
      this.themeCurrentId = dotElement.dataset.themeId;
    } else {
      console.error("Elemento dot não encontrado.");
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

  currentSlide(event) {
    const index = Number(event.currentTarget.dataset.slidesIndexParam);
    const indexTheme = Number(event.currentTarget.dataset.themeId);
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
    this.loadTheme(indexTheme);
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
      `/answers/quiz_by_theme?axi_id=${parseInt(this.axiIdValue)}&theme_id=${themeId}`,
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
    const responseData = {
      customer_id: this.customerId,
      theme_id: this.themeCurrentId,
      scenario_id: this.scenarioCurrentId,
    };
    this.responses.push(responseData);
  }

  saveQuiz() {
    console.log("Quiz finalizado! Salvando dados...");

    if (!this.isAnswerSelected()) {
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

    // Monta os dados da resposta atual
    const responseData = {
      customer_id: this.customerId,
      theme_id: this.themeCurrentId,
      scenario_id: this.scenarioCurrentId,
      axi_id: this.axiIdValue,
    };

    // Adiciona a resposta à lista de respostas
    this.responses.push(responseData);

    // Envia as respostas via fetch
    fetch("/answers", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
      body: JSON.stringify(this.responses),
    }).then((response) => {
      if (response.ok) {
        // Calcula o próximo slide
        let nextSlide = Number(this.axiIdValue) + 1;

        // Se o próximo slide for <= 3, redireciona para o próximo slide
        if (nextSlide <= 3) {
          window.location.href = "/answers/start?slide=" + nextSlide;
        }
        // Quando não houver mais slides, abre o popup de avaliação de estrelas
        else {
          fetch("/answers/save_rating", {
            method: "PUT",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
            },
            body: JSON.stringify({
              customer_id: this.customerId,
            }),
          }).then((response) => {
            if (response.ok) {
              // Redireciona para a página de resultados após o envio da avaliação
              window.location.href = "/result_quizzes";
            }
          });

          // Swal.fire({
          //   title: "Avaliação de Satisfação",
          //   text: "Por favor, avalie sua experiência:",
          //   icon: "question",
          //   input: "radio",
          //   inputOptions: {
          //     1: "Muito Ruim",
          //     2: "Ruim",
          //     3: "Bom",
          //     4: "Muito Bom",
          //     5: "Excelente",
          //   },
          //   inputValidator: (value) => {
          //     if (!value) {
          //       return "Por favor, selecione uma quantidade de estrelas!";
          //     }
          //   },
          //   confirmButtonText: "Enviar",
          //   customClass: {
          //     confirmButton: "btn btn-success btn-pop-up",
          //     popup: "custom-swal-popup", // Adicione uma classe personalizada para o popup
          //   },
          //   buttonsStyling: false,
          //   width: "600px", // Para usar os estilos personalizados do Bootstrap
          // }).then((result) => {
          //   if (result.isConfirmed) {
          //     // Pega a quantidade de estrelas selecionadas
          //     let selectedStars = result.value;
          //
          //     // Faz uma requisição para salvar a quantidade de estrelas
          //     fetch("/save_rating", {
          //       method: "POST",
          //       headers: {
          //         "Content-Type": "application/json",
          //         "X-CSRF-Token": document
          //           .querySelector('meta[name="csrf-token"]')
          //           .getAttribute("content"),
          //       },
          //       body: JSON.stringify({
          //         stars: selectedStars,
          //         customer_id: this.customerId,
          //       }),
          //     }).then((response) => {
          //       if (response.ok) {
          //         // Redireciona para a página de resultados após o envio da avaliação
          //         window.location.href = "/result_quizzes";
          //       } else {
          //         // Exibe um erro se a requisição falhar
          //         Swal.fire(
          //           "Erro!",
          //           "Houve um problema ao salvar sua avaliação.",
          //           "error",
          //         );
          //       }
          //     });
          //   }
          // });
          //
        }
      } else {
        Swal.fire("Erro!", "Houve um problema ao salvar o quiz.", "error");
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
