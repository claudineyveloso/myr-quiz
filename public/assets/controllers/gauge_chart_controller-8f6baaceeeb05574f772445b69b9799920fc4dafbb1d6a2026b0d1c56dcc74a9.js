import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="gauge-chart"
export default class extends Controller {
  connect() {
    this.initializeChart();
  }

  initializeChart() {
    // Obtendo o contexto do canvas
    const ctx = this.element.querySelector("canvas").getContext("2d");

    if (ctx) {
      new Chart(ctx, {
        type: "line", // Tipo de gráfico, pode ser 'line', 'bar', etc.
        data: {
          labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
          datasets: [
            {
              label: "Sample Data", // Adicione um rótulo para o conjunto de dados
              data: [12, 19, 3, 5, 2, 3],
              borderColor: "#FF5733", // Cor da linha do gráfico
              borderWidth: 1,
              fill: false, // Desativa o preenchimento abaixo da linha
            },
          ],
        },
        options: {
          scales: {
            y: {
              beginAtZero: true,
            },
          },
        },
      });
    } else {
      console.error("Canvas element not found for Chart.js");
    }
  }
};
