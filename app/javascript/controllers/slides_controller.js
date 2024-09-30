import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="slides"
export default class extends Controller {
  static targets = ["slide", "dot", "id", "title"];

  connect() {
    this.currentSlideIndex = 1; // Inicia o slide atual
    this.showSlide(this.currentSlideIndex);
    this.loadAxiData(this.currentSlideIndex);
  }

  async currentSlide(event) {
    const slideNumber = event.currentTarget.dataset.slidesIndexParam;
    console.log("Current Slide Number:", slideNumber);
    this.showSlide(slideNumber);
    console.log("Carregando dados do Axi para o slide:", slideNumber);
    await this.loadAxiData(slideNumber); // Carrega os dados via AJAX
  }

  showSlide(n) {
    // Esconde todos os slides
    this.slideTargets.forEach((slide) => {
      slide.style.display = "none"; // Esconde todos os slides
    });

    // Mostra o slide atual
    this.slideTargets[n - 1].style.display = "block";

    // Atualiza as bolinhas de navegação
    this.dotTargets.forEach((dot) => {
      dot.classList.remove("active");
    });

    if (this.dotTargets[n - 1]) {
      this.dotTargets[n - 1].classList.add("active");
    }
  }

  async loadAxiData(slideNumber) {
    try {
      const response = await fetch(`axi_data/${slideNumber}`);
      const data = await response.json();
      console.log("Data received:", data); // Verifique a resposta

      const slide = this.slideTargets[slideNumber - 1]; // Defina a referência para o slide atual

      // Atualiza o título com o nome do Axi
      const titleTarget = slide.querySelector('[data-slides-target="title"]');
      if (titleTarget) {
        titleTarget.textContent = data.name; // Atualiza o título com o nome do Axi
        console.log("Title updated to:", data.name);
      }

      // Atualiza o ID com os dados do Axi
      const idTarget = slide.querySelector('[data-slides-target="id"]');
      if (idTarget) {
        idTarget.textContent = data.id + "."; // Atualiza o ID do Axi
        console.log("ID updated to:", data.id);
      }
    } catch (error) {
      console.error("Erro ao carregar os dados do Axi:", error);
    }
  }
}
